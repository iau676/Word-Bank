//
//  AwardsViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 29.10.2022.
//

import UIKit

class AwardsController: UIViewController {
    
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
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBrain.loadItemArray()
        wordBrain.loadExerciseArray()
        style()
        layout()
        updateScoreLabels()
    }
    
    //MARK: - Helpers
    
    private func configureLabel(_ label: UILabel, _ text: String){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = text
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 19)
        label.textColor = Colors.black
    }
    
    private func configureButton(_ button: UIButton, _ text: String){
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(text, for: .normal)
        button.titleLabel?.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 15)
        button.setButtonCornerRadius(8)
        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        button.backgroundColor = Colors.blue
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

extension AwardsController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
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
                cell.bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.blue)
                cell.titleLabel.textColor = Colors.blue
            } else if levelTitleArray[indexPath.row] - UserDefault.level.getInt() < 10 {
                let value = Float(levelTitleArray[indexPath.row] - UserDefault.level.getInt()) * 0.1
                cell.badgeCP.setProgressWithAnimation(duration: 1.0, value: 1-value)
                cell.bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.blue)
                cell.titleLabel.textColor = Colors.blue
            } else {
                cell.badgeCP.setProgressWithAnimation(duration: 1.0, value: 0.0)
                cell.bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.b9b9b9)
                cell.titleLabel.textColor = Colors.b9b9b9
            }
        case wordsCV:
            cell.titleLabel.text = "\(wordsTitleArray[indexPath.row])"
            cell.awardLabel.text = "WORDS"
            if wordsTitleArray[indexPath.row] <= itemArray.count {
                cell.badgeCP.setProgressWithAnimation(duration: 1.0, value: 1.0)
                cell.bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.blue)
                cell.titleLabel.textColor = Colors.blue
            } else if wordsTitleArray[indexPath.row] - itemArray.count < 500 {
                let value = Float(wordsTitleArray[indexPath.row] - itemArray.count) / 5 * 0.01
                cell.badgeCP.setProgressWithAnimation(duration: 1.0, value: 1-value)
                cell.bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.blue)
                cell.titleLabel.textColor = Colors.blue
            } else {
                cell.badgeCP.setProgressWithAnimation(duration: 1.0, value: 0.0)
                cell.bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.b9b9b9)
                cell.titleLabel.textColor = Colors.b9b9b9
            }
        case exercisesCV:
            cell.titleLabel.text = "\(exercisesTitleArray[indexPath.row])"
            cell.awardLabel.text = "EXERCISES"
            if exercisesTitleArray[indexPath.row] <= exerciseArray.count {
                cell.badgeCP.setProgressWithAnimation(duration: 1.0, value: 1.0)
                cell.bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.blue)
                cell.titleLabel.textColor = Colors.blue
            } else if exercisesTitleArray[indexPath.row] - exerciseArray.count < 1000 {
                let value = Float(exercisesTitleArray[indexPath.row] - exerciseArray.count) / 10 * 0.01
                cell.badgeCP.setProgressWithAnimation(duration: 1.0, value: 1-value)
                cell.bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.blue)
                cell.titleLabel.textColor = Colors.blue
            } else {
                cell.badgeCP.setProgressWithAnimation(duration: 1.0, value: 0.0)
                cell.bannerButton.setImageWithRenderingMode(image: Images.banner, width: 100, height: 70, color: Colors.b9b9b9)
                cell.titleLabel.textColor = Colors.b9b9b9
            }
        default: break
        }
        return cell
    }
}

//MARK: - Layout

extension AwardsController {
    private func style(){
        title = "Awards"
        view.backgroundColor = Colors.cellLeft
        
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
        
        //level
        levelCV.setHeight(140)
        levelCV.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, paddingTop: 32, paddingLeft: 32)
        
        
        levelLabel.anchor(left: view.leftAnchor, bottom: levelCV.topAnchor,
                          paddingLeft: 32, paddingBottom: 1)
        
        levelButton.setHeight(29)
        levelButton.centerY(inView: levelLabel)
        levelButton.anchor(left: levelLabel.rightAnchor, paddingLeft: 8)
        
        levelScoreLabel.centerY(inView: levelLabel)
        levelScoreLabel.anchor(right: view.rightAnchor, paddingRight: 16)
        
        
        //words
        wordsCV.setHeight(140)
        wordsCV.anchor(top: levelCV.bottomAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, paddingTop: 32, paddingLeft: 32)
        
        
        wordsLabel.anchor(left: view.leftAnchor, bottom: wordsCV.topAnchor,
                          paddingLeft: 32, paddingBottom: 1)
        
        wordsButton.setHeight(29)
        wordsButton.centerY(inView: wordsLabel)
        wordsButton.anchor(left: wordsLabel.rightAnchor, paddingLeft: 8)
        
        wordsScoreLabel.centerY(inView: wordsLabel)
        wordsScoreLabel.anchor(right: view.rightAnchor, paddingRight: 16)
        
        //exercises
        exercisesCV.setHeight(140)
        exercisesCV.anchor(top: wordsCV.bottomAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, paddingTop: 32, paddingLeft: 32)
        
        
        exercisesLabel.anchor(left: view.leftAnchor, bottom: exercisesCV.topAnchor,
                          paddingLeft: 32, paddingBottom: 1)
        
        exercisesButton.setHeight(29)
        exercisesButton.centerY(inView: exercisesLabel)
        exercisesButton.anchor(left: exercisesLabel.rightAnchor, paddingLeft: 8)
        
        exerciseScoreLabel.centerY(inView: exercisesLabel)
        exerciseScoreLabel.anchor(right: view.rightAnchor, paddingRight: 16)
    }
}
