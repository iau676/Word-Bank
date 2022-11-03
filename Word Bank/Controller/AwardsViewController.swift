//
//  AwardsViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 29.10.2022.
//

import UIKit

struct BadgeData {
    var title: String
    var url: String
    var backgroundImage: UIImage?
}

class AwardsViewController: UIViewController {
    
    fileprivate let levelData = [
        BadgeData(title: "www", url: "www", backgroundImage: UIImage(named: "medal")),
        BadgeData(title: "www", url: "www", backgroundImage: UIImage(named: "medal")),
        BadgeData(title: "www", url: "www", backgroundImage: UIImage(named: "medal")),
        BadgeData(title: "www", url: "www", backgroundImage: UIImage(named: "medal")),
        BadgeData(title: "www", url: "www", backgroundImage: UIImage(named: "medal")),
    ]
    
    fileprivate let wordsData = [
        BadgeData(title: "www", url: "www", backgroundImage: UIImage(named: "winner")),
        BadgeData(title: "www", url: "www", backgroundImage: UIImage(named: "winner")),
        BadgeData(title: "www", url: "www", backgroundImage: UIImage(named: "winner")),
        BadgeData(title: "www", url: "www", backgroundImage: UIImage(named: "winner")),
        BadgeData(title: "www", url: "www", backgroundImage: UIImage(named: "winner")),
    ]
    
    fileprivate let exercisesData = [
        BadgeData(title: "www", url: "www", backgroundImage: UIImage(named: "medal")),
        BadgeData(title: "www", url: "www", backgroundImage: UIImage(named: "medal")),
        BadgeData(title: "www", url: "www", backgroundImage: UIImage(named: "medal")),
        BadgeData(title: "www", url: "www", backgroundImage: UIImage(named: "medal")),
        BadgeData(title: "www", url: "www", backgroundImage: UIImage(named: "medal")),
    ]
    
    private let levelLabel = UILabel()
    private let wordsLabel = UILabel()
    private let exercisesLabel = UILabel()
    
    private let levelButton = UIButton()
    private let wordsButton = UIButton()
    private let exercisesButton = UIButton()

    private let levelScoreLabel = UILabel()
    private let wordsScoreLabel = UILabel()
    private let exerciseScoreLabel = UILabel()

    fileprivate let levelCV:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = Colors.cellLeft
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    fileprivate let wordsCV:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = Colors.cellLeft
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    fileprivate let exercisesCV:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = Colors.cellLeft
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    //tabBar
    let tabBarStackView = UIStackView()
    let homeButton = UIButton()
    let dailyButton = UIButton()
    let awardButton = UIButton()
    let statisticButton = UIButton()
    let settingsButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        style()
        layout()
        configureTabBar()
    }
    
    private func style(){
        view.backgroundColor = Colors.cellLeft
        
        configureLabel(levelLabel, "LEVEL")
        configureLabel(wordsLabel, "WORDS")
        configureLabel(exercisesLabel, "EXERCISES")
        
        configureButton(levelButton, "99")
        configureButton(wordsButton, "99")
        configureButton(exercisesButton, "99")
        
        configureLabel(levelScoreLabel, "1/10")
        configureLabel(wordsScoreLabel, "1/10")
        configureLabel(exerciseScoreLabel, "1/10")
      
        levelCV.delegate = self
        levelCV.dataSource = self
        
        wordsCV.delegate = self
        wordsCV.dataSource = self
        
        exercisesCV.delegate = self
        exercisesCV.dataSource = self
    }
    
    private func layout(){
                
        view.addSubview(levelLabel)
        view.addSubview(wordsLabel)
        view.addSubview(exercisesLabel)
        
        view.addSubview(levelCV)
        view.addSubview(wordsCV)
        view.addSubview(exercisesCV)
        
        view.addSubview(levelButton)
        view.addSubview(wordsButton)
        view.addSubview(exercisesButton)
        
        view.addSubview(levelScoreLabel)
        view.addSubview(wordsScoreLabel)
        view.addSubview(exerciseScoreLabel)
        
        NSLayoutConstraint.activate([
            levelCV.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            levelCV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            levelCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            levelCV.heightAnchor.constraint(equalToConstant: 140),
            
            levelLabel.bottomAnchor.constraint(equalTo: levelCV.topAnchor, constant: 1),
            levelLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            
            levelButton.centerYAnchor.constraint(equalTo: levelLabel.centerYAnchor),
            levelButton.leadingAnchor.constraint(equalTo: levelLabel.trailingAnchor, constant: 8),
            levelButton.heightAnchor.constraint(equalToConstant: 29),
            
            levelScoreLabel.centerYAnchor.constraint(equalTo: levelLabel.centerYAnchor),
            levelScoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            wordsCV.topAnchor.constraint(equalTo: levelCV.bottomAnchor, constant: 32),
            wordsCV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            wordsCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            wordsCV.heightAnchor.constraint(equalToConstant: 140),
            
            wordsLabel.bottomAnchor.constraint(equalTo: wordsCV.topAnchor, constant: 1),
            wordsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            wordsButton.centerYAnchor.constraint(equalTo: wordsLabel.centerYAnchor),
            wordsButton.leadingAnchor.constraint(equalTo: wordsLabel.trailingAnchor, constant: 8),
            wordsButton.heightAnchor.constraint(equalToConstant: 29),
            
            wordsScoreLabel.centerYAnchor.constraint(equalTo: wordsLabel.centerYAnchor),
            wordsScoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
       
        NSLayoutConstraint.activate([
            exercisesCV.topAnchor.constraint(equalTo: wordsCV.bottomAnchor, constant: 32),
            exercisesCV.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            exercisesCV.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            exercisesCV.heightAnchor.constraint(equalToConstant: 140),
            
            exercisesLabel.bottomAnchor.constraint(equalTo: exercisesCV.topAnchor, constant: 1),
            exercisesLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            
            exercisesButton.centerYAnchor.constraint(equalTo: exercisesLabel.centerYAnchor),
            exercisesButton.leadingAnchor.constraint(equalTo: exercisesLabel.trailingAnchor, constant: 8),
            exercisesButton.heightAnchor.constraint(equalToConstant: 29),
            
            exerciseScoreLabel.centerYAnchor.constraint(equalTo: exercisesLabel.centerYAnchor),
            exerciseScoreLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        ])
    }
    
    func configureLabel(_ label: UILabel, _ text: String){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont(name: "AvenirNext-Regular", size: 19)
        label.textColor = Colors.black
    }
    
    func configureButton(_ button: UIButton, _ text: String){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        button.setButtonCornerRadius(8)
        button.backgroundColor = Colors.blue
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
        title = "Awards"
    }
}

extension AwardsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count = 0
        
        switch collectionView {
        case levelCV:
            count = levelData.count
        case wordsCV:
            count = wordsData.count
        case exercisesCV:
            count = exercisesData.count
        default: break
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
    
        switch collectionView {
        case levelCV:
            cell.awardLabel.text = "LEVEL"
        case wordsCV:
            cell.awardLabel.text = "WORDS"
        case exercisesCV:
            cell.awardLabel.text = "EXERCISES"
        default: break
        }
        return cell
    }
}

