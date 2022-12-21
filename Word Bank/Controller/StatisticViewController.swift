//
//  StatisticViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 28.10.2022.
//

import UIKit
import Charts

class StatisticViewController: UIViewController, ChartViewDelegate {
    
    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let barView = UIView()
    let lineView = UIView()
    let pieView = UIView()
    
    var scrollViewWidth = 0
    
    var barChart = BarChartView()
    var lineChart = LineChartView()
    var pieChart = PieChartView()
    
    private let barChartLabel = UILabel()
    private let lineChartLabel = UILabel()
    private let pieChartLabel = UILabel()
    private var dayArray: [String] = []
    
    private var wordBrain = WordBrain()
    private var itemArray: [Item] { return wordBrain.itemArray }
    private var exerciseArray: [Exercise] { return wordBrain.exerciseArray }
    private var textSize: CGFloat { return UserDefault.textSize.getCGFloat() }
    
    private var dateArray: [String] = []
    private var today = ""
    private var yesterday = ""
    private var twoDaysAgo = ""
    private var threeDaysAgo = ""
    private var fourDaysAgo = ""
    private var fiveDaysAgo = ""
    private var sixDaysAgo = ""
    
    private var wordsDict = [String: Int]()
    private var exercisesDict = [String: Int]()
    
    private var wordsWeekCount = 0
    private var exercisesWeekCount = 0
    
    enum Chart {
        case bar
        case line
    }
    
    //tabBar
    private let fireworkController = ClassicFireworkController()
    private var timerDaily = Timer()
    private let tabBarStackView = UIStackView()
    private let homeButton = UIButton()
    private let dailyButton = UIButton()
    private let awardButton = UIButton()
    private let statisticButton = UIButton()
    private let settingsButton = UIButton()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBrain.loadItemArray()
        wordBrain.loadExerciseArray()
        style()
        layout()
        
        configureNavigationBar()
        configureTabBar()
        assignDatesToDays()
        
        getLastSevenDays()
        
        prepareData { (success) -> Void in if success { setCharts() } }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewWidth = Int(self.scrollView.bounds.size.width)
        barChart.frame = CGRect(x: 4, y: 8, width: scrollViewWidth-72, height: scrollViewWidth-64)
        lineChart.frame = CGRect(x: 4, y: 8, width: scrollViewWidth-72, height: scrollViewWidth-64)
        pieChart.frame = CGRect(x: 0, y: 0, width: scrollViewWidth-64, height: scrollViewWidth-64)
    }
    
    //MARK: - Helpers
    
    private func prepareData(completion: (_ success: Bool) -> Void) {
        findWordsCount()
        findExercisesCount()
        completion(true)
    }
    
    private func setCharts(){
        barChart.noDataText = "Loading..."
        
        barChart.delegate = self
        lineChart.delegate = self
        pieChart.delegate = self
        
        configureBarChart()
        configureLineChart()
        configurePieChart()
    }
    
    private func findWordsCount() {
        for i in 0..<itemArray.count {
            let wordDate = itemArray[i].date?.getFormattedDate(format: "yyyy-MM-dd") ?? ""
            if dateArray.contains(wordDate) {
                wordsDict.updateValue((wordsDict[wordDate] ?? 0)+1, forKey: wordDate)
            }
        }
    }
    
    private func findExercisesCount() {
        for i in 0..<exerciseArray.count {
            let exerciseDate = exerciseArray[i].date?.getFormattedDate(format: "yyyy-MM-dd") ?? ""
            let exerciseName = exerciseArray[i].name ?? ""
            if dateArray.contains(exerciseDate) {
                exercisesDict.updateValue((exercisesDict[exerciseDate] ?? 0)+1, forKey: exerciseDate)
            }
            exercisesDict.updateValue((exercisesDict[exerciseName] ?? 0)+1, forKey: exerciseName)
        }
    }
    
    private func assignDatesToDays(){
        today = getDate(daysAgo: 0)
        yesterday = getDate(daysAgo: 1)
        twoDaysAgo = getDate(daysAgo: 2)
        threeDaysAgo = getDate(daysAgo: 3)
        fourDaysAgo = getDate(daysAgo: 4)
        fiveDaysAgo = getDate(daysAgo: 5)
        sixDaysAgo = getDate(daysAgo: 6)
        
        dateArray.append(sixDaysAgo)
        dateArray.append(fiveDaysAgo)
        dateArray.append(fourDaysAgo)
        dateArray.append(threeDaysAgo)
        dateArray.append(twoDaysAgo)
        dateArray.append(yesterday)
        dateArray.append(today)
    }
    
    private func getDate(daysAgo: Int) -> String {
        return Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())?.getFormattedDate(format: "yyyy-MM-dd") ?? ""
    }
    
    private func getLastSevenDays(){
        for i in stride(from: 6, to: -1, by: -1) {
            dayArray.append(Calendar.current.date(byAdding: .day, value: -i, to: Date())?.getFormattedDate(format: "EEE") ?? "")
        }
    }
    
    func configureNavigationBar(){
        let backButton: UIButton = UIButton()
        let image = UIImage();
        backButton.setImage(image, for: .normal)
        backButton.setTitle("", for: .normal);
        backButton.titleLabel?.font =  UIFont.systemFont(ofSize: 17)
        backButton.setTitleColor(.black, for: .normal)
        backButton.sizeToFit()
        let barButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButton
        title = "Statistic"
    }
    
    private func getAttributedText(For: Chart) -> NSMutableAttributedString {
        if let avenirRegular = UIFont(name: Fonts.AvenirNextRegular, size: 15),
           let avenirDemiBold = UIFont(name: Fonts.AvenirNextDemiBold, size: 15) {
            
            let verb  = For == Chart.bar ? "learned" : "completed"
            let count = For == Chart.bar ? wordsWeekCount : exercisesWeekCount
            let noun  = For == Chart.bar ? "words" : "exercises"
            
            let avenirRegularAttrs = [NSAttributedString.Key.font : avenirRegular]
            let avenirDemiBoldAttrs = [NSAttributedString.Key.font : avenirDemiBold]
            
            let text = "You have \(verb)"
            let string = NSMutableAttributedString(string:text, attributes: avenirRegularAttrs)
            
            let secondText = " \(count) \(noun) "
            let secondString = NSMutableAttributedString(string:secondText, attributes: avenirDemiBoldAttrs)
            
            let thirdText = "this week"
            let thirdString = NSMutableAttributedString(string:thirdText, attributes: avenirRegularAttrs)
            
            string.append(secondString)
            string.append(thirdString)
            
            return string
        }
        return NSMutableAttributedString()
    }
}

