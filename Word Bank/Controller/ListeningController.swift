//
//  ListeningController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 21.03.2023.
//

import UIKit

class ListeningController: UIViewController {
    
    //MARK: - Properties
    
    private let exerciseKind: ExerciseKind
    private let exerciseType: ExerciseType = .listening
    
    private var questionCounter = 0
    private var questionText = ""
    private var userAnswer = ""
    private var trueAnswer = ""
    
    private var questionArray = [String]()
    private var answerArray = [String]()
    private var userAnswerArray = [String]()
    
    private var isAnswerSelected = false
    private let exercisePoint: Int = 30
    
    private lazy var exerciseTopView = ExerciseTopView(exerciseType: exerciseType)
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
    
    private lazy var buttonOne: UIButton = {
       let button = makeListeningAnswerButton()
        button.addTarget(self, action: #selector(answerSelected), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonTwo: UIButton = {
       let button = makeListeningAnswerButton()
        button.addTarget(self, action: #selector(answerSelected), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonThree: UIButton = {
       let button = makeListeningAnswerButton()
        button.addTarget(self, action: #selector(answerSelected), for: .touchUpInside)
        return button
    }()
    
    lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = Colors.testAnswerLayer
        button.setImage(Images.chevronRight, for: .normal)
        button.addTarget(self, action: #selector(actionButtonPressed), for: .touchUpInside)
        return button
    }()
    
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
    
    //MARK: - Selectors
    
    @objc private func configureNextQuestion() {
        bubbleView.isHidden = true
        
        if questionCounter < totalQuestionNumber {
            prepareNextQuestion()
        } else {
            goToResult()
        }
    }
    
    @objc func actionButtonPressed() {
        clearButtons()
        actionButton.bounce()
        if isAnswerSelected {
            isAnswerSelected = false
            questionLabel.text = ""
            questionCounter += 1
            userAnswerArray.append(userAnswer)
            
            let userGotItRight = userAnswer == trueAnswer
            
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
            exerciseTopView.updatePoint(lastPoint: lastPoint,
                                        exercisePoint: exercisePoint,
                                        isIncrease: userGotItRight)
            
            bubbleView.isHidden = false
            bubbleView.update(answer: userGotItRight, point: exercisePoint)
            bubbleView.rotate()
            
            scheduledTimer(timeInterval: 0.7, #selector(configureNextQuestion))
        } else {
            showAlertPopup(title: "Not Selected")
        }
    }
    
    @objc private func answerSelected(_ sender: UIButton) {
        isAnswerSelected = true
        clearButtons()
        sender.backgroundColor = Colors.green
        sender.bounce()
        
        guard let senderTitle = sender.currentTitle else { return }
        Player.shared.playSound(senderTitle)
        
        userAnswer = senderTitle
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
        view.backgroundColor = Colors.raven
        
        view.addSubview(exerciseTopView)
        exerciseTopView.centerX(inView: view)
        exerciseTopView.setWidth(view.bounds.width)
        exerciseTopView.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                            paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
        
        let stackLeft = UIStackView(arrangedSubviews: [buttonOne, buttonTwo])
        stackLeft.axis = .vertical
        stackLeft.spacing = 64
        
        view.addSubview(stackLeft)
        stackLeft.centerY(inView: view, constant: view.frame.height/5)
        stackLeft.anchor(left: view.leftAnchor, paddingLeft: (view.frame.width-180)/2-32)
        
        view.addSubview(buttonThree)
        buttonThree.centerY(inView: stackLeft)
        buttonThree.anchor(left: stackLeft.rightAnchor, paddingLeft: 64)
        
        view.addSubview(questionLabel)
        questionLabel.centerX(inView: view)
        questionLabel.anchor(top: exerciseTopView.bottomAnchor, left: view.leftAnchor,
                             bottom: stackLeft.topAnchor, right: view.rightAnchor,
                             paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(bubbleView)
        bubbleView.centerX(inView: questionLabel)
        bubbleView.centerY(inView: questionLabel)
    }
    
    private func clearButtons() {
        buttonOne.backgroundColor = .clear
        buttonTwo.backgroundColor = .clear
        buttonThree.backgroundColor = .clear
    }
    
    private func prepareNextQuestion() {
        questionText = brain.getQuestionText(questionCounter, exerciseKind, exerciseType)
        questionLabel.text = questionText
        questionArray.append(questionText)
        
        let answers = brain.getListeningAnswers(exerciseKind)
        buttonOne.setTitle(answers.0, for: .normal)
        buttonTwo.setTitle(answers.1, for: .normal)
        buttonThree.setTitle(answers.2, for: .normal)
        trueAnswer = answers.3
        answerArray.append(trueAnswer)
    }
    
    private func goToResult() {
        let controller = ResultController(exerciseKind: exerciseKind, exerciseType: exerciseType, questions: questionArray, answers: answerArray, userAnswers: userAnswerArray)
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
