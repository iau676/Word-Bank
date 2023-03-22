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
    
    private let tabBar = TabBar(color4: Colors.blue ?? .systemBlue)
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBrain.loadItemArray()
        wordBrain.loadExerciseArray()
        style()
        layout()
        
        configureNavigationBar()
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
        barChart.delegate = self
        lineChart.delegate = self
        pieChart.delegate = self
        
        barChart.isUserInteractionEnabled = false
        lineChart.isUserInteractionEnabled = false
        
        configureBarChart()
        configureLineChart()
        configurePieChart()
        
        updateChartsValueFormatter()
    }

    private func updateChartsValueFormatter() {
        let format = NumberFormatter()
        format.numberStyle = .decimal
        let formatter = DefaultValueFormatter(formatter: format)
        barChart.data?.setValueFormatter(formatter)
        lineChart.data?.setValueFormatter(formatter)
        pieChart.data?.setValueFormatter(formatter)
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
        barChart.data?.setValueFont(UIFont.systemFont(ofSize: 10))
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
        lineChart.data?.setValueFont(UIFont.systemFont(ofSize: 10))
    }
    
    func configurePieChart(){
        var entries = [ChartDataEntry()]
        
        entries.append(PieChartDataEntry(value: Double(exercisesDict[ExerciseFormat.card] ?? 0), label: "Card"))
        entries.append(PieChartDataEntry(value: Double(exercisesDict[ExerciseFormat.listening] ?? 0), label: "Listening"))
        entries.append(PieChartDataEntry(value: Double(exercisesDict[ExerciseFormat.writing] ?? 0), label: "Writing"))
        entries.append(PieChartDataEntry(value: Double(exercisesDict[ExerciseFormat.test] ?? 0), label: "Test"))
        
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
        
        tabBar.delegate = self
        
        scrollView.backgroundColor = Colors.cellLeft
        
        stackView.axis = .vertical
        stackView.spacing = 48
        stackView.distribution = .fill
        
        barChartLabel.textColor = Colors.black
        barChartLabel.numberOfLines = 1
        
        lineChartLabel.textColor = Colors.black
        lineChartLabel.numberOfLines = 1
        
        barView.backgroundColor = Colors.cellRight
        barView.layer.cornerRadius = 16
        
        lineView.backgroundColor = Colors.cellRight
        lineView.layer.cornerRadius = 16
        
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
        
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                          bottom: view.bottomAnchor, right: view.rightAnchor,
                          paddingTop: 8, paddingBottom: 66)
        
        stackView.anchor(top: scrollView.topAnchor, left: view.leftAnchor,
                         bottom: scrollView.bottomAnchor, right: view.rightAnchor,
                         paddingTop: 32, paddingLeft: 32,
                         paddingBottom: 48, paddingRight: 32)
        
        lineChartLabel.anchor(left: view.leftAnchor, bottom: lineView.topAnchor,
                             paddingLeft: 32, paddingBottom: 8)
        
        barChartLabel.anchor(left: view.leftAnchor, bottom: barView.topAnchor,
                             paddingLeft: 32, paddingBottom: 8)
        
        NSLayoutConstraint.activate([
          barView.heightAnchor.constraint(equalTo: stackView.widthAnchor),
          barView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
          
          lineView.heightAnchor.constraint(equalTo: stackView.widthAnchor),
          lineView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
          
          pieView.heightAnchor.constraint(equalTo: stackView.widthAnchor),
          pieView.widthAnchor.constraint(equalTo: stackView.widthAnchor),
        ])
        
        view.addSubview(tabBar)
        tabBar.setDimensions(height: 66, width: view.bounds.width)
        tabBar.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
}

//MARK: - TabBarDelegate

extension StatisticViewController: TabBarDelegate {
    
    func homePressed() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func dailyPressed() {
        pushVC(vc: DailyViewController())
    }
    
    func awardPressed() {
        pushVC(vc: AwardsViewController())
    }
    
    func statisticPressed() {
        //pushVC(vc: StatisticViewController())
    }
    
    func settingPressed() {
        pushVC(vc: SettingsViewController())
    }
    
    func pushVC(vc: UIViewController){
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.05){
           self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
