//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import CoreData

class WordsController: UIViewController {
    
    //MARK: - Properties
    
    private let exerciseType: String
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    private let tableViewStackView = UIStackView()
    
    private let testExerciseButton = UIButton()
    private let writingExerciseButton = UIButton()
    private let listeningExerciseButton = UIButton()
    private let cardExerciseButton = UIButton()
    private let buttonStackView = UIStackView()
    
    private let testExerciseLabel = UILabel()
    private let writingExerciseLabel = UILabel()
    private let listeningExerciseLabel = UILabel()
    private let cardExerciseLabel = UILabel()
    
    var goAddPage = 0
    private var goEdit = 0
    private var editIndex = 0
    
    private var wordBrain = WordBrain()
    private var itemArray: [Item] { return wordBrain.itemArray }
    private var hardItemArray: [HardItem] { return wordBrain.hardItemArray }
    private var textSize: CGFloat { return UserDefault.textSize.getCGFloat() }
    
    //MARK: - Life Cycle
    
    init(exerciseType: String) {
        self.exerciseType = exerciseType
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBrain.loadItemArray()
        wordBrain.loadHardItemArray()
        
        style()
        layout()
        
        configureButton()
        setupNavigationBar()
        setupSearchBar()
        setupView()
        addGestureRecognizer()
        hideKeyboardWhenTappedAround()
        updateSearchBarPlaceholder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupButtons()
        checkGoAddPage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        goAddPage = 0
    }
    
    //MARK: - Selectors
    
    @objc private func addBarButtonPressed(_ sender: UIBarButtonItem) {
        goAddPage = 1
        checkGoAddPage()
    }
    
    @objc private func testExerciseButtonPressed(_ sender: Any) {
        testExerciseButton.bounce()
        testExerciseButton.updateShadowHeight(withDuration: 0.15, height: 0.3)
        let controller = TestController(exerciseType: exerciseType,
                                        exerciseFormat: ExerciseFormat.test)
        checkWordCount(controller: controller)
    }
    
    @objc private func writingExerciseButtonPressed(_ sender: UIButton) {
        writingExerciseButton.bounce()
        writingExerciseButton.updateShadowHeight(withDuration: 0.15, height: 0.3)
        let controller = WritingController(exerciseType: exerciseType,
                                           exerciseFormat: ExerciseFormat.writing)
        checkWordCount(controller: controller)
    }
    
    @objc private func listeningExerciseButtonPressed(_ sender: UIButton) {
        listeningExerciseButton.bounce()
        listeningExerciseButton.updateShadowHeight(withDuration: 0.15, height: 0.3)
        let controller = ListeningController(exerciseType: exerciseType,
                                            exerciseFormat: ExerciseFormat.listening)
        checkWordCount(controller: controller)
    }
    
    @objc private func cardExerciseButtonPressed(_ sender: UIButton) {
        cardExerciseButton.bounce()
        cardExerciseButton.updateShadowHeight(withDuration: 0.15, height: 0.3)
        let controller = CardController(exerciseType: exerciseType,
                                        exerciseFormat: ExerciseFormat.card)
        checkWordCount(controller: controller)
    }

    //MARK: - Helpers
    
    private func setupView(){
        updateView()
        setupBackgroundColor()
        setupCornerRadius()
    }
    
    private func updateView(){
        if exerciseType == ExerciseType.normal {
            searchBar.updateSearchBarVisibility(false)
            tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            searchBar.updateSearchBarVisibility(true)
            tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            cardExerciseButton.isHidden = true
            cardExerciseLabel.isHidden = true
            navigationItem.rightBarButtonItem = nil
        }
        tableView.reloadData()
    }
    
    private func configureButton(){
        testExerciseButton.changeBackgroundColor(to: Colors.raven)
        writingExerciseButton.changeBackgroundColor(to: Colors.raven)
        listeningExerciseButton.changeBackgroundColor(to: Colors.raven)
        cardExerciseButton.changeBackgroundColor(to: Colors.raven)
    }
   
