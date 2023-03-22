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
    var totalQuestionNumber = 2
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
    var selectedTyping: Int { return UserDefault.selectedTyping.getInt() }
    var exercisePoint: Int { return UserDefault.exercisePoint.getInt() }
    var keyboardHeight: CGFloat { return UserDefault.keyboardHeight.getCGFloat() }
    var truePointImage: UIImage? { return (UserDefault.selectedPointEffect.getInt() == 0) ? Images.greenBubble : Images.greenCircle }
    var falsePointImage: UIImage? { return (UserDefault.selectedPointEffect.getInt() == 0) ? Images.redBubble : Images.redCircle }
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
    var currentAnswerIndex: [Int] = []
    let backspaceButton = UIButton()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = " "
        wordBrain.getHour()
        wordBrain.loadHardItemArray()
        wordBrain.loadItemArray()
        
        style()
        setupView()
        configureColor()
        configureTextField()
        
        prepareExercise { (success) -> Void in if success { updateUI() } }
        
        configureBackBarButton()
        addGestureRecognizer()
        updateScreenWhenKeyboardWillShow()
    }

    override func viewWillAppear(_ animated: Bool) { 
        UserDefault.addedHardWordsCount.set(0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let x = textFieldStackView.center.y - 43 //textFieldStackView.heightAnchor/2
        let y = progressBarTop.center.y
        layout(questionLabelHeight: x-y)
    }
  
    //MARK: - Selectors
    
    @objc func answerPressed(_ sender: UIButton) {
        checkAnswerQ(sender,sender.currentTitle!)
    }
    
    @objc func backspaceButtonPressed(_ sender: UIButton) {
        guard let text = textField.text else {return}
        if text.count > 0 {
            textField.text = "\(text.dropLast())"
            unhideLetterCell()
        }
    }
    
    @objc func textChanged(_ sender: UITextField) {
        guard let text = sender.text else {return}
        checkTextField(text)
    }
    
    @objc func soundButtonPressed(_ sender: UIButton) {
        soundButton.bounce()
        if whichStartPressed == 1 {
            if UserDefault.selectedTestType.getInt() == 0 {
                //only english word
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
        bubbleLabel.text = ""
        currentAnswerIndex = []
        letterCV.reloadData()

        if questionCount < totalQuestionNumber {
            
            questionText = ""
            questionLabel.text = questionText

            //0 is true, 1 is false
            switch whichStartPressed {
            case 1:
                if UserDefault.playSound.getInt() == 0 && UserDefault.selectedTestType.getInt() == 0{
                    player.playSound(soundSpeed, questionText)
                }
                progressBarTop.isHidden = true
                bubbleButton.isHidden = true
                letterCV.isHidden = true
                break
            case 2:
                updateCV()
                progressBarBottom.isHidden = true
                bubbleButton.isHidden = true
                break
            case 3:
                bubbleButton.setImage(image: Images.sound, width: 66, height: 66)
                updateCV()
                player.playSound(soundSpeed, answerForStart23)
                progressBarBottom.isHidden = true
                break
            default: break
            }
            
//            refreshAnswerButton(answer1Button, title: wordBrain.getAnswer(0))
//            refreshAnswerButton(answer2Button, title: wordBrain.getAnswer(1))
            bubbleButton.setBackgroundImage(nil, for: UIControl.State.normal)
            
        } else {
            questionCount = 0
            UserDefault.hintCount.set(hintCount)
//            let vc = ResultViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
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
    
    @objc func backButtonPressed(sender : UIButton) {
        if wheelPressed == 1 {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }

    //MARK: - Helpers
    
    private func prepareExercise(completion: (_ success: Bool) -> Void) {
        wordBrain.sortWordsForExercise()
        completion(true)
    }
    
    private func unhideLetterCell() {
        guard let last = currentAnswerIndex.last else {return}
        if let cell = letterCV.cellForItem(at: IndexPath(row: last, section: 0)) as? LetterCell {
            cell.isHidden = false
            currentAnswerIndex.removeLast()
        }
    }

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
        }
    }
    
    func updateCV(){
        letterCV.isHidden = (selectedTyping == 0) ? false : true
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
            if selectedTyping == 0 {
                textField.isEnabled = false
                textField.tintColor = .clear
            } else {
                textField.becomeFirstResponder()
                textField.tintColor = Colors.raven
            }
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
        let answer = ""
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

        if letterCounter <= skeletonArr.count {
            if letterCounter == 0 {
                hint = skeleton
            } else {
                hint = hint.replace(skeletonArr[letterCounter-1], "\(answerWithoutSpace[letterCounter-1])")
                decreasePoint()
                player.playMP3(Sounds.beep)
            }
            letterCounter += 1
            hintLabel.text = hint
            hintCount += 1
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
        
        var exercisePoint = exercisePoint*20
        var userGotItRight = true
        
        if whichStartPressed == 1 {
            userGotItRight = false
        } else {
            userGotItRight = answerForStart23.lowercased() == userAnswer.lowercased()
            if whichButton == ExerciseType.hard {
               // wordBrain.arrayForResultView()
            }
        }
        
        let lastPoint = UserDefault.lastPoint.getInt()
        arrayForResultViewUserAnswer.append(userAnswer)
        UserDefault.userAnswers.set(arrayForResultViewUserAnswer)
        
        answer1Button.isEnabled = false
        answer2Button.isEnabled = false
        bubbleButton.isHidden = false
        questionLabel.text = ""
                
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
            
            bubbleButton.setBackgroundImage(truePointImage, for: .normal)
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
            
            bubbleButton.setBackgroundImage(falsePointImage, for: .normal)
            rotateBubbleButton()
            
            UserDefault.lastPoint.set(lastPoint-exercisePoint)
        }
      
        scheduledTimer(timeInterval: 0.7, #selector(updateUI))
    }
    
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
    
    func decreasePoint(){
        let lastPoint = UserDefault.lastPoint.getInt()
        
        questionLabel.isHidden = true
        
        bubbleLabel.textColor = Colors.red
        bubbleLabel.text = "-\(exercisePoint)"
        bubbleButton.setImage(image: UIImage(), width: 0, height: 0)
        
        scheduledTimer(timeInterval: 0.4, #selector(hideBubbleButton))
        
        userPointButton.setTitleWithAnimation(title: (lastPoint-exercisePoint).withCommas())
        UserDefault.lastPoint.set(lastPoint-exercisePoint)
    }
    
}

//MARK: - Layout

extension ExerciseViewController {
    
    func style(){
        view.backgroundColor = Colors.raven
        
        userPointButton.setTitleColor(Colors.raven, for: .normal)
        userPointButton.layer.cornerRadius = 12
        
        xButton.setTitle("2x", for: .normal)
        xButton.titleLabel?.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 17)
        xButton.isHidden = true
        xButton.setButtonCornerRadius(16)
        
        progressBarTop.tintColor = Colors.f6f6f6
        
        soundButton.addTarget(self, action: #selector(soundButtonPressed), for: .primaryActionTriggered)
        
        questionLabel.textColor = Colors.f6f6f6
        questionLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: 15)
        questionLabel.textAlignment = .center
        questionLabel.numberOfLines = 0
        
        bubbleButton.addTarget(self, action: #selector(bubbleButtonPressed), for: .primaryActionTriggered)
        
        bubbleLabel.font = UIFont(name: Fonts.ArialRoundedMTBold, size: 29)
        bubbleLabel.textAlignment = .center
        bubbleLabel.numberOfLines = 0
        
        hintLabel.textColor = Colors.f6f6f6
        hintLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: 15)
        hintLabel.textAlignment = .center
        hintLabel.numberOfLines = 0
        
        textField.setViewCornerRadius(6)
        textField.setLeftPaddingPoints(10)
        textField.addTarget(self, action: #selector(textChanged), for: .allEditingEvents)
        
        textFieldStackView.axis = .vertical
        textFieldStackView.distribution = .fillEqually
        textFieldStackView.spacing = 16
        
        answerStackView.axis = .vertical
        answerStackView.distribution = .fillEqually
        answerStackView.spacing = 16
        
        answer1Button.addTarget(self, action: #selector(answerPressed), for: .primaryActionTriggered)
        answer2Button.addTarget(self, action: #selector(answerPressed), for: .primaryActionTriggered)
        
        progressBarBottom.tintColor = Colors.f6f6f6
        
        letterCV.delegate = self
        letterCV.dataSource = self
        letterCV.bounces = false
        
        backspaceButton.setImageWithRenderingMode(image: Images.backspace, width: 20, height: 20,
                                                  color: Colors.black ?? .black)
        backspaceButton.isHidden = (whichStartPressed == 1) ? true : false
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
        
        userPointButton.setHeight(height: 24)
        userPointButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                               right: view.rightAnchor, paddingTop: 8,
                               paddingLeft: 16, paddingRight: 16)
        
        xButton.setDimensions(height: 32, width: 32)
        xButton.centerY(inView: userPointButton, leftAnchor: userPointButton.leftAnchor)
        
        progressBarTop.anchor(top: userPointButton.bottomAnchor, left: view.leftAnchor,
                              right: view.rightAnchor, paddingTop: 8,
                              paddingLeft: 16, paddingRight: 16)
        
        soundButton.setDimensions(height: 40, width: 40)
        soundButton.anchor(top: progressBarTop.bottomAnchor, right: view.rightAnchor,
                           paddingTop: 16, paddingRight: 32)
        
        answerStackView.setHeight(height: 256)
        answerStackView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                               right: view.rightAnchor, paddingLeft: 32,
                               paddingBottom: 66, paddingRight: 32)
        
        textFieldStackView.setHeight(height: 86)
        textFieldStackView.centerY(inView: answerStackView, constant: -128)
        textFieldStackView.anchor(left: view.leftAnchor, right: view.rightAnchor,
                                  paddingLeft: 32, paddingRight: 32)
        
        questionLabel.setHeight(height: questionLabelHeight)
        questionLabel.anchor(top: progressBarTop.bottomAnchor, left: view.leftAnchor,
                             right: view.rightAnchor, paddingTop: 16,
                             paddingLeft: 32, paddingRight: 32)
        
        bubbleButton.setDimensions(height: 90, width: 90)
        bubbleButton.centerY(inView: questionLabel)
        bubbleButton.centerX(inView: questionLabel)
        
        bubbleLabel.centerY(inView: bubbleButton)
        bubbleLabel.centerX(inView: bubbleButton)
        
        progressBarBottom.anchor(left: view.leftAnchor, bottom: view.bottomAnchor,
                                 right: view.rightAnchor, paddingLeft: 16,
                                 paddingBottom: 16, paddingRight: 16)
        
        letterCV.anchor(top: textFieldStackView.bottomAnchor, left: view.leftAnchor,
                        bottom: view.bottomAnchor, right: view.rightAnchor,
                        paddingTop: 32, paddingLeft: 32,
                        paddingBottom: 32, paddingRight: 32)
        
        backspaceButton.setWidth(width: backspaceButton.bounds.height)
        backspaceButton.anchor(top: textField.topAnchor, bottom: textField.bottomAnchor,
                               right: textField.rightAnchor, paddingRight: 4)
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
        cell.isHidden = false
        cell.titleLabel.text = "\(shuffledAnswer[indexPath.row])"
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collectionView.cellForItem(at: indexPath) as! LetterCell
        guard let title = item.titleLabel.text else {return}
        currentAnswerIndex.append(indexPath.row)
        item.isHidden = true
        textField.text! += "\(title)"
        checkTextField(textField.text ?? "")
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
