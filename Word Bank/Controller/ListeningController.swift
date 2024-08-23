//
//  ListeningController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 21.03.2023.
//

import UIKit

class ListeningController: UIViewController {
    
    //MARK: - Properties
    
    private let exerciseType: String
    private let exerciseFormat: String
    
    private var wordBrain = WordBrain()
    
    private var questionCounter = 0
    private var totalQuestionNumber = 10
    private var questionText = ""
    private var userAnswer = ""
    private var trueAnswer = ""
    
    private var questionArray = [String]()
    private var answerArray = [String]()
    private var userAnswerArray = [String]()
    private var userAnswerArrayBool = [Bool]()
    
    private var isAnswerSelected = false
    private let exercisePoint: Int = 10
    
    private lazy var exerciseTopView = ExerciseTopView(exerciseFormat: exerciseFormat)
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
        wordBrain.loadHardItemArray()
        wordBrain.loadItemArray()
        wordBrain.sortWordsForExercise()
        configureUI()
        updateUI()
    }
    
    //MARK: - Selectors
    
    @objc private func updateUI() {
        bubbleView.isHidden = true
        if questionCounter < totalQuestionNumber {
            questionText = wordBrain.getQuestionText(questionCounter, 2, exerciseType)
            questionLabel.text = questionText
            questionArray.append(questionText)
            configureAnswers()
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
    
    @objc func actionButtonPressed() {
        clearButtons()
        actionButton.bounce()
        if isAnswerSelected {
            questionCounter += 1
            exerciseTopView.updateProgress(questionCounter: questionCounter)
            
            let lastPoint = UserDefault.lastPoint.getInt()
            
            isAnswerSelected = false
            bubbleView.isHidden = false
            questionLabel.text = ""
            
            let userGotItRight = userAnswer == trueAnswer
            
            if userGotItRight {
                Player.shared.playMP3(Sounds.truee)
                wordBrain.userGotItCorrect()
                
                if exerciseType == ExerciseType.normal {
                    wordBrain.userGotItCorrect()
                } else {
                    if wordBrain.updateCorrectCountHardWord() { questionCounter = totalQuestionNumber }
                }
            } else {
                Player.shared.playMP3(Sounds.falsee)
                wordBrain.userGotItWrong()
                
                if exerciseType == ExerciseType.normal {
                    wordBrain.userGotItWrong()
                } else {
                    wordBrain.updateWrongCountHardWords()
                }
            }
            
            exerciseTopView.updatePoint(lastPoint: lastPoint,
                                        exercisePoint: exercisePoint,
                                        isIncrease: userGotItRight)
            userAnswerArray.append(userAnswer)
            userAnswerArrayBool.append(userGotItRight)
            bubbleView.update(answer: userGotItRight, point: exercisePoint)
            bubbleView.rotate()
            scheduledTimer(timeInterval: 0.7, #selector(updateUI))
        } else {
            showAlert(title: "Not Selected", message: "")
        }
    }
    
    @objc private func answerSelected(_ sender: UIButton) {
        isAnswerSelected = true
        clearButtons()
        sender.backgroundColor = Colors.green
        sender.bounce()
        
        guard let senderTitle = sender.currentTitle else { return }
        let soundSpeed = UserDefault.soundSpeed.getDouble()
        Player.shared.playSound(soundSpeed, senderTitle)
        
        userAnswer = senderTitle
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        configureNavigationBar()
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
        questionLabel.anchor(top: exerciseTopView.userPointButton.bottomAnchor, left: view.leftAnchor,
                             bottom: stackLeft.topAnchor, right: view.rightAnchor,
                             paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(bubbleView)
        bubbleView.centerX(inView: questionLabel)
        bubbleView.centerY(inView: questionLabel)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
    }
    
    private func configureAnswers() {
        let answers = wordBrain.getListeningAnswers(exerciseType)
        buttonOne.setTitle(answers.0, for: .normal)
        buttonTwo.setTitle(answers.1, for: .normal)
        buttonThree.setTitle(answers.2, for: .normal)
        trueAnswer = answers.3
        answerArray.append(trueAnswer)
    }
    
    private func clearButtons() {
        buttonOne.backgroundColor = .clear
        buttonTwo.backgroundColor = .clear
        buttonThree.backgroundColor = .clear
    }
}
