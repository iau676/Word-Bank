//
//  CardViewController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 20.03.2022.
//

import UIKit
import CoreData

class CardViewController: UIViewController {
    
    //MARK: - IBOutlet
    
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Variables
    
    var wordBrain = WordBrain()
    var quizCoreDataArray = [AddedList]()
    var itemArray: [Item] { return wordBrain.itemArray }
    var cardCounter = 0
    var questionNumber = 0
    var lastPoint = 0
    var wordEnglish = ""
    var wordMeaning = ""
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lastPoint = UserDefault.lastPoint.getInt()
        setupTableView()
        wordBrain.loadItemArray()
        updateWord()
    }
    
    //MARK: - prepare
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToResult" {
            let destinationVC = segue.destination as! ResultViewController
            destinationVC.cardCounter = cardCounter
            //destinationVC.itemArray = itemArray
        }
    }
    
    //MARK: - IBAction
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        updateWord()
        swipeAnimation()
        tableView.reloadData()
    }
    
    //MARK: - Other Functions
    
    func setupTableView(){
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "WordCell", bundle: nil), forCellReuseIdentifier:"ReusableCell")
        tableView.tableFooterView = UIView()
    }
    
    func updateWord(){
        questionNumber = Int.random(in: 0..<itemArray.count)
        wordEnglish = itemArray[questionNumber].eng ?? "empty"
        wordMeaning = itemArray[questionNumber].tr ?? "empty"
        cardCounter += 1
        lastPoint += 1
        if cardCounter == 4 { //26
            performSegue(withIdentifier: "goToResult", sender: self)
        } else {
            UserDefault.lastPoint.set(lastPoint)
        }
        self.swipeAnimation()
        self.tableView.reloadData()
    }
    
    func swipeAnimation() {
        tableView.isHidden = true
        UIView.transition(with: tableView, duration: 1.0,
                          options: .transitionCurlUp,
                          animations: {
                            self.tableView.isHidden = false
                      })
    }
}

    //MARK: - Show Words

extension CardViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! WordCell
        cell.engView.isHidden = true
        cell.trLabel.textAlignment = .center
        cell.trView.backgroundColor = Colors.raven
        cell.trLabel.textColor = Colors.d6d6d6
        cell.trLabel.attributedText = writeAnswerCell(wordEnglish, wordMeaning)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.height
    }
    
    func writeAnswerCell(_ eng: String, _ tr: String) -> NSMutableAttributedString{
        
        let textSize = UserDefault.textSize.getCGFloat()
        
        let boldFontAttributes = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size:textSize+12)]
        
        let normalFontAttributes = [NSAttributedString.Key.foregroundColor: Colors.d6d6d6, NSAttributedString.Key.font: UIFont.systemFont(ofSize: textSize)]
        
        let english = NSMutableAttributedString(string: "\(eng)\n\n", attributes: boldFontAttributes as [NSAttributedString.Key : Any])
        
        let meaning =  NSMutableAttributedString(string: "\(tr)\n", attributes: normalFontAttributes as [NSAttributedString.Key : Any])
     
        let combination = NSMutableAttributedString()
            
        combination.append(english)
        combination.append(meaning)
    
        return combination
    }
}

    //MARK: - Swipe Cell

extension CardViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?{
        let addAction = UIContextualAction(style: .normal, title:  "", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            self.showAlert(title: "Added to Hard Words")
            self.wordBrain.addWordToHardWords(self.questionNumber)
            success(true)
        })
        addAction.setImage(imageName: "plus", width: 25, height: 25)
        addAction.setBackgroundColor(Colors.yellow)
        
        if itemArray[questionNumber].addedHardWords == true {
            showAlert(title: "Already Added")
            return UISwipeActionsConfiguration()
        }
        return UISwipeActionsConfiguration(actions: [addAction])
    }

    func showAlert(title: String){
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        let when = DispatchTime.now() + 0.5
        DispatchQueue.main.asyncAfter(deadline: when){
            alert.dismiss(animated: true, completion: nil)
            self.updateWord()
        }
        self.present(alert, animated: true, completion: nil)
    }
}
