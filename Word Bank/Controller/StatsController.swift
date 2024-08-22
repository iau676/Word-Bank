//
//  StatisticViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 28.10.2022.
//

import UIKit
import Charts

class StatsController: UIViewController {
    
    private let scrollView = UIScrollView()
    
    private lazy var barChart: BarChartView = {
        let chart = BarChartView()
        chart.backgroundColor = Colors.cellRight
        chart.layer.cornerRadius = 16
        chart.layer.masksToBounds = true
        chart.isUserInteractionEnabled = false
        chart.legend.enabled = false
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dayNames)
        chart.leftAxis.granularity = 1
        chart.rightAxis.granularity = 1
        return chart
    }()
    
    private lazy var lineChart: LineChartView = {
       let chart = LineChartView()
        chart.backgroundColor = Colors.cellRight
        chart.layer.cornerRadius = 16
        chart.layer.masksToBounds = true
        chart.isUserInteractionEnabled = false
        chart.legend.enabled = false
        chart.xAxis.valueFormatter = IndexAxisValueFormatter(values: dayNames)
        chart.leftAxis.granularity = 1
        chart.rightAxis.granularity = 1
        return chart
    }()
    
    private lazy var pieChart: PieChartView = {
       let chart = PieChartView()
        chart.backgroundColor = Colors.cellRight
        chart.layer.cornerRadius = 16
        chart.layer.masksToBounds = true
        chart.legend.enabled = false
        chart.centerText = "Completed \nExercises"
        chart.holeColor = Colors.cellRight
        return chart
    }()
    
    private lazy var barChartLabel: UILabel = {
       let label = UILabel()
        label.textColor = Colors.black
        label.setAttributedText(verb: "Learned", count: wordsWeekCount, noun: "word")
        return label
    }()
    
    private lazy var lineChartLabel: UILabel = {
       let label = UILabel()
        label.textColor = Colors.black
        label.setAttributedText(verb: "Completed", count: exercisesWeekCount, noun: "exercise")
        return label
    }()
    
    private var wordBrain = WordBrain()
    private var itemArray: [Item] { return wordBrain.itemArray }
    private var exerciseArray: [Exercise] { return wordBrain.exerciseArray }
    
    private var dayNames: [String] = []
    private var dateArray: [String] = []
    private var wordsDict = [String: Int]()
    private var exercisesDict = [String: Int]()
    
    private var wordsWeekCount = 0
    private var exercisesWeekCount = 0
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBrain.loadItemArray()
        wordBrain.loadExerciseArray()
        configureUI()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        configureCharts()
        
        title = "Statistic"
        view.backgroundColor = Colors.cellLeft
        scrollView.backgroundColor = Colors.cellLeft
        
        view.addSubview(scrollView)
        scrollView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                          paddingTop: 8, paddingBottom: 8)
        
        let stack = UIStackView(arrangedSubviews: [barChart, lineChart, pieChart])
        stack.axis = .vertical
        stack.spacing = 48
        stack.distribution = .fillEqually

        let viewWidth = view.frame.width-64
        barChart.setDimensions(width: viewWidth, height: viewWidth)
        lineChart.setDimensions(width: viewWidth, height: viewWidth)
        pieChart.setDimensions(width: viewWidth, height: viewWidth)

        scrollView.addSubview(stack)
        stack.anchor(top: scrollView.topAnchor, left: view.leftAnchor,
                         bottom: scrollView.bottomAnchor, right: view.rightAnchor,
                         paddingTop: 32, paddingLeft: 32,
                         paddingBottom: 48, paddingRight: 32)
        
        view.addSubview(barChartLabel)
        barChartLabel.anchor(left: view.leftAnchor, bottom: barChart.topAnchor,
                             paddingLeft: 32, paddingBottom: 8)
        
        view.addSubview(lineChartLabel)
        lineChartLabel.anchor(left: view.leftAnchor, bottom: lineChart.topAnchor,
                             paddingLeft: 32, paddingBottom: 8)
    }
    
    private func configureCharts() {
        getLastSevenDayDates()
        getLastSevenDayNames()
        findWordsCount()
        findExercisesCount()
        
        configureBarChart()
        configureLineChart()
        configurePieChart()
    }
    
    private func getLastSevenDayDates() {
        dateArray.append(getDate(daysAgo: 6))
        dateArray.append(getDate(daysAgo: 5))
        dateArray.append(getDate(daysAgo: 4))
        dateArray.append(getDate(daysAgo: 3))
        dateArray.append(getDate(daysAgo: 2))
        dateArray.append(getDate(daysAgo: 1))
        dateArray.append(getDate(daysAgo: 0))
    }
    
    private func getDate(daysAgo: Int) -> String {
        return Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date())?.getFormattedDate(format: DateFormats.yyyyMMdd) ?? ""
    }
    
    private func getLastSevenDayNames() {
        for i in stride(from: 6, to: -1, by: -1) {
            dayNames.append(Calendar.current.date(byAdding: .day, value: -i, to: Date())?.getFormattedDate(format: DateFormats.EEE) ?? "")
        }
    }
    
    private func findWordsCount() {
        for i in 0..<itemArray.count {
            let wordDate = itemArray[i].date?.getFormattedDate(format: DateFormats.yyyyMMdd) ?? ""
            if dateArray.contains(wordDate) {
                wordsDict.updateValue((wordsDict[wordDate] ?? 0)+1, forKey: wordDate)
            } else {
                break
            }
        }
    }
    
    private func findExercisesCount() {
        for i in 0..<exerciseArray.count {
            let exerciseDate = exerciseArray[i].date?.getFormattedDate(format: DateFormats.yyyyMMdd) ?? ""
            let exerciseName = exerciseArray[i].name ?? ""
            if dateArray.contains(exerciseDate) {
                exercisesDict.updateValue((exercisesDict[exerciseDate] ?? 0)+1, forKey: exerciseDate)
            }
            exercisesDict.updateValue((exercisesDict[exerciseName] ?? 0)+1, forKey: exerciseName)
        }
    }
    
    private func configureBarChart() {
        var entries = [BarChartDataEntry()]
        
        for i in 0..<dateArray.count {
            entries.append(BarChartDataEntry(x: Double(i), y: Double(wordsDict[dateArray[i]] ?? 0)))
            wordsWeekCount += wordsDict[dateArray[i]] ?? 0
        }
        
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        set.label = ""
        
        let data = BarChartData(dataSet: set)
        barChart.data = data
        barChart.data?.setValueFont(UIFont.systemFont(ofSize: 10))
        barChart.data?.setValueFormatter(DefaultValueFormatter(decimals: 0))
    }
    
    private func configureLineChart() {
        var entries = [ChartDataEntry()]
        
        for i in 0..<dateArray.count {
            entries.append(ChartDataEntry(x: Double(i), y: Double(exercisesDict[dateArray[i]] ?? 0)))
            exercisesWeekCount += exercisesDict[dateArray[i]] ?? 0
        }
        
        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.colorful()
        set.label = ""
        
        let data = LineChartData(dataSet: set)
        lineChart.data = data
        lineChart.data?.setValueFont(UIFont.systemFont(ofSize: 10))
        lineChart.data?.setValueFormatter(DefaultValueFormatter(decimals: 0))
    }
    
    private func configurePieChart() {
        var entries = [ChartDataEntry()]
        
        entries.append(PieChartDataEntry(value: Double(exercisesDict[ExerciseFormat.card] ?? 0), label: "Card"))
        entries.append(PieChartDataEntry(value: Double(exercisesDict[ExerciseFormat.listening] ?? 0), label: "Listening"))
        entries.append(PieChartDataEntry(value: Double(exercisesDict[ExerciseFormat.writing] ?? 0), label: "Writing"))
        entries.append(PieChartDataEntry(value: Double(exercisesDict[ExerciseFormat.test] ?? 0), label: "Test"))
        
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.liberty()
        set.label = ""
        
        let data = PieChartData(dataSet: set)
        pieChart.data = data
        pieChart.data?.setValueFormatter(DefaultValueFormatter(decimals: 0))
    }
}
