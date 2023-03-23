//
//  SettingsViewController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 13.03.2022.
//

import UIKit
import AVFoundation
import CoreData

class SettingsViewController: UIViewController, UITextFieldDelegate {
        
    let xView = UIView()
    let appSoundView = UIView()
    let wordSoundView = UIView()
    let soundSpeedView = UIView()
    let textSizeView = UIView()
    
    let soundSpeedStackView = UIStackView()
    let textSizeStackView = UIStackView()
    
    let x2Label = UILabel()
    let x2HoursLabel = UILabel()
    let appSoundLabel = UILabel()
    let wordSoundLabel = UILabel()
    let soundSpeedLabel = UILabel()
    let textSizeLabel = UILabel()
    
    let appSoundSwitch = UISwitch()
    let wordSoundSwitch = UISwitch()
    
    let soundSpeedSegmentedControl = UISegmentedControl()
    let textSegmentedControl = UISegmentedControl()
    
    let xButton = UIButton()
    let soundSpeedButton = UIButton()
    let exerciseSettingsButton = UIButton()
    
    var player = Player()
    var wordBrain = WordBrain()
    var soundSpeed = 0.0
    var soundImageName = ""
    var textSize: CGFloat { return UserDefault.textSize.getCGFloat() }
    
    let textSizeArray = [9, 11, 13, 15, 17, 19, 21]
    let soundSpeedArray = [0.3, 0.5, 0.7]
    
