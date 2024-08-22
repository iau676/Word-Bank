//
//  SettingsViewController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 13.03.2022.
//

import UIKit
import AVFoundation
import CoreData

private let reuseIdentifier = "SettingsCell"

class SettingsController: UIViewController, UITextFieldDelegate {
    
    private let scrollView = UIScrollView()
    private let appSoundView = UIView()
    private let wordSoundView = UIView()
    private let soundSpeedView = UIView()
    
    private let appSoundLabel: UILabel = {
        let label = UILabel()
        label.text = "App Sound"
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 15)
        return label
    }()
    
    private let wordSoundLabel: UILabel = {
        let label = UILabel()
        label.text = "Word Sound"
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 15)
        return label
    }()
    
    private let soundSpeedLabel: UILabel = {
        let label = UILabel()
        label.text = "Sound Speed"
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 15)
        return label
    }()
    
    private lazy var appSoundSwitch: UISwitch = {
        let sw = UISwitch()
        sw.addTarget(self, action: #selector(appSoundChanged(_:)), for: UIControl.Event.valueChanged)
        return sw
    }()
    
    private lazy var wordSoundSwitch: UISwitch = {
        let sw = UISwitch()
        sw.addTarget(self, action: #selector(wordSoundChanged(_:)), for: UIControl.Event.valueChanged)
        return sw
    }()
    
    private lazy var soundSpeedButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .clear
        button.setImage(image: Images.soundBlack, width: 30, height: 30)
        button.addTarget(self, action: #selector(soundSpeedButtonPressed), for: .primaryActionTriggered)
        return button
    }()
    
    private lazy var soundSpeedSegmentedControl: UISegmentedControl = {
        let sg = UISegmentedControl()
        sg.replaceSegments(segments: ["0.5", "1", "2"])
        sg.addTarget(self, action: #selector(soundSpeedChanged(_:)), for: UIControl.Event.valueChanged)
        return sg
    }()
    
    private let testTypeView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.cellRight
        return view
    }()
    
    private let testTypeLabel: UILabel = {
        let label = UILabel()
        label.text = "Test Type"
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 15)
        label.textColor = Colors.black
        return label
    }()
    
    private lazy var testTypeSegmentedControl: UISegmentedControl = {
        let sg = UISegmentedControl()
        sg.tintColor = .black
        sg.replaceSegments(segments: ["English - Meaning", "Meaning - English"])
        sg.setTitleTextAttributes([.foregroundColor: Colors.black, .font: UIFont.systemFont(ofSize: 13),], for: .normal)
        sg.selectedSegmentIndex = UserDefault.selectedTestType.getInt()
        sg.addTarget(self, action: #selector(testTypeChanged(_:)), for: UIControl.Event.valueChanged)
        return sg
    }()
    
    private let pointView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.cellRight
        return view
    }()
    
    private let pointLabel: UILabel = {
        let label = UILabel()
        label.text = "Point Effect"
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 15)
        return label
    }()
    
    private lazy var pointCV:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = Colors.cellRight
        cv.register(ExerciseSettingsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private let typingView: UIView = {
        let view = UIView()
        view.backgroundColor = Colors.cellRight
        return view
    }()
    
    private let typingLabel: UILabel = {
        let label = UILabel()
        label.text = "Typing"
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 15)
        return label
    }()
    
    private lazy var typingCV:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = Colors.cellRight
        cv.register(ExerciseSettingsCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
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
        setupDefaults()
        configureUI()
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
    
    private func configureUI() {
        title = "Settings"
        
        view.addSubview(scrollView)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                          paddingTop: 8, paddingBottom: 8)
        
        let firstStack = UIStackView(arrangedSubviews: [appSoundView, wordSoundView, soundSpeedView])
        firstStack.axis = .vertical
        firstStack.spacing = 1
        firstStack.layer.cornerRadius = 10
        firstStack.layer.masksToBounds = true
        
        appSoundView.setHeight(50)
        wordSoundView.setHeight(50)
        soundSpeedView.setHeight(90)
        
        let secondStack = UIStackView(arrangedSubviews: [testTypeView, pointView, typingView])
        secondStack.axis = .vertical
        secondStack.spacing = 1
        secondStack.layer.cornerRadius = 10
        secondStack.layer.masksToBounds = true
        
        testTypeView.setHeight(90)
        pointView.setHeight(160)
        typingView.setHeight(160)
        
        let stack = UIStackView(arrangedSubviews: [firstStack, secondStack])
        stack.axis = .vertical
        stack.spacing = 32
        stack.alignment = .fill
        
        scrollView.addSubview(stack)
        stack.anchor(top: scrollView.topAnchor, left: view.leftAnchor,
                     bottom: scrollView.bottomAnchor, right: view.rightAnchor,
                     paddingTop: 16, paddingLeft: 32, paddingBottom: 16, paddingRight: 32)
        
        appSoundView.addSubview(appSoundLabel)
        appSoundLabel.centerY(inView: appSoundView)
        appSoundLabel.anchor(left: appSoundView.leftAnchor, paddingLeft: 16)
        
        appSoundView.addSubview(appSoundSwitch)
        appSoundSwitch.centerY(inView: appSoundView)
        appSoundSwitch.anchor(right: appSoundView.rightAnchor, paddingRight: 16)
        
        wordSoundView.addSubview(wordSoundLabel)
        wordSoundLabel.centerY(inView: wordSoundView)
        wordSoundLabel.anchor(left: wordSoundView.leftAnchor, paddingLeft: 16)
        
        wordSoundView.addSubview(wordSoundSwitch)
        wordSoundSwitch.centerY(inView: wordSoundView)
        wordSoundSwitch.anchor(right: wordSoundView.rightAnchor, paddingRight: 16)
        
        soundSpeedView.addSubview(soundSpeedButton)
        soundSpeedButton.anchor(top: soundSpeedView.topAnchor, right: soundSpeedView.rightAnchor,
                                paddingTop: 9, paddingRight: 16)
        
        let soundSpeedStack = UIStackView(arrangedSubviews: [soundSpeedLabel, soundSpeedSegmentedControl])
        soundSpeedStack.axis = .vertical
        soundSpeedStack.spacing = 8
        soundSpeedStack.distribution = .fill
        soundSpeedView.addSubview(soundSpeedStack)
        soundSpeedStack.anchor(top: soundSpeedView.topAnchor, left: soundSpeedView.leftAnchor,
                               bottom: soundSpeedView.bottomAnchor, right: soundSpeedView.rightAnchor,
                               paddingTop: 16, paddingLeft: 16,
                               paddingBottom: 16, paddingRight: 16)
        
        let testTypeStack = UIStackView(arrangedSubviews: [testTypeLabel, testTypeSegmentedControl])
        testTypeStack.axis = .vertical
        testTypeStack.spacing = 8
        testTypeStack.distribution = .fill
        testTypeView.addSubview(testTypeStack)
        testTypeStack.anchor(top: testTypeView.topAnchor, left: testTypeView.leftAnchor,
                             bottom: testTypeView.bottomAnchor, right: testTypeView.rightAnchor,
                             paddingTop: 16, paddingLeft: 16,
                             paddingBottom: 16, paddingRight: 16)
        
        pointView.addSubview(pointLabel)
        pointLabel.anchor(top: pointView.topAnchor, left: pointView.leftAnchor,
                          paddingTop: 16, paddingLeft: 16)
        
        pointView.addSubview(pointCV)
        pointCV.anchor(top: pointLabel.bottomAnchor, left: pointView.leftAnchor,
                       bottom: pointView.bottomAnchor, right: pointView.rightAnchor,
                       paddingTop: 8, paddingLeft: 16,
                       paddingBottom: 16, paddingRight: 16)
        
        typingView.addSubview(typingLabel)
        typingLabel.anchor(top: typingView.topAnchor, left: typingView.leftAnchor,
                           paddingTop: 16, paddingLeft: 16)
        
        typingView.addSubview(typingCV)
        typingCV.anchor(top: typingLabel.bottomAnchor, left: typingView.leftAnchor,
                        bottom: typingView.bottomAnchor, right: typingView.rightAnchor,
                        paddingTop: 8, paddingLeft: 16,
                        paddingBottom: 16, paddingRight: 16)
    }
    
    private func configureColor() {
        view.backgroundColor = Colors.cellLeft
        appSoundView.backgroundColor = Colors.cellRight
        wordSoundView.backgroundColor = Colors.cellRight
        soundSpeedView.backgroundColor = Colors.cellRight
        
        appSoundLabel.textColor = Colors.black
        wordSoundLabel.textColor = Colors.black
        soundSpeedLabel.textColor = Colors.black
        
        soundSpeedSegmentedControl.tintColor = .black
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

//MARK: - UICollectionViewDataSource

extension SettingsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! ExerciseSettingsCell
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
