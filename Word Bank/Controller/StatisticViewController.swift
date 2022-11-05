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
    
    //tabBar
    let tabBarStackView = UIStackView()
    let homeButton = UIButton()
    let dailyButton = UIButton()
    let awardButton = UIButton()
    let statisticButton = UIButton()
    let settingsButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBrain.loadItemArray()
        wordBrain.loadExerciseArray()
        style()
        layout()
        barChart.delegate = self
        lineChart.delegate = self
        pieChart.delegate = self
        configureNavigationBar()
        configureTabBar()
        assignDatesToDays()
        findWordsCount()
        findExercisesCount()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureBarChart()
        configureLineChart()
        configurePieChart()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewWidth = Int(self.scrollView.bounds.size.width)
        barChart.frame = CGRect(x: 16, y: 16, width: scrollViewWidth-32, height: scrollViewWidth-32)
        lineChart.frame = CGRect(x: 16, y: 16, width: scrollViewWidth-32, height: scrollViewWidth-32)
        pieChart.frame = CGRect(x: 16, y: 16, width: scrollViewWidth-32, height: scrollViewWidth-32)
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
        sixDaysAgo = getDate(daysAgo: 5)
        
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
}

//MARK: - Charts

extension StatisticViewController {
    
    func configureBarChart(){
        var entries = [BarChartDataEntry()]
        
        for i in 0..<dateArray.count {
            entries.append(BarChartDataEntry(x: Double(i), y: Double(wordsDict[dateArray[i]] ?? 0)))
        }
        
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        set.label = ""
        barChart.legend.enabled = false
        
        let data = BarChartData(dataSet: set)
        barChart.data = data
    }
    
    func configureLineChart(){
        var entries = [ChartDataEntry()]
        
        for i in 0..<dateArray.count {
            entries.append(ChartDataEntry(x: Double(i), y: Double(exercisesDict[dateArray[i]] ?? 0)))
        }
        
        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.material()
        set.label = ""
        lineChart.legend.enabled = false
        
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
        pieChart.holeColor = .systemGray2
        
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
        stackView.spacing = 32
        stackView.distribution = .fill
        
        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.backgroundColor = .systemGray5
        barView.layer.cornerRadius = 16
        
        lineView.translatesAutoresizingMaskIntoConstraints = false
        lineView.backgroundColor = .systemPurple
        lineView.layer.cornerRadius = 16
        
        pieView.translatesAutoresizingMaskIntoConstraints = false
        pieView.backgroundColor = .systemGray2
        pieView.layer.cornerRadius = 16
        
        barChart.frame = CGRect(x: 0, y: 0, width: 200, height: 200)
        
        //self.view.frame.size.width
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
        
        
        NSLayoutConstraint.activate([
            
           scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
           scrollView.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 4),
           view.trailingAnchor.constraint(equalToSystemSpacingAfter: scrollView.trailingAnchor, multiplier: 4),
           //scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
           scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -66),
           
           stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
           stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
           stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
           stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
           stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
           
           barView.heightAnchor.constraint(equalTo: scrollView.widthAnchor),
           barView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
           
           lineView.heightAnchor.constraint(equalTo: scrollView.widthAnchor),
           lineView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
           
           pieView.heightAnchor.constraint(equalTo: scrollView.widthAnchor),
           pieView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
        ])
    }
}

//MARK: - Tab Bar

extension StatisticViewController {
    
    func configureTabBar() {
        //style
        tabBarStackView.translatesAutoresizingMaskIntoConstraints = false
        tabBarStackView.axis = .horizontal
        tabBarStackView.spacing = 0
        tabBarStackView.distribution = .fillEqually
        
        homeButton.configureForTabBar(image: Images.home, title: "Home", titleColor: .darkGray, imageWidth: 25, imageHeight: 25)
        dailyButton.configureForTabBar(image: Images.daily, title: "Daily", titleColor: .darkGray, imageWidth: 26, imageHeight: 26)
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
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func dailyButtonPressed(gesture: UISwipeGestureRecognizer) {
        let vc = DailyViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func awardButtonPressed(gesture: UISwipeGestureRecognizer) {
        let vc = AwardsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func settingsButtonPressed(gesture: UISwipeGestureRecognizer) {
        let vc = SettingsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
