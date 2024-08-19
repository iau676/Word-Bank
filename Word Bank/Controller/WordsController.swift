//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import CoreData

private let reuseIdentifier = "ReusableCell"

class WordsController: UIViewController {
    
    //MARK: - Properties
    
    var presentAdd: Bool = false
    private let exerciseType: String
    
    private let searchBar = UISearchBar()
    private let tableView = UITableView()
    
    private let testExerciseButton = makeExerciseButton(image: Images.testExercise)
    private let writingExerciseButton = makeExerciseButton(image: Images.writingExercise)
    private let listeningExerciseButton = makeExerciseButton(image: Images.listeningExercise)
    private let cardExerciseButton = makeExerciseButton(image: Images.cardExercise)
    
    private let testExerciseLabel = makeExerciseLabel(text: "Test")
    private let writingExerciseLabel = makeExerciseLabel(text: "Writing")
    private let listeningExerciseLabel = makeExerciseLabel(text: "Listening")
    private let cardExerciseLabel = makeExerciseLabel(text: "Card")
    
    private var wordBrain = WordBrain()
    private var itemArray: [Item] { return wordBrain.itemArray }
    private var hardItemArray: [HardItem] { return wordBrain.hardItemArray }
    
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
        
        configureUI()
        addGestureRecognizer()
        updateSearchBarPlaceholder()
        hideKeyboardWhenTappedAround()
        presentAddControllerIfNeed()
    }
    
    //MARK: - Selectors
    
    @objc private func addBarButtonPressed(_ sender: UIBarButtonItem) {
        presentAddController()
    }
    
    @objc private func testExerciseButtonPressed(_ sender: UIButton) {
        sender.bounce()
        let controller = TestController(exerciseType: exerciseType, exerciseFormat: ExerciseFormat.test)
        checkAndNavigate(controller: controller)
    }
    
    @objc private func writingExerciseButtonPressed(_ sender: UIButton) {
        sender.bounce()
        let controller = WritingController(exerciseType: exerciseType, exerciseFormat: ExerciseFormat.writing)
        checkAndNavigate(controller: controller)
    }
    
    @objc private func listeningExerciseButtonPressed(_ sender: UIButton) {
        sender.bounce()
        let controller = ListeningController(exerciseType: exerciseType, exerciseFormat: ExerciseFormat.listening)
        checkAndNavigate(controller: controller)
    }
    
    @objc private func cardExerciseButtonPressed(_ sender: UIButton) {
        sender.bounce()
        let controller = CardController(exerciseType: exerciseType, exerciseFormat: ExerciseFormat.card)
        checkAndNavigate(controller: controller)
    }

    //MARK: - Helpers
    
    private func configureUI() {
        configureNavigationBar()
        configureSearchBar()
        configureTableView()
        configureButtons()
        addGradientLayer()
        
        cardExerciseButton.isHidden = exerciseType == ExerciseType.hard
        cardExerciseLabel.isHidden = exerciseType == ExerciseType.hard
        
        let tableStack = UIStackView(arrangedSubviews: [searchBar, tableView])
        tableStack.axis = .vertical
        tableStack.spacing = 0
        tableStack.distribution = .fill
        
        let buttonStack = UIStackView(arrangedSubviews: [testExerciseButton, writingExerciseButton, listeningExerciseButton, cardExerciseButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 16
        buttonStack.distribution = .fillEqually
        buttonStack.setHeight(55)
        
        let labelStack = UIStackView(arrangedSubviews: [testExerciseLabel, writingExerciseLabel, listeningExerciseLabel, cardExerciseLabel])
        labelStack.axis = .horizontal
        labelStack.spacing = 16
        labelStack.distribution = .fillEqually
        
        let stack = UIStackView(arrangedSubviews: [tableStack, buttonStack, labelStack])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fill
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                     bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,
                     paddingTop: 8, paddingLeft: 16, paddingBottom: 32, paddingRight: 16)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
        title = exerciseType == ExerciseType.normal ? "Words" : "Hard Words"
        let barButtonItem = UIBarButtonItem(image: Images.add, style: .plain, target: self, action: #selector(addBarButtonPressed))
        navigationItem.rightBarButtonItem = exerciseType == ExerciseType.normal ? barButtonItem :  nil
    }
    
    private func configureSearchBar() {
        searchBar.delegate = self
        searchBar.isHidden = true
        searchBar.barTintColor = Colors.cellLeft
        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = 10
        searchBar.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        searchBar.searchTextField.textColor = Colors.black
        searchBar.isHidden = exerciseType == ExerciseType.hard
        
        switch UserDefault.userInterfaceStyle {
        case "dark": searchBar.keyboardAppearance = .dark
        default: searchBar.keyboardAppearance = .default
        }
    }
    
    private func updateSearchBarPlaceholder() {
        searchBar.placeholder = itemArray.count > 0 ? "Search in \(itemArray.count) words" : "Nothing to see here"
    }
    
    private func configureTableView() {
        tableView.register(WordCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.isScrollEnabled = true
        tableView.allowsSelection = false
        tableView.backgroundColor = Colors.cellLeft
        tableView.layer.cornerRadius = 10
        
        let maskBottom: CACornerMask = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        let maskAll: CACornerMask = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        tableView.layer.maskedCorners =  exerciseType == ExerciseType.normal ? maskBottom : maskAll
    }
    
    private func configureButtons() {
        testExerciseButton.addTarget(self, action: #selector(testExerciseButtonPressed), for: .touchUpInside)
        writingExerciseButton.addTarget(self, action: #selector(writingExerciseButtonPressed), for: .touchUpInside)
        listeningExerciseButton.addTarget(self, action: #selector(listeningExerciseButtonPressed), for: .touchUpInside)
        cardExerciseButton.addTarget(self, action: #selector(cardExerciseButtonPressed), for: .touchUpInside)
    }
        
    private func addGradientLayer() {
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        let topColor = exerciseType == ExerciseType.normal ? Colors.blue : Colors.yellow
        let bottomColor = exerciseType == ExerciseType.normal ? Colors.blueLight : Colors.yellowLight
        gradient.colors = [topColor.cgColor, bottomColor.cgColor]
        view.layer.insertSublayer(gradient, at: 0)
    }

    private func presentAddController(item: Item? = nil) {
        let controller = AddController()
        controller.item = item
        controller.delegate = self
        controller.modalPresentationStyle = .overCurrentContext
        self.present(controller, animated: true)
    }
    
    private func presentAddControllerIfNeed() {
        if presentAdd { presentAddController() }
    }
    
    private func checkAndNavigate(controller: UIViewController) {
        let wordCount = exerciseType == ExerciseType.normal ? itemArray.count : hardItemArray.count
        
        if wordCount < 2 {
            showAlert(title: "Minimum two words required", message: "") { _ in
                if self.exerciseType == ExerciseType.normal {
                    self.presentAddController()
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
        } else {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    private func showAlertIfHardWordsEmpty(){
        if hardItemArray.count <= 0 {
            showAlert(title: "Nothing to see here yet", message: "When you answer a word incorrectly in the exercises, that word is added to this page. In order to delete that word from here, you should answer correctly 5 times.") { _ in
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
    }
}

//MARK: - UISearchBarDelegate

extension WordsController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard let text = searchBar.text else { return }
        if text.count > 0 {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            let firstPredicate = NSPredicate(format: "eng CONTAINS[cd] %@", text)
            let secondPredicate = NSPredicate(format: "tr CONTAINS[cd] %@", text)
            request.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [firstPredicate,secondPredicate])
            request.sortDescriptors = [NSSortDescriptor(key: "eng", ascending: true)]
            wordBrain.loadItemArray(with: request)
        } else {
            wordBrain.loadItemArray()
        }
        tableView.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! WordCell
        cell.engLabel.text = exerciseType == ExerciseType.normal ? itemArray[indexPath.row].eng : hardItemArray[indexPath.row].eng
        cell.meaningLabel.text = exerciseType == ExerciseType.normal ? itemArray[indexPath.row].tr : hardItemArray[indexPath.row].tr
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let text = exerciseType == ExerciseType.normal ? itemArray[indexPath.row].tr : hardItemArray[indexPath.row].tr
        let height = size(forText: text, minusWidth: 26+32).height
        return height+24
    }
}

    //MARK: - UITableViewDelegate

extension WordsController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let item = self.itemArray[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.showAlertWithCancel(title: "'\(item.eng ?? "Word")' will be deleted",
                                     message: "This action cannot be undone",
                                     actionTitle: "Delete", style: .destructive) { _ in
                self.wordBrain.deleteHardWord(item)
                self.wordBrain.removeWord(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
                tableView.reloadData()
            }
            success(true)
        })
        deleteAction.setImage(image: Images.bin, width: 25, height: 25)
        deleteAction.setBackgroundColor(UIColor.systemRed)
        
        let editAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.presentAddController(item: item)
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
        
        let standartConf: UISwipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction])
        let hardConf: UISwipeActionsConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, editAction, addAction])
        let emptyConf: UISwipeActionsConfiguration = UISwipeActionsConfiguration()
        let itemAlreadyHard = self.itemArray[indexPath.row].addedHardWords == true
        
        return exerciseType == ExerciseType.normal ? itemAlreadyHard ? standartConf : hardConf : emptyConf
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
        if exerciseType == ExerciseType.normal { presentAddController() }
    }
    
    @objc private func respondToSwipeRightGesture(gesture: UISwipeGestureRecognizer) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}

//MARK: - AddControllerDelegate

extension WordsController: AddControllerDelegate {
    func updateTableView() {
        wordBrain.saveContext()
        wordBrain.loadItemArray()
        updateSearchBarPlaceholder()
        tableView.reloadData()
    }
}