    private func setupSearchBar() {
        searchBar.delegate = self
        searchBar.isHidden = true
        
        // SearchBar text
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor.black
        textFieldInsideUISearchBar?.font = textFieldInsideUISearchBar?.font?.withSize(textSize)

        // SearchBar placeholder
        let labelInsideUISearchBar = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
        labelInsideUISearchBar?.textColor = UIColor.darkGray
        
        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = 10
        searchBar.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        
        switch UserDefault.userInterfaceStyle {
        case "dark":
            searchBar.keyboardAppearance = .dark
            break
        default:
            searchBar.keyboardAppearance = .default
        }
    }
    
    private func setupCornerRadius() {
        testExerciseButton.setButtonCornerRadius(10)
        writingExerciseButton.setButtonCornerRadius(10)
        listeningExerciseButton.setButtonCornerRadius(10)
        cardExerciseButton.setButtonCornerRadius(10)
        tableView.setViewCornerRadius(10)
    }
    
    private func configureLabel(_ label: UILabel, _ text: String){
        label.textColor = Colors.black
        label.text = text
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 13)
        label.numberOfLines = 1
    }
    
    private func setupBackgroundColor(){
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        if exerciseType == ExerciseType.normal {
            gradient.colors = [Colors.blue.cgColor, Colors.blueLight.cgColor]
        } else {
            gradient.colors = [Colors.yellow.cgColor, Colors.yellowLight.cgColor]
        }
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    private func setupNavigationBar(){
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
        
        if exerciseType == ExerciseType.normal {
            title = "Words"
        } else {
            title = "Hard Words"
        }
    }
    
    private func setupButtons(){
        setupButtonImage(testExerciseButton, image: Images.testExercise, width: 30, height: 15)
        setupButtonImage(writingExerciseButton, image: Images.writingExercise, width: 30, height: 15)
        setupButtonImage(listeningExerciseButton, image: Images.listeningExercise, width: 30, height: 15)
        setupButtonImage(cardExerciseButton, image: Images.cardExercise, width: 30, height: 15)
        
        setupButtonShadow(testExerciseButton)
        setupButtonShadow(writingExerciseButton)
        setupButtonShadow(listeningExerciseButton)
        setupButtonShadow(cardExerciseButton)
    }
    
    private func setupButtonImage(_ button: UIButton, image: UIImage?, width: CGFloat, height: CGFloat){
        button.setImage(image: image, width: width+textSize, height: height+textSize)
    }
    
    private  func setupButtonShadow(_ button: UIButton) {
        button.layer.shadowColor = Colors.ravenShadow.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
    }

    private func checkGoAddPage(){
        if goAddPage == 1 && exerciseType == ExerciseType.normal{
            goAddEdit()
        }
    }
    
    private func goAddEdit() {
        let controller = AddEditController()
        controller.modalPresentationStyle = .overCurrentContext
        controller.delegate = self
        self.present(controller, animated: true)
    }
    
    private func checkWordCount(controller: UIViewController){
        let wordCount = (exerciseType == ExerciseType.normal) ? itemArray.count : hardItemArray.count
        
        if wordCount < 2 {
            showAlert(title: "Minimum two words required", message: "") { _ in
                if self.exerciseType == ExerciseType.normal {
                    self.goAddEdit()
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        } else {
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
}

    //MARK: - Search Bar

extension WordsController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        if text.count > 0 {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            let firstPredicate = NSPredicate(format: "eng CONTAINS[cd] %@", text)
            let secondPredicate = NSPredicate(format: "tr CONTAINS[cd] %@", text)
            request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [firstPredicate,
                                                                                    secondPredicate])
            request.sortDescriptors = [NSSortDescriptor(key: "eng", ascending: true)]
            wordBrain.loadItemArray(with: request)
        } else {
            wordBrain.loadItemArray()
        }
        tableView.reloadData()
    }
    
    private func updateSearchBarPlaceholder(){
        if itemArray.count > 0 {
            searchBar.placeholder = "Search in \(itemArray.count) words"
        } else {
            searchBar.placeholder = "Nothing to see here"
        }
    }
}

    //MARK: - UITableViewDataSource

extension WordsController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateSearchBarPlaceholder()
        if exerciseType == ExerciseType.normal {
            return itemArray.count
        } else {
            showAlertIfHardWordsEmpty()
            return hardItemArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! WordCell
        
        cell.engView.backgroundColor = Colors.cellLeft
        cell.trView.backgroundColor = Colors.cellRight
        
        cell.engView.isHidden = false
        cell.trView.isHidden = false
        
        if itemArray.count > 0 {
            if exerciseType == ExerciseType.normal {
                cell.engLabel.text = itemArray[indexPath.row].eng
                cell.trLabel.text = itemArray[indexPath.row].tr
            } else {
                cell.engLabel.text = hardItemArray[indexPath.row].eng
                cell.trLabel.text = hardItemArray[indexPath.row].tr
            }
            
        } else {
            cell.trView.isHidden = true
            cell.engLabel.text = ""
            tableView.separatorStyle = .none
        }

        cell.updateLabelTextSize(cell.engLabel, textSize)
        cell.updateLabelTextSize(cell.trLabel, textSize)
        return cell
    }
    
    private func showAlertIfHardWordsEmpty(){
        if hardItemArray.count <= 0 {
            showAlert(title: "Nothing to see here yet",
                      message: "When you answer a word incorrectly in the exercises, that word is added to this page. In order to delete that word from here, you should answer correctly 5 times.") { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

    //MARK: - UITableViewDelegate

extension WordsController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let item = self.itemArray[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let alert = UIAlertController(title: "'\(item.eng ?? "Word")' will be deleted",
                                          message: "This action cannot be undone", preferredStyle: .alert)
            let actionDelete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                
                self.wordBrain.deleteHardWord(item)
                self.wordBrain.removeWord(at: indexPath.row)

                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
                tableView.reloadData()
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(actionDelete)
            alert.addAction(actionCancel)
            self.present(alert, animated: true, completion: nil)
            success(true)
        })
        deleteAction.setImage(image: Images.bin, width: 25, height: 25)
        deleteAction.setBackgroundColor(UIColor.systemRed)
        
        let editAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.goEdit = 1
            self.editIndex = indexPath.row
            let controller = AddEditController()
            controller.goEdit = 1
            controller.item = item
            controller.modalPresentationStyle = .overCurrentContext
            controller.delegate = self
            self.present(controller, animated: true)
            success(true)
        })
        editAction.setImage(image: Images.edit, width: 25, height: 25)
        editAction.setBackgroundColor(Colors.lightBlue)
        
        let addAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if self.itemArray[indexPath.row].addedHardWords == false {
                self.wordBrain.addWordToHardWords(indexPath.row)
                
                let alert = UIAlertController(title: "Added to Hard Words", message: "", preferredStyle: .alert)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when){
                  alert.dismiss(animated: true, completion: nil)
                }
                self.present(alert, animated: true, completion: nil)
            }
            success(true)
        })
        addAction.setImage(image: Images.plus, width: 25, height: 25)
        addAction.setBackgroundColor(Colors.yellow)
        
        if exerciseType == ExerciseType.normal {
            if self.itemArray[indexPath.row].addedHardWords == true {
                return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            }
            return UISwipeActionsConfiguration(actions: [deleteAction, editAction, addAction])
        } else {
            return UISwipeActionsConfiguration()
        }
    }
}

