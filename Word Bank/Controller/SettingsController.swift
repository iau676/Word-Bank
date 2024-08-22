//
//  SettingsViewController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 13.03.2022.
//

import UIKit
import AVFoundation
import CoreData

class SettingsController: UIViewController, UITextFieldDelegate {
        
    private let appSoundView = UIView()
    private let wordSoundView = UIView()
    private let soundSpeedView = UIView()
    
    private let soundSpeedStackView = UIStackView()
    
    private let appSoundLabel = UILabel()
    private let wordSoundLabel = UILabel()
    private let soundSpeedLabel = UILabel()
    
    private let appSoundSwitch = UISwitch()
    private let wordSoundSwitch = UISwitch()
    
    private let soundSpeedSegmentedControl = UISegmentedControl()
    
    private let soundSpeedButton = UIButton()
    
    private let testTypeView = UIView()
    private let testTypeStackView = UIStackView()
    private let testTypeLabel = UILabel()
    private let testTypeSegmentedControl = UISegmentedControl()
    
    private let pointView = UIView()
    private let pointLabel = UILabel()
    fileprivate let pointCV:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = Colors.cellRight
        cv.register(ExerciseSettingsCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private let typingView = UIView()
    private let typingLabel = UILabel()
    fileprivate let typingCV:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = Colors.cellRight
        cv.register(ExerciseSettingsCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private var wordBrain = WordBrain()
    private var soundSpeed = 0.0
    private var soundImageName = ""
    private var textSize: CGFloat { return UserDefault.textSize.getCGFloat() }
    
    private let textSizeArray = [9, 11, 13, 15, 17, 19, 21]
    private let soundSpeedArray = [0.3, 0.5, 0.7]
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        configureColor()
        updateTextSize()
        setupButton(soundSpeedButton)
        style()
        setupDefaults()
        layout()
    }
    
    //MARK: - Selectors

    @objc private func wordSoundChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefault.playSound.set(0)
            changeViewState(soundSpeedView, alpha: 1, isUserInteraction: true)
        } else {
            UserDefault.playSound.set(1)
            changeViewState(soundSpeedView, alpha: 0.6, isUserInteraction: false)
        }
    }
    
    @objc private func appSoundChanged(_ sender: UISwitch) {
        UserDefault.playAppSound.set(sender.isOn == true ? 0 : 1)
    }
    
    @objc private func soundSpeedChanged(_ sender: UISegmentedControl) {
        UserDefault.soundSpeed.set(soundSpeedArray[sender.selectedSegmentIndex])
        soundSpeed = soundSpeedArray[sender.selectedSegmentIndex]
        soundSpeedButton.flash()
        Player.shared.playSound(soundSpeed, "how are you?")
    }
    
    @objc private func soundSpeedButtonPressed(_ sender: UIButton) {
        soundSpeedButton.flash()
        Player.shared.playSound(soundSpeed, "how are you?")
    }
    
    @objc private func testTypeChanged(_ sender: UISegmentedControl) {
        UserDefault.selectedTestType.set(sender.selectedSegmentIndex)
    }
    
    //MARK: - Helpers
    
    private func configureColor() {
        view.backgroundColor = Colors.cellLeft
        appSoundView.backgroundColor = Colors.cellRight
        wordSoundView.backgroundColor = Colors.cellRight
        soundSpeedView.backgroundColor = Colors.cellRight
        
        appSoundLabel.textColor = Colors.black
        wordSoundLabel.textColor = Colors.black
        soundSpeedLabel.textColor = Colors.black
        
        soundSpeedButton.changeBackgroundColor(to: .clear)
        
        soundSpeedSegmentedControl.tintColor = .black
    }

    private func setupButton(_ button: UIButton){
        button.setImage(image: Images.soundBlack, width: 30, height: 30)
    }
    
    private func setupDefaults(){
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
        
        soundSpeed = UserDefault.soundSpeed.getDouble()
        guard let soundSpeedIndex = soundSpeedArray.firstIndex(where: {$0 == soundSpeed}) else {return}
        soundSpeedSegmentedControl.selectedSegmentIndex = soundSpeedIndex
    }

    private func updateTextSize(){
        updateLabelTextSize(wordSoundLabel)
        updateLabelTextSize(appSoundLabel)
        updateLabelTextSize(soundSpeedLabel)
  
        updateSegmentedControlTextSize(soundSpeedSegmentedControl)
    }
    
    private func updateSegmentedControlTextSize(_ segmentedControl: UISegmentedControl){
        segmentedControl.setTitleTextAttributes([.foregroundColor: Colors.black, .font: UIFont.systemFont(ofSize: textSize),], for: .normal)
    }
    
    private func updateLabelTextSize(_ label: UILabel){
        label.font = label.font.withSize(textSize)
    }
    
    private func updateButtonTextSize(_ button: UIButton){
        button.titleLabel?.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
    }

    private func changeViewState(_ uiview: UIView, alpha a: CGFloat, isUserInteraction bool: Bool){
        UIView.transition(with: uiview, duration: 0.4,
                          options: (a < 1 ? .transitionFlipFromTop : .transitionFlipFromBottom),
                          animations: {
            uiview.isUserInteractionEnabled = bool
            uiview.alpha = a
        })
    }
}

