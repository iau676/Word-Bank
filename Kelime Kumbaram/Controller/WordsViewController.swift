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
    @IBOutlet weak var emptyView: UIView!
    @IBOutlet weak var emptyViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var expandButton: UIButton!
    
    //MARK: - Variables
    
    var goEdit = 0
    var editIndex = 0
    var goAddPage = 0
    var showWords = 0
    var expandIconName = ""
    var notExpandIconName = ""
    var wordBrain = WordBrain()
    var itemArray: [Item] { return wordBrain.itemArray }
    var HardItemArray = [HardItem]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var textSize: CGFloat { return wordBrain.textSize.getCGFloat() }
    let pageStatistic = ["Words count: \(UserDefaults.standard.integer(forKey: "userWordCount"))" ,
                             "Completed exercises count: \(UserDefaults.standard.integer(forKey: "blueExerciseCount"))",
                             "Correct answers: \(UserDefaults.standard.integer(forKey: "blueTrueCount"))",
                             "Wrong answers: \(UserDefaults.standard.integer(forKey: "blueFalseCount"))"]
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Bank"
        wordBrain.loadItemArray()
        setupSearchBar()
        setupView()
        setupExerciseButtons()
        setupExpandButton()
        hideKeyboardWhenTappedAround()
        updateSearchBarPlaceholder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkGoAddPage()
    }
    
    //MARK: - prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goAdd" {
            let destinationVC = segue.destination as! AddViewController
            destinationVC.itemArray = itemArray
            destinationVC.modalPresentationStyle = .overFullScreen
            
            if segue.destination is AddViewController {
                (segue.destination as? AddViewController)?.updateWordsPage = {
                    self.wordBrain.saveWord()
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
    
    @IBAction func expandButtonPressed(_ sender: UIButton) {
        if showWords == 0 {
            showWords = 1
        } else {
            showWords = 0
        }
        updateView()
        tableView.reloadData()
    }
    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        goAddPage = 1
        checkGoAddPage()
    }
    
    @IBAction func startPressed(_ sender: Any) {
        wordBrain.startPressed.set(1)
        startButton.pulstate()
        check2Items()
    }
    
    @IBAction func startPressed2(_ sender: UIButton) {
        wordBrain.startPressed.set(2)
        startButton2.pulstate()
        check2Items()
    }
    
    @IBAction func startPressed3(_ sender: UIButton) {
        startButton3.pulstate()
        //0 is true, 1 is false
        if wordBrain.playSound.getInt() == 0 {
            wordBrain.startPressed.set(3)
            check2Items()
        } else {
            let alert = UIAlertController(title: "To start this exercise, you need to activate the \"Word Sound\" feature.", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                // what will happen once user clicks the add item button on UIAlert
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func startPressed4(_ sender: UIButton) {
        wordBrain.startPressed.set(4)
        startButton4.pulstate()
        
        if itemArray.count < 2 {
            let alert = UIAlertController(title: "Minimum two words are required", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                // what will happen once user clicks the add item button on UIAlert
                self.showWords = 1
                self.updateView()
                self.tableView.reloadData()
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
            performSegue(withIdentifier: "goAdd", sender: self)
            if showWords == 0 {
                showWords = 1
                updateView()
                tableView.reloadData()
            }
            break
        case .down:
            if showWords == 0 {
                showWords = 1
                updateView()
                tableView.reloadData()
            }
            break
        default: break
        }
    }

    //MARK: - Other Functions
    
    func setupView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "WordCell", bundle: nil), forCellReuseIdentifier:"ReusableCell")
        tableView.tableFooterView = UIView()
        
        setupNavigationBar()
        setupBackgroundColor()
        setupCornerRadius()
    }
    
    func updateView(){
        if showWords == 0 {
            expandButton.setImage(imageName: expandIconName, width: 35, height: 25)
            emptyView.updateViewVisibility(false)
            searchBar.updateSearchBarVisibility(true)
            updateTableViewConstraintMultiplier(0.7)
            
            tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: CGFloat(66*pageStatistic.count-1));
    
            tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            expandButton.setImage(imageName: notExpandIconName, width: 35, height: 25)
            emptyView.updateViewVisibility(true)
            searchBar.updateSearchBarVisibility(false)
            updateTableViewConstraintMultiplier(0.2)
            
            tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
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
    }
    
    func setupCornerRadius() {
        startButton.setButtonCornerRadius(10)
        startButton2.setButtonCornerRadius(10)
        startButton3.setButtonCornerRadius(10)
        startButton4.setButtonCornerRadius(10)
        expandButton.setButtonCornerRadius(10)
        tableView.setViewCornerRadius(10)
    }
    
    func setupBackgroundColor(){
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(named: "bblueColor")!.cgColor, UIColor(named: "bblueColorBottom")!.cgColor]
        mainView.layer.insertSublayer(gradient, at: 0)
    }
    
    func setupNavigationBar(){
        let backButton = UIBarButtonItem()
        backButton.title = "Geri"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func setupExerciseButtons(){
        setupExerciseButtonImage(startButton, imageName: "firstStartImage", width: 30, height: 15)
        setupExerciseButtonImage(startButton2, imageName: "secondStartImage", width: 30, height: 15)
        setupExerciseButtonImage(startButton3, imageName: "thirdStartImage", width: 30, height: 15)
        setupExerciseButtonImage(startButton4, imageName: "card", width: 20, height: 20)
        
        setupExerciseButtonShadow(startButton)
        setupExerciseButtonShadow(startButton2)
        setupExerciseButtonShadow(startButton3)
        setupExerciseButtonShadow(startButton4)
    }
    
    func setupExerciseButtonImage(_ button: UIButton, imageName: String, width: CGFloat, height: CGFloat){
        button.setImage(imageName: imageName, width: width+textSize, height: height+textSize)
    }
    
    func setupExerciseButtonShadow(_ button: UIButton) {
        button.layer.shadowColor = UIColor(red: 0.16, green: 0.19, blue: 0.28, alpha: 1.00).cgColor
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
        if goAddPage == 1 {
            showWords = 1
            tableView.reloadData()
            updateView()
            performSegue(withIdentifier: "goAdd", sender: self)
        }
    }
    
    func check2Items(){
        if itemArray.count < 2 {
            let alert = UIAlertController(title: "Minimum two words are required", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.showWords = 1
                self.updateView()
                self.tableView.reloadData()
                self.performSegue(withIdentifier: "goAdd", sender: self)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } else {
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.performSegue(withIdentifier: "goToMyQuiz2", sender: self)
            }
        }
    }
    
    func findUserPoint(){ //using after delete a word
        let userWordCountIntVariable = wordBrain.userWordCount.getInt()
        var lastPoint = wordBrain.pointForMyWords.getInt()
        print("userWordCountIntVariable>>\(userWordCountIntVariable)")
        print("lastPoint>>\(lastPoint)")
        if userWordCountIntVariable >= 100 {
           let newPoint = userWordCountIntVariable/100*2 + 12
            if lastPoint - newPoint > 0 {
                wordBrain.pointForMyWords.set(newPoint)
            }
        } else {
          if  userWordCountIntVariable >= 10{
              if userWordCountIntVariable < 50 {
                  lastPoint = 11
              } else {
                  lastPoint = 12
              }
          } else {
              lastPoint = 10
          }
          wordBrain.pointForMyWords.set(lastPoint)
        }
    }
    
    func imageRenderer(imageName: String, width: CGFloat, height: CGFloat) -> UIImage {
        return UIGraphicsImageRenderer(size: CGSize(width: width, height: height)).image { _ in
            UIImage(named: imageName)?.draw(in: CGRect(x: 0, y: 0, width: width, height: height)) }
    }
    
    func setupExpandButton(){
        assignExpandIconName()
        expandButton.setImage(imageName: expandIconName, width: 35, height: 25)
    }
    
    func assignExpandIconName() {
        switch traitCollection.userInterfaceStyle {
        case .light, .unspecified:
            expandIconName = "expand"
            notExpandIconName = "notExpand"
            break
        case .dark:
            expandIconName = "expandLight"
            notExpandIconName = "notExpandLight"
            break
        default: break
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
        } else {
            wordBrain.loadItemArray()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            wordBrain.loadItemArray()
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
        return (showWords == 1 ?  itemArray.count == 0 ? 1 : itemArray.count  : pageStatistic.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! WordCell
        
        tableView.backgroundColor = UIColor(named: "rightCelerColor")
        tableView.separatorStyle = .singleLine
        if showWords == 1 {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.isScrollEnabled = true
            cell.engView.isHidden = false
            cell.trView.isHidden = false
            
            if itemArray.count > 0 {
                cell.engLabel.text = itemArray[indexPath.row].eng
                cell.trLabel.text = itemArray[indexPath.row].tr
            } else {
                cell.trView.isHidden = true
                cell.engLabel.text = ""
                tableView.separatorStyle = .none
            }
        } else {
            cell.engView.isHidden = true
            cell.trView.isHidden = false
            //Fatal error: Index out of range
            //problem text size 17 and 10 words when press expand button
            if indexPath.row < 4 {
                cell.trLabel.text = pageStatistic[indexPath.row]
            }
            tableView.backgroundColor = UIColor.clear
            tableView.rowHeight = 66
            tableView.isScrollEnabled = false
            // tableView contentSize
            tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: CGFloat(66*pageStatistic.count-1));
        }
        cell.updateLabelTextSize(cell.engLabel, textSize)
        cell.updateLabelTextSize(cell.trLabel, textSize)
        return cell
    }
}

    //MARK: - Swipe Cell

extension WordsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            // 1 is false, 0 is true
                
            let alert = UIAlertController(title: "Word will be deleted", message: "This action cannot be undone", preferredStyle: .alert)
            let action = UIAlertAction(title: "Delete", style: .destructive) { (action) in
                
                self.context.delete(self.itemArray[indexPath.row])
                self.wordBrain.removeWord(at: indexPath.row)
                self.updateSearchBarPlaceholder()
                let userWordCount = self.wordBrain.userWordCount.getInt()
                self.wordBrain.userWordCount.set(userWordCount-1)
                self.findUserPoint()
                if self.itemArray.count > 0 {
                    tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
                } else {
                    tableView.reloadData()
                }
                self.dismiss(animated: true, completion: nil)
            }
            let actionCancel = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel) { (action) in
                alert.dismiss(animated: true, completion: nil)
            }
            alert.addAction(action)
            alert.addAction(actionCancel)
            self.present(alert, animated: true, completion: nil)
            success(true)
        })
        deleteAction.image = imageRenderer(imageName: "bin", width: 25, height: 25)
        deleteAction.backgroundColor = UIColor.systemRed
        
        let editAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in

            self.goEdit = 1
            self.editIndex = indexPath.row
            let engEdit = self.itemArray[indexPath.row].eng ?? "empty"
            let trEdit = self.itemArray[indexPath.row].tr ?? "empty"
            self.wordBrain.engEdit.set(engEdit)
            self.wordBrain.trEdit.set(trEdit)
            self.performSegue(withIdentifier: "goAdd", sender: self)
            success(true)
        })
        editAction.image = imageRenderer(imageName: "edit", width: 25, height: 25)
        editAction.backgroundColor = UIColor(red: 0.46, green: 0.62, blue: 0.80, alpha: 1.00)
        
        let addAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            if self.itemArray[indexPath.row].addedHardWords == false {
                let newItem = HardItem(context: self.context)
                newItem.eng = self.itemArray[indexPath.row].eng
                newItem.tr = self.itemArray[indexPath.row].tr
                newItem.uuid = self.itemArray[indexPath.row].uuid
                newItem.originalindex = Int32(indexPath.row)
                newItem.originalList = "MyWords"
                newItem.date = Date()
                newItem.correctNumber = 5
                self.HardItemArray.append(newItem)
                
                self.itemArray[indexPath.row].addedHardWords = true
                let lastCount = self.wordBrain.hardWordsCount.getInt()
                self.wordBrain.hardWordsCount.set(lastCount+1)

                do {
                    try self.context.save()
                } catch {
                   print("Error saving context \(error)")
                }
                
                self.wordBrain.loadItemArray()
                
                let alert = UIAlertController(title: "Added to Hard Words", message: "", preferredStyle: .alert)
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when){
                  alert.dismiss(animated: true, completion: nil)
                }
                self.present(alert, animated: true, completion: nil)
            } else {
                    let alert = UIAlertController(title: "Already Added", message: "", preferredStyle: .alert)

                    // dismiss alert after 1 second
                    let when = DispatchTime.now() + 1
                    DispatchQueue.main.asyncAfter(deadline: when){
                      alert.dismiss(animated: true, completion: nil)
                    }
               
                    self.present(alert, animated: true, completion: nil)
            }

            success(true)
        })
        addAction.image = imageRenderer(imageName: "plus", width: 25, height: 25)
        addAction.backgroundColor = UIColor(red: 1.00, green: 0.75, blue: 0.28, alpha: 1.00)
        
        if showWords == 1 {
            if self.itemArray[indexPath.row].addedHardWords == true {
                return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            }
            
            if self.itemArray[indexPath.row].isCreatedFromUser == false {
                return UISwipeActionsConfiguration(actions: [deleteAction, addAction])
            }

            return UISwipeActionsConfiguration(actions: [deleteAction, editAction, addAction])
        } else {
            return UISwipeActionsConfiguration()
        }
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

