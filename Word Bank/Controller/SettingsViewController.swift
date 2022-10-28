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
    
    var player = Player()
    var wordBrain = WordBrain()
    var soundSpeed = 0.0
    var onViewWillDisappear: (()->())?
    var soundImageName = ""
    var textSize: CGFloat { return UserDefault.textSize.getCGFloat() }
    
    let hours = ["00:00 - 01:00",
                 "01:00 - 02:00",
                 "02:00 - 03:00",
                 "03:00 - 04:00",
                 "04:00 - 05:00",
                 "05:00 - 06:00",
                 "06:00 - 07:00",
                 "07:00 - 08:00",
                 "08:00 - 09:00",
                 "09:00 - 10:00",
                 "10:00 - 11:00",
                 "11:00 - 12:00",
                 "12:00 - 13:00",
                 "13:00 - 14:00",
                 "14:00 - 15:00",
                 "15:00 - 16:00",
                 "16:00 - 17:00",
                 "17:00 - 18:00",
                 "18:00 - 19:00",
                 "19:00 - 20:00",
                 "20:00 - 21:00",
                 "21:00 - 22:00",
                 "22:00 - 23:00",
                 "23:00 - 00:00"]
    
    //tabBar
    let tabBarStackView = UIStackView()
    let homeButton = UIButton()
    let dailyButton = UIButton()
    let awardButton = UIButton()
    let statisticButton = UIButton()
    let settingsButton = UIButton()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        configureColor()
        updateTextSize()
        setupCornerRadius()
        setupButton(soundSpeedButton)
        configureTabBar()
        configureNavigationBar()
        style()
        setupDefaults()
        layout()
    }
    
    //MARK: - prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goPicker" {
            if segue.destination is X2SettingViewController {
                (segue.destination as? X2SettingViewController)?.onViewWillDisappear = { (id) -> Void in
                    self.x2HoursLabel.text = self.hours[id]
                    self.onViewWillDisappear?()// trigger function in ViewController
                }
            }
        }
    }
    
    //MARK: - Selectors
    
    @objc func xViewPressed(gesture: UISwipeGestureRecognizer) {
        let vc = X2SettingViewController()
        vc.modalPresentationStyle = .popover
        vc.popoverPresentationController?.sourceView = UIView()
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
        if sender.isOn {
            UserDefault.playAppSound.set(0)
        } else {
            UserDefault.playAppSound.set(1)
        }
    }
    
    @objc func soundSpeedChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UserDefault.soundSpeed.set(0.3)
            soundSpeed = 0.3
            break
        case 1:
            UserDefault.soundSpeed.set(0.5)
            soundSpeed = 0.5
            break
        case 2:
            UserDefault.soundSpeed.set(0.7)
            soundSpeed = 0.7
            break
        default: break
        }
        soundSpeedButton.flash()
        player.playSound(soundSpeed, "how are you?")
    }
    
    @objc func soundSpeedButtonPressed(_ sender: UIButton) {
        soundSpeedButton.flash()
        player.playSound(soundSpeed, "how are you?")
    }
    
    @objc func textSizeChanged(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            UserDefault.textSize.set(9)
            break
        case 1:
            UserDefault.textSize.set(11)
            break
        case 2:
            UserDefault.textSize.set(13)
            break
        case 3:
            UserDefault.textSize.set(15)
            break
        case 4:
            UserDefault.textSize.set(17)
            break
        case 5:
            UserDefault.textSize.set(19)
            break
        default:
            UserDefault.textSize.set(21)
        }
        updateTextSize()
    }
    
    //MARK: - Helpers
    
    func configureColor() {
        
        appSoundView.backgroundColor = Colors.cellRight
        wordSoundView.backgroundColor = Colors.cellRight
        soundSpeedView.backgroundColor = Colors.cellRight
        textSizeView.backgroundColor = Colors.cellRight
        
        x2Label.textColor = Colors.black
        x2HoursLabel.textColor = Colors.black
        appSoundLabel.textColor = Colors.black
        wordSoundLabel.textColor = Colors.black
        soundSpeedLabel.textColor = Colors.black
        textSizeLabel.textColor = Colors.black
        
        soundSpeedButton.changeBackgroundColor(to: .clear)
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
        button.setImage(imageName: "soundBlack", width: 30, height: 30)
    }
    
    func setupCornerRadius(){
        wordSoundView.layer.cornerRadius = 8
        textSizeView.layer.cornerRadius = 8
        appSoundView.layer.cornerRadius = 8
        soundSpeedView.layer.cornerRadius = 8
    }
    
    func setupDefaults(){
        if UserDefault.playSound.getInt() == 1 {
            wordSoundSwitch.isOn = false
            changeViewState(soundSpeedView, alpha: 0.6, isUserInteraction: false)
        } else {
            wordSoundSwitch.isOn = true
            changeViewState(soundSpeedView, alpha: 1, isUserInteraction: true)
        }
        
        if UserDefault.playAppSound.getInt() == 1 {
            appSoundSwitch.isOn = false
        } else {
            appSoundSwitch.isOn = true
        }
        
        if UserDefault.textSize.getInt() == 0 {
            UserDefault.textSize.set(15)
            UserDefault.soundSpeed.set(0.3)
        }
        
        x2HoursLabel.text = hours[UserDefault.userSelectedHour.getInt()]
        
        soundSpeed = UserDefault.soundSpeed.getDouble()
        switch soundSpeed {
        case 0.3:
            soundSpeedSegmentedControl.selectedSegmentIndex = 0
            break
        case 0.5:
            soundSpeedSegmentedControl.selectedSegmentIndex = 1
            break
        case 0.7:
            soundSpeedSegmentedControl.selectedSegmentIndex = 2
            break
        default: break
        }
        
        switch UserDefault.textSize.getInt() {
        case 9:
            textSegmentedControl.selectedSegmentIndex = 0
            break
        case 11:
            textSegmentedControl.selectedSegmentIndex = 1
            break
        case 13:
            textSegmentedControl.selectedSegmentIndex = 2
            break
        case 15:
            textSegmentedControl.selectedSegmentIndex = 3
            break
        case 17:
            textSegmentedControl.selectedSegmentIndex = 4
            break
        case 19:
            textSegmentedControl.selectedSegmentIndex = 5
            break
        case 21:
            textSegmentedControl.selectedSegmentIndex = 6
            break
        default: break
        }
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
    }
    
    func updateSegmentedControlTextSize(_ segmentedControl: UISegmentedControl){
        segmentedControl.setTitleTextAttributes([.foregroundColor: Colors.black!, .font: UIFont.systemFont(ofSize: textSize),], for: .normal)
    }
    
    func updateLabelTextSize(_ label: UILabel){
        label.font = label.font.withSize(textSize)
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

extension SettingsViewController {
    
    func style() {
        view.backgroundColor = Colors.cellLeft
        
        xView.translatesAutoresizingMaskIntoConstraints = false
        xView.backgroundColor = Colors.cellRight
        xView.setViewCornerRadius(8)
        let xViewGesture = UITapGestureRecognizer(target: self, action:  #selector(self.xViewPressed))
        xView.addGestureRecognizer(xViewGesture)
        
        appSoundView.translatesAutoresizingMaskIntoConstraints = false
        appSoundView.backgroundColor = Colors.cellRight
        appSoundView.setViewCornerRadius(8)
        
        wordSoundView.translatesAutoresizingMaskIntoConstraints = false
        wordSoundView.backgroundColor = Colors.cellRight
        wordSoundView.setViewCornerRadius(8)
        
        soundSpeedView.translatesAutoresizingMaskIntoConstraints = false
        soundSpeedView.backgroundColor = Colors.cellRight
        soundSpeedView.setViewCornerRadius(8)
        
        textSizeView.translatesAutoresizingMaskIntoConstraints = false
        textSizeView.backgroundColor = Colors.cellRight
        textSizeView.setViewCornerRadius(8)
        
        soundSpeedStackView.translatesAutoresizingMaskIntoConstraints = false
        soundSpeedStackView.axis = .vertical
        soundSpeedStackView.spacing = 8
        soundSpeedStackView.distribution = .fill
        
        textSizeStackView.translatesAutoresizingMaskIntoConstraints = false
        textSizeStackView.axis = .vertical
        textSizeStackView.spacing = 8
        textSizeStackView.distribution = .fill
        
        x2Label.translatesAutoresizingMaskIntoConstraints = false
        x2Label.textColor = Colors.black
        x2Label.text = "2x Hour"
        x2Label.font = UIFont(name: "AvenirNext-Regular", size: textSize)
        
        x2HoursLabel.translatesAutoresizingMaskIntoConstraints = false
        x2HoursLabel.textColor = .darkGray
        x2HoursLabel.textAlignment = .right
        x2HoursLabel.font = UIFont(name: "AvenirNext-Regular", size: textSize)
        
        appSoundLabel.translatesAutoresizingMaskIntoConstraints = false
        appSoundLabel.textColor = Colors.black
        appSoundLabel.text = "App Sound"
        appSoundLabel.font = UIFont(name: "AvenirNext-Regular", size: textSize)
        
        appSoundSwitch.translatesAutoresizingMaskIntoConstraints = false
        appSoundSwitch.addTarget(self, action: #selector(appSoundChanged(_:)), for: UIControl.Event.valueChanged)
        
        wordSoundLabel.translatesAutoresizingMaskIntoConstraints = false
        wordSoundLabel.textColor = Colors.black
        wordSoundLabel.text = "Word Sound"
        wordSoundLabel.font = UIFont(name: "AvenirNext-Regular", size: textSize)
        
        wordSoundSwitch.translatesAutoresizingMaskIntoConstraints = false
        wordSoundSwitch.addTarget(self, action: #selector(wordSoundChanged(_:)), for: UIControl.Event.valueChanged)
        
        soundSpeedLabel.translatesAutoresizingMaskIntoConstraints = false
        soundSpeedLabel.textColor = Colors.black
        soundSpeedLabel.text = "Sound Speed"
        soundSpeedLabel.font = UIFont(name: "AvenirNext-Regular", size: textSize)
        
        soundSpeedButton.translatesAutoresizingMaskIntoConstraints = false
        soundSpeedButton.addTarget(self, action: #selector(soundSpeedButtonPressed), for: .primaryActionTriggered)
        
        soundSpeedSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        soundSpeedSegmentedControl.replaceSegments(segments: ["0.5", "1", "2"])
        soundSpeedSegmentedControl.tintColor = .black
        soundSpeedSegmentedControl.addTarget(self, action: #selector(soundSpeedChanged(_:)), for: UIControl.Event.valueChanged)
        
        textSizeLabel.translatesAutoresizingMaskIntoConstraints = false
        textSizeLabel.textColor = Colors.black
        textSizeLabel.text = "Text Size"
        textSizeLabel.font = UIFont(name: "AvenirNext-Regular", size: textSize)
        
        textSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        textSegmentedControl.replaceSegments(segments: ["9", "11", "13", "15", "17", "19", "21"])
        textSegmentedControl.tintColor = .black
        textSegmentedControl.addTarget(self, action: #selector(textSizeChanged(_:)), for: UIControl.Event.valueChanged)
        
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
        
        NSLayoutConstraint.activate([
            
            xView.topAnchor.constraint(equalTo: view.topAnchor, constant: self.navigationController!.navigationBar.frame.height+45),
            xView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            xView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            x2Label.topAnchor.constraint(equalTo: xView.topAnchor, constant: 8),
            x2Label.leadingAnchor.constraint(equalTo: xView.leadingAnchor, constant: 16),
            x2Label.bottomAnchor.constraint(equalTo: xView.bottomAnchor, constant: -8),
            
            x2HoursLabel.topAnchor.constraint(equalTo: xView.topAnchor, constant: 8),
            x2HoursLabel.trailingAnchor.constraint(equalTo: xView.trailingAnchor, constant: -16),
            x2HoursLabel.bottomAnchor.constraint(equalTo: xView.bottomAnchor, constant: -8),

            appSoundView.topAnchor.constraint(equalTo: xView.bottomAnchor, constant: 16),
            appSoundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            appSoundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            appSoundLabel.topAnchor.constraint(equalTo: appSoundView.topAnchor, constant: 8),
            appSoundLabel.leadingAnchor.constraint(equalTo: appSoundView.leadingAnchor, constant: 16),
            appSoundLabel.bottomAnchor.constraint(equalTo: appSoundView.bottomAnchor, constant: -8),
            
            appSoundSwitch.topAnchor.constraint(equalTo: appSoundView.topAnchor, constant: 4),
            appSoundSwitch.trailingAnchor.constraint(equalTo: appSoundView.trailingAnchor, constant: -16),
            
            wordSoundView.topAnchor.constraint(equalTo: appSoundView.bottomAnchor, constant: 16),
            wordSoundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            wordSoundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            wordSoundLabel.topAnchor.constraint(equalTo: wordSoundView.topAnchor, constant: 8),
            wordSoundLabel.leadingAnchor.constraint(equalTo: wordSoundView.leadingAnchor, constant: 16),
            wordSoundLabel.bottomAnchor.constraint(equalTo: wordSoundView.bottomAnchor, constant: -8),
            
            wordSoundSwitch.topAnchor.constraint(equalTo: wordSoundView.topAnchor, constant: 4),
            wordSoundSwitch.trailingAnchor.constraint(equalTo: wordSoundView.trailingAnchor, constant: -16),
            
            soundSpeedView.topAnchor.constraint(equalTo: wordSoundView.bottomAnchor, constant: 16),
            soundSpeedView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            soundSpeedView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            soundSpeedButton.topAnchor.constraint(equalTo: soundSpeedView.topAnchor, constant: 9),
            soundSpeedButton.trailingAnchor.constraint(equalTo: soundSpeedView.trailingAnchor, constant: -16),
            
            soundSpeedStackView.topAnchor.constraint(equalTo: soundSpeedView.topAnchor, constant: 16),
            soundSpeedStackView.leadingAnchor.constraint(equalTo: soundSpeedView.leadingAnchor, constant: 16),
            soundSpeedStackView.trailingAnchor.constraint(equalTo: soundSpeedView.trailingAnchor, constant: -16),
            soundSpeedStackView.bottomAnchor.constraint(equalTo: soundSpeedView.bottomAnchor, constant: -16),
            
            textSizeView.topAnchor.constraint(equalTo: soundSpeedView.bottomAnchor, constant: 16),
            textSizeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            textSizeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            textSizeStackView.topAnchor.constraint(equalTo: textSizeView.topAnchor, constant: 16),
            textSizeStackView.leadingAnchor.constraint(equalTo: textSizeView.leadingAnchor, constant: 16),
            textSizeStackView.trailingAnchor.constraint(equalTo: textSizeView.trailingAnchor, constant: -16),
            textSizeStackView.bottomAnchor.constraint(equalTo: textSizeView.bottomAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            xView.heightAnchor.constraint(equalToConstant: 40),
            appSoundView.heightAnchor.constraint(equalToConstant: 40),
            wordSoundView.heightAnchor.constraint(equalToConstant: 40),
            soundSpeedView.heightAnchor.constraint(equalToConstant: 90),
            textSizeView.heightAnchor.constraint(equalToConstant: 90),
        ])
    }
}

//MARK: - Tab Bar

extension SettingsViewController {
    
    func configureTabBar() {
        tabBarStackView.translatesAutoresizingMaskIntoConstraints = false
        tabBarStackView.axis = .horizontal
        tabBarStackView.spacing = 0
        tabBarStackView.distribution = .fillEqually
        
        homeButton.backgroundColor = .white
        dailyButton.backgroundColor = .white
        awardButton.backgroundColor = .white
        statisticButton.backgroundColor = .white
        settingsButton.backgroundColor = .white
        
        homeButton.setImageWithRenderingMode(imageName: "home", width: 25, height: 25, color: .darkGray)
        dailyButton.setImageWithRenderingMode(imageName: "dailyQuest", width: 26, height: 26, color: .darkGray)
        awardButton.setImageWithRenderingMode(imageName: "award", width: 27, height: 27, color: .darkGray)
        statisticButton.setImageWithRenderingMode(imageName: "statistic", width: 25, height: 25, color: .darkGray)
        settingsButton.setImageWithRenderingMode(imageName: "settingsImage", width: 25, height: 25, color: Colors.blue ?? .blue)
        
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.setTitle("Home", for: .normal)
        homeButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 11)
        homeButton.setTitleColor(.darkGray, for: .normal)
        homeButton.alignTextBelow()
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .primaryActionTriggered)
        
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        dailyButton.setTitle("Daily", for: .normal)
        dailyButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 11)
        dailyButton.setTitleColor(.darkGray, for: .normal)
        dailyButton.alignTextBelow()
        dailyButton.addTarget(self, action: #selector(dailyButtonPressed), for: .primaryActionTriggered)
        
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        awardButton.setTitle("Awards", for: .normal)
        awardButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 11)
        awardButton.setTitleColor(.darkGray, for: .normal)
        awardButton.alignTextBelow()
        awardButton.addTarget(self, action: #selector(awardButtonPressed), for: .primaryActionTriggered)
        
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        statisticButton.setTitle("Statistics", for: .normal)
        statisticButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 11)
        statisticButton.setTitleColor(.darkGray, for: .normal)
        statisticButton.alignTextBelow()
        statisticButton.addTarget(self, action: #selector(statisticButtonPressed), for: .primaryActionTriggered)
        
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 11)
        settingsButton.setTitleColor(Colors.blue ?? .blue, for: .normal)
        settingsButton.alignTextBelow()
        
        tabBarStackView.addArrangedSubview(homeButton)
        tabBarStackView.addArrangedSubview(dailyButton)
        tabBarStackView.addArrangedSubview(awardButton)
        tabBarStackView.addArrangedSubview(statisticButton)
        tabBarStackView.addArrangedSubview(settingsButton)
        view.addSubview(tabBarStackView)
        
        NSLayoutConstraint.activate([
            tabBarStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tabBarStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tabBarStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            tabBarStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabBarStackView.heightAnchor.constraint(equalToConstant: 66)
        ])
    }
    
    @objc func homeButtonPressed(gesture: UISwipeGestureRecognizer) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func dailyButtonPressed(gesture: UISwipeGestureRecognizer) {
        
    }
    
    @objc func awardButtonPressed(gesture: UISwipeGestureRecognizer) {
        
    }
    
    @objc func statisticButtonPressed(gesture: UISwipeGestureRecognizer) {
        let vc = StatisticViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