//MARK: - Layout

extension SettingsController {
    
    private func style() {
        title = "Settings"
        
        soundSpeedStackView.axis = .vertical
        soundSpeedStackView.spacing = 8
        soundSpeedStackView.distribution = .fill
        
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
        
        testTypeView.backgroundColor = Colors.cellRight
        
        testTypeStackView.axis = .vertical
        testTypeStackView.spacing = 8
        testTypeStackView.distribution = .fill
        
        testTypeLabel.text = "Test Type"
        testTypeLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        testTypeLabel.textColor = Colors.black
        
        testTypeSegmentedControl.tintColor = .black
        testTypeSegmentedControl.replaceSegments(segments: ["English - Meaning", "Meaning - English"])
        testTypeSegmentedControl.setTitleTextAttributes([.foregroundColor: Colors.black,
                                                         .font: UIFont.systemFont(ofSize: textSize-3),], for: .normal)
        testTypeSegmentedControl.selectedSegmentIndex = UserDefault.selectedTestType.getInt()
        testTypeSegmentedControl.addTarget(self, action: #selector(testTypeChanged(_:)),
                                           for: UIControl.Event.valueChanged)
        
        pointView.backgroundColor = Colors.cellRight
        
        pointLabel.text = "Point Effect"
        pointLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        
        pointCV.delegate = self
        pointCV.dataSource = self
        
        typingView.backgroundColor = Colors.cellRight
        
        typingLabel.text = "Typing"
        typingLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        
        typingCV.delegate = self
        typingCV.dataSource = self
    }
    
    private func layout() {
        appSoundView.addSubview(appSoundLabel)
        appSoundView.addSubview(appSoundSwitch)
        
        wordSoundView.addSubview(wordSoundLabel)
        wordSoundView.addSubview(wordSoundSwitch)
        
        soundSpeedStackView.addArrangedSubview(soundSpeedLabel)
        soundSpeedStackView.addArrangedSubview(soundSpeedSegmentedControl)
        
        soundSpeedView.addSubview(soundSpeedStackView)
        soundSpeedView.addSubview(soundSpeedButton)
                
        let stack = UIStackView(arrangedSubviews: [appSoundView, wordSoundView, soundSpeedView])
        stack.axis = .vertical
        stack.spacing = 1
        stack.distribution = .fill
        stack.backgroundColor = .clear
        stack.layer.cornerRadius = 10
        stack.layer.masksToBounds = true
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor,
                     paddingTop: 16, paddingLeft: 32, paddingRight: 32)
        
        appSoundLabel.centerY(inView: appSoundView)
        appSoundLabel.anchor(left: appSoundView.leftAnchor, paddingLeft: 16)
        
        appSoundSwitch.centerY(inView: appSoundView)
        appSoundSwitch.anchor(right: appSoundView.rightAnchor, paddingRight: 16)
        
        wordSoundLabel.centerY(inView: wordSoundView)
        wordSoundLabel.anchor(left: wordSoundView.leftAnchor, paddingLeft: 16)
        