//MARK: - Charts

extension StatisticViewController {
    
    func configureBarChart(){
        var entries = [BarChartDataEntry()]
        
        for i in 0..<dateArray.count {
            entries.append(BarChartDataEntry(x: Double(i), y: Double(wordsDict[dateArray[i]] ?? 0)))
            wordsWeekCount += wordsDict[dateArray[i]] ?? 0
        }
        
        barChartLabel.attributedText = getAttributedText(For: Chart.bar)
        
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        set.label = ""
        barChart.legend.enabled = false
        
        barChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dayArray)
        barChart.xAxis.granularity = 1
        
        let data = BarChartData(dataSet: set)
        barChart.data = data
    }
    
    func configureLineChart(){
        var entries = [ChartDataEntry()]
        
        for i in 0..<dateArray.count {
            entries.append(ChartDataEntry(x: Double(i), y: Double(exercisesDict[dateArray[i]] ?? 0)))
            exercisesWeekCount += exercisesDict[dateArray[i]] ?? 0
        }
         
        lineChartLabel.attributedText = getAttributedText(For: Chart.line)
        
        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.colorful()
        set.label = ""
        lineChart.legend.enabled = false
        
        lineChart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dayArray)
        lineChart.xAxis.granularity = 1
        
        let data = LineChartData(dataSet: set)
        lineChart.data = data
    }
    
    func configurePieChart(){
        var entries = [ChartDataEntry()]
        
        entries.append(PieChartDataEntry(value: Double(exercisesDict[ExerciseName.card] ?? 0), label: "Card"))
        entries.append(PieChartDataEntry(value: Double(exercisesDict[ExerciseName.listening] ?? 0), label: "Listening"))
        entries.append(PieChartDataEntry(value: Double(exercisesDict[ExerciseName.writing] ?? 0), label: "Writing"))
        entries.append(PieChartDataEntry(value: Double(exercisesDict[ExerciseName.test] ?? 0), label: "Test"))
        
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.liberty()
        set.label = ""
        pieChart.legend.enabled = false
        
        pieChart.centerText = "Completed \nExercises"
        pieChart.holeColor = Colors.cellRight
        
        let data = PieChartData(dataSet: set)
        pieChart.data = data
    }
}

//MARK: - Layout

extension StatisticViewController {
    
    func style() {
        view.backgroundColor = Colors.cellLeft
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = Colors.cellLeft
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 48
        stackView.distribution = .fill
        
        barChartLabel.translatesAutoresizingMaskIntoConstraints = false
        barChartLabel.textColor = Colors.black
        barChartLabel.numberOfLines = 1
        
        lineChartLabel.translatesAutoresizingMaskIntoConstraints = false
        lineChartLabel.textColor = Colors.black
        lineChartLabel.numberOfLines = 1
        
        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.backgroundColor = Colors.cellRight
        barView.layer.cornerRadius = 16
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = Colors.cellRight
        lineView.layer.cornerRadius = 16
        
        pieView.translatesAutoresizingMaskIntoConstraints = false
        pieView.backgroundColor = Colors.cellRight
        pieView.layer.cornerRadius = 16
        
        barChart.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
    }
    
