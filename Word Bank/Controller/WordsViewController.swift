//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import CoreData

class WordsViewController: UIViewController {
    
    let searchBar = UISearchBar()
    let tableView = UITableView()
    let tableViewStackView = UIStackView()
    
    let testExerciseButton = UIButton()
    let writingExerciseButton = UIButton()
    let listeningExerciseButton = UIButton()
    let cardExerciseButton = UIButton()
    let buttonStackView = UIStackView()
    
    let testExerciseLabel = UILabel()
    let writingExerciseLabel = UILabel()
    let listeningExerciseLabel = UILabel()
    let cardExerciseLabel = UILabel()
    
    var goEdit = 0
    var editIndex = 0
    var goAddPage = 0
    var wordBrain = WordBrain()
    var itemArray: [Item] { return wordBrain.itemArray }
    var hardItemArray: [HardItem] { return wordBrain.hardItemArray }
    var textSize: CGFloat { return UserDefault.textSize.getCGFloat() }
    var whichButton: String	{ return UserDefault.whichButton.getString() }
    
    //MARK: - Life Cycle
    
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
     
    //MARK: - prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goAdd" {
            let destinationVC = segue.destination as! AddViewController
            destinationVC.modalPresentationStyle = .overFullScreen
            
            if segue.destination is AddViewController {
                (segue.destination as? AddViewController)?.updateWordsPage = {
                    self.wordBrain.saveContext()
                    self.wordBrain.loadItemArray()
                    self.updateSearchBarPlaceholder()
                    self.tableView.reloadData()
                }
                (segue.destination as? AddViewController)?.onViewWillDisappear = {
                    self.goEdit = 0
                    self.goAddPage = 0
                    self.setupButtons()
                }
            }
            