    private let tabBar = TabBar(color5: Colors.blue ?? .systemBlue)
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        configureColor()
        updateTextSize()
        setupCornerRadius()
        setupButton(soundSpeedButton)
        configureNavigationBar()
        style()
        setupDefaults()
        layout()
    }
    
    //MARK: - Selectors
    
    @objc func xViewPressed(gesture: UISwipeGestureRecognizer) {
        let vc = X2SettingViewController()
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.sourceView = UIView()
        vc.delegate = self
        present(vc, animated: true)
    }

    @objc func wordSoundChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefault.playSound.set(0)
            changeViewState(soundSpeedView, alpha: 1, isUserInteraction: true)
        } else {
            UserDefault.playSound.set(1)
            changeViewState(soundSpeedView, alpha: 0.6, isUserInteraction: false)
        }
    }
    
    @objc func appSoundChanged(_ sender: UISwitch) {
        UserDefault.playAppSound.set(sender.isOn == true ? 0 : 1)
    }
    
    @objc func soundSpeedChanged(_ sender: UISegmentedControl) {
        UserDefault.soundSpeed.set(soundSpeedArray[sender.selectedSegmentIndex])
        soundSpeed = soundSpeedArray[sender.selectedSegmentIndex]
        soundSpeedButton.flash()
        player.playSound(soundSpeed, "how are you?")
    }
    
    @objc func soundSpeedButtonPressed(_ sender: UIButton) {
        soundSpeedButton.flash()
        player.playSound(soundSpeed, "how are you?")
    }
    
    @objc func exerciseSettingsButtonPressed(gesture: UISwipeGestureRecognizer) {
        self.navigationController?.pushViewController(ExerciseSettingsViewController(), animated: false)
    }
    
    @objc func textSizeChanged(_ sender: UISegmentedControl) {
        UserDefault.textSize.set(textSizeArray[sender.selectedSegmentIndex])
        updateTextSize()
    }
    
    //MARK: - Helpers
    
    func configureColor() {
        view.backgroundColor = Colors.cellLeft
        xView.backgroundColor = Colors.cellRight
        appSoundView.backgroundColor = Colors.cellRight
        wordSoundView.backgroundColor = Colors.cellRight
        soundSpeedView.backgroundColor = Colors.cellRight
        textSizeView.backgroundColor = Colors.cellRight
        exerciseSettingsButton.backgroundColor = Colors.cellRight
        
        x2Label.textColor = Colors.black
        x2HoursLabel.textColor = Colors.black
        appSoundLabel.textColor = Colors.black
        wordSoundLabel.textColor = Colors.black
        soundSpeedLabel.textColor = Colors.black
        textSizeLabel.textColor = Colors.black
        x2HoursLabel.textColor = .darkGray
        exerciseSettingsButton.setTitleColor(Colors.black, for: .normal)
        
        soundSpeedButton.changeBackgroundColor(to: .clear)
        
        textSegmentedControl.tintColor = .black
        soundSpeedSegmentedControl.tintColor = .black
    }
        
    func configureNavigationBar(){
        let backButton: UIButton = UIButton()
        let image = UIImage();
        backButton.setImage(image, for: .normal)
        backButton.setTitle("", for: .normal);
        backButton.titleLabel?.font =  UIFont.systemFont(ofSize: 17)
        backButton.setTitleColor(.black, for: .normal)
        backButton.sizeToFit()
        let barButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButton
        title = "Settings"
    }

    func setupButton(_ button: UIButton){
        button.setImage(image: Images.soundBlack, width: 30, height: 30)
    }
    
    func setupCornerRadius(){
        wordSoundView.layer.cornerRadius = 8
        textSizeView.layer.cornerRadius = 8
        appSoundView.layer.cornerRadius = 8
        soundSpeedView.layer.cornerRadius = 8
    }
    
    func setupDefaults(){
        
        if UserDefault.textSize.getInt() == 0 {
            UserDefault.textSize.set(15)
            UserDefault.soundSpeed.set(0.3)
        }
        
        if UserDefault.playSound.getInt() == 1 {
            wordSoundSwitch.isOn = false
            changeViewState(soundSpeedView, alpha: 0.6, isUserInteraction: false)
        } else {
            wordSoundSwitch.isOn = true
            changeViewState(soundSpeedView, alpha: 1, isUserInteraction: true)
        }
        
        appSoundSwitch.isOn = (UserDefault.playAppSound.getInt() == 1) ? false : true
        
        x2HoursLabel.text = wordBrain.hours[UserDefault.userSelectedHour.getInt()]
        
        soundSpeed = UserDefault.soundSpeed.getDouble()
        guard let soundSpeedIndex = soundSpeedArray.firstIndex(where: {$0 == soundSpeed}) else {return}
        soundSpeedSegmentedControl.selectedSegmentIndex = soundSpeedIndex
        
        guard let textSizeIndex = textSizeArray.firstIndex(where: {$0 == UserDefault.textSize.getInt()}) else {return}
        textSegmentedControl.selectedSegmentIndex = textSizeIndex
    }

    func updateTextSize(){
        updateLabelTextSize(wordSoundLabel)
        updateLabelTextSize(textSizeLabel)
        updateLabelTextSize(x2Label)
        updateLabelTextSize(x2HoursLabel)
        updateLabelTextSize(appSoundLabel)
        updateLabelTextSize(soundSpeedLabel)
  
        updateSegmentedControlTextSize(textSegmentedControl)
        updateSegmentedControlTextSize(soundSpeedSegmentedControl)
        
        updateButtonTextSize(exerciseSettingsButton)
    }
    
    func updateSegmentedControlTextSize(_ segmentedControl: UISegmentedControl){
        segmentedControl.setTitleTextAttributes([.foregroundColor: Colors.black!, .font: UIFont.systemFont(ofSize: textSize),], for: .normal)
    }
    
    func updateLabelTextSize(_ label: UILabel){
        label.font = label.font.withSize(textSize)
    }
    
    func updateButtonTextSize(_ button: UIButton){
        button.titleLabel?.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
    }
    
    func dismissView(){
        self.dismiss(animated: true, completion: nil)
    }

    func changeViewState(_ uiview: UIView, alpha a: CGFloat, isUserInteraction bool: Bool){
        UIView.transition(with: uiview, duration: 0.4,
                          options: (a < 1 ? .transitionFlipFromTop : .transitionFlipFromBottom),
                          animations: {
            uiview.isUserInteractionEnabled = bool
            uiview.alpha = a
        })
    }
}

//MARK: - X2HourDelegate

