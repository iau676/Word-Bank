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
    
    private let tabBar = TabBar(color5: Colors.blue ?? .systemBlue)
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
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
        title = "Exercise Settings"
        
        setColors()
        tabBar.delegate = self
        
        //Test Type
        testTypeView.setViewCornerRadius(8)
        
        testTypeStackView.axis = .vertical
        testTypeStackView.spacing = 8
        testTypeStackView.distribution = .fill
        
        testTypeLabel.text = "Test Type"
        testTypeLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        
        testTypeSegmentedControl.replaceSegments(segments: ["English - Meaning", "Meaning - English"])
        testTypeSegmentedControl.setTitleTextAttributes([.foregroundColor: Colors.black ?? .black,
                                                         .font: UIFont.systemFont(ofSize: textSize-3),], for: .normal)
        testTypeSegmentedControl.selectedSegmentIndex = UserDefault.selectedTestType.getInt()
        testTypeSegmentedControl.addTarget(self, action: #selector(testTypeChanged(_:)),
                                           for: UIControl.Event.valueChanged)
        
        //Point Effect
        pointView.setViewCornerRadius(8)
        
        pointLabel.text = "Point Effect"
        pointLabel.font = UIFont(name: Fonts.AvenirNextRegular, size: textSize)
        
        pointCV.delegate = self
        pointCV.dataSource = self
        
        //Typing
        typingView.setViewCornerRadius(8)
        
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
            cell.imageView.layer.cornerRadius = 8
            cell.imageView.clipsToBounds = true
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
    
    lazy var imageView: UIImageView = {
        var imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
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

//MARK: - TabBarDelegate

extension ExerciseSettingsViewController: TabBarDelegate {
    
    func homePressed() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    func dailyPressed() {
        navigationController?.pushViewController(DailyViewController(), animated: true)
    }
    
    func awardPressed() {
        navigationController?.pushViewController(AwardsViewController(), animated: true)
    }
    
    func statisticPressed() {
        navigationController?.pushViewController(StatisticViewController(), animated: true)
    }
    
    func settingPressed() {
        navigationController?.pushViewController(SettingsViewController(), animated: true)
    }
}