            if goEdit == 1 {
                destinationVC.goEdit = 1
                destinationVC.editIndex = editIndex
            }
        }
    }
    
    //MARK: - Selectors
    
    @objc func addBarButtonPressed(_ sender: UIBarButtonItem) {
        goAddPage = 1
        checkGoAddPage()
    }
    
    @objc func testExerciseButtonPressed(_ sender: Any) {
        UserDefault.startPressed.set(1)
        testExerciseButton.bounce()
        testExerciseButton.updateShadowHeight(withDuration: 0.15, height: 0.3)
        checkWordCount(ifOK: "goToExercise")
    }
    
    @objc func writingExerciseButtonPressed(_ sender: UIButton) {
        UserDefault.startPressed.set(2)
        writingExerciseButton.bounce()
        writingExerciseButton.updateShadowHeight(withDuration: 0.15, height: 0.3)
        checkWordCount(ifOK: "goToExercise")
    }
    
    @objc func listeningExerciseButtonPressed(_ sender: UIButton) {
        listeningExerciseButton.bounce()
        listeningExerciseButton.updateShadowHeight(withDuration: 0.15, height: 0.3)
        checkSoundSetting()
    }
    
    @objc func cardExerciseButtonPressed(_ sender: UIButton) {
        UserDefault.startPressed.set(4)
        cardExerciseButton.bounce()
        cardExerciseButton.updateShadowHeight(withDuration: 0.15, height: 0.3)
        checkWordCount(ifOK: "goCard")
    }

    //MARK: - Helpers
    
    func setupView(){
        updateView()
        setupBackgroundColor()
        setupCornerRadius()
    }
    
    func updateView(){
        if whichButton == ExerciseType.normal {
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
    
    func configureButton(){
        testExerciseButton.changeBackgroundColor(to: Colors.raven)
        writingExerciseButton.changeBackgroundColor(to: Colors.raven)
        listeningExerciseButton.changeBackgroundColor(to: Colors.raven)
        cardExerciseButton.changeBackgroundColor(to: Colors.raven)
    }
   
    func setupSearchBar() {
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
    
    func setupCornerRadius() {
        testExerciseButton.setButtonCornerRadius(10)
        writingExerciseButton.setButtonCornerRadius(10)
        listeningExerciseButton.setButtonCornerRadius(10)
        cardExerciseButton.setButtonCornerRadius(10)
        tableView.setViewCornerRadius(10)
    }
    
    func configureLabel(_ label: UILabel, _ text: String){
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Colors.black
        label.text = text
        label.font = UIFont(name: Fonts.AvenirNextRegular, size: 13)
        label.numberOfLines = 1
    }
    
    func setupBackgroundColor(){
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        if whichButton == ExerciseType.normal {
            gradient.colors = [Colors.blue!.cgColor, Colors.blueBottom!.cgColor]
        } else {
            gradient.colors = [Colors.yellow!.cgColor, Colors.yellowBottom!.cgColor]
        }
        view.layer.insertSublayer(gradient, at: 0)
    }
    
    func setupNavigationBar(){
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        if whichButton == ExerciseType.normal {
            title = "My Words"
        } else {
            title = "Hard Words"
        }
    }
    
    func setupButtons(){
        setupButtonImage(testExerciseButton, image: Images.testExercise, width: 30, height: 15)
        setupButtonImage(writingExerciseButton, image: Images.writingExercise, width: 30, height: 15)
        setupButtonImage(listeningExerciseButton, image: Images.listeningExercise, width: 30, height: 15)
        setupButtonImage(cardExerciseButton, image: Images.cardExercise, width: 30, height: 15)
        
        setupButtonShadow(testExerciseButton)
        setupButtonShadow(writingExerciseButton)
        setupButtonShadow(listeningExerciseButton)
        setupButtonShadow(cardExerciseButton)
    }
    
    func setupButtonImage(_ button: UIButton, image: UIImage?, width: CGFloat, height: CGFloat){
        button.setImage(image: image, width: width+textSize, height: height+textSize)
    }
    
    func setupButtonShadow(_ button: UIButton) {
        button.layer.shadowColor = Colors.ravenShadow?.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
    }

    func checkGoAddPage(){
        if goAddPage == 1 && whichButton == ExerciseType.normal{
            performSegue(withIdentifier: "goAdd", sender: self)
        }
    }
    
    func checkWordCount(ifOK: String){
        let wordCount = (whichButton == ExerciseType.normal) ? itemArray.count : hardItemArray.count
        
        if wordCount < 2 {
            let alert = UIAlertController(title: "Minimum two words are required", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                if self.whichButton == ExerciseType.normal {
                    self.performSegue(withIdentifier: "goAdd", sender: self)
                } else {
                    self.navigationController?.popToRootViewController(animated: true)
                }
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.performSegue(withIdentifier: ifOK, sender: self)
            }
        }
    }
    
    func checkSoundSetting(){
        //0 is true, 1 is false
        if UserDefault.playSound.getInt() == 0 {
            UserDefault.startPressed.set(3)
            checkWordCount(ifOK: "goToExercise")
        } else {
            let alert = UIAlertController(title: "To start this exercise, you need to activate the \"Word Sound\" feature.", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                self.navigationController?.pushViewController(SettingsViewController(), animated: true)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
}

    //MARK: - Search Bar

extension WordsViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text!.count > 0 {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            request.predicate = NSPredicate(format: "eng CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "eng", ascending: true)]
            wordBrain.loadItemArray(with: request)
            tableView.reloadData()
        } else {
            wordBrain.loadItemArray()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            wordBrain.loadItemArray()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    func updateSearchBarPlaceholder(){
        if itemArray.count > 0 {
            searchBar.placeholder = "Search in \(itemArray.count) words"
        } else {
            searchBar.placeholder = "Nothing to see here"
        }
    }
}

    //MARK: - Show Words

extension WordsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        updateSearchBarPlaceholder()
        if whichButton == ExerciseType.normal {
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
            if whichButton == ExerciseType.normal {
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
    
    func showAlertIfHardWordsEmpty(){
        if hardItemArray.count <= 0 {
            let alert = UIAlertController(title: "Nothing to see here yet", message: "When you answer a word incorrectly in the exercises, that word is added to this page. In order to delete that word from here, you should answer correctly 5 times.", preferredStyle: .alert)
                            
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
}

    //MARK: - Swipe Cell

extension WordsViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let alert = UIAlertController(title: "'\(self.itemArray[indexPath.row].eng ?? "Word")' will be deleted", message: "This action cannot be undone", preferredStyle: .alert)
            let actionDelete = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                self.wordBrain.removeWord(at: indexPath.row)
                UserDefault.userWordCount.set(UserDefault.userWordCount.getInt()-1)
                self.wordBrain.calculateExercisePoint()
                if self.itemArray.count > 0 {
                    tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
                } else {
                    tableView.reloadData()
                }
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
            let engEdit = self.itemArray[indexPath.row].eng ?? "empty"
            let trEdit = self.itemArray[indexPath.row].tr ?? "empty"
            UserDefault.engEdit.set(engEdit)
            UserDefault.trEdit.set(trEdit)
            self.performSegue(withIdentifier: "goAdd", sender: self)
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
        
        if whichButton == ExerciseType.normal {
            if self.itemArray[indexPath.row].addedHardWords == true {
                return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            }
            return UISwipeActionsConfiguration(actions: [deleteAction, editAction, addAction])
        } else {
            return UISwipeActionsConfiguration()
        }
    }
}

extension WordsViewController {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

//dismiss keyboard when user tap around
extension WordsViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(WordsViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension WordsViewController {
    func style(){
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addBarButtonPressed))
        
        tableViewStackView.translatesAutoresizingMaskIntoConstraints = false
        tableViewStackView.axis = .vertical
        tableViewStackView.spacing = 0
        tableViewStackView.distribution = .fill
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = Colors.cellLeft
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UINib(nibName: "WordCell", bundle: nil), forCellReuseIdentifier:"ReusableCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = true
        tableView.backgroundColor = Colors.cellLeft
        
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonStackView.axis = .horizontal
        buttonStackView.spacing = 16
        buttonStackView.distribution = .fillEqually
        
        testExerciseButton.translatesAutoresizingMaskIntoConstraints = false
        testExerciseButton.addTarget(self, action: #selector(testExerciseButtonPressed), for: .primaryActionTriggered)
        
        writingExerciseButton.translatesAutoresizingMaskIntoConstraints = false
        writingExerciseButton.addTarget(self, action: #selector(writingExerciseButtonPressed), for: .primaryActionTriggered)
        
        listeningExerciseButton.translatesAutoresizingMaskIntoConstraints = false
        listeningExerciseButton.addTarget(self, action: #selector(listeningExerciseButtonPressed), for: .primaryActionTriggered)
        
        cardExerciseButton.translatesAutoresizingMaskIntoConstraints = false
        cardExerciseButton.addTarget(self, action: #selector(cardExerciseButtonPressed), for: .primaryActionTriggered)
        
        configureLabel(testExerciseLabel, "Test")
        configureLabel(writingExerciseLabel, "Writing")
        configureLabel(listeningExerciseLabel, "Listening")
        configureLabel(cardExerciseLabel, "Card")
    }
    
    func layout(){
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
        
        NSLayoutConstraint.activate([
            tableViewStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: wordBrain.getTopBarHeight() + 8),
            tableViewStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableViewStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableViewStackView.bottomAnchor.constraint(equalTo: buttonStackView.topAnchor, constant: -16),
            
            buttonStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            buttonStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            testExerciseLabel.topAnchor.constraint(equalTo: testExerciseButton.bottomAnchor, constant: 8),
            testExerciseLabel.centerXAnchor.constraint(equalTo: testExerciseButton.centerXAnchor),
            
            writingExerciseLabel.topAnchor.constraint(equalTo: writingExerciseButton.bottomAnchor, constant: 8),
            writingExerciseLabel.centerXAnchor.constraint(equalTo: writingExerciseButton.centerXAnchor),
            
            listeningExerciseLabel.topAnchor.constraint(equalTo: listeningExerciseButton.bottomAnchor, constant: 8),
            listeningExerciseLabel.centerXAnchor.constraint(equalTo: listeningExerciseButton.centerXAnchor),
            
            cardExerciseLabel.topAnchor.constraint(equalTo: cardExerciseButton.bottomAnchor, constant: 8),
            cardExerciseLabel.centerXAnchor.constraint(equalTo: cardExerciseButton.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.heightAnchor.constraint(equalToConstant: 55),
        ])
        
        UIView.transition(with: tableView, duration: 0.6,
                          options: .transitionCrossDissolve,
                          animations: {
            self.view.layoutIfNeeded()
            self.tableViewStackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16).isActive = true
            self.buttonStackView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -48).isActive = true
        })
    }
}

//MARK: - Swipe Gesture

extension WordsViewController {
    func addGestureRecognizer(){
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeLeftGesture))
        swipeLeft.direction = .left
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeRightGesture))
        swipeRight.direction = .right
        
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
    }
    
    @objc func respondToSwipeLeftGesture(gesture: UISwipeGestureRecognizer) {
        if whichButton == ExerciseType.normal { performSegue(withIdentifier: "goAdd", sender: self) }
    }
    
    @objc func respondToSwipeRightGesture(gesture: UISwipeGestureRecognizer) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}
