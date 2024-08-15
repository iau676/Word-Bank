//
//  DailyViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 1.11.2022.
//

import UIKit

class DailyController: UIViewController {
        
    private let secondView = UIView()
    
    //top tabBar
    private let topTapBarStackView = UIStackView()
    private let dailyTaskButton = UIButton()
    private let x2EventButton = UIButton()
    private let lineView = UIView()
    
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
    
    //2x
    private let x2Label = UILabel()
    private let wheelButton = UIButton()
    private let whiteCircleButton = UIButton()
    
    private var wordBrain = WordBrain()
    private var itemArray: [Item] { return wordBrain.itemArray }
    private var exerciseArray: [Exercise] { return wordBrain.exerciseArray }
    private var todayDate: String { return wordBrain.getTodayDate() }
    
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
        wordBrain.getHour()
        wordBrain.loadItemArray()
        wordBrain.loadExerciseArray()
        wordBrain.findExercisesCompletedToday()

        style()
        updateButtons()
        
        showDailyTask()
        hide2xEvent()
        addGestureRecognizer()
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
    
    @objc private func wheelButtonPressed(){
        wheelButton.bounce()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1){
            self.navigationController?.pushViewController(WheelController(), animated: true)
        }
    }
    
    @objc private func x2EventButtonPressed(){
        hideDailyTask()
        show2xEvent()
    }
    
    @objc private func dailyTaskButtonPressed(){
        showDailyTask()
        hide2xEvent()
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
            if UserDefault.userGotDailyPrize.getString() != todayDate {
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
    
    private func showDailyTask(){
        taskOneButton.isHidden = false
        taskOneButtonBlueLayer.isHidden = false
        taskOneButtonRavenLayer.isHidden = false
        
        taskTwoButton.isHidden = false
        taskTwoButtonBlueLayer.isHidden = false
        taskTwoButtonRavenLayer.isHidden = false
        
        taskThreeButton.isHidden = false
        taskThreeButtonBlueLayer.isHidden = false
        taskThreeButtonRavenLayer.isHidden = false
        
        prizeButton.isHidden = false
    }
    
    private func show2xEvent(){
        secondView.backgroundColor = Colors.pink
        x2Label.isHidden = false
        wheelButton.isHidden = false
        whiteCircleButton.isHidden = false
        
        if UserDefault.currentHour.getInt() == UserDefault.userSelectedHour.getInt() {
            x2Label.text = "You are on 2x points hour!\n\nYou will earn 2x points for each correct answer.\n\nYou can change this hour on settings."
            wheelButton.isEnabled = true
            whiteCircleButton.alpha = 1
        } else {
            x2Label.text = "You will earn 2x points for each correct answer between \(wordBrain.hours[UserDefault.userSelectedHour.getInt()])  hours.\n\nYou can change this hour on settings."
            wheelButton.isEnabled = false
            whiteCircleButton.alpha = 0.7
        }
    }
    
    private func hideDailyTask(){
        taskOneButton.isHidden = true
        taskOneButtonBlueLayer.isHidden = true
        taskOneButtonRavenLayer.isHidden = true
        
        taskTwoButton.isHidden = true
        taskTwoButtonBlueLayer.isHidden = true
        taskTwoButtonRavenLayer.isHidden = true
        
        taskThreeButton.isHidden = true
        taskThreeButtonBlueLayer.isHidden = true
        taskThreeButtonRavenLayer.isHidden = true
        
        prizeButton.isHidden = true
    }
    
    private func hide2xEvent(){
        secondView.backgroundColor = Colors.cellRight
        x2Label.isHidden = true
        wheelButton.isHidden = true
        whiteCircleButton.isHidden = true
    }
}

//MARK: - Layout

extension DailyController {
    
    private func style(){
        title = "Daily"
        view.backgroundColor = Colors.cellLeft
        
        secondView.backgroundColor = Colors.cellRight
        secondView.setViewCornerRadius(10)
        
        //top tabBar
        topTapBarStackView.axis = .horizontal
        topTapBarStackView.distribution = .fillEqually
        topTapBarStackView.spacing = 0
        
        dailyTaskButton.setImage(image: Images.wheel_prize_present, width: 25, height: 25)
        dailyTaskButton.setButtonCornerRadius(8)
        dailyTaskButton.layer.maskedCorners = [.layerMinXMinYCorner]
        dailyTaskButton.backgroundColor = Colors.cellRight
        dailyTaskButton.addTarget(self, action: #selector(dailyTaskButtonPressed), for: .primaryActionTriggered)
        
        x2EventButton.setImage(image: UIImage(named: "x2V"), width: 25, height: 25)
        x2EventButton.setButtonCornerRadius(8)
        x2EventButton.layer.maskedCorners = [.layerMaxXMinYCorner]
        x2EventButton.backgroundColor = Colors.pink
        x2EventButton.addTarget(self, action: #selector(x2EventButtonPressed), for: .primaryActionTriggered)
        
        lineView.backgroundColor = .systemGray5
        
        //Daily
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
        
        //2x
        x2Label.font = UIFont(name: Fonts.AvenirNextRegular, size: 21)
        x2Label.textColor = Colors.f6f6f6
        x2Label.numberOfLines = 0
        x2Label.textAlignment = .center
        
        wheelButton.setImage(image: Images.wheelicon, width: 128, height: 128)
        wheelButton.backgroundColor = .clear
        wheelButton.isEnabled = true
        wheelButton.addTarget(self, action: #selector(wheelButtonPressed), for: .primaryActionTriggered)
        
        whiteCircleButton.backgroundColor = .white
        whiteCircleButton.setButtonCornerRadius(9)
        whiteCircleButton.layer.borderWidth = 0.6
        whiteCircleButton.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    private func layout(taskButtonWidth: CGFloat){
        view.addSubview(secondView)
        
        //top tabBar
        topTapBarStackView.addArrangedSubview(dailyTaskButton)
        topTapBarStackView.addArrangedSubview(x2EventButton)
        secondView.addSubview(topTapBarStackView)
        secondView.addSubview(lineView)
        
        
        let taskButtonW = view.bounds.width-64-32
        let taskOneBlueLayerWidth = (taskButtonW/10)*CGFloat(testExerciseCount)
        let taskTwoBlueLayerWidth = (taskButtonW/10)*CGFloat(writingExerciseCount)
        let taskThreeBlueLayerWidth = (taskButtonW/10)*CGFloat(listeningExerciseCount)
        
        secondView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                          bottom: view.bottomAnchor, right: view.rightAnchor,
                          paddingTop: 8, paddingLeft: 32,
                          paddingBottom: 82, paddingRight: 32)

        //top tabBar
        topTapBarStackView.setHeight(66)
        topTapBarStackView.anchor(top: secondView.topAnchor, left: secondView.leftAnchor,
                                  right: secondView.rightAnchor)
        
        lineView.setHeight(1)
        lineView.anchor(top: topTapBarStackView.bottomAnchor, left: secondView.leftAnchor,
                        right: secondView.rightAnchor)
        
        //Daily
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
        stackViewRaven.anchor(top: topTapBarStackView.bottomAnchor, paddingTop: 32)
  
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

        
        //2x
        //x2Label
        secondView.addSubview(x2Label)
        x2Label.anchor(top: secondView.topAnchor, left: secondView.leftAnchor,
                       right: secondView.rightAnchor, paddingTop: 128,
                       paddingLeft: 16, paddingRight: 16)
        
        //wheelButton
        secondView.addSubview(wheelButton)
        wheelButton.centerX(inView: secondView)
        wheelButton.setDimensions(width: 128, height: 128)
        wheelButton.anchor(top: x2Label.bottomAnchor, paddingTop: 32)
        
        secondView.addSubview(whiteCircleButton)
        whiteCircleButton.centerX(inView: wheelButton)
        whiteCircleButton.centerY(inView: wheelButton)
        whiteCircleButton.setDimensions(width: 18, height: 18)
    }
}

//MARK: - Swipe Gesture

extension DailyController {
    private func addGestureRecognizer(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeLeft))
        swipeLeft.direction = .left
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRight))
        swipeRight.direction = .right
        
        secondView.addGestureRecognizer(swipeLeft)
        secondView.addGestureRecognizer(swipeRight)
    }
    
    @objc private func respondToSwipeLeft(gesture: UISwipeGestureRecognizer) {
        show2xEvent()
        hideDailyTask()
    }
        
    @objc private func respondToSwipeRight(gesture: UISwipeGestureRecognizer) {
        showDailyTask()
        hide2xEvent()
    }
}