    func layout() {
        
        barView.addSubview(barChart)
        lineView.addSubview(lineChart)
        pieView.addSubview(pieChart)
        
        stackView.addArrangedSubview(barView)
        stackView.addArrangedSubview(lineView)
        stackView.addArrangedSubview(pieView)

        scrollView.addSubview(stackView)
        
        view.addSubview(scrollView)
        view.addSubview(barChartLabel)
        view.addSubview(lineChartLabel)
        
        NSLayoutConstraint.activate([
           scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: wordBrain.getTopBarHeight() + 8),
           scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
           scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -66),
           
           stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 32),
           stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
           stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
           stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -48),
           
           barChartLabel.bottomAnchor.constraint(equalTo: barView.topAnchor, constant: -8),
           barChartLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
           
           barView.heightAnchor.constraint(equalTo: stackView.widthAnchor),
           barView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
           
           lineChartLabel.bottomAnchor.constraint(equalTo: lineView.topAnchor, constant: -8),
           lineChartLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
           
           lineView.heightAnchor.constraint(equalTo: stackView.widthAnchor),
           lineView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
           
           pieView.heightAnchor.constraint(equalTo: stackView.widthAnchor),
           pieView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
    }
}

//MARK: - Tab Bar

extension StatisticViewController {
    
    func configureTabBar() {
        
        var whichImage: Int = 0
        self.timerDaily = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { _ in
            if self.wordBrain.getCurrentHour() == UserDefault.userSelectedHour.getInt() {
                whichImage += 1
                self.updateDailyButtonImage(whichImage)
            }
        })
        
        //style
        tabBarStackView.translatesAutoresizingMaskIntoConstraints = false
        tabBarStackView.axis = .horizontal
        tabBarStackView.spacing = 0
        tabBarStackView.distribution = .fillEqually
        
        homeButton.configureForTabBar(image: Images.home, title: "Home", titleColor: .darkGray, imageWidth: 25, imageHeight: 25)
        dailyButton.configureForTabBar(image: wordBrain.dailyImages[UserDefault.dailyImageIndex.getInt()], title: "Daily", titleColor: .darkGray, imageWidth: 26, imageHeight: 26)
        awardButton.configureForTabBar(image: Images.award, title: "Awards", titleColor: .darkGray, imageWidth: 27, imageHeight: 27)
        statisticButton.configureForTabBar(image: Images.statistic, title: "Statistics", titleColor: Colors.blue ?? .blue, imageWidth: 25, imageHeight: 25)
        settingsButton.configureForTabBar(image: Images.settings, title: "Settings", titleColor: .darkGray, imageWidth: 25, imageHeight: 25)
        
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .primaryActionTriggered)
        dailyButton.addTarget(self, action: #selector(dailyButtonPressed), for: .primaryActionTriggered)
        awardButton.addTarget(self, action: #selector(awardButtonPressed), for: .primaryActionTriggered)
        settingsButton.addTarget(self, action: #selector(settingsButtonPressed), for: .primaryActionTriggered)
        
        //layout
        tabBarStackView.addArrangedSubview(homeButton)
        tabBarStackView.addArrangedSubview(dailyButton)
        tabBarStackView.addArrangedSubview(awardButton)
        tabBarStackView.addArrangedSubview(statisticButton)
        tabBarStackView.addArrangedSubview(settingsButton)
  
        view.addSubview(tabBarStackView)
        
        NSLayoutConstraint.activate([
            tabBarStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            tabBarStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            tabBarStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -0),
            tabBarStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tabBarStackView.heightAnchor.constraint(equalToConstant: 66)
        ])
    }
    
    @objc func homeButtonPressed(gesture: UISwipeGestureRecognizer) {
        pushVC(vc: UIViewController(), button: homeButton)
    }
    
    @objc func dailyButtonPressed(gesture: UISwipeGestureRecognizer) {
        pushVC(vc: DailyViewController(), button: dailyButton)
    }
    
    @objc func awardButtonPressed(gesture: UISwipeGestureRecognizer) {
        pushVC(vc: AwardsViewController(), button: awardButton)
    }
    
    @objc func settingsButtonPressed(gesture: UISwipeGestureRecognizer) {
        pushVC(vc: SettingsViewController(), button: settingsButton)
    }
    
    func pushVC(vc: UIViewController, button: UIButton){
        timerDaily.invalidate()
        self.fireworkController.addFireworks(count: 5, sparks: 5, around: button)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05){
            if button == self.homeButton {
                self.navigationController?.popToRootViewController(animated: true)
            } else {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func updateDailyButtonImage(_ whichImage: Int){
        UIView.transition(with: dailyButton.imageView ?? dailyButton, duration: 0.8,
                          options: .transitionFlipFromBottom,
                          animations: {
            if whichImage % 2 == 0 {
                self.dailyButton.setImageWithRenderingMode(image: self.wordBrain.dailyImages[UserDefault.dailyImageIndex.getInt()], width: 26, height: 26, color: .darkGray)
            } else {
                self.dailyButton.setImage(image: Images.x2Tab, width: 26, height: 26)
            }
        })
    }
}
