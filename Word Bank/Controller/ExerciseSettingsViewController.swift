//
//  ExerciseSettingsViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 9.12.2022.
//

import UIKit

class ExerciseSettingsViewController: UIViewController {
    
    let testTypeView = UIView()
    let testTypeStackView = UIStackView()
    let testTypeLabel = UILabel()
    let testTypeSegmentedControl = UISegmentedControl()
    
    let pointView = UIView()
    let pointLabel = UILabel()
    fileprivate let pointCV:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = Colors.cellRight
        cv.register(ExerciseSettingsCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    let typingView = UIView()
    let typingLabel = UILabel()
    fileprivate let typingCV:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = Colors.cellRight
        cv.register(ExerciseSettingsCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    var wordBrain = WordBrain()
    var textSize: CGFloat { return UserDefault.textSize.getCGFloat() }
    
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
        title = "Exercise Settings"
        configureTabBar()
        style()
        layout()
    }
    
    //MARK: - Helpers
    
    private func setColors(){
        view.backgroundColor = Colors.cellLeft
        testTypeView.backgroundColor = Colors.cellRight
        testTypeLabel.textColor = Colors.black
        testTypeSegmentedControl.tintColor = .black
        pointView.backgroundColor = Colors.cellRight
        typingView.backgroundColor = Colors.cellRight
    }
    
    //MARK: - Layout
    
    private func style(){
        setColors()
        
        //Test Type
        testTypeView.translatesAutoresizingMaskIntoConstraints = false
        testTypeView.setViewCornerRadius(8)
        
        testTypeStackView.translatesAutoresizingMaskIntoConstraints = false
        testTypeStackView.axis = .vertical
        testTypeStackView.spacing = 8
        testTypeStackView.distribution = .fill
        
        testTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        testTypeLabel.text = "Test Type"
        testTypeLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        
        testTypeSegmentedControl.translatesAutoresizingMaskIntoConstraints = false
        testTypeSegmentedControl.replaceSegments(segments: ["English - Meaning", "Meaning - English"])
        testTypeSegmentedControl.setTitleTextAttributes([.foregroundColor: Colors.black ?? .black, .font: UIFont.systemFont(ofSize: textSize-3),], for: .normal)
        testTypeSegmentedControl.selectedSegmentIndex = UserDefault.selectedTestType.getInt()
        testTypeSegmentedControl.addTarget(self, action: #selector(testTypeChanged(_:)), for: UIControl.Event.valueChanged)
        
        //Point Effect
        pointView.translatesAutoresizingMaskIntoConstraints = false
        pointView.setViewCornerRadius(8)
        
        pointLabel.translatesAutoresizingMaskIntoConstraints = false
        pointLabel.text = "Point Effect"
        pointLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        
        pointCV.delegate = self
        pointCV.dataSource = self
        
        //Typing
        typingView.translatesAutoresizingMaskIntoConstraints = false
        typingView.setViewCornerRadius(8)
        
        typingLabel.translatesAutoresizingMaskIntoConstraints = false
        typingLabel.text = "Typing"
        typingLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        
        typingCV.delegate = self
        typingCV.dataSource = self
    }
    
    private func layout(){
        
        //Test Type
        view.addSubview(testTypeView)
        testTypeView.addSubview(testTypeStackView)
        testTypeStackView.addArrangedSubview(testTypeLabel)
        testTypeStackView.addArrangedSubview(testTypeSegmentedControl)
        
        NSLayoutConstraint.activate([
            testTypeView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            testTypeView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            testTypeView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),
            
            testTypeStackView.topAnchor.constraint(equalTo: testTypeView.topAnchor, constant: 16),
            testTypeStackView.leadingAnchor.constraint(equalTo: testTypeView.leadingAnchor, constant: 16),
            testTypeStackView.trailingAnchor.constraint(equalTo: testTypeView.trailingAnchor, constant: -16),
            testTypeStackView.bottomAnchor.constraint(equalTo: testTypeView.bottomAnchor, constant: -16),
        ])
        
        //Point Effect
        view.addSubview(pointView)
        pointView.addSubview(pointLabel)
        pointView.addSubview(pointCV)
        
        NSLayoutConstraint.activate([
            pointView.topAnchor.constraint(equalTo: testTypeView.bottomAnchor, constant: 16),
            pointView.leadingAnchor.constraint(equalTo: testTypeView.leadingAnchor),
            pointView.trailingAnchor.constraint(equalTo: testTypeView.trailingAnchor),
            
            pointLabel.topAnchor.constraint(equalTo: pointView.topAnchor, constant: 16),
            pointLabel.leadingAnchor.constraint(equalTo: pointView.leadingAnchor, constant: 16),
            
            pointCV.topAnchor.constraint(equalTo: pointLabel.bottomAnchor, constant: 16),
            pointCV.leadingAnchor.constraint(equalTo: pointView.leadingAnchor, constant: 16),
            pointCV.trailingAnchor.constraint(equalTo: pointView.trailingAnchor, constant: -16),
            pointCV.bottomAnchor.constraint(equalTo: pointView.bottomAnchor, constant: -16),
        ])
        
        //Typing
        view.addSubview(typingView)
        typingView.addSubview(typingLabel)
        typingView.addSubview(typingCV)
        
        NSLayoutConstraint.activate([
            typingView.topAnchor.constraint(equalTo: pointView.bottomAnchor, constant: 16),
            typingView.leadingAnchor.constraint(equalTo: testTypeView.leadingAnchor),
            typingView.trailingAnchor.constraint(equalTo: testTypeView.trailingAnchor),
            
            typingLabel.topAnchor.constraint(equalTo: typingView.topAnchor, constant: 16),
            typingLabel.leadingAnchor.constraint(equalTo: typingView.leadingAnchor, constant: 16),
            
            typingCV.topAnchor.constraint(equalTo: typingLabel.bottomAnchor, constant: 16),
            typingCV.leadingAnchor.constraint(equalTo: typingView.leadingAnchor, constant: 16),
            typingCV.trailingAnchor.constraint(equalTo: typingView.trailingAnchor, constant: -16),
            typingCV.bottomAnchor.constraint(equalTo: typingView.bottomAnchor, constant: -16),
        ])
        
        NSLayoutConstraint.activate([
            testTypeView.heightAnchor.constraint(equalToConstant: 90),
            pointView.heightAnchor.constraint(equalToConstant: 169),
            typingView.heightAnchor.constraint(equalToConstant: 169),
        ])
    }
    
    //MARK: - Selectors
    
    @objc func testTypeChanged(_ sender: UISegmentedControl) {
        UserDefault.selectedTestType.set(sender.selectedSegmentIndex)
    }
}

//MARK: - Collection View

extension ExerciseSettingsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 99, height: 99)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! ExerciseSettingsCell
        switch collectionView {
        case pointCV:
            cell.imageView.image = (indexPath.row == 0) ? Images.greenBubble : Images.greenCircle
            cell.contentView.layer.borderColor = (indexPath.row == UserDefault.selectedPointEffect.getInt()) ? Colors.blue?.cgColor : Colors.d6d6d6?.cgColor
        case typingCV:
            cell.imageView.image = (indexPath.row == 0) ? Images.customKeyboard : Images.defaultKeyboard
            cell.contentView.layer.borderColor = (indexPath.row == UserDefault.selectedTyping.getInt()) ? Colors.blue?.cgColor : Colors.d6d6d6?.cgColor
        default: break
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch collectionView {
        case pointCV:
            UserDefault.selectedPointEffect.set(indexPath.row)
        case typingCV:
            UserDefault.selectedTyping.set(indexPath.row)
        default: break
        }
        collectionView.reloadData()
    }
}

