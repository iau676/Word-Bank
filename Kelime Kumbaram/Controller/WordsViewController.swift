//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import CoreData

class WordsViewController: UIViewController {
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var startButton2: UIButton!
    @IBOutlet weak var startButton3: UIButton!
    @IBOutlet weak var startButton4: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var expandButton: UIButton!
    @IBOutlet weak var emptyView: UIView!
    
    var selectedSegmentIndex = 0
    var wordBrain = WordBrain()
    var showWords = 0

    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var itemArray = [Item]()
    var HardItemArray = [HardItem]()
    var quizCoreDataArray = [AddedList]()
    
    var textForLabel = ""
    var userWordCount = ""
    var numberForAlert = 0
    
    var expandIconName = ""
    var notExpandIconName = ""
    
    
    @IBOutlet weak var emptyViewConstraint: NSLayoutConstraint!
    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.register(UINib(nibName: "WordCell", bundle: nil), forCellReuseIdentifier:"ReusableCell")
        tableView.tableFooterView = UIView()

        setupView()
        
        loadItems() //load hard items
        numberForAlert = HardItemArray.count

        //it will run when user reopen the app after pressing home button
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateTable), name: UIApplication.didBecomeActiveNotification, object: nil)
       
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
                print("nothing#viewWillAppear")
                }
        
        
        loadItems()
        loadItemsToItemArray()
 
        if UserDefaults.standard.string(forKey: "whichButton") == "yellow" {
            showAlert(HardItemArray.count)
            showWords = 1
            expandButton.isHidden = true
            startButton4.isHidden = true
            updateView()
        } else {
            showWords = 0
            expandButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 35, height: 25)).image { _ in
                UIImage(named: expandIconName)?.draw(in: CGRect(x: 0, y: 0, width: 35, height: 25)) }, for: .normal)
            
        }
        
        tableView.reloadData()
    }

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "goNewPoint" {
                let destinationVC = segue.destination as! NewPointViewController
                destinationVC.textForLabel = textForLabel
                destinationVC.userWordCount = userWordCount
            }
        
            if segue.identifier == "goCard" {
                let destinationVC = segue.destination as! CardViewController
                destinationVC.quizCoreDataArray = quizCoreDataArray
            }
        }
    
    

    
    //MARK: - loadItems
    func loadItems(with request: NSFetchRequest<HardItem> = HardItem.fetchRequest()){
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
            HardItemArray = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
       // self.tableView.reloadData()
    }
    
    func loadItemsToItemArray(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        do {
           // request.sortDescriptors = [NSSortDescriptor(key: "eng", ascending: false)]
            itemArray = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
    }
    
    //MARK: - setup
    func setupView(){
        title = "Zor Kelimeler"
        
        let gradient = CAGradientLayer()
        gradient.frame = view.bounds
        gradient.colors = [UIColor(named: "yellowColor")!.cgColor, UIColor(named: "yellowColorBottom")!.cgColor]
        mainView.layer.insertSublayer(gradient, at: 0)
        
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

        
        startButton.layer.cornerRadius = 10
        startButton2.layer.cornerRadius = 10
        startButton3.layer.cornerRadius = 10
        startButton4.layer.cornerRadius = 10
        expandButton.layer.cornerRadius = 10
        tableView.layer.cornerRadius = 10
        
        let backButton = UIBarButtonItem()
        backButton.title = "Geri"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }//setupView
    
    @objc func updateTable(){
        updateView()
        tableView.reloadData()
    }
    
    func updateView(){
        if showWords == 0 {
            
            expandButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 35, height: 25)).image { _ in
                UIImage(named: expandIconName)?.draw(in: CGRect(x: 0, y: 0, width: 35, height: 25)) }, for: .normal)
            
            UIView.transition(with: emptyView, duration: 0.6,
                              options: .transitionCrossDissolve,
                              animations: {
                self.emptyView.isHidden = false
                          })
            
            UIView.transition(with: tableView, duration: 0.6,
                              options: .transitionCrossDissolve,
                              animations: {
                let newConstraint2 = self.stackViewConstraint.constraintWithMultiplier(0.7)
                                self.stackViewConstraint.isActive = false
                                self.view.addConstraint(newConstraint2)
                                self.view.layoutIfNeeded()
                                self.stackViewConstraint = newConstraint2
                          })
            tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: CGFloat(66*wordBrain.pageStatistic.count-1));
        } else {
            
            expandButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 35, height: 25)).image { _ in
                UIImage(named: notExpandIconName)?.draw(in: CGRect(x: 0, y: 0, width: 35, height: 25)) }, for: .normal)
            
            UIView.transition(with: emptyView, duration: 0.6,
                              options: .transitionCrossDissolve,
                              animations: {
                                    self.emptyView.isHidden = true
                          })
            
            UIView.transition(with: emptyView, duration: 0.6,
                              options: .transitionCrossDissolve,
                              animations: {
                                let newConstraint2 = self.stackViewConstraint.constraintWithMultiplier(0.2)
                                self.stackViewConstraint.isActive = false
                                self.view.addConstraint(newConstraint2)
                                self.view.layoutIfNeeded()
                                self.stackViewConstraint = newConstraint2
                          })
        }

    }
    
    //MARK: - user did something
    
    @IBAction func expandButtonPressed(_ sender: UIButton) {
        
        if showWords == 0 {
            showWords = 1
        } else {
            showWords = 0
        }
        updateView()
        tableView.reloadData()
       
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        UserDefaults.standard.set(1, forKey: "startPressed")
        startButton.pulstate()
        check2Items()
    }
    
    
    @IBAction func start2Pressed(_ sender: UIButton) {
        UserDefaults.standard.set(2, forKey: "startPressed")
        startButton2.pulstate()
        check2Items()
    }
    
    
    @IBAction func start3Pressed(_ sender: UIButton) {
        UserDefaults.standard.set(3, forKey: "startPressed")
        startButton3.pulstate()
        
        //0 is true, 1 is false
        if UserDefaults.standard.integer(forKey: "playSound") == 0 {
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
    
    @IBAction func start4Pressed(_ sender: UIButton) {
        startButton4.pulstate()
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when){
            self.performSegue(withIdentifier: "goCard", sender: self)
        }
    }
    
    
    
    func check2Items() {
        // 2 words required
        if UserDefaults.standard.string(forKey: "whichButton") == "yellow" {
            if UserDefaults.standard.integer(forKey: "hardWordsCount") < 2 {
                let alert = UIAlertController(title: "En az iki kelime gereklidir", message: "", preferredStyle: .alert)
                let action = UIAlertAction(title: "Tamam", style: .default) { (action) in
                    // what will happen once user clicks the add item button on UIAlert
                    self.navigationController?.popToRootViewController(animated: true)
                }
                alert.addAction(action)
                present(alert, animated: true, completion: nil)
            }
            else{
                let when = DispatchTime.now() + 0.1
                DispatchQueue.main.asyncAfter(deadline: when){
                    self.performSegue(withIdentifier: "goToQuiz", sender: self)
                }
            }
        } else {
            
            let when = DispatchTime.now() + 0.1
            DispatchQueue.main.asyncAfter(deadline: when){
                self.performSegue(withIdentifier: "goToQuiz", sender: self)
            }
        }
    }
    


    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            self.navigationController?.popToRootViewController(animated: true)
            break
        case .down:
                if showWords == 0 {
                    showWords = 1
                    updateView()
                    tableView.reloadData()
                }
            break
        default:
            print("nothing")
        }
    }
    
}
//MARK: - show words
extension WordsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return showWords == 0 ? wordBrain.pageStatistic.count : HardItemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! WordCell

        
        cell.engLabel.font = cell.engLabel.font.withSize(CGFloat(UserDefaults.standard.integer(forKey: "textSize")))
        
        cell.trLabel.font = cell.trLabel.font.withSize(CGFloat(UserDefaults.standard.integer(forKey: "textSize")))
        
        cell.numberLabel.font = cell.numberLabel.font.withSize(CGFloat(UserDefaults.standard.integer(forKey: "textSize")-4))
        cell.numberLabel.textColor = .darkGray


        if showWords == 1 {
            tableView.rowHeight = UITableView.automaticDimension
            tableView.backgroundColor = UIColor(named: "rightCelerColor")
            cell.engView.isHidden = false
            tableView.isScrollEnabled = true
            
            if selectedSegmentIndex == 0 {
                showAlert(HardItemArray.count)
                cell.engLabel.text = HardItemArray[indexPath.row].eng
                cell.trLabel.text = HardItemArray[indexPath.row].tr
                
            } else {
                showAlert(HardItemArray.count)
                cell.trLabel.text = HardItemArray[indexPath.row].eng
                cell.engLabel.text = HardItemArray[indexPath.row].tr
            }
            
        } else {
            cell.engView.isHidden = true
            
            cell.trLabel.text = wordBrain.pageStatistic[indexPath.row]
            cell.numberLabel.text = ""
            
            tableView.backgroundColor = UIColor.clear
            tableView.rowHeight = 66
            tableView.isScrollEnabled = false

            tableView.frame = CGRect(x: tableView.frame.origin.x, y: tableView.frame.origin.y, width: tableView.frame.size.width, height: CGFloat(66*wordBrain.pageStatistic.count-1));
        }

        return cell
    }
    
    func showAlert(_ hardItemArrayCount: Int){
        if hardItemArrayCount <= 0 {
            let alert = UIAlertController(title: "Burada henüz bir şey yok", message: "Kumbaram sayfasındaki alıştırmalarda bir kelimeyi yanlış cevapladığınızda o kelime bu sayfaya eklenir. Kelimenin bu sayfadan silinmesi için 5 defa doğru cevaplanması gerekir.", preferredStyle: .alert)
                            
            let action = UIAlertAction(title: "Tamam", style: .default) { (action) in
                // what will happen once user clicks the add item button on UIAlert
                self.navigationController?.popToRootViewController(animated: true)
            }
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        } 
    }
}


extension WordsViewController:UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