extension SettingsViewController: X2HourDelegate {
    func x2HourChanged(_ userSelectedHour: Int) {
        self.x2HoursLabel.text = self.wordBrain.hours[userSelectedHour]
    }
}

//MARK: - Layout

extension SettingsViewController {
    
    func style() {
        
        tabBar.delegate = self
        
        xView.setViewCornerRadius(8)
        let xViewGesture = UITapGestureRecognizer(target: self, action:  #selector(self.xViewPressed))
        xView.addGestureRecognizer(xViewGesture)
        
        appSoundView.setViewCornerRadius(8)
        wordSoundView.setViewCornerRadius(8)
        soundSpeedView.setViewCornerRadius(8)
        textSizeView.setViewCornerRadius(8)
        
        soundSpeedStackView.axis = .vertical
        soundSpeedStackView.spacing = 8
        soundSpeedStackView.distribution = .fill
        
        textSizeStackView.axis = .vertical
        textSizeStackView.spacing = 8
        textSizeStackView.distribution = .fill
        
        x2Label.text = "2x Hour"
        x2Label.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        
        x2HoursLabel.textAlignment = .right
        x2HoursLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        
        appSoundLabel.text = "App Sound"
        appSoundLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        
        appSoundSwitch.addTarget(self, action: #selector(appSoundChanged(_:)),
                                 for: UIControl.Event.valueChanged)
        
        wordSoundLabel.text = "Word Sound"
        wordSoundLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        
        wordSoundSwitch.addTarget(self, action: #selector(wordSoundChanged(_:)),
                                  for: UIControl.Event.valueChanged)
        
        soundSpeedLabel.text = "Sound Speed"
        soundSpeedLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        
        soundSpeedButton.addTarget(self, action: #selector(soundSpeedButtonPressed),
                                   for: .primaryActionTriggered)
        
        soundSpeedSegmentedControl.replaceSegments(segments: ["0.5", "1", "2"])
        soundSpeedSegmentedControl.addTarget(self, action: #selector(soundSpeedChanged(_:)),
                                             for: UIControl.Event.valueChanged)
        
        textSizeLabel.text = "Text Size"
        textSizeLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        
        textSegmentedControl.replaceSegments(segments: ["9", "11", "13", "15", "17", "19", "21"])
        textSegmentedControl.addTarget(self, action: #selector(textSizeChanged(_:)),
                                       for: UIControl.Event.valueChanged)
        
        exerciseSettingsButton.setTitle("Exercise Settings", for: [])
        exerciseSettingsButton.layer.cornerRadius = 10
        exerciseSettingsButton.setImageWithRenderingMode(image: Images.next,
                                                         width: 18, height: 18,
                                                         color: Colors.black ?? .black)
        exerciseSettingsButton.addTarget(self, action: #selector(exerciseSettingsButtonPressed),
                                         for: .primaryActionTriggered)
    }
    
    func layout() {

        xView.addSubview(x2Label)
        xView.addSubview(x2HoursLabel)
        
        appSoundView.addSubview(appSoundLabel)
        appSoundView.addSubview(appSoundSwitch)
        
        wordSoundView.addSubview(wordSoundLabel)
        wordSoundView.addSubview(wordSoundSwitch)
        
        soundSpeedStackView.addArrangedSubview(soundSpeedLabel)
        soundSpeedStackView.addArrangedSubview(soundSpeedSegmentedControl)
        
        soundSpeedView.addSubview(soundSpeedStackView)
        soundSpeedView.addSubview(soundSpeedButton)
        
        textSizeStackView.addArrangedSubview(textSizeLabel)
        textSizeStackView.addArrangedSubview(textSegmentedControl)
        
        textSizeView.addSubview(textSizeStackView)
        
        view.addSubview(xView)
        view.addSubview(appSoundView)
        view.addSubview(wordSoundView)
        view.addSubview(soundSpeedView)
        view.addSubview(textSizeView)
        view.addSubview(exerciseSettingsButton)
        
        //2x Hour
        xView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                     right: view.rightAnchor, paddingTop: 16,
                     paddingLeft: 32, paddingRight: 32)
        
        x2Label.centerY(inView: xView)
        x2Label.anchor(left: xView.leftAnchor, paddingLeft: 16)
        
        x2HoursLabel.centerY(inView: xView)
        x2HoursLabel.anchor(right: xView.rightAnchor, paddingRight: 16)
        
        //App Sound
        appSoundView.anchor(top: xView.bottomAnchor, left: view.leftAnchor,
                            right: view.rightAnchor, paddingTop: 16,
                            paddingLeft: 32, paddingRight: 32)
        
        appSoundLabel.centerY(inView: appSoundView)
        appSoundLabel.anchor(left: appSoundView.leftAnchor, paddingLeft: 16)
        
        appSoundSwitch.centerY(inView: appSoundView)
        appSoundSwitch.anchor(right: appSoundView.rightAnchor, paddingRight: 16)
        
        //Word Sound
        wordSoundView.anchor(top: appSoundView.bottomAnchor, left: view.leftAnchor,
                             right: view.rightAnchor, paddingTop: 16,
                             paddingLeft: 32, paddingRight: 32)
        
        wordSoundLabel.centerY(inView: wordSoundView)
        wordSoundLabel.anchor(left: wordSoundView.leftAnchor, paddingLeft: 16)
        
        wordSoundSwitch.centerY(inView: wordSoundView)
        wordSoundSwitch.anchor(right: wordSoundView.rightAnchor, paddingRight: 16)
        
        //Sound Speed
        soundSpeedView.anchor(top: wordSoundView.bottomAnchor, left: view.leftAnchor,
                              right: view.rightAnchor, paddingTop: 16,
                              paddingLeft: 32, paddingRight: 32)
        
        soundSpeedButton.anchor(top: soundSpeedView.topAnchor, right: soundSpeedView.rightAnchor,
                                paddingTop: 9, paddingRight: 16)
        
        soundSpeedStackView.anchor(top: soundSpeedView.topAnchor, left: soundSpeedView.leftAnchor,
                                   bottom: soundSpeedView.bottomAnchor, right: soundSpeedView.rightAnchor,
                                   paddingTop: 16, paddingLeft: 16,
                                   paddingBottom: 16, paddingRight: 16)
        
        //Text Size
        textSizeView.anchor(top: soundSpeedView.bottomAnchor, left: view.leftAnchor,
                            right: view.rightAnchor, paddingTop: 16,
                            paddingLeft: 32, paddingRight: 32)
        
        textSizeStackView.anchor(top: textSizeView.topAnchor, left: textSizeView.leftAnchor,
                                 bottom: textSizeView.bottomAnchor, right: textSizeView.rightAnchor,
                                 paddingTop: 16, paddingLeft: 16,
                                 paddingBottom: 16, paddingRight: 16)
        
        //Exercise Settings
        exerciseSettingsButton.anchor(top: textSizeView.bottomAnchor, left: textSizeView.leftAnchor,
                                      right: textSizeView.rightAnchor, paddingTop: 16)
        
        xView.setHeight(40)
        appSoundView.setHeight(40)
        wordSoundView.setHeight(40)
        soundSpeedView.setHeight(90)
        textSizeView.setHeight(90)
        exerciseSettingsButton.setHeight(40)
        exerciseSettingsButton.moveImageRight()
        
        view.addSubview(tabBar)
        tabBar.setDimensions(width: view.bounds.width, height: 66)
        tabBar.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
}

//MARK: - TabBarDelegate

extension SettingsViewController: TabBarDelegate {
    
    func homePressed() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func dailyPressed() {
        pushVC(vc: DailyViewController())
    }
    
    func awardPressed() {
        pushVC(vc: AwardsViewController())
    }
    
    func statisticPressed() {
        pushVC(vc: StatisticViewController())
    }
    
    func settingPressed() {
        //pushVC(vc: SettingsViewController())
    }
    
    func pushVC(vc: UIViewController){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05){
           self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