//MARK: - ExerciseSettingsCell

class ExerciseSettingsCell: UICollectionViewCell {
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 19)
        label.textColor = Colors.black ?? .darkGray
        return label
    }()
    
    lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.setViewCornerRadius(8)
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        contentView.backgroundColor = .clear
        contentView.layer.borderWidth = 2
        contentView.setViewCornerRadius(8)
        
        contentView.addSubview(imageView)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Tab Bar

extension ExerciseSettingsViewController {
    
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
        statisticButton.configureForTabBar(image: Images.statistic, title: "Statistics", titleColor: .darkGray, imageWidth: 25, imageHeight: 25)
        settingsButton.configureForTabBar(image: Images.settings, title: "Settings", titleColor: Colors.blue ?? .blue, imageWidth: 25, imageHeight: 25)
        
        homeButton.addTarget(self, action: #selector(homeButtonPressed), for: .primaryActionTriggered)
        dailyButton.addTarget(self, action: #selector(dailyButtonPressed), for: .primaryActionTriggered)
        awardButton.addTarget(self, action: #selector(awardButtonPressed), for: .primaryActionTriggered)
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
        pushVC(vc: UIViewController(), button: homeButton)
    }
    
    @objc func dailyButtonPressed(gesture: UISwipeGestureRecognizer) {
        pushVC(vc: DailyViewController(), button: dailyButton)
    }
    
    @objc func awardButtonPressed(gesture: UISwipeGestureRecognizer) {
        pushVC(vc: AwardsViewController(), button: awardButton)
    }
    
    @objc func statisticButtonPressed(gesture: UISwipeGestureRecognizer) {
        pushVC(vc: StatisticViewController(), button: statisticButton)
    }
    
    @objc func settingsButtonPressed(gesture: UISwipeGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func pushVC(vc: UIViewController, button: UIButton){
        timerDaily.invalidate()
        self.fireworkController.addFireworks(count: 5, sparks: 5, around: button)
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.15){
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
