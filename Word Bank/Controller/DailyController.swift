//
//  DailyViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 1.11.2022.
//

import UIKit

class DailyController: UIViewController {
    
    //MARK: - Properties
    
    private var wordBrain = WordBrain()
    private var itemArray: [Item] { return wordBrain.itemArray }
    private var exerciseArray: [Exercise] { return wordBrain.exerciseArray }
    
    private lazy var testExerciseCount: Int = {
        let int = wordBrain.getExerciseCountToday(for: ExerciseFormat.test)
        return int > 10 ? 10 : int
    }()
    
    private lazy var writingExerciseCount: Int = {
        let int = wordBrain.getExerciseCountToday(for: ExerciseFormat.writing)
        return int > 10 ? 10 : int
    }()
    
    private lazy var listeningExerciseCount: Int = {
        let int = wordBrain.getExerciseCountToday(for: ExerciseFormat.listening)
        return int > 10 ? 10 : int
    }()
    
    private let secondView: UIView = {
       let view = UIView()
        view.backgroundColor = Colors.cellRight
        view.setViewCornerRadius(10)
        return view
    }()
    
    private lazy var testTaskView: UIView = {
       let view = TaskView(title: "Complete 10 Test Exercise", exerciseCount: testExerciseCount)
        view.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(testTaskPressed))
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }()
    
    private lazy var writingTaskView: UIView = {
       let view = TaskView(title: "Complete 10 Writing Exercise", exerciseCount: writingExerciseCount)
        view.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(writingTaskPressed))
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }()
    
    private lazy var listeningTaskView: UIView = {
       let view = TaskView(title: "Complete 10 Listening Exercise", exerciseCount: listeningExerciseCount)
        view.isUserInteractionEnabled = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(listeningTaskPressed))
        view.addGestureRecognizer(tapGestureRecognizer)
        return view
    }()
    
    private lazy var prizeButton: UIButton = {
        let button = UIButton()
        button.setImage(image: Images.wheel_prize_present, width: 128, height: 128)
        button.backgroundColor = .clear
        button.isEnabled = false
        button.addTarget(self, action: #selector(prizeButtonPressed), for: .primaryActionTriggered)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBrain.loadItemArray()
        wordBrain.loadExerciseArray()
        wordBrain.findExercisesCompletedToday()

        configureUI()
        configurePrizeButton()
    }
    
    //MARK: - Selectors
    
    @objc private func testTaskPressed() {
        testTaskView.bounce()
        let controller = TestController(exerciseType: ExerciseType.normal,
                                        exerciseFormat: ExerciseFormat.test)
        checkWordCountAndNavigate(controller: controller)
    }
    
    @objc private func writingTaskPressed() {
        writingTaskView.bounce()
        let controller = WritingController(exerciseType: ExerciseType.normal,
                                           exerciseFormat: ExerciseFormat.writing)
        checkWordCountAndNavigate(controller: controller)
    }
    
    @objc private func listeningTaskPressed() {
        listeningTaskView.bounce()
        let controller = ListeningController(exerciseType: ExerciseType.normal,
                                             exerciseFormat: ExerciseFormat.listening)
        checkWordCountAndNavigate(controller: controller)
    }
    
    @objc private func prizeButtonPressed() {
        prizeButton.bounce()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1){
            self.navigationController?.pushViewController(WheelController(), animated: true)
        }
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        title = "Daily"
        view.backgroundColor = Colors.cellLeft
        
        view.addSubview(secondView)
        secondView.anchor(left: view.leftAnchor, right: view.rightAnchor,
                          paddingLeft: 32,paddingRight: 32)
        secondView.centerY(inView: view)
        secondView.setHeight(388) //16*5 + 60*3 + 128
        
        let stack = UIStackView(arrangedSubviews: [testTaskView, writingTaskView, listeningTaskView])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 16
        
        testTaskView.setHeight(60)
        secondView.addSubview(stack)
        stack.centerX(inView: view)
        stack.anchor(top: secondView.topAnchor, left: secondView.leftAnchor, right: secondView.rightAnchor,
                     paddingTop: 16, paddingLeft: 16, paddingRight: 16)

        secondView.addSubview(prizeButton)
        prizeButton.centerX(inView: secondView)
        prizeButton.setDimensions(width: 128, height: 128)
        prizeButton.anchor(top: stack.bottomAnchor, paddingTop: 16)
    }
    
    private func configurePrizeButton() {
        if testExerciseCount >= 10 && writingExerciseCount >= 10 && listeningExerciseCount >= 10 {
            if UserDefault.userGotDailyPrize.getString() != wordBrain.getTodayDate() {
                prizeButton.isEnabled = true
            }
        }
    }
    
    private func checkWordCountAndNavigate(controller: UIViewController) {
        let wordCount = itemArray.count
        
        if wordCount < 2 {
            showAlert(title: "Minimum two words required", message: "") { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1){
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}