extension WordsController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//MARK: - Layout

extension WordsController {
    private func style(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                            style: .plain, target: self,
                                                            action: #selector(addBarButtonPressed))
        
        tableViewStackView.axis = .vertical
        tableViewStackView.spacing = 0
        tableViewStackView.distribution = .fill
        
        searchBar.barTintColor = Colors.cellLeft
        
        tableView.register(UINib(nibName: "WordCell", bundle: nil), forCellReuseIdentifier:"ReusableCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = true
        tableView.backgroundColor = Colors.cellLeft
        
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 16
        buttonStackView.distribution = .fillEqually
        
        testExerciseButton.addTarget(self, action: #selector(testExerciseButtonPressed),
                                     for: .primaryActionTriggered)
        
        writingExerciseButton.addTarget(self, action: #selector(writingExerciseButtonPressed),
                                        for: .primaryActionTriggered)
        
        listeningExerciseButton.addTarget(self, action: #selector(listeningExerciseButtonPressed),
                                          for: .primaryActionTriggered)
        
        cardExerciseButton.addTarget(self, action: #selector(cardExerciseButtonPressed),
                                     for: .primaryActionTriggered)
        
        configureLabel(testExerciseLabel, "Test")
        configureLabel(writingExerciseLabel, "Writing")
        configureLabel(listeningExerciseLabel, "Listening")
        configureLabel(cardExerciseLabel, "Card")
    }
    
    private func layout(){
        tableViewStackView.addArrangedSubview(searchBar)
        tableViewStackView.addArrangedSubview(tableView)
        
        buttonStackView.addArrangedSubview(testExerciseButton)
        buttonStackView.addArrangedSubview(writingExerciseButton)
        buttonStackView.addArrangedSubview(listeningExerciseButton)
        buttonStackView.addArrangedSubview(cardExerciseButton)
        
        view.addSubview(testExerciseLabel)
        view.addSubview(writingExerciseLabel)
        view.addSubview(listeningExerciseLabel)
        view.addSubview(cardExerciseLabel)
        
        view.addSubview(tableViewStackView)
        view.addSubview(buttonStackView)
        
        tableViewStackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                                  bottom: buttonStackView.topAnchor, right: view.rightAnchor,
                                  paddingTop: 8, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
        buttonStackView.setHeight(55)
        buttonStackView.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor,
                               right: view.rightAnchor, paddingLeft: 16,
                               paddingBottom: 40, paddingRight: 16)
        
        testExerciseLabel.centerX(inView: testExerciseButton)
        testExerciseLabel.anchor(top: testExerciseButton.bottomAnchor, paddingTop: 8)
        
        writingExerciseLabel.centerX(inView: writingExerciseButton)
        writingExerciseLabel.anchor(top: writingExerciseButton.bottomAnchor, paddingTop: 8)
        
        listeningExerciseLabel.centerX(inView: listeningExerciseButton)
        listeningExerciseLabel.anchor(top: listeningExerciseButton.bottomAnchor, paddingTop: 8)
        
        cardExerciseLabel.centerX(inView: cardExerciseButton)
        cardExerciseLabel.anchor(top: cardExerciseButton.bottomAnchor, paddingTop: 8)
    }
}

//MARK: - Swipe Gesture

extension WordsController {
    private func addGestureRecognizer(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeLeftGesture))
        swipeLeft.direction = .left
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRightGesture))
        swipeRight.direction = .right
        
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc private func respondToSwipeLeftGesture(gesture: UISwipeGestureRecognizer) {
        if exerciseType == ExerciseType.normal { goAddEdit() }
    }
    
    @objc private func respondToSwipeRightGesture(gesture: UISwipeGestureRecognizer) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - AddEditControllerDelegate

extension WordsController: AddEditControllerDelegate {
    func updateTableView() {
        wordBrain.saveContext()
        wordBrain.loadItemArray()
        updateSearchBarPlaceholder()
        tableView.reloadData()
    }
    
    func onViewWillDisappear() {
        goEdit = 0
        goAddPage = 0
        setupButtons()
    }
}
