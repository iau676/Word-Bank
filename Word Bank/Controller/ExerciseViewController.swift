//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import AVFoundation
import CoreData

class ExerciseViewController: UIViewController, UITextFieldDelegate {
    
    let userPointButton = UIButton()
    let xButton = UIButton()
    let progressBarTop = UIProgressView()
    let soundButton = UIButton()
    
    let bubbleButton = UIButton()
    let bubbleLabel = UILabel()
    let questionLabel = UILabel()
    
    let hintLabel = UILabel()
    let textField = UITextField()
    let textFieldStackView = UIStackView()
    
    let answer1Button = UIButton()
    let answer2Button = UIButton()
    let answerStackView = UIStackView()
    
    let progressBarBottom = UIProgressView()
    
    var hint = ""
    var letterCounter = 0
    var totalQuestionNumber = 20
    var failNumber: [Int] = []
    var failIndex: [Int] = []
    var itemArray: [Item] { return wordBrain.itemArray }
    var hardItemArray: [HardItem] { return wordBrain.hardItemArray }
    var questionCount = 0
    var timer = Timer()
    var questionText = ""
    var answerForStart23 = ""
    var soundSpeed = Double()
    var arrayForResultViewUserAnswer = [String]()
    var player = Player()
    var wordBrain = WordBrain()
    var whichButton: String { return UserDefault.whichButton.getString() }
    var whichStartPressed : Int { return UserDefault.startPressed.getInt() }
    var keyboardHeight: CGFloat { return UserDefault.keyboardHeight.getCGFloat() }
    var wheelPressed = 0
    var hintCount = 0
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // collection view
    
    fileprivate let letterCV:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.register(LetterCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    var shuffledAnswer: Array<Character> = Array("")
    let backspaceButton = UIButton()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " "
        wordBrain.getHour()
        
        style()
        setupView()
        configureColor()
        configureTextField()
        
        wordBrain.loadHardItemArray()
        wordBrain.loadItemArray()
        
        updateUI()
        wordBrain.sortFails()
        
        configureBackBarButton()
        addGestureRecognizer()
        updateScreenWhenKeyboardWillShow()
        preventInterrupt()
    }

