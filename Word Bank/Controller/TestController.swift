//
//  TestController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 12.03.2023.
//

import UIKit

class TestController: UIViewController {
    
    //MARK: - Properties
    
    private let exerciseKind: ExerciseKind
    private let exerciseType: ExerciseType = .test
        
    private var questionCounter = 0
    private var questionText = ""
    private let exercisePoint: Int = 10
    private var selectedTestType: Int { return UserDefault.selectedTestType.getInt() }
    private var wordSoundOpen: Bool { return UserDefault.playSound.getInt() == 0 }
    
    private var questionArray = [String]()
    private var answerArray = [String]()
    private var userAnswerArray = [String]()
    
    private lazy var exerciseTopView: ExerciseTopView = {
        let view = ExerciseTopView(exerciseType: exerciseType)
        view.delegate = self
        return view
    }()
    
    private var bubbleView = BubbleView()
    
    private let questionLabel: UILabel = {
       let label = UILabel()
        label.textColor = Colors.f6f6f6
        label.numberOfLines = 6
        label.adjustsFontSizeToFitWidth = true
        label.font = Fonts.AvenirNextRegular15
        label.textAlignment = .center
        return label
    }()
    
    private lazy var answer1Button: UIButton = {
       let button = makeTestAnswerButton()
        button.addTarget(self, action: #selector(answerPressed), for: .touchUpInside)
        return button
    }()
    
    private lazy var answer2Button: UIButton = {
       let button = makeTestAnswerButton()
        button.addTarget(self, action: #selector(answerPressed), for: .touchUpInside)
        return button
    }()
    
    private let timerView = UIView()
    private var timer = Timer()
    private var timerCounter: CGFloat = 0
    private let second: CGFloat = 10
    
    //MARK: - Lifecycle
    
    init(exerciseKind: ExerciseKind) {
        self.exerciseKind = exerciseKind
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        brain.clearAddedHardWordsCount()
        brain.loadHardItemArray()
        brain.loadItemArray()
        brain.sortWordsForExercise()
        configureUI()
        configureNextQuestion()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopTimer()
    }
    
    //MARK: - Selectors
    
    @objc private func configureNextQuestion() {
        bubbleView.isHidden = true
        
        if questionCounter < totalQuestionNumber {
            startTimer()
            prepareNextQuestion()
        } else {
            goToResult()
        }
    }
    
    @objc private func answerPressed(_ sender: UIButton) {
        stopTimer()
        guard let userAnswer = sender.currentTitle else { return }
        checkAnswer(userAnswer: userAnswer, sender: sender)
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
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
        
        view.addSubview(bubbleView)
        bubbleView.centerX(inView: questionLabel)
        bubbleView.centerY(inView: questionLabel)
    }
    
    private func prepareNextQuestion() {
        questionText = brain.getQuestionText(questionCounter, exerciseKind, exerciseType)
        questionLabel.text = questionText
        questionArray.append(questionText)
        
        let answers = brain.getTestAnswer(exerciseKind: exerciseKind)
        refreshAnswerButton(answer1Button, title: answers.0)
        refreshAnswerButton(answer2Button, title: answers.1)

        if selectedTestType == 0 {
            if wordSoundOpen { Player.shared.playSound(questionText) }
            answerArray.append(brain.getMeaning(exerciseKind: exerciseKind))
        } else {
            answerArray.append(brain.getEnglish(exerciseKind: exerciseKind))
        }
    }
    
    private func checkAnswer(userAnswer: String, sender: UIButton? = nil) {
        let userGotItRight = answerArray[questionCounter] == userAnswer
        
        questionCounter += 1
        userAnswerArray.append(userAnswer)
        sender?.backgroundColor = userGotItRight ? Colors.green : Colors.red
        
        if userGotItRight {
            Player.shared.playMP3(Sounds.truee)
            
            if exerciseKind == .normal {
                brain.userGotItCorrect()
            } else {
                if brain.updateCorrectCountHardWord() { questionCounter = totalQuestionNumber }
            }
        } else {
            Player.shared.playMP3(Sounds.falsee)
            
            if exerciseKind == .normal {
                brain.userGotItWrong()
            } else {
                brain.updateWrongCountHardWords()
            }
        }
        
        let lastPoint = UserDefault.lastPoint.getInt()
        exerciseTopView.updateProgress(questionCounter: questionCounter)
        exerciseTopView.updatePoint(lastPoint: lastPoint, exercisePoint: exercisePoint, isIncrease: userGotItRight)
        
        answer1Button.isEnabled = false
        answer2Button.isEnabled = false
        
        bubbleView.isHidden = false
        bubbleView.update(answer: userGotItRight, point: exercisePoint)
        bubbleView.rotate()
        
        scheduledTimer(timeInterval: 0.7, #selector(configureNextQuestion))
    }
    
    private func refreshAnswerButton(_ button: UIButton, title: String) {
        button.isEnabled = true
        button.backgroundColor = UIColor.clear
        button.setTitle(title, for: .normal)
    }
    
    private func goToResult() {
        let controller = ResultController(exerciseKind: exerciseKind, exerciseType: exerciseType, questions: questionArray, answers: answerArray, userAnswers: userAnswerArray)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - Timer Funcs

extension TestController {
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
        Player.shared.playSound(questionText)
    }
}
