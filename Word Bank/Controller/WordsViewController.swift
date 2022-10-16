//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import CoreData


class WordsViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var startButton2: UIButton!
    @IBOutlet weak var startButton3: UIButton!
    @IBOutlet weak var startButton4: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewConstraint: NSLayoutConstraint!
    
    //MARK: - Variables
    
    var goEdit = 0
    var editIndex = 0
    var goAddPage = 0
    var expandIconName = "expand"
    var notExpandIconName = "notExpand"
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
        configureButton()
        setupNavigationBar()
        setupSearchBar()
        setupView()
        hideKeyboardWhenTappedAround()
        updateSearchBarPlaceholder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefault.selectedSegmentIndex.set(0)
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
                }
            }
            
            if goEdit == 1 {
                destinationVC.goEdit = 1
                destinationVC.editIndex = editIndex
            }
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        goAddPage = 1
        checkGoAddPage()
    }
    
    @IBAction func startPressed(_ sender: Any) {
        UserDefault.startPressed.set(1)
        startButton.bounce()
        startButton.updateShadowHeight(withDuration: 0.15, height: 0.3)
        check2Items()
    }
    
    @IBAction func startPressed2(_ sender: UIButton) {
        UserDefault.startPressed.set(2)
        startButton2.bounce()
        startButton2.updateShadowHeight(withDuration: 0.15, height: 0.3)
        check2Items()
    }
    
    @IBAction func startPressed3(_ sender: UIButton) {
        startButton3.bounce()
        startButton3.updateShadowHeight(withDuration: 0.15, height: 0.3)
        //0 is true, 1 is false
        if UserDefault.playSound.getInt() == 0 {
            UserDefault.startPressed.set(3)
            check2Items()
        } else {
            let alert = UIAlertController(title: "To start this exercise, you need to activate the \"Word Sound\" feature.", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func startPressed4(_ sender: UIButton) {
        UserDefault.startPressed.set(4)
        startButton4.pulstate()
        startButton4.updateShadowHeight(withDuration: 0.15, height: 0.3)
        if itemArray.count < 2 {
            let alert = UIAlertController(title: "Minimum two words are required", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.performSegue(withIdentifier: "goAdd", sender: self)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.performSegue(withIdentifier: "goCard", sender: self)
            }
        }
    }
   
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            self.navigationController?.popToRootViewController(animated: true)
            break
        case .left:
            if whichButton == "blue" { performSegue(withIdentifier: "goAdd", sender: self) }
            break
        default: break
        }
    }

    //MARK: - Helpers
    
    func setupView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "WordCell", bundle: nil), forCellReuseIdentifier:"ReusableCell")
        tableView.tableFooterView = UIView()

        updateView()
        setupBackgroundColor()
        setupCornerRadius()
    }
    
    func updateView(){
        updateTableViewConstraintMultiplier(0.1)
        
        if whichButton == "blue" {
            searchBar.updateSearchBarVisibility(false)
            tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            searchBar.updateSearchBarVisibility(true)
            tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
            startButton4.isHidden = true
            navigationItem.rightBarButtonItem = nil
        }
        tableView.reloadData()
    }
    
    func configureButton(){
        startButton.changeBackgroundColor(to: Colors.raven)
        startButton2.changeBackgroundColor(to: Colors.raven)
        startButton3.changeBackgroundColor(to: Colors.raven)
        startButton4.changeBackgroundColor(to: Colors.raven)
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
        startButton.setButtonCornerRadius(10)
        startButton2.setButtonCornerRadius(10)
        startButton3.setButtonCornerRadius(10)
        startButton4.setButtonCornerRadius(10)
        tableView.setViewCornerRadius(10)
    }
    
    func setupBackgroundColor(){
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        if whichButton == "blue" {
            gradient.colors = [Colors.blue!.cgColor, Colors.blueBottom!.cgColor]
        } else {
            gradient.colors = [Colors.yellow!.cgColor, Colors.yellowBottom!.cgColor]
        }
        mainView.layer.insertSublayer(gradient, at: 0)
    }
    
    func setupNavigationBar(){
        let backButton = UIBarButtonItem()
        backButton.title = "Back"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        if whichButton == "blue" {
            title = "My Words"
        } else {
            title = "Hard Words"
        }
    }
    
    func setupButtons(){
        setupButtonImage(startButton, imageName: "firstStartImage", width: 30, height: 15)
        setupButtonImage(startButton2, imageName: "secondStartImage", width: 30, height: 15)
        setupButtonImage(startButton3, imageName: "thirdStartImage", width: 30, height: 15)
        setupButtonImage(startButton4, imageName: "card", width: 20, height: 20)
        
        setupButtonShadow(startButton)
        setupButtonShadow(startButton2)
        setupButtonShadow(startButton3)
        setupButtonShadow(startButton4)
    }
    
    func setupButtonImage(_ button: UIButton, imageName: String, width: CGFloat, height: CGFloat){
        button.setImage(imageName: imageName, width: width+textSize, height: height+textSize)
    }
    
    func setupButtonShadow(_ button: UIButton) {
        button.layer.shadowColor = Colors.ravenShadow?.cgColor
        button.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        button.layer.shadowOpacity = 1.0
        button.layer.shadowRadius = 0.0
        button.layer.masksToBounds = false
    }
        
    func updateTableViewConstraintMultiplier(_ double: Double) {
        UIView.transition(with: tableView, duration: 0.6,
                          options: .transitionCrossDissolve,
                          animations: {
                            let newConstraint2 = self.tableViewConstraint.constraintWithMultiplier(double)
                            self.tableViewConstraint.isActive = false
                            self.view.addConstraint(newConstraint2)
                            self.view.layoutIfNeeded()
                            self.tableViewConstraint = newConstraint2
                      })
    }

    func checkGoAddPage(){
        if goAddPage == 1 && whichButton == "blue"{
            performSegue(withIdentifier: "goAdd", sender: self)
        }
    }
    
    func check2Items(){
        let checkCount = (whichButton == "blue") ? itemArray.count : hardItemArray.count
        
        if checkCount < 2 {
            let alert = UIAlertController(title: "Minimum two words are required", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.updateView()
                if self.whichButton == "blue" {
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
                self.performSegue(withIdentifier: "goToExercise", sender: self)
            }
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
        if whichButton == "blue" {
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
        
        tableView.backgroundColor = Colors.cellLeft
        tableView.separatorStyle = .singleLine
        tableView.rowHeight = UITableView.automaticDimension
        tableView.isScrollEnabled = true
        cell.engView.isHidden = false
        cell.trView.isHidden = false
        
        if itemArray.count > 0 {
            if whichButton == "blue" {
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
                            
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
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
            let alert = UIAlertController(title: "Word will be deleted", message: "This action cannot be undone", preferredStyle: .alert)
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
        deleteAction.setImage(imageName: "bin", width: 25, height: 25)
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
        editAction.setImage(imageName: "edit", width: 25, height: 25)
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
        addAction.setImage(imageName: "plus", width: 25, height: 25)
        addAction.setBackgroundColor(Colors.yellow)
        
        if whichButton == "blue" {
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

