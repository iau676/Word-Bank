//
//  DailyViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 1.11.2022.
//

import UIKit

class DailyController: UIViewController {
        
    private let secondView = UIView()
    
    //Daily
    private let taskOneButton = UIButton()
    private let taskOneButtonBlueLayer = UIButton()
    private let taskOneButtonRavenLayer = UIButton()
    
    private let taskTwoButton = UIButton()
    private let taskTwoButtonBlueLayer = UIButton()
    private let taskTwoButtonRavenLayer = UIButton()
    
    private let taskThreeButton = UIButton()
    private let taskThreeButtonBlueLayer = UIButton()
    private let taskThreeButtonRavenLayer = UIButton()

    private let prizeButton = UIButton()

    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBrain.loadItemArray()
        wordBrain.loadExerciseArray()
        wordBrain.findExercisesCompletedToday()

        style()
        updateButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let taskButtonWidth = taskOneButton.frame.width
        layout(taskButtonWidth: taskButtonWidth)
    }
    
    //MARK: - Selectors
    
    @objc private func taskOneButtonPressed(){
        let controller = TestController(exerciseType: ExerciseType.normal,
                                        exerciseFormat: ExerciseFormat.test)
        checkWordCount(controller: controller)
    }
    
    @objc private func taskTwoButtonPressed(){
        let controller = WritingController(exerciseType: ExerciseType.normal,
                                           exerciseFormat: ExerciseFormat.writing)
        checkWordCount(controller: controller)
    }
    
    @objc private func taskThreeButtonPressed(){
        let controller = ListeningController(exerciseType: ExerciseType.normal,
                                             exerciseFormat: ExerciseFormat.listening)
        checkWordCount(controller: controller)
    }
    
    @objc private func prizeButtonPressed(){
        prizeButton.bounce()
        UserDefault.userGotDailyPrize.set("willGet")
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1){
            self.navigationController?.pushViewController(WheelController(), animated: true)
        }
    }
    
    //MARK: - Helpers
    
    private func checkWordCount(controller: UIViewController){
        let wordCount = itemArray.count
        
        if wordCount < 2 {
            showAlert(title: "Minimum two words required", message: "") { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
        } else {
            navigationController?.pushViewController(controller, animated: true)
        }
    }
    
    private func updateButtons(){
        if testExerciseCount >= 10 && writingExerciseCount >= 10 && listeningExerciseCount >= 10 {
            if UserDefault.userGotDailyPrize.getString() != wordBrain.getTodayDate() {
                prizeButton.isEnabled = true
            }
        }
        
        if testExerciseCount >= 10 {
            taskOneButton.setImageWithRenderingMode(image: Images.check, width: 25, height: 25, color: .white)
        }
        
        if writingExerciseCount >= 10 {
            taskTwoButton.setImageWithRenderingMode(image: Images.check, width: 25, height: 25, color: .white)
        }
        
        if listeningExerciseCount >= 10 {
            taskThreeButton.setImageWithRenderingMode(image: Images.check, width: 25, height: 25, color: .white)
        }
    }
    
    private func configureLayerButton(_ button: UIButton, _ color: UIColor?) {
        button.setHeight(60)
        button.setButtonCornerRadius(8)
        button.backgroundColor = color
    }
    
    private func configureButton(_ button: UIButton, _ text: String){
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 15)
        button.setButtonCornerRadius(8)
    }
}

//MARK: - Layout

extension DailyController {
    