        wordSoundSwitch.centerY(inView: wordSoundView)
        wordSoundSwitch.anchor(right: wordSoundView.rightAnchor, paddingRight: 16)
        
        soundSpeedButton.anchor(top: soundSpeedView.topAnchor, right: soundSpeedView.rightAnchor,
                                paddingTop: 9, paddingRight: 16)
        
        soundSpeedStackView.anchor(top: soundSpeedView.topAnchor, left: soundSpeedView.leftAnchor,
                                   bottom: soundSpeedView.bottomAnchor, right: soundSpeedView.rightAnchor,
                                   paddingTop: 16, paddingLeft: 16,
                                   paddingBottom: 16, paddingRight: 16)
        
        appSoundView.setHeight(50)
        wordSoundView.setHeight(50)
        soundSpeedView.setHeight(90)
        
        let secondStack = UIStackView(arrangedSubviews: [testTypeView, pointView, typingView])
        secondStack.axis = .vertical
        secondStack.spacing = 1
        secondStack.distribution = .fill
        secondStack.backgroundColor = .clear
        secondStack.layer.cornerRadius = 10
        secondStack.layer.masksToBounds = true
        
        view.addSubview(secondStack)
        secondStack.anchor(top: stack.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 16, paddingLeft: 32, paddingRight: 32)
        
        testTypeView.addSubview(testTypeStackView)
        testTypeStackView.addArrangedSubview(testTypeLabel)
        testTypeStackView.addArrangedSubview(testTypeSegmentedControl)
        
        testTypeView.setHeight(90)
        
        testTypeStackView.anchor(top: testTypeView.topAnchor, left: testTypeView.leftAnchor,
                                 bottom: testTypeView.bottomAnchor, right: testTypeView.rightAnchor,
                                 paddingTop: 16, paddingLeft: 16,
                                 paddingBottom: 16, paddingRight: 16)
        
        pointView.addSubview(pointLabel)
        pointView.addSubview(pointCV)
        
        pointView.setHeight(160)
        
        pointLabel.anchor(top: pointView.topAnchor, left: pointView.leftAnchor,
                          paddingTop: 16, paddingLeft: 16)
        
        pointCV.anchor(top: pointLabel.bottomAnchor, left: pointView.leftAnchor,
                       bottom: pointView.bottomAnchor, right: pointView.rightAnchor,
                       paddingTop: 8, paddingLeft: 16,
                       paddingBottom: 16, paddingRight: 16)
        
        typingView.addSubview(typingLabel)
        typingView.addSubview(typingCV)
        
        typingView.setHeight(160)
        
        typingLabel.anchor(top: typingView.topAnchor, left: typingView.leftAnchor,
                           paddingTop: 16, paddingLeft: 16)
        
        typingCV.anchor(top: typingLabel.bottomAnchor, left: typingView.leftAnchor,
                        bottom: typingView.bottomAnchor, right: typingView.rightAnchor,
                        paddingTop: 8, paddingLeft: 16,
                        paddingBottom: 16, paddingRight: 16)
    }
}

//MARK: - UICollectionViewDataSource

extension SettingsController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ExerciseSettingsCell
        switch collectionView {
        case pointCV:
            cell.imageView.image = (indexPath.row == 0) ? Images.greenBubble : Images.greenCircle
            cell.contentView.layer.borderColor = (indexPath.row == UserDefault.selectedPointEffect.getInt()) ? Colors.blue.cgColor : Colors.d6d6d6.cgColor
        case typingCV:
            cell.imageView.image = (indexPath.row == 0) ? Images.customKeyboard : Images.defaultKeyboard
            cell.imageView.layer.cornerRadius = 8
            cell.imageView.clipsToBounds = true
            cell.contentView.layer.borderColor = (indexPath.row == UserDefault.selectedTyping.getInt()) ? Colors.blue.cgColor : Colors.d6d6d6.cgColor
        default: break
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension SettingsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 99, height: 99)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case pointCV:
            UserDefault.selectedPointEffect.set(indexPath.row)
        case typingCV:
            UserDefault.selectedTyping.set(indexPath.row)
        default: break
        }
        collectionView.reloadData()
    }
}
