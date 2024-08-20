//
//  AwardsViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 29.10.2022.
//

import UIKit

private let reuseIdentifier = "AwardCell"

class AwardsController: UIViewController {
    
    private var wordBrain = WordBrain()
    private var itemArray: [Item] { return wordBrain.itemArray }
    private var exerciseArray: [Exercise] { return wordBrain.exerciseArray }
    
    private let levelTitleArray: [Int] = [10, 20, 30, 40, 50, 60, 70, 80, 90, 100]
    private let wordsTitleArray: [Int] = [500, 1000, 1500, 2000, 2500, 3000, 3500, 4000, 4500, 5000]
    private let exercisesTitleArray: [Int] = [1000, 2000, 3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000]
    
    private let levelLabel = makeAwardLabel(text: "LEVEL")
    private let wordsLabel = makeAwardLabel(text: "WORDS")
    private let exercisesLabel = makeAwardLabel(text: "EXERCISES")
    
    private lazy var levelInfoLabel = makePaddingLabel(text: "\(UserDefault.level.getInt())")
    private lazy var wordsInfoLabel = makePaddingLabel(text: "\(itemArray.count)")
    private lazy var exercisesInfoLabel = makePaddingLabel(text: "\(exerciseArray.count)")

    private let levelScoreLabel = makeAwardLabel(text: "0/10")
    private let wordsScoreLabel = makeAwardLabel(text: "0/10")
    private let exerciseScoreLabel = makeAwardLabel(text: "0/10")

    private lazy var levelCV: UICollectionView = {
        let cv = makeAwardCollectionView(withIdentifier: reuseIdentifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var wordsCV: UICollectionView = {
        let cv = makeAwardCollectionView(withIdentifier: reuseIdentifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    private lazy var exercisesCV: UICollectionView = {
        let cv = makeAwardCollectionView(withIdentifier: reuseIdentifier)
        cv.delegate = self
        cv.dataSource = self
        return cv
    }()
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBrain.loadItemArray()
        wordBrain.loadExerciseArray()
        configureUI()
        updateScoreLabels()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        title = "Awards"
        view.backgroundColor = Colors.cellLeft
        
        view.addSubview(levelLabel)
        view.addSubview(wordsLabel)
        view.addSubview(exercisesLabel)
        
        view.addSubview(levelCV)
        view.addSubview(wordsCV)
        view.addSubview(exercisesCV)
        
        view.addSubview(levelInfoLabel)
        view.addSubview(wordsInfoLabel)
        view.addSubview(exercisesInfoLabel)
        
        view.addSubview(levelScoreLabel)
        view.addSubview(wordsScoreLabel)
        view.addSubview(exerciseScoreLabel)
        
        //level
        levelCV.setHeight(140)
        levelCV.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, paddingTop: 32, paddingLeft: 32)
        
        
        levelLabel.anchor(left: view.leftAnchor, bottom: levelCV.topAnchor,
                          paddingLeft: 32, paddingBottom: 1)
        
        levelInfoLabel.setHeight(29)
        levelInfoLabel.centerY(inView: levelLabel)
        levelInfoLabel.anchor(left: levelLabel.rightAnchor, paddingLeft: 8)
        
        levelScoreLabel.centerY(inView: levelLabel)
        levelScoreLabel.anchor(right: view.rightAnchor, paddingRight: 16)
        
        
        //words
        wordsCV.setHeight(140)
        wordsCV.anchor(top: levelCV.bottomAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, paddingTop: 32, paddingLeft: 32)
        
        
        wordsLabel.anchor(left: view.leftAnchor, bottom: wordsCV.topAnchor,
                          paddingLeft: 32, paddingBottom: 1)
        
        wordsInfoLabel.setHeight(29)
        wordsInfoLabel.centerY(inView: wordsLabel)
        wordsInfoLabel.anchor(left: wordsLabel.rightAnchor, paddingLeft: 8)
        
        wordsScoreLabel.centerY(inView: wordsLabel)
        wordsScoreLabel.anchor(right: view.rightAnchor, paddingRight: 16)
        
        //exercises
        exercisesCV.setHeight(140)
        exercisesCV.anchor(top: wordsCV.bottomAnchor, left: view.leftAnchor,
                       right: view.rightAnchor, paddingTop: 32, paddingLeft: 32)
        
        
        exercisesLabel.anchor(left: view.leftAnchor, bottom: exercisesCV.topAnchor,
                          paddingLeft: 32, paddingBottom: 1)
        
        exercisesInfoLabel.setHeight(29)
        exercisesInfoLabel.centerY(inView: exercisesLabel)
        exercisesInfoLabel.anchor(left: exercisesLabel.rightAnchor, paddingLeft: 8)
        
        exerciseScoreLabel.centerY(inView: exercisesLabel)
        exerciseScoreLabel.anchor(right: view.rightAnchor, paddingRight: 16)
    }
    
    private func updateScoreLabels() {
        var levelScoreCount = 0
        var wordScoreCount = 0
        var exerciseScoreCount = 0
        
        for i in 0..<10 {
            if levelTitleArray[i] <= UserDefault.level.getInt() {
                levelScoreCount += 1
                levelScoreLabel.text = "\(levelScoreCount)/10"
            }
            
            if wordsTitleArray[i] <= itemArray.count {
                wordScoreCount += 1
                wordsScoreLabel.text = "\(wordScoreCount)/10"
            }
            
            if exercisesTitleArray[i] <= exerciseArray.count {
                exerciseScoreCount += 1
                exerciseScoreLabel.text = "\(exerciseScoreCount)/10"
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! AwardCell
        
        var titleText = ""
        var bannerText = ""
        var cpValue: Float = 0.0
        var color = UIColor.brown
        
        switch collectionView {
        case levelCV:
            let levelNumber = levelTitleArray[indexPath.row]
            let userLevel = UserDefault.level.getInt()
            let value = Float(levelNumber - userLevel) * 0.1
            
            bannerText = "LEVEL"
            titleText = "\(levelNumber)"
            cpValue = levelNumber <= userLevel ? 1.0 : levelNumber - userLevel < 10 ? 1-value : 0.0
            color = levelNumber <= userLevel ? Colors.blue : levelNumber - userLevel < 10 ? Colors.blue : Colors.b9b9b9
        case wordsCV:
            let wordsNumber = wordsTitleArray[indexPath.row]
            let userWordsCount = itemArray.count
            let value = Float(wordsNumber - userWordsCount) / 5 * 0.01
            
            bannerText = "WORDS"
            titleText = "\(wordsNumber)"
            cpValue = wordsNumber <= userWordsCount ? 1.0 : wordsNumber - userWordsCount < 500 ? 1-value : 0.0
            color = wordsNumber <= userWordsCount ? Colors.blue : wordsNumber - userWordsCount < 500 ? Colors.blue : Colors.b9b9b9
        case exercisesCV:
            let exerciseNumber = exercisesTitleArray[indexPath.row]
            let userExerciseCount = exerciseArray.count
            let value = Float(exerciseNumber - userExerciseCount) / 10 * 0.01
            
            bannerText = "EXERCISES"
            titleText = "\(exerciseNumber)"
            cpValue = exerciseNumber <= userExerciseCount ? 1.0 : exerciseNumber - userExerciseCount < 1000 ? 1-value : 0.0
            color = exerciseNumber <= userExerciseCount ? Colors.blue : exerciseNumber - userExerciseCount < 1000 ? Colors.blue : Colors.b9b9b9
        default: break
        }
        
        cell.configure(bannerText: bannerText, titleText: titleText, cpValue: cpValue, color: color)
        return cell
    }
}
