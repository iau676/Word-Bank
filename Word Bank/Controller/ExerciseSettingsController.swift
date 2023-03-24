//
//  ExerciseSettingsViewController.swift
//  Word Bank
//
//  Created by ibrahim uysal on 9.12.2022.
//

import UIKit

class ExerciseSettingsController: UIViewController {
    
    private let testTypeView = UIView()
    private let testTypeStackView = UIStackView()
    private let testTypeLabel = UILabel()
    private let testTypeSegmentedControl = UISegmentedControl()
    
    private let pointView = UIView()
    private let pointLabel = UILabel()
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
    
    private let typingView = UIView()
    private let typingLabel = UILabel()
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
    
    private var wordBrain = WordBrain()
    private var textSize: CGFloat { return UserDefault.textSize.getCGFloat() }
    
    private let tabBar = TabBar(color5: Colors.blue ?? .systemBlue)
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        style()
        layout()
    }
    
    //MARK: - Helpers

    private func style(){
        title = "Exercise Settings"
        view.backgroundColor = Colors.cellLeft
        
        tabBar.delegate = self
        
        //Test Type
        testTypeView.setViewCornerRadius(8)
        testTypeView.backgroundColor = Colors.cellRight
        
        testTypeStackView.axis = .vertical
        testTypeStackView.spacing = 8
        testTypeStackView.distribution = .fill
        
        testTypeLabel.text = "Test Type"
        testTypeLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        testTypeLabel.textColor = Colors.black
        
        testTypeSegmentedControl.tintColor = .black
        testTypeSegmentedControl.replaceSegments(segments: ["English - Meaning", "Meaning - English"])
        testTypeSegmentedControl.setTitleTextAttributes([.foregroundColor: Colors.black ?? .black,
                                                         .font: UIFont.systemFont(ofSize: textSize-3),], for: .normal)
        testTypeSegmentedControl.selectedSegmentIndex = UserDefault.selectedTestType.getInt()
        testTypeSegmentedControl.addTarget(self, action: #selector(testTypeChanged(_:)),
                                           for: UIControl.Event.valueChanged)
        
        //Point Effect
        pointView.setViewCornerRadius(8)
        pointView.backgroundColor = Colors.cellRight
        
        pointLabel.text = "Point Effect"
        pointLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        
        pointCV.delegate = self
        pointCV.dataSource = self
        
        //Typing
        typingView.setViewCornerRadius(8)
        typingView.backgroundColor = Colors.cellRight
        
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
        
        testTypeView.setHeight(90)
        testTypeView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                            right: view.rightAnchor, paddingTop: 16,
                            paddingLeft: 32, paddingRight: 32)
        
        testTypeStackView.anchor(top: testTypeView.topAnchor, left: testTypeView.leftAnchor,
                                 bottom: testTypeView.bottomAnchor, right: testTypeView.rightAnchor,
                                 paddingTop: 16, paddingLeft: 16,
                                 paddingBottom: 16, paddingRight: 16)
        
        //Point Effect
        view.addSubview(pointView)
        pointView.addSubview(pointLabel)
        pointView.addSubview(pointCV)
        
        pointView.setHeight(160)
        pointView.anchor(top: testTypeView.bottomAnchor, left: testTypeView.leftAnchor,
                         right: testTypeView.rightAnchor, paddingTop: 16)
        
        pointLabel.anchor(top: pointView.topAnchor, left: pointView.leftAnchor,
                          paddingTop: 16, paddingLeft: 16)
        
        pointCV.anchor(top: pointLabel.bottomAnchor, left: pointView.leftAnchor,
                       bottom: pointView.bottomAnchor, right: pointView.rightAnchor,
                       paddingTop: 8, paddingLeft: 16,
                       paddingBottom: 16, paddingRight: 16)
        
        //Typing
        view.addSubview(typingView)
        typingView.addSubview(typingLabel)
        typingView.addSubview(typingCV)
        
        typingView.setHeight(160)
        typingView.anchor(top: pointView.bottomAnchor, left: testTypeView.leftAnchor,
                          right: testTypeView.rightAnchor, paddingTop: 16)
        
        typingLabel.anchor(top: typingView.topAnchor, left: typingView.leftAnchor,
                           paddingTop: 16, paddingLeft: 16)
        
        
        typingCV.anchor(top: typingLabel.bottomAnchor, left: typingView.leftAnchor,
                        bottom: typingView.bottomAnchor, right: typingView.rightAnchor,
                        paddingTop: 8, paddingLeft: 16,
                        paddingBottom: 16, paddingRight: 16)
        
        view.addSubview(tabBar)
        tabBar.setDimensions(width: view.bounds.width, height: 66)
        tabBar.anchor(bottom: view.bottomAnchor)
    }
    
    //MARK: - Selectors
    
    @objc private func testTypeChanged(_ sender: UISegmentedControl) {
        UserDefault.selectedTestType.set(sender.selectedSegmentIndex)
    }
}

//MARK: - UICollectionViewDataSource

extension ExerciseSettingsController: UICollectionViewDataSource {
    
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
            cell.imageView.layer.cornerRadius = 8
            cell.imageView.clipsToBounds = true
            cell.contentView.layer.borderColor = (indexPath.row == UserDefault.selectedTyping.getInt()) ? Colors.blue?.cgColor : Colors.d6d6d6?.cgColor
        default: break
        }
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout

extension ExerciseSettingsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 99, height: 99)
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

//MARK: - TabBarDelegate

extension ExerciseSettingsController: TabBarDelegate {
    
    func homePressed() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func dailyPressed() {
        navigationController?.pushViewController(DailyController(), animated: true)
    }
    
    func awardPressed() {
        navigationController?.pushViewController(AwardsController(), animated: true)
    }
    
    func statisticPressed() {
        navigationController?.pushViewController(StatsController(), animated: true)
    }
    
    func settingPressed() {
        navigationController?.pushViewController(SettingsController(), animated: true)
    }
}
