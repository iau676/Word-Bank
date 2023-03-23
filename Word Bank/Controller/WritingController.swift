//
//  WritingController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 21.03.2023.
//

import UIKit

class WritingController: UIViewController {
    
    //MARK: - Properties
    
    private let exerciseType: String
    private let exerciseFormat: String
    
    private var wordBrain = WordBrain()
    private var player = Player()
    private var timer = Timer()
    
    private var exercisePoint: Int { return wordBrain.getExercisePoint() }
    private var selectedTyping: Int { return UserDefault.selectedTyping.getInt() }
    
    private var questionArray = [String]()
    private var answerArray = [String]()
    private var userAnswerArray = [String]()
    private var userAnswerArrayBool = [Bool]()
    
    private var questionCounter = 0
    private var totalQuestionNumber = 2
    private var questionText = ""
    private var answerText = ""
    
    private lazy var exerciseTopView: ExerciseTopView = {
        let view = ExerciseTopView(exerciseFormat: exerciseFormat)
        view.delegate = self
        return view
    }()
    
    private var bubbleButton = BubbleView()
    
    private let questionLabel: UILabel = {
       let label = UILabel()
        label.textColor = Colors.f6f6f6
        label.numberOfLines = 6
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: UserDefault.textSize.getCGFloat())
        label.textAlignment = .center
        return label
    }()
    
    //hint
    
    private var hint = ""
    private var hintCount = 0
    private var letterCounter = 0
    
    private let hintLabel:  UILabel = {
       let label = UILabel()
        label.textColor = Colors.f6f6f6
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 15)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.setViewCornerRadius(6)
        tf.setLeftPaddingPoints(10)
        tf.backgroundColor = .white
        tf.addTarget(self, action: #selector(textChanged), for: .allEditingEvents)
        return tf
    }()
    
    private let decreaseLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Fonts.ArialRoundedMTBold, size: 29)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.textColor = Colors.red
        label.isHidden = true
        return label
    }()
    
    // collection view
    
    fileprivate lazy var letterCV: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = .clear
        cv.register(LetterCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        cv.delegate = self
        cv.dataSource = self
        cv.bounces = false
        cv.isHidden = !(selectedTyping == 0)
        return cv
    }()
    
    private var shuffledAnswer: Array<Character> = Array("")
    private var currentAnswerIndex: [Int] = []
    
    private lazy var backspaceButton: UIButton = {
       let button = UIButton()
        button.isHidden = !(selectedTyping == 0)
        button.setImageWithRenderingMode(image: Images.backspace, width: 20, height: 20,
                                                  color: Colors.black ?? .black)
        button.addTarget(self, action: #selector(backspaceButtonPressed),
                                  for: .primaryActionTriggered)
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
        configureTextField()
        configureUI()
        updateUI()
    }
    
    //MARK: - Selectors
    
    @objc private func updateUI() {
        bubbleButton.isHidden = true
        letterCounter = 0
        hint = ""
        hintLabel.text = ""
        currentAnswerIndex = []
        
        if questionCounter < totalQuestionNumber {
            questionText = wordBrain.getQuestionText(questionCounter, 2, exerciseType)
            answerText = wordBrain.getEnglish(exerciseType: exerciseType)
            questionLabel.text = questionText
            questionArray.append(questionText)
            answerArray.append(answerText)
            updateCV()
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
    
    @objc private func textChanged(_ sender: UITextField) {
        guard let userAnswer = sender.text else { return }
        if answerText.lowercased() == userAnswer.lowercased() {
            checkAnswer(userAnswer)
            textField.text = ""
        }
    }
    
    private func checkAnswer(_ userAnswer: String){
        wordBrain.getHour()
        questionCounter += 1
        exerciseTopView.updateProgress()
        
        let userGotItRight = answerText.lowercased() == userAnswer.lowercased()
        let lastPoint = UserDefault.lastPoint.getInt()
        
        bubbleButton.isHidden = false
        questionLabel.text = ""
        
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
        bubbleButton.update(answer: userGotItRight, point: exercisePoint)
        bubbleButton.rotate()
        scheduledTimer(timeInterval: 0.7, #selector(updateUI))
    }
    
    @objc private func backspaceButtonPressed(_ sender: UIButton) {
        guard let text = textField.text else {return}
        if text.count > 0 {
            textField.text = "\(text.dropLast())"
            unhideLetterCell()
        }
    }
    
    private func unhideLetterCell() {
        guard let last = currentAnswerIndex.last else {return}
        if let cell = letterCV.cellForItem(at: IndexPath(row: last, section: 0)) as? LetterCell {
            cell.isHidden = false
            currentAnswerIndex.removeLast()
        }
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        configureNavigationBar()
        view.backgroundColor = Colors.raven
        
        view.addSubview(exerciseTopView)
        exerciseTopView.centerX(inView: view)
        exerciseTopView.setWidth(view.bounds.width)
        exerciseTopView.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 16)
        
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
        
        view.addSubview(bubbleButton)
        bubbleButton.centerX(inView: questionLabel)
        bubbleButton.centerY(inView: questionLabel)
        
        view.addSubview(decreaseLabel)
        decreaseLabel.centerX(inView: questionLabel)
        decreaseLabel.centerY(inView: questionLabel)
        
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
        textField.delegate = self
        textField.isEnabled = !(selectedTyping == 0)
        textField.tintColor = (selectedTyping == 0) ? .clear : Colors.raven
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
    }
    
    private func updateCV(){
        shuffledAnswer = answerText.shuffled()
        letterCV.reloadData()
    }
   
}

//MARK: - Hint

extension WritingController {
    
    @objc private func hideDecreaseLabel() {
        decreaseLabel.isHidden = true
        questionLabel.isHidden = false
    }
    
    @objc private func updateHintLabelColor() {
        hintLabel.textColor = Colors.f6f6f6
    }
    
    private func getLetter() {
        let answer = answerText
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
    
    private func decreasePoint() {
        let lastPoint = UserDefault.lastPoint.getInt()
        questionLabel.isHidden = true
        decreaseLabel.isHidden = false
        decreaseLabel.text = "-\(exercisePoint)"
        
        scheduledTimer(timeInterval: 0.4, #selector(hideDecreaseLabel))
        exerciseTopView.updatePoint(lastPoint: lastPoint,
                                    exercisePoint: exercisePoint,
                                    isIncrease: false)
    }
}

//MARK: - UITextFieldDelegate

extension WritingController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textFieldd: UITextField) -> Bool {
        getLetter()
        return false
    }
}

//MARK: - Collection View

extension WritingController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return shuffledAnswer.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! LetterCell
        cell.isHidden = false
        cell.titleLabel.text = "\(shuffledAnswer[indexPath.row])"
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension WritingController {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = collectionView.cellForItem(at: indexPath) as! LetterCell
        guard let title = item.titleLabel.text else {return}
        currentAnswerIndex.append(indexPath.row)
        item.isHidden = true
        textField.text! += "\(title)"
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