class CustomCell: UICollectionViewCell {
    
    let badgeCP = BadgeView(frame: CGRect(x: 10.0, y: 10.0, width: 60.0, height: 60.0))
    
    let badgeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.setViewCornerRadius(12)
        return view
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "9"
        label.font = UIFont(name: "AvenirNext-Medium", size: 29)
        label.textColor = UIColor(hex: "#b9b9b9") ?? .darkGray
        return label
    }()
    
    lazy var awardLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "LEVEL"
        label.font = UIFont(name: "AvenirNext-Medium", size: 9)
        label.textColor = .white
        return label
    }()
    
    lazy var bannerButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("", for: .normal)
        button.titleLabel?.font = UIFont(name: "AvenirNext-DemiBold", size: 15)
        button.backgroundColor = .clear
        button.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: UIColor(hex: "#b9b9b9") ?? .darkGray)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        badgeCP.trackColor = UIColor(hex: "#d9d9d9") ?? .darkGray
        badgeCP.progressColor = Colors.blue ?? .blue
        badgeCP.setProgressWithAnimation(duration: 1.0, value: 0.0)
        badgeCP.center = CGPoint(x: contentView.center.x+65, y: contentView.center.y+70)
        
        contentView.addSubview(badgeView)
        contentView.addSubview(badgeCP)
        contentView.addSubview(titleLabel)
        
        contentView.addSubview(bannerButton)
        contentView.addSubview(awardLabel)
        
        NSLayoutConstraint.activate([
            badgeView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            badgeView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            badgeView.heightAnchor.constraint(equalToConstant: 120),
            badgeView.widthAnchor.constraint(equalToConstant: 120),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: badgeCP.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: badgeCP.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            bannerButton.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            bannerButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 20),
        ])
        
        NSLayoutConstraint.activate([
            awardLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            awardLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 14.5),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Tab Bar

extension AwardsViewController {
    
    func configureTabBar() {
        //style
        tabBarStackView.translatesAutoresizingMaskIntoConstraints = false
        tabBarStackView.axis = .horizontal
        tabBarStackView.spacing = 0
        tabBarStackView.distribution = .fillEqually
        
        homeButton.configureForTabBar(image: Images.home, title: "Home", titleColor: .darkGray, imageWidth: 25, imageHeight: 25)
        dailyButton.configureForTabBar(image: Images.daily, title: "Daily", titleColor: .darkGray, imageWidth: 26, imageHeight: 26)
        awardButton.configureForTabBar(image: Images.award, title: "Awards", titleColor: Colors.blue ?? .blue, imageWidth: 27, imageHeight: 27)
        statisticButton.configureForTabBar(image: Images.statistic, title: "Statistics", titleColor: .darkGray, imageWidth: 25, imageHeight: 25)
        settingsButton.configureForTabBar(image: Images.settings, title: "Settings", titleColor: .darkGray, imageWidth: 25, imageHeight: 25)
        
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .primaryActionTriggered)
        dailyButton.addTarget(self, action: #selector(dailyButtonPressed), for: .primaryActionTriggered)
        statisticButton.addTarget(self, action: #selector(statisticButtonPressed), for: .primaryActionTriggered)
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
  
    @objc func statisticButtonPressed(gesture: UISwipeGestureRecognizer) {
        let vc = StatisticViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func settingsButtonPressed(gesture: UISwipeGestureRecognizer) {
        let vc = SettingsViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
