//
//  DailyViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 1.11.2022.
//

import UIKit

class DailyController: UIViewController {
    
    //MARK: - Properties
    
    private var itemArray: [Item] { return brain.itemArray }
    private var exerciseArray: [Exercise] { return brain.exerciseArray }
    private var exerciseDict = [String: Int]()
    
    private lazy var testExerciseCount: Int = 0
    private lazy var writingExerciseCount: Int = 0
    private lazy var listeningExerciseCount: Int = 0
    
    private let secondView: UIView = {
       let view = UIView()
        view.backgroundColor = Colors.cellRight
        view.setViewCornerRadius(10)
        return view
    }()
    
    private lazy var testTaskView = TaskView(title: "Complete 10 Test Exercise", exerciseCount: testExerciseCount)
    private lazy var writingTaskView = TaskView(title: "Complete 10 Writing Exercise", exerciseCount: writingExerciseCount)
    private lazy var listeningTaskView = TaskView(title: "Complete 10 Listening Exercise", exerciseCount: listeningExerciseCount)
    
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
        brain.loadItemArray()
        brain.loadExerciseArray()
        findExercisesCompletedToday()

        configureUI()
        configurePrizeButton()
        addGestures()
    }
    
    //MARK: - Selectors
    
    @objc private func testTaskPressed() {
        testTaskView.bounce()
        let controller = TestController(exerciseKind: .normal)
        checkWordCountAndNavigate(controller: controller)
    }
    
    @objc private func writingTaskPressed() {
        writingTaskView.bounce()
        let controller = WritingController(exerciseKind: .normal)
        checkWordCountAndNavigate(controller: controller)
    }
    
    @objc private func listeningTaskPressed() {
        listeningTaskView.bounce()
        let controller = ListeningController(exerciseKind: .normal)
        checkWordCountAndNavigate(controller: controller)
    }
    
    @objc private func prizeButtonPressed() {
        prizeButton.bounce()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1){
            self.navigationController?.pushViewController(WheelController(), animated: true)
        }
    }
    
    //MARK: - Helpers
    
    private func findExercisesCompletedToday() {
        exerciseDict.removeAll()
        let todayDate = Date().getTodayDate()
        for i in 0..<exerciseArray.count {
            let exerciseDate = exerciseArray[i].date?.getFormattedDate(format: DateFormats.yyyyMMdd) ?? ""
            let exerciseName = exerciseArray[i].name ?? ""
            if exerciseDate == todayDate {
                exerciseDict.updateValue((exerciseDict[exerciseName] ?? 0)+1, forKey: exerciseName)
            } else {
                break
            }
        }
        
        testExerciseCount = getExerciseCountToday(exerciseType: .test)
        writingExerciseCount = getExerciseCountToday(exerciseType: .writing)
        listeningExerciseCount = getExerciseCountToday(exerciseType: .listening)
    }
    
    func getExerciseCountToday(exerciseType: ExerciseType) -> Int {
        let int = exerciseDict[exerciseType.description] ?? 0
        return int > 10 ? 10 : int
    }
    
    private func configureUI() {
        title = "Daily"
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
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
            if UserDefault.userGotDailyPrize.getString() != Date().getTodayDate() {
                prizeButton.isEnabled = true
            }
        }
    }
    
    private func addGestures() {
        testTaskView.isUserInteractionEnabled = true
        testTaskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(testTaskPressed)))
        
        writingTaskView.isUserInteractionEnabled = true
        writingTaskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(writingTaskPressed)))
        
        listeningTaskView.isUserInteractionEnabled = true
        listeningTaskView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(listeningTaskPressed)))
    }
    
    private func checkWordCountAndNavigate(controller: UIViewController) {
        let wordCount = itemArray.count
        let needWord = controller as? ListeningController == nil ? 2 : 3
        
        if wordCount < needWord {
            showAlert(title: "Minimum \(needWord) words required", message: "")
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1){
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}
