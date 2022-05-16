//
//  CardViewController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 20.03.2022.
//

import UIKit
import CoreData

class CardViewController: UIViewController {
    
    @IBOutlet var mainView: UIView!
    
    
    @IBOutlet weak var tableView: UITableView!
    var wordBrain = WordBrain()
    
    var quizCoreDataArray = [AddedList]()
    var itemArray = [Item]()
    
    var cardCounter = 0
    var questionNumber = 0
    var questionENG = ""
    var questionTR = ""
    
    var whichButton = ""
    var lastPoint = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "WordCell", bundle: nil), forCellReuseIdentifier:"ReusableCell")
        tableView.tableFooterView = UIView()
        lastPoint = UserDefaults.standard.integer(forKey: "lastPoint")
        whichButton = UserDefaults.standard.string(forKey: "whichButton")!
        //delete navigation bar background
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
       
        updateText()
        tableView.reloadData()
    }
    
    func updateText(){

        questionNumber = Int.random(in: 0..<itemArray.count)
        questionENG = itemArray[questionNumber].eng ?? "empty"
        questionTR = itemArray[questionNumber].tr ?? "empty"
        cardCounter += 1
        lastPoint += 1
        if cardCounter == 26 {
            performSegue(withIdentifier: "goToResult", sender: self)
        } else {
            UserDefaults.standard.set(lastPoint, forKey: "lastPoint")
        }
        //print("cardCounter##\(cardCounter)")
       
    }
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        
        updateText()
        tableView.isHidden = true
        UIView.transition(with: tableView, duration: 1.0,
                          options: .transitionCurlUp,
                          animations: {
                            self.tableView.isHidden = false
                      })
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.cardCounter = cardCounter
            destinationVC.itemArray = itemArray
            destinationVC.quizCoreDataArray = quizCoreDataArray
        }
    }
    
}

//MARK: - show words
extension CardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! WordCell
        
        cell.engView.isHidden = true
        cell.trLabel.textAlignment = .center
        cell.trView.backgroundColor = UIColor(named: "quizBackground")
        cell.trLabel.textColor = UIColor(named: "d6d6d6")
        cell.trLabel.attributedText = writeAnswerCell(questionENG, questionTR)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return tableView.frame.height
    }
    
    func writeAnswerCell(_ eng: String, _ tr: String) -> NSMutableAttributedString{
        
        let boldFontAttributes = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: CGFloat(UserDefaults.standard.integer(forKey: "textSize")+12))]
        let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "d6d6d6"), NSAttributedString.Key.font: UIFont.systemFont(ofSize: CGFloat(UserDefaults.standard.integer(forKey: "textSize")))]
        
        let partOne = NSMutableAttributedString(string: "\(eng)\n\n", attributes: boldFontAttributes as [NSAttributedString.Key : Any])
        
        let partTwo =  NSMutableAttributedString(string: "\(tr)\n", attributes: normalFontAttributes as [NSAttributedString.Key : Any])
      
       
     
        let combination = NSMutableAttributedString()
            
    
            combination.append(partOne)
            combination.append(partTwo)
      
        
        return combination
        
    }

}

//MARK: - when cell swipe
extension CardViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {

        let addAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            
            let alert = UIAlertController(title: "Zor kelimeler sayfasına eklendi", message: "", preferredStyle: .alert)
            // dismiss alert after 1 second
            let when = DispatchTime.now() + 0.5
            DispatchQueue.main.asyncAfter(deadline: when){
              alert.dismiss(animated: true, completion: nil)
                
                self.wordBrain.addHardWords(self.questionNumber)
                
                self.updateText()
                
                tableView.isHidden = true
                UIView.transition(with: tableView, duration: 1.0,
                                  options: .transitionCurlUp,
                                  animations: {
                                    self.tableView.isHidden = false
                              })
                
                tableView.reloadData()
            }
            self.present(alert, animated: true, completion: nil)

            success(true)
        })
        addAction.image = UIGraphicsImageRenderer(size: CGSize(width: 25, height: 25)).image { _ in
            UIImage(named: "plus")?.draw(in: CGRect(x: 0, y: 0, width: 25, height: 25)) }
        addAction.backgroundColor = UIColor(red: 1.00, green: 0.75, blue: 0.28, alpha: 1.00)

            if itemArray[questionNumber].add == true {
                showAlert()
                return UISwipeActionsConfiguration()
            }
    
        return UISwipeActionsConfiguration(actions: [addAction])

    }
    
    func showAlert(){
        let alert = UIAlertController(title: "Zaten mevcut", message: "", preferredStyle: .alert)
        // dismiss alert after 1 second
        let when = DispatchTime.now() + 0.3
        DispatchQueue.main.asyncAfter(deadline: when){
          alert.dismiss(animated: true, completion: nil)
        }
        self.present(alert, animated: true, completion: nil)
    }

}
