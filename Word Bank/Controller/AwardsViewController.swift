//
//  AwardsViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 29.10.2022.
//

import UIKit

class AwardsViewController: UIViewController {
    
    private let levelLabel = UILabel()
    private let wordsLabel = UILabel()
    private let exercisesLabel = UILabel()
    
    private let levelButton = UIButton()
    private let wordsButton = UIButton()
    private let exercisesButton = UIButton()

    private let levelScoreLabel = UILabel()
    private let wordsScoreLabel = UILabel()
    private let exerciseScoreLabel = UILabel()
    
    private var wordBrain = WordBrain()
    private var itemArray: [Item] { return wordBrain.itemArray }
    private var exerciseArray: [Exercise] { return wordBrain.exerciseArray }
    
    private let levelTitleArray: [Int] = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    private let wordsTitleArray: [Int] = [500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000]
    private let exercisesTitleArray: [Int] = [1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000]
    
    private var levelBadgeCount = 0
    private var wordBadgeCount = 0
    private var exerciseBadgeCount = 0

    fileprivate let levelCV:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = Colors.cellLeft
        cv.register(AwardCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    fileprivate let wordsCV:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = Colors.cellLeft
        cv.register(AwardCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    fileprivate let exercisesCV:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.backgroundColor = Colors.cellLeft
        cv.register(AwardCell.self, forCellWithReuseIdentifier: "cell")
        cv.showsHorizontalScrollIndicator = false
        return cv
    }()
    
    private let tabBar = TabBar(color3: Colors.blue ?? .systemBlue)
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBrain.loadItemArray()
        wordBrain.loadExerciseArray()
        configureNavigationBar()
        style()
        layout()
        updateScoreLabels()
    }
    
    //MARK: - Helpers
    
    func configureLabel(_ label: UILabel, _ text: String){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 19)
        label.textColor = Colors.black
    }
    
    func configureButton(_ button: UIButton, _ text: String){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 15)
        button.setButtonCornerRadius(8)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
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
    
    private func updateScoreLabels(){
        for i in 0..<10 {
            if levelTitleArray[i] <= UserDefault.level.getInt() {
                levelBadgeCount += 1
                levelScoreLabel.text = "\(levelBadgeCount)/10"
            }
            
            if wordsTitleArray[i] <= itemArray.count {
                wordBadgeCount += 1
                wordsScoreLabel.text = "\(wordBadgeCount)/10"
            }
            
            if exercisesTitleArray[i] <= exerciseArray.count {
                exerciseBadgeCount += 1
                exerciseScoreLabel.text = "\(exerciseBadgeCount)/10"
            }
        }
    }
}

//MARK: - Collection View

extension AwardsViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 130, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! AwardCell
        
        switch collectionView {
        case levelCV:
            cell.titleLabel.text = "\(levelTitleArray[indexPath.row])"
            cell.awardLabel.text = "LEVEL"
            if levelTitleArray[indexPath.row] <= UserDefault.level.getInt() {
                cell.badgeCP.setProgressWithAnimation(duration: 1.0, value: 1.0)
                cell.bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.blue ?? .blue)
                cell.titleLabel.textColor = Colors.blue ?? .blue
            } else if levelTitleArray[indexPath.row] - UserDefault.level.getInt() < 10 {
                let value = Float(levelTitleArray[indexPath.row] - UserDefault.level.getInt()) * 0.1
                cell.badgeCP.setProgressWithAnimation(duration: 1.0, value: 1-value)
                cell.bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.blue ?? .blue)
                cell.titleLabel.textColor = Colors.blue ?? .blue
            } else {
                cell.badgeCP.setProgressWithAnimation(duration: 1.0, value: 0.0)
                cell.bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.b9b9b9 ?? .darkGray)
                cell.titleLabel.textColor = Colors.b9b9b9
            }
        case wordsCV:
            cell.titleLabel.text = "\(wordsTitleArray[indexPath.row])"
            cell.awardLabel.text = "WORDS"
            if wordsTitleArray[indexPath.row] <= itemArray.count {
                cell.badgeCP.setProgressWithAnimation(duration: 1.0, value: 1.0)
                cell.bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.blue ?? .blue)
                cell.titleLabel.textColor = Colors.blue ?? .blue
            } else if wordsTitleArray[indexPath.row] - itemArray.count < 500 {
                let value = Float(wordsTitleArray[indexPath.row] - itemArray.count) / 5 * 0.01
                cell.badgeCP.setProgressWithAnimation(duration: 1.0, value: 1-value)
                cell.bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.blue ?? .blue)
                cell.titleLabel.textColor = Colors.blue ?? .blue
            } else {
                cell.badgeCP.setProgressWithAnimation(duration: 1.0, value: 0.0)
                cell.bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.b9b9b9 ?? .darkGray)
                cell.titleLabel.textColor = Colors.b9b9b9
            }
        case exercisesCV:
            cell.titleLabel.text = "\(exercisesTitleArray[indexPath.row])"
            cell.awardLabel.text = "EXERCISES"
            if exercisesTitleArray[indexPath.row] <= exerciseArray.count {
                cell.badgeCP.setProgressWithAnimation(duration: 1.0, value: 1.0)
                cell.bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.blue ?? .blue)
                cell.titleLabel.textColor = Colors.blue ?? .blue
            } else if exercisesTitleArray[indexPath.row] - exerciseArray.count < 1000 {
                let value = Float(exercisesTitleArray[indexPath.row] - exerciseArray.count) / 10 * 0.01
                cell.badgeCP.setProgressWithAnimation(duration: 1.0, value: 1-value)
                cell.bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.blue ?? .blue)
                cell.titleLabel.textColor = Colors.blue ?? .blue
            } else {
                cell.badgeCP.setProgressWithAnimation(duration: 1.0, value: 0.0)
                cell.bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.b9b9b9 ?? .darkGray)
                cell.titleLabel.textColor = Colors.b9b9b9
            }
        default: break
        }
        return cell
    }
}

//MARK: - Layout

extension AwardsViewController {
    private func style(){
        view.backgroundColor = Colors.cellLeft
        
        tabBar.delegate = self
        
        configureLabel(levelLabel, "LEVEL")
        configureLabel(wordsLabel, "WORDS")
        configureLabel(exercisesLabel, "EXERCISES")
        
        configureButton(levelButton, "\(UserDefault.level.getInt())")
        configureButton(wordsButton, "\(itemArray.count)")
        configureButton(exercisesButton, "\(exerciseArray.count)")
        
        configureLabel(levelScoreLabel, "0/10")
        configureLabel(wordsScoreLabel, "0/10")
        configureLabel(exerciseScoreLabel, "0/10")
      
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
            levelCV.topAnchor.constraint(equalTo: view.topAnchor, constant: wordBrain.getTopBarHeight() + 32),
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
        
        view.addSubview(tabBar)
        tabBar.setDimensions(height: 66, width: view.bounds.width)
        tabBar.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor)
    }
}

//MARK: - TabBarDelegate

extension AwardsViewController: TabBarDelegate {
    
    func homePressed() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func dailyPressed() {
        pushVC(vc: DailyViewController())
    }
    
    func awardPressed() {
        //pushVC(vc: AwardsViewController())
    }
    
    func statisticPressed() {
        pushVC(vc: StatisticViewController())
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
