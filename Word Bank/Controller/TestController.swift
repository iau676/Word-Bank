//
//  TestController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 12.03.2023.
//

import UIKit

class TestController: UIViewController {
    
    //MARK: - Properties
    
    private let exerciseType: String
    private let exerciseFormat: String
    
    private var wordBrain = WordBrain()
    private var player = Player()
    
    private var questionCounter = 0
    private var totalQuestionNumber = 10
    private var questionText = ""
    private var exercisePoint: Int { return wordBrain.getExercisePoint() }
    private var selectedTestType: Int { return UserDefault.selectedTestType.getInt() }
    private var wordSoundOpen: Bool { return UserDefault.playSound.getInt() == 0 }
    
    private var questionArray = [String]()
    private var answerArray = [String]()
    private var userAnswerArray = [String]()
    private var userAnswerArrayBool = [Bool]()
    
    private lazy var exerciseTopView: ExerciseTopView = {
        let view = ExerciseTopView(exerciseFormat: exerciseFormat)
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

    private let timerView = UIView()
    private var timer = Timer()
    private var timerCounter: CGFloat = 0
    private let second: CGFloat = 10
    
    //MARK: - Lifecycle
    
    init(exerciseType: String, exerciseFormat: String) {
        self.exerciseType = exerciseType
        self.exerciseFormat = exerciseFormat
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefault.addedHardWordsCount.set(0)
        wordBrain.getHour()
        wordBrain.loadHardItemArray()
        wordBrain.loadItemArray()
        wordBrain.sortWordsForExercise()
        configureUI()
        updateUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    //MARK: - Selectors
    
    @objc private func updateUI() {
        bubbleButton.isHidden = true
        if questionCounter < totalQuestionNumber {
            startTimer()
            questionText = wordBrain.getQuestionText(questionCounter, 1, exerciseType)
            questionLabel.text = questionText
            questionArray.append(questionText)
            refreshAnswerButton(answer1Button, title: wordBrain.getAnswer(0, exerciseType))
            refreshAnswerButton(answer2Button, title: wordBrain.getAnswer(1, exerciseType))

            if selectedTestType == 0 {
                if wordSoundOpen { playSound() }
                answerArray.append(wordBrain.getMeaning(exerciseType: exerciseType))
            } else {
                answerArray.append(wordBrain.getEnglish(exerciseType: exerciseType))
            }
        } else {
            questionCounter = 0
            let controller = ResultController(exerciseType: exerciseType,
                                                  exerciseFormat: exerciseFormat)
            controller.questionArray = questionArray
            controller.answerArray = answerArray
            controller.userAnswerArray = userAnswerArray
            controller.userAnswerArrayBool = userAnswerArrayBool
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    @objc private func answerPressed(_ sender: UIButton) {
        stopTimer()
        guard let userAnswer = sender.currentTitle else { return }
        checkAnswer(userAnswer: userAnswer, sender: sender)
    }
    
    //MARK: - Helpers
    
    private func configureUI(){
        configureNavigationBar()
        view.backgroundColor = Colors.raven
        
        timerView.backgroundColor = Colors.red
        view.addSubview(timerView)
        timerView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor)
        timerView.setHeight(0)
        
        view.addSubview(exerciseTopView)
        exerciseTopView.centerX(inView: view)
        exerciseTopView.setWidth(view.bounds.width)
        exerciseTopView.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        
        let answerStackView = UIStackView(arrangedSubviews: [answer1Button, answer2Button])
        answerStackView.distribution = .fillEqually
        answerStackView.axis = .vertical
        answerStackView.spacing = 16
        
        answer1Button.setHeight(120)
        view.addSubview(answerStackView)
        answerStackView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                               right: view.rightAnchor, paddingLeft: 32,
                               paddingBottom: 66, paddingRight: 32)
        
        view.addSubview(questionLabel)
        questionLabel.centerX(inView: view)
        questionLabel.anchor(top: exerciseTopView.userPointButton.bottomAnchor, left: view.leftAnchor,
                             bottom: answerStackView.topAnchor, right: view.rightAnchor,
                             paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(bubbleButton)
        bubbleButton.centerX(inView: questionLabel)
        bubbleButton.centerY(inView: questionLabel)
    }
    
    private func checkAnswer(userAnswer: String, sender: UIButton? = nil) {
        let userGotItRight = answerArray[questionCounter] == userAnswer
        let lastPoint = UserDefault.lastPoint.getInt()
        
        questionCounter += 1
        exerciseTopView.updateProgress()
        bubbleButton.isHidden = false
        answer1Button.isEnabled = false
        answer2Button.isEnabled = false
        
        if userGotItRight {
            player.playMP3(Sounds.truee)
            
            if exerciseType == ExerciseType.normal {
                wordBrain.userGotItCorrect()
            } else {
                if wordBrain.updateCorrectCountHardWord() { questionCounter = totalQuestionNumber }
            }
        } else {
            player.playMP3(Sounds.falsee)
            
            if exerciseType == ExerciseType.normal {
                wordBrain.userGotItWrong()
            } else {
                wordBrain.updateWrongCountHardWords()
            }
        }
        sender?.backgroundColor = userGotItRight ? Colors.green : Colors.red
        exerciseTopView.updatePoint(lastPoint: lastPoint,
                                    exercisePoint: exercisePoint,
                                    isIncrease: userGotItRight)
        userAnswerArray.append(userAnswer)
        userAnswerArrayBool.append(userGotItRight)
        bubbleButton.update(answer: userGotItRight, point: exercisePoint)
        bubbleButton.rotate()
        scheduledTimer(timeInterval: 0.7, #selector(updateUI))
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
    
    private func playSound() {
        let soundSpeed = UserDefault.soundSpeed.getDouble()
        player.playSound(soundSpeed, questionText)
    }
    
    private func handleTimer() {
        timerCounter += 1
        if timerCounter == second+1 {
            stopTimer()
            checkAnswer(userAnswer: "")
        } else {
            timerView.setHeightWithAnimation(view.bounds.height/second*timerCounter, animateTime: 1.5)
        }
    }
    
    private func startTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            self.handleTimer()
        })
    }
    
    private func stopTimer() {
        timerCounter = 0
        timer.invalidate()
        timerView.setHeightWithAnimation(0)
    }
}

//MARK: - ExerciseTopDelegate

extension TestController: ExerciseTopDelegate {
    func soundHintButtonPressed() {
        playSound()
    }
}