    private func style(){
        title = "Daily"
        view.backgroundColor = Colors.cellLeft
        
        secondView.backgroundColor = Colors.cellRight
        secondView.setViewCornerRadius(10)
        
        configureButton(taskOneButton, "Complete 10 Test Exercise")
        configureButton(taskTwoButton, "Complete 10 Writing Exercise")
        configureButton(taskThreeButton, "Complete 10 Listening Exercise")
        configureButton(prizeButton, "")
        
        taskOneButton.setImageWithRenderingMode(image: Images.whiteCircle, width: 25, height: 25, color: .white)
        taskTwoButton.setImageWithRenderingMode(image: Images.whiteCircle, width: 25, height: 25, color: .white)
        taskThreeButton.setImageWithRenderingMode(image: Images.whiteCircle, width: 25, height: 25, color: .white)
        
        taskOneButton.moveImageTitleLeft()
        taskTwoButton.moveImageTitleLeft()
        taskThreeButton.moveImageTitleLeft()
        
        taskOneButton.addTarget(self, action: #selector(taskOneButtonPressed), for: .primaryActionTriggered)
        taskTwoButton.addTarget(self, action: #selector(taskTwoButtonPressed), for: .primaryActionTriggered)
        taskThreeButton.addTarget(self, action: #selector(taskThreeButtonPressed), for: .primaryActionTriggered)
        
        configureLayerButton(taskOneButtonBlueLayer, Colors.blue)
        configureLayerButton(taskOneButtonRavenLayer, Colors.raven)
        
        configureLayerButton(taskTwoButtonBlueLayer, Colors.blue)
        configureLayerButton(taskTwoButtonRavenLayer, Colors.raven)
        
        configureLayerButton(taskThreeButtonBlueLayer, Colors.blue)
        configureLayerButton(taskThreeButtonRavenLayer, Colors.raven)
        
        prizeButton.setImage(image: Images.wheel_prize_present, width: 128, height: 128)
        prizeButton.backgroundColor = .clear
        prizeButton.isEnabled = false
        prizeButton.addTarget(self, action: #selector(prizeButtonPressed), for: .primaryActionTriggered)
    }
    
    private func layout(taskButtonWidth: CGFloat){
        view.addSubview(secondView)
        
        let taskButtonW = view.bounds.width-64-32
        let taskOneBlueLayerWidth = (taskButtonW/10)*CGFloat(testExerciseCount)
        let taskTwoBlueLayerWidth = (taskButtonW/10)*CGFloat(writingExerciseCount)
        let taskThreeBlueLayerWidth = (taskButtonW/10)*CGFloat(listeningExerciseCount)
        
        secondView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                          bottom: view.bottomAnchor, right: view.rightAnchor,
                          paddingTop: 8, paddingLeft: 32,
                          paddingBottom: 82, paddingRight: 32)
        
        //raven layer
        let stackViewRaven = UIStackView(arrangedSubviews: [taskOneButtonRavenLayer,
                                                            taskTwoButtonRavenLayer,
                                                            taskThreeButtonRavenLayer])
        stackViewRaven.distribution = .fillEqually
        stackViewRaven.axis = .vertical
        stackViewRaven.spacing = 16
        
        secondView.addSubview(stackViewRaven)
        stackViewRaven.centerX(inView: view)
        stackViewRaven.setWidth(taskButtonW)
        stackViewRaven.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
  
        //blue layer
        taskOneButtonRavenLayer.addSubview(taskOneButtonBlueLayer)
        taskOneButtonBlueLayer.setWidth(taskOneBlueLayerWidth)
        
        taskTwoButtonRavenLayer.addSubview(taskTwoButtonBlueLayer)
        taskTwoButtonBlueLayer.setWidth(taskTwoBlueLayerWidth)

        taskThreeButtonRavenLayer.addSubview(taskThreeButtonBlueLayer)
        taskThreeButtonBlueLayer.setWidth(taskThreeBlueLayerWidth)
        
        //button layer
        taskOneButtonRavenLayer.addSubview(taskOneButton)
        taskOneButton.setDimensions(width: taskButtonW, height: 60)
        
        taskTwoButtonRavenLayer.addSubview(taskTwoButton)
        taskTwoButton.setDimensions(width: taskButtonW, height: 60)
        
        taskThreeButtonRavenLayer.addSubview(taskThreeButton)
        taskThreeButton.setDimensions(width: taskButtonW, height: 60)

        //prize button
        secondView.addSubview(prizeButton)
        prizeButton.centerX(inView: secondView)
        prizeButton.setDimensions(width: 128, height: 128)
        prizeButton.anchor(top: stackViewRaven.bottomAnchor, paddingTop: 32)
    }
}
