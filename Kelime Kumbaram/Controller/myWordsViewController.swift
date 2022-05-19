//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import CoreData


class myWordsViewController: UIViewController {
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
    
    
    var selectedSegmentIndex = 0
    var goEdit = 0
    var editIndex = 0
    
    var goAddPage = 0

    var showWords = 0
    var expandIconName = ""
    var notExpandIconName = ""
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    var HardItemArray = [HardItem]()
    
    let pageStatistic = ["Kumbaradaki kelime sayısı: \(UserDefaults.standard.integer(forKey: "userWordCount"))" ,
                         "Yapılan alıştırma sayısı: \(UserDefaults.standard.integer(forKey: "blueExerciseCount"))",
                         
                         "Doğru cevap sayısı: \(UserDefaults.standard.integer(forKey: "blueTrueCount"))",
                         "Yanlış cevap sayısı: \(UserDefaults.standard.integer(forKey: "blueFalseCount"))"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Kumbaram"
        
        searchBar.delegate = self
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "WordCell", bundle: nil), forCellReuseIdentifier:"ReusableCell")
        tableView.tableFooterView = UIView()
        
        loadItems()
        setupView()
        hideKeyboardWhenTappedAround()
        changeSearchBarPlaceholder()
        
    }
    
    

    override func viewWillAppear(_ animated: Bool) {
        selectedSegmentIndex = 0
        UserDefaults.standard.set(0, forKey: "selectedSegmentIndex")
        
        // DETECT LİGHT MODE OR DARK MODE
                switch traitCollection.userInterfaceStyle {
                case .light, .unspecified:
                    expandIconName = "expand"
                    notExpandIconName = "notExpand"
                    break
                case .dark:
                    expandIconName = "expandLight"
                    notExpandIconName = "notExpandLight"
                    break
                default:
                print("nothing")
                }
        
        showWords = 0
        expandButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 35, height: 25)).image { _ in
            UIImage(named: expandIconName)?.draw(in: CGRect(x: 0, y: 0, width: 35, height: 25)) }, for: .normal)
        searchBar.isHidden = true
        
        if goAddPage == 1 {
            showWords = 1
            updateView()
            performSegue(withIdentifier: "goAdd", sender: self)
        }
        tableView.reloadData()
    }


    
    
    //MARK: - setup
    func setupView(){
        
        let textSize = CGFloat(UserDefaults.standard.integer(forKey: "textSize"))
        
        startButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 30+textSize, height: 15+textSize)).image { _ in
            UIImage(named: "firstStartImage")?.draw(in: CGRect(x: 0, y: 0, width: 30+textSize, height: 15+textSize)) }, for: .normal)
        
        startButton2.setImage(UIGraphicsImageRenderer(size: CGSize(width: 30+textSize, height: 15+textSize)).image { _ in
            UIImage(named: "secondStartImage")?.draw(in: CGRect(x: 0, y: 0, width: 30+textSize, height: 15+textSize)) }, for: .normal)
        
        startButton3.setImage(UIGraphicsImageRenderer(size: CGSize(width: 30+textSize, height: 15+textSize)).image { _ in
            UIImage(named: "thirdStartImage")?.draw(in: CGRect(x: 0, y: 0, width: 30+textSize, height: 15+textSize)) }, for: .normal)
        
        startButton4.setImage(UIGraphicsImageRenderer(size: CGSize(width: 20+textSize, height: 20+textSize)).image { _ in
            UIImage(named: "card")?.draw(in: CGRect(x: 0, y: 0, width: 20+textSize, height: 20+textSize)) }, for: .normal)
        
        startButton.layer.shadowColor = UIColor(red: 0.16, green: 0.19, blue: 0.28, alpha: 1.00).cgColor
        startButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        startButton.layer.shadowOpacity = 1.0
        startButton.layer.shadowRadius = 0.0
        startButton.layer.masksToBounds = false
        startButton.layer.cornerRadius = 20.0
        
        startButton2.layer.shadowColor = UIColor(red: 0.16, green: 0.19, blue: 0.28, alpha: 1.00).cgColor
        startButton2.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        startButton2.layer.shadowOpacity = 1.0
        startButton2.layer.shadowRadius = 0.0
        startButton2.layer.masksToBounds = false
        startButton2.layer.cornerRadius = 20.0
        
        startButton3.layer.shadowColor = UIColor(red: 0.16, green: 0.19, blue: 0.28, alpha: 1.00).cgColor
        startButton3.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        startButton3.layer.shadowOpacity = 1.0
        startButton3.layer.shadowRadius = 0.0
        startButton3.layer.masksToBounds = false
        startButton3.layer.cornerRadius = 20.0
        
        startButton4.layer.shadowColor = UIColor(red: 0.16, green: 0.19, blue: 0.28, alpha: 1.00).cgColor
        startButton4.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        startButton4.layer.shadowOpacity = 1.0
        startButton4.layer.shadowRadius = 0.0
        startButton4.layer.masksToBounds = false
        startButton4.layer.cornerRadius = 20.0

        
        // SearchBar text
        let textFieldInsideUISearchBar = searchBar.value(forKey: "searchField") as? UITextField
        textFieldInsideUISearchBar?.textColor = UIColor.black
        textFieldInsideUISearchBar?.font = textFieldInsideUISearchBar?.font?.withSize(CGFloat(UserDefaults.standard.integer(forKey: "textSize")))

        // SearchBar placeholder
        let labelInsideUISearchBar = textFieldInsideUISearchBar!.value(forKey: "placeholderLabel") as? UILabel
        labelInsideUISearchBar?.textColor = UIColor.darkGray
        

        let backButton = UIBarButtonItem()
        backButton.title = "Geri"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        let gradient = CAGradientLayer()

        gradient.frame = view.bounds
        gradient.colors = [UIColor(named: "bblueColor")!.cgColor, UIColor(named: "bblueColorBottom")!.cgColor]

        mainView.layer.insertSublayer(gradient, at: 0)
        
        startButton.layer.cornerRadius = 10
        startButton2.layer.cornerRadius = 10
        startButton3.layer.cornerRadius = 10
        startButton4.layer.cornerRadius = 10
        expandButton.layer.cornerRadius = 10
        
        tableView.layer.cornerRadius = 10

        searchBar.clipsToBounds = true
        searchBar.layer.cornerRadius = 10
        searchBar.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
    }//setupView
    
    func updateView(){
        
        if showWords == 0 {
            
            expandButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 35, height: 25)).image { _ in
                UIImage(named: expandIconName)?.draw(in: CGRect(x: 0, y: 0, width: 35, height: 25)) }, for: .normal)
            
            
            UIView.transition(with: emptyView, duration: 0.6,
                              options: .transitionCrossDissolve,
                              animations: {
                self.emptyView.isHidden = false
                          })
            
            UIView.transition(with: emptyView, duration: 0.6,
                              options: .transitionCrossDissolve,
                              animations: {
                self.searchBar.isHidden = true
                          })
            
            UIView.transition(with: tableView, duration: 0.6,
                              options: .transitionCrossDissolve,
                              animations: {
                let newConstraint2 = self.tableViewConstraint.constraintWithMultiplier(0.7)
                                self.tableViewConstraint.isActive = false
                                self.view.addConstraint(newConstraint2)
                                self.view.layoutIfNeeded()
                                self.tableViewConstraint = newConstraint2
                          })
            tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: CGFloat(66*pageStatistic.count-1));
    
            tableView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner, .layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        } else {
            
            expandButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 35, height: 25)).image { _ in
                UIImage(named: notExpandIconName)?.draw(in: CGRect(x: 0, y: 0, width: 35, height: 25)) }, for: .normal)
            
            UIView.transition(with: emptyView, duration: 0.6,
                              options: .transitionCrossDissolve,
                              animations: {
                self.searchBar.isHidden = false
                          })
            
            UIView.transition(with: emptyView, duration: 0.6,
                              options: .transitionCrossDissolve,
                              animations: {
                                    self.emptyView.isHidden = true
                          })
            
            UIView.transition(with: emptyView, duration: 0.6,
                              options: .transitionCrossDissolve,
                              animations: {
                                let newConstraint2 = self.tableViewConstraint.constraintWithMultiplier(0.2)
                                self.tableViewConstraint.isActive = false
                                self.view.addConstraint(newConstraint2)
                                self.view.layoutIfNeeded()
                                self.tableViewConstraint = newConstraint2
                          })

            tableView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMinXMaxYCorner]
        }
    }//updateView
    
    
    //MARK: - user did something
    
    @IBAction func expandButtonPressed(_ sender: UIButton) {
        
        if showWords == 0 {
            showWords = 1
        } else {
            showWords = 0
        }
        updateView()
        print("<showWords>\(showWords)")
        tableView.reloadData()
        
    }
    
    @IBAction func addBarButtonPressed(_ sender: UIBarButtonItem) {
        goAdd()
    }
    
    func goAdd(){
        performSegue(withIdentifier: "goAdd", sender: self)
      
        if showWords == 0 {
            showWords = 1
            tableView.reloadData()
            updateView()
        }
    }
    
    @IBAction func startPressed(_ sender: Any) {
        UserDefaults.standard.set(1, forKey: "startPressed")
        startButton.pulstate()
        check2Items()
    }
    
    @IBAction func startPressed2(_ sender: UIButton) {
        UserDefaults.standard.set(2, forKey: "startPressed")
        startButton2.pulstate()
        check2Items()
    }
    
    @IBAction func startPressed3(_ sender: UIButton) {
        startButton3.pulstate()
        //0 is true, 1 is false
        if UserDefaults.standard.integer(forKey: "playSound") == 0 {
            UserDefaults.standard.set(3, forKey: "startPressed")
            check2Items()
        } else {
            let alert = UIAlertController(title: "Bu alıştırmayı başlatmak için \"Kelime dinle\" özelliğini aktif etmeniz gerekir.", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Tamam", style: .default) { (action) in
                // what will happen once user clicks the add item button on UIAlert
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func startPressed4(_ sender: UIButton) {
        UserDefaults.standard.set(4, forKey: "startPressed")
        startButton4.pulstate()
        
        if itemArray.count < 2 {
            let alert = UIAlertController(title: "En az iki kelime gereklidir", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Tamam", style: .default) { (action) in
                // what will happen once user clicks the add item button on UIAlert
                self.showWords = 1
                self.updateView()
                self.tableView.reloadData()
                self.performSegue(withIdentifier: "goAdd", sender: self)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else{
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.performSegue(withIdentifier: "goCard", sender: self)
            }
        }
    }
   
    func check2Items(){
        
        if itemArray.count < 2 {
            let alert = UIAlertController(title: "En az iki kelime gereklidir", message: "", preferredStyle: .alert)
            let action = UIAlertAction(title: "Tamam", style: .default) { (action) in
                // what will happen once user clicks the add item button on UIAlert
                self.showWords = 1
                self.updateView()
                self.tableView.reloadData()
                self.performSegue(withIdentifier: "goAdd", sender: self)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
        else{
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.performSegue(withIdentifier: "goToMyQuiz2", sender: self)
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
        default:
            print("nothing#swipeGesture")
        }
    }
    
    //MARK: - findUserPoint
    func findUserPoint(){ //using after delete a word
        
        let userWordCountIntVariable = UserDefaults.standard.integer(forKey: "userWordCount")
        var lastPoint = UserDefaults.standard.integer(forKey: "pointForMyWords")
        print("userWordCountIntVariable>>\(userWordCountIntVariable)")
        print("lastPoint>>\(lastPoint)")
        if userWordCountIntVariable >= 100 {
           let newPoint = userWordCountIntVariable/100*2 + 12
            if lastPoint - newPoint > 0 {
                UserDefaults.standard.set(newPoint, forKey: "pointForMyWords")
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
          UserDefaults.standard.set(lastPoint, forKey: "pointForMyWords")
        }
    }
    
    
    
    //MARK: - Model Manupulation Methods
    func saveItems() {
        do {
          try context.save()
        } catch {
           print("Error saving context \(error)")
        }
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
          itemArray = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
        self.tableView.reloadData()
    }

    
    //MARK: - prepare
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMyQuiz2" {
            let destinationVC = segue.destination as! MyQuizViewController
            destinationVC.itemArray = itemArray
            
        }
        
        if segue.identifier == "goCard" {
            let destinationVC = segue.destination as! CardViewController
            destinationVC.itemArray = itemArray
        }
        
        if segue.identifier == "goAdd" {
            let destinationVC = segue.destination as! AddViewController
                        
            destinationVC.itemArray = itemArray
            destinationVC.modalPresentationStyle = .overFullScreen
            
            
            if segue.destination is AddViewController {
                (segue.destination as? AddViewController)?.onViewWillDisappear = {
                    self.saveItems()
                    self.loadItems()
                    self.changeSearchBarPlaceholder()
                    self.goEdit = 0
                }
            }
            
            if goEdit == 1 {
                destinationVC.goEdit = 1
                destinationVC.editIndex = editIndex
            }
            
        }

    }
  

}

//MARK: - searchbar
extension myWordsViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if searchBar.text!.count > 0 {
            let request : NSFetchRequest<Item> = Item.fetchRequest()
            
            request.predicate = NSPredicate(format: "eng CONTAINS[cd] %@", searchBar.text!)
            request.sortDescriptors = [NSSortDescriptor(key: "eng", ascending: true)]
           
            loadItems(with: request)
        }
        else {
            loadItems()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()
            
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
    
    func changeSearchBarPlaceholder(){
        if itemArray.count > 0 {
            searchBar.placeholder = "\(itemArray.count) kelime içerisinde ara"
        }
        else{
            searchBar.placeholder = "Henüz kelime eklemediniz"
        }
    }
}

//MARK: - show words
extension myWordsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("jojojo*****\(showWords)")
        return (showWords == 1 ?  itemArray.count == 0 ? 1 : itemArray.count  : pageStatistic.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! WordCell
        
        tableView.backgroundColor = UIColor(named: "rightCelerColor")
        tableView.separatorStyle = .singleLine
        if showWords == 1 {
            
            tableView.rowHeight = UITableView.automaticDimension
            
            cell.engView.isHidden = false
            cell.trView.isHidden = false
            tableView.isScrollEnabled = true
            
            
            if itemArray.count > 0
            {
                
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
            print("showWords-\(showWords)>>\(pageStatistic.count)>>\(indexPath.row)")
            //Fatal error: Index out of range
            //problem text size 17 and 10 words when press expand button
            if indexPath.row < 4 {
                cell.trLabel.text = pageStatistic[indexPath.row]
            }
            
            cell.numberLabel.text = ""
            

            tableView.backgroundColor = UIColor.clear
            tableView.rowHeight = 66
            tableView.isScrollEnabled = false

            // tableView contentSize
            tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: CGFloat(66*pageStatistic.count-1));
        }
        
        
        
        cell.engLabel.font = cell.engLabel.font.withSize(CGFloat(UserDefaults.standard.integer(forKey: "textSize")))
        
        cell.trLabel.font = cell.trLabel.font.withSize(CGFloat(UserDefaults.standard.integer(forKey: "textSize")))
        
        
        return cell
    }
    
}


//MARK: - when swipe cell
extension myWordsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //print(indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       
        return true
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        
        let deleteAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in

            // 1 is false, 0 is true
            if UserDefaults.standard.integer(forKey: "switchDelete") == 0 {
                
                let alert = UIAlertController(title: "Kelime silinecek", message: "Bu eylem geri alınamaz", preferredStyle: .alert)
                let action = UIAlertAction(title: "Sil", style: .destructive) { (action) in
                    // what will happen once user clicks the add item button on UIAlert

                    
                    self.context.delete(self.itemArray[indexPath.row])
                    self.itemArray.remove(at: indexPath.row)
                    
                    self.saveItems()
                    self.changeSearchBarPlaceholder()
                    let userWordCount = UserDefaults.standard.integer(forKey: "userWordCount")
                    UserDefaults.standard.set(userWordCount-1, forKey: "userWordCount")
                    self.findUserPoint()
                    if self.itemArray.count > 0 {
                        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
                    } else {
                        tableView.reloadData()
                    }
                    self.dismiss(animated: true, completion: nil)
                }
                let actionCancel = UIAlertAction(title: "İptal", style: UIAlertAction.Style.cancel) { (action) in
                    // what will happen once user clicks the cancel item button on UIAlert
                    alert.dismiss(animated: true, completion: nil)
                }
                alert.addAction(action)
                alert.addAction(actionCancel)
                self.present(alert, animated: true, completion: nil)
            } else {
                self.context.delete(self.itemArray[indexPath.row])
                self.itemArray.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.left)
                self.saveItems()
                self.changeSearchBarPlaceholder()
                let userWordCount = UserDefaults.standard.integer(forKey: "userWordCount")
                UserDefaults.standard.set(userWordCount-1, forKey: "userWordCount")
                self.findUserPoint()
            }
            success(true)
        })
        deleteAction.image = UIGraphicsImageRenderer(size: CGSize(width: 25, height: 25)).image { _ in
            UIImage(named: "bin")?.draw(in: CGRect(x: 0, y: 0, width: 25, height: 25)) }
        deleteAction.backgroundColor = UIColor.systemRed
        
        let editAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in

            self.goEdit = 1
            self.editIndex = indexPath.row
            let engEdit = self.itemArray[indexPath.row].eng
            let trEdit = self.itemArray[indexPath.row].tr
            UserDefaults.standard.set(engEdit, forKey: "engEdit")
            UserDefaults.standard.set(trEdit, forKey: "trEdit")
            self.performSegue(withIdentifier: "goAdd", sender: self)
            
            
            success(true)
        })
        editAction.image = UIGraphicsImageRenderer(size: CGSize(width: 25, height: 25)).image { _ in
            UIImage(named: "edit")?.draw(in: CGRect(x: 0, y: 0, width: 25, height: 25)) }
        editAction.backgroundColor = UIColor(red: 0.46, green: 0.62, blue: 0.80, alpha: 1.00)
        
        let addAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
     
            if self.itemArray[indexPath.row].add == false {
                let newItem = HardItem(context: self.context)
                newItem.eng = self.itemArray[indexPath.row].eng
                newItem.tr = self.itemArray[indexPath.row].tr
                newItem.uuid = self.itemArray[indexPath.row].uuid
                newItem.originalindex = Int32(indexPath.row)
                newItem.originalList = "MyWords"
                newItem.date = Date()
                newItem.correctNumber = 5
                self.HardItemArray.append(newItem)
                
                // the word ADD to hard words
                self.itemArray[indexPath.row].add = true
                let lastCount = UserDefaults.standard.integer(forKey: "hardWordsCount")
                UserDefaults.standard.set(lastCount+1, forKey: "hardWordsCount")

                do {
                    try self.context.save()
                } catch {
                   print("Error saving context \(error)")
                }
                
                self.loadItems()
                
                let alert = UIAlertController(title: "Zor kelimeler sayfasına eklendi", message: "", preferredStyle: .alert)
                // dismiss alert after 1 second
                let when = DispatchTime.now() + 1
                DispatchQueue.main.asyncAfter(deadline: when){
                  alert.dismiss(animated: true, completion: nil)
                }
                self.present(alert, animated: true, completion: nil)
            } else {
                    let alert = UIAlertController(title: "Zaten mevcut", message: "", preferredStyle: .alert)

                    // dismiss alert after 1 second
                    let when = DispatchTime.now() + 1
                    DispatchQueue.main.asyncAfter(deadline: when){
                      alert.dismiss(animated: true, completion: nil)
                    }
               
                    self.present(alert, animated: true, completion: nil)
            }

            success(true)
        })
        addAction.image = UIGraphicsImageRenderer(size: CGSize(width: 25, height: 25)).image { _ in
            UIImage(named: "plus")?.draw(in: CGRect(x: 0, y: 0, width: 25, height: 25)) }
        addAction.backgroundColor = UIColor(red: 1.00, green: 0.75, blue: 0.28, alpha: 1.00)
        

        
        if showWords == 1 {
            if self.itemArray[indexPath.row].add == true {
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
extension myWordsViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(myWordsViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

