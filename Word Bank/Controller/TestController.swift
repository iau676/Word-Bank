//
//  TestController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 12.03.2023.
//

import UIKit

class TestController: UIViewController {
    
    //MARK: - Properties
    
    private var wordBrain = WordBrain()
    private var player = Player()
    
    private var questionCounter = 0
    private var totalQuestionNumber = 5
    private var questionText = ""
    private var arrayForResultViewUserAnswer = [String]()
    private var exercisePoint: Int { return UserDefault.exercisePoint.getInt() }
    
    private lazy var exerciseTopView: ExerciseTopView = {
        let view = ExerciseTopView()
        view.delegate = self
        return view
    }()
    
    private var bubbleButton = BubbleView()
    private lazy var answer1Button = makeAnswerButton()
    private lazy var answer2Button = makeAnswerButton()
    
    private let questionLabel: UILabel = {
       let label = UILabel()
        label.textColor = Colors.f6f6f6
        label.numberOfLines = 6
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: UserDefault.textSize.getCGFloat())
        label.textAlignment = .center
        return label
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBrain.getHour()
        wordBrain.loadHardItemArray()
        wordBrain.loadItemArray()
        configureUI()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefault.addedHardWordsCount.set(0)
    }
    
    //MARK: - Selectors
    
    @objc private func updateUI() {
        bubbleButton.isHidden = true
        if questionCounter < totalQuestionNumber {
            questionText = wordBrain.getQuestionText(questionCounter, 1)
            questionLabel.text = questionText
            refreshAnswerButton(answer1Button, title: wordBrain.getAnswer(0))
            refreshAnswerButton(answer2Button, title: wordBrain.getAnswer(1))
        } else {
            questionCounter = 0
            let vc = ResultViewController()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc private func answerPressed(_ sender: UIButton) {
        guard let userAnswer = sender.currentTitle else { return }
        let userGotItRight = wordBrain.checkAnswer(userAnswer: userAnswer)
        let lastPoint = UserDefault.lastPoint.getInt()
        
        questionCounter += 1
        exerciseTopView.updateProgress()
        bubbleButton.isHidden = false
        answer1Button.isEnabled = false
        answer2Button.isEnabled = false
        
        arrayForResultViewUserAnswer.append(userAnswer)
        UserDefault.userAnswers.set(arrayForResultViewUserAnswer)
        
        if userGotItRight {
            player.playMP3(Sounds.truee)
            
//            if whichButton == ExerciseType.normal {
//                wordBrain.userGotItCorrect()
//            } else {
//                if wordBrain.updateCorrectCountHardWord() { questionCount = totalQuestionNumber }
//            }
            
            wordBrain.userGotItCorrect()
            
            sender.backgroundColor = Colors.green
            exerciseTopView.updatePoint(lastPoint: lastPoint, exercisePoint: exercisePoint, isIncrease: true)
        } else {
            player.playMP3(Sounds.falsee)
            
//            if whichButton == ExerciseType.normal {
//                wordBrain.userGotItWrong()
//            } else {
//                wordBrain.updateWrongCountHardWords()
//            }
            
            wordBrain.userGotItWrong()
           
            sender.backgroundColor = Colors.red
            exerciseTopView.updatePoint(lastPoint: lastPoint, exercisePoint: exercisePoint, isIncrease: false)
        }
        bubbleButton.update(answer: userGotItRight, point: exercisePoint)
        bubbleButton.rotate()
        scheduledTimer(timeInterval: 0.7, #selector(updateUI))
    }
    
    //MARK: - Helpers
    
    private func configureUI(){
        configureNavigationBar()
        view.backgroundColor = Colors.raven
        
        view.addSubview(exerciseTopView)
        exerciseTopView.centerX(inView: view)
        exerciseTopView.setWidth(width: view.bounds.width)
        exerciseTopView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        
        let answerStackView = UIStackView(arrangedSubviews: [answer1Button, answer2Button])
        answerStackView.distribution = .fillEqually
        answerStackView.axis = .vertical
        answerStackView.spacing = 16
        
        answer1Button.setHeight(height: 120)
        view.addSubview(answerStackView)
        answerStackView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                               right: view.rightAnchor, paddingLeft: 32,
                               paddingBottom: 66, paddingRight: 32)
        
        view.addSubview(questionLabel)
        questionLabel.centerX(inView: view)
        questionLabel.anchor(top: exerciseTopView.userPointButton.bottomAnchor,
                             bottom: answerStackView.topAnchor)
        
        view.addSubview(bubbleButton)
        bubbleButton.centerX(inView: questionLabel)
        bubbleButton.centerY(inView: questionLabel)
    }
    
    private func refreshAnswerButton(_ button: UIButton, title: String) {
        button.isEnabled = true
        button.backgroundColor = UIColor.clear
        button.setTitle(title, for: .normal)
    }
    
    private func makeAnswerButton() -> UIButton {
        let button = UIButton()
         button.titleLabel?.font =  button.titleLabel?.font.withSize(UserDefault.textSize.getCGFloat())
         button.addTarget(self, action: #selector(answerPressed), for: .touchUpInside)
         button.titleLabel?.numberOfLines = 3
         button.titleEdgeInsets = UIEdgeInsets(top: 30, left: 15, bottom: 30, right: 15)

         button.backgroundColor = .clear
         button.layer.cornerRadius = 18
         button.layer.borderWidth = 5
         button.layer.borderColor = Colors.testAnswerLayer?.cgColor
         return button
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
    }
}

//MARK: - ExerciseTopDelegate

extension TestController: ExerciseTopDelegate {
    func soundHintButtonPressed() {
        //only english word
        if UserDefault.selectedTestType.getInt() == 0 {
            let soundSpeed = UserDefault.soundSpeed.getDouble()
            player.playSound(soundSpeed, questionText)
        }
    }
}
