//
//  SettingsViewController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 13.03.2022.
//

import UIKit

private let reuseIdentifier = "SettingsCell"

class SettingsController: UIViewController {
    
    //MARK: - Properties
    
    private var wordBrain = WordBrain()
    private var soundSpeed = 0.0
    private let soundSpeedArray = [0.3, 0.5, 0.7]
    
    private let scrollView = UIScrollView()
    private let appSoundView = makeBackgroundView(bgColor: Colors.cellRight)
    private let wordSoundView = makeBackgroundView(bgColor: Colors.cellRight)
    private let testTypeView = makeBackgroundView(bgColor: Colors.cellRight)
    private let pointView = makeBackgroundView(bgColor: Colors.cellRight)
    private let typingView = makeBackgroundView(bgColor: Colors.cellRight)
    
    private let soundSpeedView: UIView = {
       let view = makeBackgroundView(bgColor: Colors.cellRight)
        let playSound = UserDefault.playSound.getInt() == 0
        let alpha = playSound ? 1 : 0.6
        view.changeViewState(alpha: alpha, isUserInteraction: playSound)
        return view
    }()
    
    private let appSoundLabel = makeSettingLabel(text: "App Sound")
    private let wordSoundLabel = makeSettingLabel(text: "Word Sound")
    private let soundSpeedLabel = makeSettingLabel(text: "Sound Speed")
    private let testTypeLabel = makeSettingLabel(text: "Test Type")
    private let pointLabel = makeSettingLabel(text: "Point Effect")
    private let typingLabel = makeSettingLabel(text: "Typing")
    
    private lazy var appSoundSwitch: UISwitch = {
        let sw = makeSwitch(isOn: UserDefault.playAppSound.getInt() == 0)
        sw.addTarget(self, action: #selector(appSoundChanged(_:)), for: UIControl.Event.valueChanged)
        return sw
    }()
    
    private lazy var wordSoundSwitch: UISwitch = {
        let sw = makeSwitch(isOn: UserDefault.playSound.getInt() == 0)
        sw.addTarget(self, action: #selector(wordSoundChanged(_:)), for: UIControl.Event.valueChanged)
        return sw
    }()
    
    private let soundSpeedButton: UIButton = {
        let button = UIButton()
        button.setImage(image: Images.soundBlack, width: 30, height: 30)
        return button
    }()
    
    private lazy var soundSpeedSegmentedControl: UISegmentedControl = {
        let sg = makeSegmentedControl(tintColor: UIColor.black, segments: ["0.5", "1", "2"])
        sg.addTarget(self, action: #selector(soundSpeedChanged(_:)), for: UIControl.Event.valueChanged)
        if let soundSpeedIndex = soundSpeedArray.firstIndex(where: {$0 == UserDefault.soundSpeed.getDouble()}) {
            sg.selectedSegmentIndex = soundSpeedIndex
        }
        return sg
    }()
    
    private lazy var testTypeSegmentedControl: UISegmentedControl = {
        let sg = makeSegmentedControl(tintColor: UIColor.black, segments: ["English - Meaning", "Meaning - English"])
        sg.selectedSegmentIndex = UserDefault.selectedTestType.getInt()
        sg.addTarget(self, action: #selector(testTypeChanged(_:)), for: UIControl.Event.valueChanged)
        return sg
    }()
    
    private lazy var pointCV: UICollectionView = {
        let cv = makeSettingCollectionView(withIdentifier: reuseIdentifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var typingCV:UICollectionView = {
        let cv = makeSettingCollectionView(withIdentifier: reuseIdentifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        configureUI()
    }
    
    //MARK: - Selectors

    @objc private func wordSoundChanged(_ sender: UISwitch) {
        if sender.isOn {
            UserDefault.playSound.set(0)
            soundSpeedView.changeViewState(alpha: 1, isUserInteraction: true)
        } else {
            UserDefault.playSound.set(1)
            soundSpeedView.changeViewState(alpha: 0.6, isUserInteraction: false)
        }
    }
    
    @objc private func appSoundChanged(_ sender: UISwitch) {
        UserDefault.playAppSound.set(sender.isOn == true ? 0 : 1)
    }
    
    @objc private func soundSpeedChanged(_ sender: UISegmentedControl) {
        UserDefault.soundSpeed.set(soundSpeedArray[sender.selectedSegmentIndex])
        soundSpeedButton.flash()
        Player.shared.playSound("Word Bank")
    }
    
    @objc private func testTypeChanged(_ sender: UISegmentedControl) {
        UserDefault.selectedTestType.set(sender.selectedSegmentIndex)
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        title = "Settings"
        view.backgroundColor = Colors.cellLeft
        
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
}

//MARK: - UICollectionViewDataSource

extension SettingsController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        let index = indexPath.row
        var image: UIImage?
        var borderColor: CGColor?
        
        switch collectionView {
        case pointCV:
            image = index == 0 ? Images.greenBubble : Images.greenCircle
            borderColor = index == UserDefault.selectedPointEffect.getInt() ? Colors.blue.cgColor : Colors.d6d6d6.cgColor
        case typingCV:
            image = index == 0 ? Images.customKeyboard : Images.defaultKeyboard
            borderColor = index == UserDefault.selectedTyping.getInt() ? Colors.blue.cgColor : Colors.d6d6d6.cgColor
        default: break
        }
        
        cell.configure(image: image, borderColor: borderColor)
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
