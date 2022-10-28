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
    
    //tabBar
    let tabBarStackView = UIStackView()
    let homeButton = UIButton()
    let dailyButton = UIButton()
    let awardButton = UIButton()
    let statisticButton = UIButton()
    let settingsButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        layout()
        barChart.delegate = self
        lineChart.delegate = self
        pieChart.delegate = self
        configureNavigationBar()
        configureTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollViewWidth = Int(self.scrollView.bounds.size.width)
        barChart.frame = CGRect(x: 16, y: 16, width: scrollViewWidth-32, height: scrollViewWidth-32)
        lineChart.frame = CGRect(x: 16, y: 16, width: scrollViewWidth-32, height: scrollViewWidth-32)
        pieChart.frame = CGRect(x: 16, y: 16, width: scrollViewWidth-32, height: scrollViewWidth-32)
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
        
        for d in 0..<10 {
            entries.append(BarChartDataEntry(x: Double(d), y: Double(d)))
        }
        
        let set = BarChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.joyful()
        
        let data = BarChartData(dataSet: set)
        
        barChart.data = data
    }
    
    func configureLineChart(){
        var entries = [ChartDataEntry()]
        
        for d in 0..<10 {
            entries.append(ChartDataEntry(x: Double(d), y: Double(d)))
        }
        
        let set = LineChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.material()
        
        let data = LineChartData(dataSet: set)
        
        lineChart.data = data
    }
    
    func configurePieChart(){
        var entries = [ChartDataEntry()]
        
        for d in 0..<10 {
            entries.append(ChartDataEntry(x: Double(d), y: Double(d)))
        }
        
        let set = PieChartDataSet(entries: entries)
        set.colors = ChartColorTemplates.colorful()
        
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
        configureBarChart()
        configureLineChart()
        configurePieChart()
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
        tabBarStackView.translatesAutoresizingMaskIntoConstraints = false
        tabBarStackView.axis = .horizontal
        tabBarStackView.spacing = 0
        tabBarStackView.distribution = .fillEqually
        
        homeButton.backgroundColor = .white
        dailyButton.backgroundColor = .white
        awardButton.backgroundColor = .white
        statisticButton.backgroundColor = .white
        settingsButton.backgroundColor = .white
        
        homeButton.setImageWithRenderingMode(imageName: "home", width: 25, height: 25, color: .darkGray)
        dailyButton.setImageWithRenderingMode(imageName: "dailyQuest", width: 26, height: 26, color: .darkGray)
        awardButton.setImageWithRenderingMode(imageName: "award", width: 27, height: 27, color: .darkGray)
        statisticButton.setImageWithRenderingMode(imageName: "statistic", width: 25, height: 25, color: Colors.blue ?? .blue)
        settingsButton.setImageWithRenderingMode(imageName: "settingsImage", width: 25, height: 25, color: .darkGray)
        
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButton.setTitle("Home", for: .normal)
        homeButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 11)
        homeButton.setTitleColor(.darkGray, for: .normal)
        homeButton.alignTextBelow()
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .primaryActionTriggered)
        
        dailyButton.translatesAutoresizingMaskIntoConstraints = false
        dailyButton.setTitle("Daily", for: .normal)
        dailyButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 11)
        dailyButton.setTitleColor(.darkGray, for: .normal)
        dailyButton.alignTextBelow()
        dailyButton.addTarget(self, action: #selector(dailyButtonPressed), for: .primaryActionTriggered)
        
        awardButton.translatesAutoresizingMaskIntoConstraints = false
        awardButton.setTitle("Awards", for: .normal)
        awardButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 11)
        awardButton.setTitleColor(.darkGray, for: .normal)
        awardButton.alignTextBelow()
        awardButton.addTarget(self, action: #selector(awardButtonPressed), for: .primaryActionTriggered)
        
        statisticButton.translatesAutoresizingMaskIntoConstraints = false
        statisticButton.setTitle("Statistics", for: .normal)
        statisticButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 11)
        statisticButton.setTitleColor(Colors.blue ?? .blue, for: .normal)
        statisticButton.alignTextBelow()
        
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.setTitle("Settings", for: .normal)
        settingsButton.titleLabel?.font = UIFont(name: "AvenirNext-Regular", size: 11)
        settingsButton.setTitleColor(.darkGray, for: .normal)
        settingsButton.alignTextBelow()
        settingsButton.addTarget(self, action: #selector(settingsButtonPressed), for: .primaryActionTriggered)
        
        
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
        
    }
    
    @objc func awardButtonPressed(gesture: UISwipeGestureRecognizer) {
        
    }
    
    @objc func settingsButtonPressed(gesture: UISwipeGestureRecognizer) {
        let vc = SettingsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
