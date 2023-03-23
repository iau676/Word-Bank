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
    private var player = Player()
    
    private var questionCounter = 0
    private var totalQuestionNumber = 1
    private var questionText = ""
    private var userAnswer = ""
    private var trueAnswer = ""
    
    private var questionArray = [String]()
    private var answerArray = [String]()
    private var userAnswerArray = [String]()
    private var userAnswerArrayBool = [Bool]()
    
    private var isAnswerSelected = false
    private var exercisePoint: Int { return wordBrain.getExercisePoint() }
    
    private lazy var exerciseTopView = ExerciseTopView(exerciseFormat: exerciseFormat)
    private var bubbleView = BubbleView()
    
    private let questionLabel: UILabel = {
       let label = UILabel()
        label.textColor = Colors.f6f6f6
        label.numberOfLines = 6
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: UserDefault.textSize.getCGFloat())
        label.textAlignment = .center
        return label
    }()
    
    private lazy var buttonOne = makeAnswerButton()
    private lazy var buttonTwo = makeAnswerButton()
    private lazy var buttonThree = makeAnswerButton()
    
    lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = Colors.testAnswerLayer
        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
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
        wordBrain.getHour()
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
            let controller = ResultViewController(exerciseType: exerciseType,
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
            exerciseTopView.updateProgress()
            
            let lastPoint = UserDefault.lastPoint.getInt()
            
            isAnswerSelected = false
            bubbleView.isHidden = false
            questionLabel.text = ""
            
            let userGotItRight = userAnswer == trueAnswer
            
            if userGotItRight {
                player.playMP3(Sounds.truee)
                wordBrain.userGotItCorrect()
                
                if exerciseType == ExerciseType.normal {
                    wordBrain.userGotItCorrect()
                } else {
                    if wordBrain.updateCorrectCountHardWord() { questionCounter = totalQuestionNumber }
                }
            } else {
                player.playMP3(Sounds.falsee)
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
        player.playSound(soundSpeed, senderTitle)
        
        userAnswer = senderTitle
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        configureNavigationBar()
        view.backgroundColor = Colors.raven
        
        view.addSubview(exerciseTopView)
        exerciseTopView.centerX(inView: view)
        exerciseTopView.setWidth(view.bounds.width)
        exerciseTopView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        
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
        questionLabel.anchor(top: exerciseTopView.userPointButton.bottomAnchor,
                             bottom: stackLeft.topAnchor)
        
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
    
    private func makeAnswerButton() -> UIButton {
        let button = UIButton()
         button.setImage(Images.sound?.imageResized(to: CGSize(width: 50, height: 50)), for: .normal)
         button.backgroundColor = .clear
         button.layer.borderWidth = 5
         button.layer.borderColor = Colors.testAnswerLayer?.cgColor
         button.setDimensions(width: 90, height: 90)
         button.setButtonCornerRadius(90 / 2)
         button.titleLabel?.font = UIFont.systemFont(ofSize: 0)
         button.addTarget(self, action: #selector(answerSelected), for: .touchUpInside)
         return button
    }
    
    private func clearButtons() {
        buttonOne.backgroundColor = .clear
        buttonTwo.backgroundColor = .clear
        buttonThree.backgroundColor = .clear
    }
}
