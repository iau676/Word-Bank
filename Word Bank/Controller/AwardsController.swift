//
//  AwardsViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 29.10.2022.
//

import UIKit

private let reuseIdentifier = "AwardCell"

class AwardsController: UIViewController {
    
    private var itemArray: [Item] { return brain.itemArray }
    private var exerciseArray: [Exercise] { return brain.exerciseArray }
    
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
        brain.loadItemArray()
        brain.loadExerciseArray()
        configureUI()
        updateScoreLabels()
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        title = "Awards"
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
        view.backgroundColor = Colors.cellLeft
        
        let cvStack = UIStackView(arrangedSubviews: [levelCV, wordsCV, exercisesCV])
        cvStack.axis = .vertical
        cvStack.spacing = 32
        cvStack.distribution = .fillEqually
        
        view.addSubview(cvStack)
        levelCV.setHeight(140)
        cvStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32)
        
        let levelStack = UIStackView(arrangedSubviews: [levelLabel, levelInfoLabel, levelScoreLabel])
        levelStack.axis = .horizontal
        levelStack.spacing = 8
        levelStack.distribution = .fill
        levelScoreLabel.textAlignment = .right
        
        view.addSubview(levelStack)
        levelStack.anchor(left: view.leftAnchor, bottom: levelCV.topAnchor, right: view.rightAnchor, paddingLeft: 32, paddingBottom: 2, paddingRight: 16)

        let wordsStack = UIStackView(arrangedSubviews: [wordsLabel, wordsInfoLabel, wordsScoreLabel])
        wordsStack.axis = .horizontal
        wordsStack.spacing = 8
        wordsStack.distribution = .fill
        wordsScoreLabel.textAlignment = .right
        
        view.addSubview(wordsStack)
        wordsStack.anchor(left: view.leftAnchor, bottom: wordsCV.topAnchor, right: view.rightAnchor, paddingLeft: 32, paddingBottom: 2, paddingRight: 16)
        
        let exercisesStack = UIStackView(arrangedSubviews: [exercisesLabel, exercisesInfoLabel, exerciseScoreLabel])
        exercisesStack.axis = .horizontal
        exercisesStack.spacing = 8
        exercisesStack.distribution = .fill
        exerciseScoreLabel.textAlignment = .right
        
        view.addSubview(exercisesStack)
        exercisesStack.anchor(left: view.leftAnchor, bottom: exercisesCV.topAnchor, right: view.rightAnchor, paddingLeft: 32, paddingBottom: 2, paddingRight: 16)
    }
    
    private func updateScoreLabels() {
        for i in 0..<10 {
            if levelTitleArray[i] <= UserDefault.level.getInt() {
                levelScoreLabel.text = "\(i+1)/10"
            }
            
            if wordsTitleArray[i] <= itemArray.count {
                wordsScoreLabel.text = "\(i+1)/10"
            }
            
            if exercisesTitleArray[i] <= exerciseArray.count {
                exerciseScoreLabel.text = "\(i+1)/10"
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
