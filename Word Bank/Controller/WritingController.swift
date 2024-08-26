//
//  WritingController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 21.03.2023.
//

import UIKit

private let reuseIdentifier = "LetterCell"

class WritingController: UIViewController {
    
    //MARK: - Properties
    
    private let exerciseKind: ExerciseKind
    private let exerciseType: ExerciseType = .writing
    
    private var wordBrain = WordBrain()
    
    private var questionCounter = 0
    private var questionText = ""
    private var answerText = ""
    private let exercisePoint: Int = 10
    private var selectedTyping: Int { return UserDefault.selectedTyping.getInt() }
    
    private var shuffledAnswer: Array<Character> = Array("")
    private var currentAnswerIndex: [Int] = []
    
    private var questionArray = [String]()
    private var answerArray = [String]()
    private var userAnswerArray = [String]()
    private var userAnswerArrayBool = [Bool]()
    
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
        
    private let textField: UITextField = {
        let tf = UITextField()
        tf.setViewCornerRadius(6)
        tf.setLeftPaddingPoints(10)
        tf.backgroundColor = .white
        return tf
    }()
    
    private lazy var backspaceButton: UIButton = {
       let button = UIButton()
        button.isHidden = true
        button.setImageWithRenderingMode(image: Images.backspace, width: 20, height: 20, color: Colors.black)
        button.addTarget(self, action: #selector(backspaceButtonPressed), for: .primaryActionTriggered)
        return button
    }()
    
    private lazy var letterCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.register(LetterCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.bounces = false
        cv.isHidden = !(selectedTyping == 0)
        return cv
    }()
    
    //hint
    private var hint = ""
    private var skeleton = ""
    private var hintCount = 0
    private var letterCounter = 0
    private var underscoreArr = [String]()
    private var skeletonArr = [Int]()
    private var randomArr = [Int]()
    
    private let hintLabel:  UILabel = {
       let label = UILabel()
        label.textColor = Colors.f6f6f6
        label.font = Fonts.AvenirNextRegular15
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
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
        UserDefault.addedHardWordsCount.set(0)
        wordBrain.loadHardItemArray()
        wordBrain.loadItemArray()
        wordBrain.sortWordsForExercise()
        configureUI()
    }
    
    //MARK: - Selectors
    
    @objc private func configureNextQuestion() {
        bubbleView.isHidden = true
        
        if questionCounter < totalQuestionNumber {
            getNewQuestion()
            updateLetterCV()
            setHint()
        } else {
            goToResult()
        }
    }
    
    @objc private func textChanged(_ sender: UITextField) {
        guard let userAnswer = sender.text else { return }
        backspaceButton.isHidden = !(selectedTyping == 0 && userAnswer.count > 0)
        checkAnswer(userAnswer)
    }
    
    @objc private func backspaceButtonPressed(_ sender: UIButton) {
        guard let text = textField.text else {return}
        if text.count > 0 {
            textField.text = "\(text.dropLast())"
            textChanged(textField)
            unhideLastSelectedLetterCell()
        }
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        configureNavigationBar()
        configureTextField()
        configureNextQuestion()
        view.backgroundColor = Colors.raven
        
        view.addSubview(exerciseTopView)
        exerciseTopView.centerX(inView: view)
        exerciseTopView.setWidth(view.bounds.width)
        exerciseTopView.anchor(top: view.safeAreaLayoutGuide.topAnchor)
        
        let stack = UIStackView(arrangedSubviews: [hintLabel, textField])
        stack.axis = .vertical
        stack.distribution = .fillEqually
        stack.spacing = 16

        view.addSubview(stack)
        stack.setHeight(86)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor, right: view.rightAnchor,
                     paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(questionLabel)
        questionLabel.centerX(inView: view)
        questionLabel.anchor(top: exerciseTopView.userPointButton.bottomAnchor, left: view.leftAnchor,
                             bottom: textField.topAnchor, right: view.rightAnchor,
                             paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(bubbleView)
        bubbleView.centerX(inView: questionLabel)
        bubbleView.centerY(inView: questionLabel)
        
        view.addSubview(letterCV)
        letterCV.anchor(top: stack.bottomAnchor, left: view.leftAnchor,
                        bottom: view.bottomAnchor, right: view.rightAnchor,
                        paddingTop: 32, paddingLeft: 32,
                        paddingBottom: 32, paddingRight: 32)
        
        view.addSubview(backspaceButton)
        backspaceButton.setDimensions(width: 50, height: 50)
        backspaceButton.centerY(inView: textField)
        backspaceButton.anchor(right: textField.rightAnchor)
    }
    
    private func configureTextField() {
        textField.addTarget(self, action: #selector(textChanged), for: .allEditingEvents)
        textField.isEnabled = !(selectedTyping == 0)
        textField.tintColor = (selectedTyping == 0) ? .clear : Colors.raven
        if selectedTyping == 1 { textField.becomeFirstResponder() }
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
    }
    
    private func updateLetterCV() {
        shuffledAnswer = answerText.shuffled()
        letterCV.reloadData()
    }
    
    private func unhideLastSelectedLetterCell() {
        guard let last = currentAnswerIndex.last else {return}
        if let cell = letterCV.cellForItem(at: IndexPath(row: last, section: 0)) as? LetterCell {
            cell.isHidden = false
            currentAnswerIndex.removeLast()
        }
    }
    
    private func checkAnswer(_ userAnswer: String){
        let userGotItRight = answerText.lowercased() == userAnswer.lowercased()
        
        if userGotItRight {
            questionCounter += 1
            questionLabel.text = ""
            textField.text = ""
            
            letterCounter = 0
            hint = ""
            hintLabel.text = ""
            currentAnswerIndex = []
            
            bubbleView.isHidden = false
            backspaceButton.isHidden = true
            Player.shared.playMP3(Sounds.truee)
            
            if exerciseKind == .normal {
                wordBrain.userGotItCorrect()
            } else {
                if wordBrain.updateCorrectCountHardWord() { questionCounter = totalQuestionNumber }
            }
            
            let lastPoint = UserDefault.lastPoint.getInt()
            exerciseTopView.updatePoint(lastPoint: lastPoint, exercisePoint: exercisePoint, isIncrease: userGotItRight)
            exerciseTopView.updateProgress(questionCounter: questionCounter)
            
            userAnswerArray.append(userAnswer)
            userAnswerArrayBool.append(userGotItRight)
            
            bubbleView.update(answer: userGotItRight, point: exercisePoint)
            bubbleView.rotate()
            scheduledTimer(timeInterval: 0.7, #selector(configureNextQuestion))
        }
    }
    
    private func getNewQuestion() {
        questionText = wordBrain.getQuestionText(questionCounter, 2, exerciseKind)
        answerText = wordBrain.getEnglish(exerciseKind: exerciseKind)
        questionLabel.text = questionText
        questionArray.append(questionText)
        answerArray.append(answerText)
    }
   
    private func goToResult() {
        let controller = ResultController(exerciseKind: exerciseKind, exerciseType: exerciseType)
        controller.questionArray = questionArray
        controller.answerArray = answerArray
        controller.userAnswerArray = userAnswerArray
        controller.userAnswerArrayBool = userAnswerArrayBool
        self.navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - Hint

extension WritingController {
    
    private func setHint() {
        skeleton = ""
        underscoreArr.removeAll()
        skeletonArr.removeAll()
        randomArr.removeAll()
        
        for i in 0..<answerText.count {
            if answerText[i] != " " {
                underscoreArr.append("_")
                skeletonArr.append(i)
                randomArr.append(i)
            } else {
                underscoreArr.append(" ")
            }
        }
        skeleton = underscoreArr.joined(separator: " ")
    }
    
    private func getLetter() {
        if letterCounter <= skeletonArr.count {
            ClassicFireworkController.shared.addFireworks(count: 33, sparks: 5, around: exerciseTopView.userPointButton, maxVectorChange: view.frame.width)
            if letterCounter == 0 {
                hint = skeleton
            } else {
                let randomElement = randomArr.randomElement() ?? 0
                randomArr = randomArr.filter { $0 != randomElement }
                underscoreArr[randomElement] = "\(answerText[randomElement])"
                hint = underscoreArr.joined(separator: " ")
                //player.playMP3(Sounds.beep)
            }
            hintCount += 1
            letterCounter += 1
            hintLabel.text = hint
        } else {
            hintLabel.flash(withColor: Colors.green, originalColor: Colors.f6f6f6)
        }
    }
}

//MARK: - Collection View

extension WritingController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shuffledAnswer.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LetterCell
        cell.isHidden = false
        cell.letter = "\(shuffledAnswer[indexPath.row])"
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension WritingController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! LetterCell
        guard let letter = cell.letter else { return }
        guard let text = textField.text else { return }
        cell.isHidden = true
        currentAnswerIndex.append(indexPath.row)
        textField.text = text + letter
        textChanged(textField)
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension WritingController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 45)
    }
}

//MARK: - ExerciseTopDelegate

extension WritingController: ExerciseTopDelegate {
    func soundHintButtonPressed() {
        getLetter()
    }
}