    override func viewWillAppear(_ animated: Bool) { 
        UserDefault.addedHardWordsCount.set(0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let x = textFieldStackView.center.y
        let y = progressBarTop.center.y
        layout(questionLabelHeight: x-y)
    }
  
    //MARK: - Selectors
    
    @objc func answerPressed(_ sender: UIButton) {
        checkAnswerQ(sender,sender.currentTitle!)
    }
    
    @objc func backspaceButtonPressed(_ sender: UIButton) {
        guard let text = textField.text else {return}
        if let lastLetter = text.last {
            shuffledAnswer.append(lastLetter)
            textField.text = "\(text.dropLast())"
            letterCV.reloadData()
        }
    }
    
    @objc func textChanged(_ sender: UITextField) {
        guard let text = sender.text else {return}
        checkTextField(text)
    }
    
    @objc func soundButtonPressed(_ sender: UIButton) {
        soundButton.bounce()
        if whichStartPressed == 1 {
            if UserDefault.selectedSegmentIndex.getInt() == 0 {
                player.playSound(soundSpeed, questionText)
            }
        } else {
            getLetter()
        }
    }
    
    @objc func bubbleButtonPressed(_ sender: UIButton) {
        bubbleButton.bounce()
        player.playSound(soundSpeed, answerForStart23)
    }
    
    @objc func updateUI() {
        letterCounter = 0
        hint = ""
        hintLabel.text = ""

        if questionCount < totalQuestionNumber {

            bubbleLabel.text = ""
            
            if whichStartPressed == 3 {
                bubbleButton.setImage(image: Images.sound, width: 66, height: 66)
            } else {
                bubbleButton.isHidden=true
            }
         
            failNumber = UserDefault.failNumber.getValue() as? [Int] ?? [Int]()
            failIndex = UserDefault.failIndex.getValue() as? [Int] ?? [Int]()
                
            questionText = wordBrain.getQuestionText(UserDefault.selectedSegmentIndex.getInt(),questionCount, whichStartPressed)
            answerForStart23 = wordBrain.getAnswer()
            questionLabel.text = questionText

            //0 is true, 1 is false
            switch whichStartPressed {
            case 1:
                if UserDefault.playSound.getInt() == 0 {
                    if UserDefault.selectedSegmentIndex.getInt() == 0 {
                        player.playSound(soundSpeed, questionText)
                    }
                }
                progressBarTop.isHidden = true
                break
            case 2:
                updateCV()
                progressBarBottom.isHidden = true
                break
            case 3:
                updateCV()
                player.playSound(soundSpeed, answerForStart23)
                progressBarBottom.isHidden = true
                break
            default: break
            }
            
            refreshAnswerButton(answer1Button, title: wordBrain.getAnswer(0))
            refreshAnswerButton(answer2Button, title: wordBrain.getAnswer(1))
            bubbleButton.setBackgroundImage(nil, for: UIControl.State.normal)
            
        } else {
            questionCount = 0
            UserDefault.hintCount.set(hintCount)
            let vc = ResultViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }//updateUI
    
    @objc func hideBubbleButton(){
        bubbleLabel.text = ""
        if whichStartPressed == 3 {
            bubbleButton.setImage(image: Images.sound, width: 66, height: 66)
        } else {
            bubbleButton.isHidden = true
        }
        
        if whichStartPressed == 2 {
            questionLabel.isHidden = false
        }
    }
    
    @objc func updateHintLabelColor() {
        hintLabel.textColor = Colors.f6f6f6
    }
    
//    @objc func updateImg(_ timer: Timer){
//        let imgName = timer.userInfo!
//        let imagePath:String? = Bundle.main.path(forResource: (imgName as! String), ofType: "png")
//        let image:UIImage? = UIImage(contentsOfFile: imagePath!)
//        bubbleButton.setBackgroundImage(image, for: UIControl.State.normal)
//    }
    
    @objc func backButtonPressed(sender : UIButton) {
        if wheelPressed == 1 {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    //MARK: - Helpers

    func refreshAnswerButton(_ button: UIButton, title: String) {
        button.isEnabled = true
        button.backgroundColor = UIColor.clear
        button.setTitle(title, for: .normal)
    }
    
    func textFieldShouldReturn(_ textFieldd: UITextField) -> Bool {
        getLetter()
        return false
    }
    
    func checkTextField(_ text: String) {
        if answerForStart23.lowercased() == text.lowercased() {
            checkAnswerQ(nil,text)
            textField.text = ""
            bubbleButton.setImage(image: UIImage(), width: 0, height: 0)
            wordBrain.answerTrue()
        }
    }
    
    func updateCV(){
        shuffledAnswer = answerForStart23.shuffled()
        letterCV.reloadData()
    }
    
    func configureColor(){
        questionLabel.textColor = Colors.f6f6f6
        hintLabel.textColor = Colors.f6f6f6
        answer1Button.setTitleColor(Colors.f6f6f6, for: .normal)
        answer2Button.setTitleColor(Colors.f6f6f6, for: .normal)
        userPointButton.changeBackgroundColor(to: Colors.f6f6f6)
        xButton.changeBackgroundColor(to: Colors.pink)
        soundButton.tintColor = Colors.f6f6f6
        progressBarTop.tintColor = Colors.f6f6f6
        progressBarTop.tintColor = Colors.f6f6f6
        textField.backgroundColor = Colors.f6f6f6
        textField.textColor = Colors.black
    }
    
    func configureTextField(){
        switch UserDefault.userInterfaceStyle {
        case "dark":
            textField.keyboardAppearance = .dark
            break
        default:
            textField.keyboardAppearance = .default
        }
        textField.delegate = self
        if whichStartPressed != 1 {
            textField.becomeFirstResponder()
        }
    }
    
    func configureBackBarButton(){
        let backButton: UIButton = UIButton()
        let image = Images.arrow_back
        backButton.setImage(image, for: .normal)
        backButton.setTitle(" Back", for: .normal);
        backButton.titleLabel?.font =  UIFont.systemFont(ofSize: 17)
        backButton.setTitleColor(.black, for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector (backButtonPressed(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    func setupView(){
        
        bubbleButton.isHidden = true
        
        if whichStartPressed == 1 {
            textFieldStackView.isHidden = true
            soundButton.setImage(image: Images.soundLeft, width: 40, height: 40)
        } else {
            answerStackView.isHidden = true
            soundButton.setImage(image: Images.question, width: 35, height: 35)
        }
        
        if whichStartPressed == 3 {
            questionLabel.isHidden = true
            bubbleButton.isHidden = false
        }
        
        if UserDefault.currentHour.getInt() == UserDefault.userSelectedHour.getInt() {
            xButton.isHidden = false
        } else {
            xButton.isHidden = true
        }
        
        soundSpeed = UserDefault.soundSpeed.getDouble()
        
        let textSize = UserDefault.textSize.getCGFloat()
        questionLabel.font = questionLabel.font.withSize(textSize)
        answer1Button.titleLabel?.font =  answer1Button.titleLabel?.font.withSize(textSize)
        answer2Button.titleLabel?.font =  answer2Button.titleLabel?.font.withSize(textSize)
        userPointButton.titleLabel?.font =  userPointButton.titleLabel?.font.withSize(textSize)
        
        userPointButton.setTitle(String(UserDefault.lastPoint.getInt().withCommas()), for: UIControl.State.normal)
        
        progressBarTop.progress = 0
        progressBarBottom.progress = 0
        questionLabel.numberOfLines = 6
        questionLabel.adjustsFontSizeToFitWidth = true
        
        setupAnswerButton(answer1Button)
        setupAnswerButton(answer2Button)
    }//setupView
    
    func setupAnswerButton(_ button: UIButton) {
        button.titleLabel?.numberOfLines = 3
        button.titleEdgeInsets = UIEdgeInsets(top: 30,left: 15,bottom: 30,right: 15)

        button.backgroundColor = .clear
        button.layer.cornerRadius = 18
        button.layer.borderWidth = 5
        button.layer.borderColor = Colors.testAnswerLayer?.cgColor
    }
    
    func getLetter(){
        let answer = wordBrain.getAnswer()
        let answerWithoutSpace = answer.replace(string: " ", replacement: "")
        var skeleton = ""
        var skeletonArr = [Int]()
        
        for i in 0..<answer.count {
            if answer[i] != " " {
                skeleton.append(" _")
            } else {
                skeleton.append("  ")
            }
        }
        
        for i in 0..<skeleton.count {
            if skeleton[i] == "_" {
                skeletonArr.append(i)
            }
        }
        
        if letterCounter == 0 {
            hint = skeleton
        }
        
        if letterCounter < skeletonArr.count {
            hint = hint.replace(skeletonArr[letterCounter], "\(answerWithoutSpace[letterCounter])")
            letterCounter += 1
            hintLabel.text = hint
            decreaseOnePoint()
            hintCount += 1
            player.playMP3(Sounds.beep)
        } else {
            hintLabel.textColor = Colors.green
            hintLabel.flash()
            scheduledTimer(timeInterval: 0.8, #selector(updateHintLabelColor))
        }
    }

    func checkAnswerQ(_ sender: UIButton? = nil, _ userAnswer: String){
        wordBrain.getHour()
        questionCount += 1
        let progrs = wordBrain.getProgress()
        progressBarTop.progress = progrs
        progressBarBottom.progress = progrs
        
        var exercisePoint = 0
        var userGotItRight = true
        
        if whichStartPressed == 1 {
            userGotItRight = wordBrain.checkAnswer(userAnswer: userAnswer)
        } else {
            userGotItRight = answerForStart23.lowercased() == userAnswer.lowercased()
            if whichButton == ExerciseType.hard {
                wordBrain.arrayForResultView()
            }
        }
        
        let lastPoint = UserDefault.lastPoint.getInt()
        arrayForResultViewUserAnswer.append(userAnswer)
        UserDefault.userAnswers.set(arrayForResultViewUserAnswer)
        
        answer1Button.isEnabled = false
        answer2Button.isEnabled = false
        bubbleButton.isHidden = false
        questionLabel.text = ""
        
        exercisePoint = UserDefault.exercisePoint.getInt()
        
        switch whichStartPressed {
        case 0:
            exercisePoint = 1
            break
        case 2:
            exercisePoint += 10
            break
        case 3:
            exercisePoint += 20
            break
        default: break
        }
        
        if UserDefault.currentHour.getInt() == UserDefault.userSelectedHour.getInt() {
            exercisePoint *= 2
            xButton.isHidden = false
        } else {
            xButton.isHidden = true
        }
                
        if userGotItRight {
            player.playMP3(Sounds.truee)
            
            if whichButton == ExerciseType.normal {
                wordBrain.userGotItCorrect()
            } else {
                if wordBrain.updateCorrectCountHardWord() { questionCount = totalQuestionNumber }
            }
            
            sender?.backgroundColor = Colors.green
            bubbleLabel.textColor = Colors.green
            bubbleLabel.text = "+\(exercisePoint)"
            userPointButton.setTitleWithAnimation(title: (lastPoint+exercisePoint).withCommas())
            
            bubbleButton.setBackgroundImage(Images.greenBubble, for: .normal)
            rotateBubbleButton()
            
            UserDefault.lastPoint.set(lastPoint+exercisePoint)
        } else {
            player.playMP3(Sounds.falsee)
            
            if whichButton == ExerciseType.normal {
                wordBrain.userGotItWrong()
            } else {
                wordBrain.updateWrongCountHardWords()
            }
           
            sender?.backgroundColor = Colors.red
            bubbleLabel.textColor = Colors.red
            bubbleLabel.text = "\(-exercisePoint)"
            userPointButton.setTitleWithAnimation(title: (lastPoint-exercisePoint).withCommas())
            
            bubbleButton.setBackgroundImage(Images.redBubble, for: .normal)
            rotateBubbleButton()
            
            UserDefault.lastPoint.set(lastPoint-exercisePoint)
        }
      
        wordBrain.nextQuestion()
 
        scheduledTimer(timeInterval: 0.7, #selector(updateUI))
    }
    
//    func rotateBubbleButton(timeInterval: Double, userInfo: String) -> Timer {
//        return Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateImg(_:)), userInfo: userInfo, repeats: false)
//    }
    
    func rotateBubbleButton() {
        UIView.animate(withDuration:0.2, animations: {
            self.bubbleButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        })
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1){
            UIView.animate(withDuration:0.2, animations: {
                self.bubbleButton.transform = .identity
            })
        }
    }
    
    func decreaseOnePoint(){
        let lastPoint = UserDefault.lastPoint.getInt()
        
        questionLabel.isHidden = true
        
        bubbleLabel.textColor = Colors.red
        bubbleLabel.text = "-1"
        bubbleButton.setImage(image: UIImage(), width: 0, height: 0)
        
        scheduledTimer(timeInterval: 0.4, #selector(hideBubbleButton))
        
        userPointButton.setTitleWithAnimation(title: (lastPoint-1).withCommas())
        UserDefault.lastPoint.set(lastPoint-1)
    }
    
    func scheduledTimer(timeInterval: Double, _ selector : Selector) {
        Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: selector, userInfo: nil, repeats: false)
    }
    
    func preventInterrupt(){
        // None of our movies should interrupt system music playback.
            _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .mixWithOthers)
    }
}

//MARK: - Layout

extension ExerciseViewController {
    
    func style(){
        view.backgroundColor = Colors.raven
        
        userPointButton.translatesAutoresizingMaskIntoConstraints = false
        userPointButton.setTitleColor(Colors.raven, for: .normal)
        userPointButton.layer.cornerRadius = 12
        
        xButton.translatesAutoresizingMaskIntoConstraints = false
        xButton.setTitle("2x", for: .normal)
        xButton.titleLabel?.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 17)
        xButton.isHidden = true
        xButton.setButtonCornerRadius(16)
        
        progressBarTop.translatesAutoresizingMaskIntoConstraints = false
        progressBarTop.tintColor = Colors.f6f6f6
        
        soundButton.translatesAutoresizingMaskIntoConstraints = false
        soundButton.addTarget(self, action: #selector(soundButtonPressed), for: .primaryActionTriggered)
        
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.textColor = Colors.f6f6f6
        questionLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: 15)
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        
        bubbleButton.translatesAutoresizingMaskIntoConstraints = false
        bubbleButton.addTarget(self, action: #selector(bubbleButtonPressed), for: .primaryActionTriggered)
        
        bubbleLabel.translatesAutoresizingMaskIntoConstraints = false
        bubbleLabel.font = UIFont(name: Fonts.ArialRoundedMTBold, size: 29)
        bubbleLabel.textAlignment = .center
        bubbleLabel.numberOfLines = 0
        
        hintLabel.translatesAutoresizingMaskIntoConstraints = false
        hintLabel.textColor = Colors.f6f6f6
        hintLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: 15)
        hintLabel.textAlignment = .center
        hintLabel.numberOfLines = 0
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.setViewCornerRadius(6)
        textField.setLeftPaddingPoints(10)
        textField.tintColor = .clear
        textField.addTarget(self, action: #selector(textChanged), for: .allEditingEvents)
        
        textFieldStackView.translatesAutoresizingMaskIntoConstraints = false
        textFieldStackView.axis = .vertical
        textFieldStackView.distribution = .fillEqually
        textFieldStackView.spacing = 16
        
        answerStackView.translatesAutoresizingMaskIntoConstraints = false
        answerStackView.axis = .vertical
        answerStackView.distribution = .fillEqually
        answerStackView.spacing = 16
        
        answer1Button.translatesAutoresizingMaskIntoConstraints = false
        answer1Button.addTarget(self, action: #selector(answerPressed), for: .primaryActionTriggered)
        
        answer2Button.translatesAutoresizingMaskIntoConstraints = false
        answer2Button.addTarget(self, action: #selector(answerPressed), for: .primaryActionTriggered)
        
        progressBarBottom.translatesAutoresizingMaskIntoConstraints = false
        progressBarBottom.tintColor = Colors.f6f6f6
        
        letterCV.delegate = self
        letterCV.dataSource = self
        
        backspaceButton.translatesAutoresizingMaskIntoConstraints = false
        backspaceButton.setImage(image: UIImage(named: "backspace"), width: 25, height: 25)
        backspaceButton.isHidden = false
        backspaceButton.addTarget(self, action: #selector(backspaceButtonPressed), for: .primaryActionTriggered)
    }
    
    func layout(questionLabelHeight: CGFloat){
        textFieldStackView.addArrangedSubview(hintLabel)
        textFieldStackView.addArrangedSubview(textField)
        
        answerStackView.addArrangedSubview(answer1Button)
        answerStackView.addArrangedSubview(answer2Button)
        
        view.addSubview(userPointButton)
        view.addSubview(xButton)
        view.addSubview(progressBarTop)
        view.addSubview(soundButton)
        view.addSubview(questionLabel)
        view.addSubview(bubbleButton)
        view.addSubview(bubbleLabel)
        view.addSubview(textFieldStackView)
        view.addSubview(answerStackView)
        view.addSubview(progressBarBottom)
        view.addSubview(letterCV)
        view.addSubview(backspaceButton)

        NSLayoutConstraint.activate([
            userPointButton.topAnchor.constraint(equalTo: view.topAnchor, constant: wordBrain.getTopBarHeight() + 8),
            userPointButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            userPointButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            userPointButton.heightAnchor.constraint(equalToConstant: 24),
            
            xButton.centerYAnchor.constraint(equalTo: userPointButton.centerYAnchor),
            xButton.leadingAnchor.constraint(equalTo: userPointButton.leadingAnchor),
            xButton.widthAnchor.constraint(equalToConstant: 32),
            xButton.heightAnchor.constraint(equalToConstant: 32),
            
            progressBarTop.topAnchor.constraint(equalTo: userPointButton.bottomAnchor, constant: 8),
            progressBarTop.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressBarTop.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            soundButton.topAnchor.constraint(equalTo: progressBarTop.bottomAnchor, constant: 16),
            soundButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            textFieldStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            textFieldStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            textFieldStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -keyboardHeight-16),
            
            answerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            answerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            answerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -66),
            
            questionLabel.topAnchor.constraint(equalTo: progressBarTop.bottomAnchor, constant: 16),
            questionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            questionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            bubbleButton.centerYAnchor.constraint(equalTo: questionLabel.centerYAnchor),
            bubbleButton.centerXAnchor.constraint(equalTo: questionLabel.centerXAnchor),
            
            bubbleLabel.centerYAnchor.constraint(equalTo: bubbleButton.centerYAnchor),
            bubbleLabel.centerXAnchor.constraint(equalTo: bubbleButton.centerXAnchor),
            
            progressBarBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            progressBarBottom.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            progressBarBottom.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            letterCV.topAnchor.constraint(equalTo: textFieldStackView.bottomAnchor, constant: 32),
            letterCV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            letterCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            letterCV.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            
            backspaceButton.trailingAnchor.constraint(equalTo: textField.trailingAnchor, constant: -4),
            backspaceButton.topAnchor.constraint(equalTo: textField.topAnchor),
            backspaceButton.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            soundButton.widthAnchor.constraint(equalToConstant: 40),
            soundButton.heightAnchor.constraint(equalToConstant: 40),
            bubbleButton.widthAnchor.constraint(equalToConstant: 90),
            bubbleButton.heightAnchor.constraint(equalToConstant: 90),
            questionLabel.heightAnchor.constraint(equalToConstant: questionLabelHeight),
            answerStackView.heightAnchor.constraint(equalToConstant: 256),
            textFieldStackView.heightAnchor.constraint(equalToConstant: 86),
            backspaceButton.widthAnchor.constraint(equalTo: backspaceButton.heightAnchor)
        ])
    }
}

//MARK: - Collection View

extension ExerciseViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 45)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shuffledAnswer.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LetterCell
        cell.titleLabel.text = "\(shuffledAnswer[indexPath.row])"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collectionView.cellForItem(at: indexPath) as! LetterCell
        guard let title = item.titleLabel.text else {return}
        shuffledAnswer.remove(at: shuffledAnswer.index(shuffledAnswer.startIndex, offsetBy: indexPath.row))
        textField.text! += "\(title)"
        checkTextField(textField.text ?? "")
        collectionView.reloadData()
    }
}

//MARK: - LetterCell

class LetterCell: UICollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 19)
        label.textColor = Colors.black ?? .darkGray
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = Colors.f6f6f6
        contentView.setViewCornerRadius(8)
     
        contentView.addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Keyboard Will Show

 extension ExerciseViewController {
     private func updateScreenWhenKeyboardWillShow(){
         NotificationCenter.default.addObserver(
             self,
             selector: #selector(keyboardWillShow),
             name: UIResponder.keyboardWillShowNotification,
             object: nil
         )
     }
     
     @objc func keyboardWillShow(notification: NSNotification) {
         if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
             let keyboardHeight = CGFloat(keyboardSize.height)
             backspaceButton.isHidden = (keyboardHeight < 100) ? false : true
         }
     }
 }

//MARK: - Swipe Gesture

extension ExerciseViewController {
    func addGestureRecognizer(){
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRightGesture))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func respondToSwipeRightGesture(gesture: UISwipeGestureRecognizer) {
        if wheelPressed == 1 {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
