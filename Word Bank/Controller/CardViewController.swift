//
//  CardViewController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 20.03.2022.
//

import UIKit
import CoreData

class CardViewController: UIViewController {
    
    //MARK: - Variables
    
    var wordBrain = WordBrain()
    var itemArray: [Item] { return wordBrain.itemArray }
    let cardView = UIView()
    let cardView2 = UIView()
    let cardLabel = UILabel()
    let imageView = UIImageView()
    var divisor: CGFloat!
    var cardCenter: CGPoint!
    var cardCounter = 0
    var questionNumber = 0
    var lastPoint = 0
    var wheelPressed = 0
    var wordEnglish = ""
    var wordMeaning = ""
    var isOpen = false
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBrain.loadItemArray()
        lastPoint = UserDefault.lastPoint.getInt()
        style()
        layout()
        updateWord()
        addGestureRecognizer()
        configureBackBarButton()
        divisor = (view.frame.width/2)/0.61
    }

    //MARK: - Helpers
    
    func style(){
        view.backgroundColor = Colors.ravenShadow
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = Colors.raven
        cardView.layer.cornerRadius = 16
        
        cardView2.translatesAutoresizingMaskIntoConstraints = false
        cardView2.backgroundColor = Colors.raven
        cardView2.layer.cornerRadius = 16
        
        cardLabel.translatesAutoresizingMaskIntoConstraints = false
        cardLabel.textColor = .white
        cardLabel.font = UIFont(name: "AvenirNext-DemiBold", size: 25)
        cardLabel.textAlignment = .center
        cardLabel.lineBreakMode = .byWordWrapping
        cardLabel.numberOfLines = 0
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
    }
    
    func layout(){
        
        cardView.addSubview(imageView)
        cardView.addSubview(cardLabel)
        
        view.addSubview(cardView2)
        view.addSubview(cardView)
        
        let navigationBarHeight = navigationController?.navigationBar.frame.height ?? 0
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationBarHeight+16),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            
            cardView2.topAnchor.constraint(equalTo: view.topAnchor, constant: navigationBarHeight+16),
            cardView2.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardView2.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            
            cardLabel.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
            cardLabel.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            cardLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            cardLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
        ])
    }
    
    func addGestureRecognizer(){
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        cardView.addGestureRecognizer(swipeGesture)
        
        let flipCardGesture = UITapGestureRecognizer(target: self, action:  #selector (self.flipCard(_:)))
        cardView.addGestureRecognizer(flipCardGesture)
    }
    
    func resetCard(_ card: UIView) {
        card.center = cardCenter
        self.imageView.alpha = 0
        self.cardLabel.alpha = 1
        self.cardView.alpha = 1
        self.cardView.transform = .identity
        self.isOpen = false
    }
    
    func updateCard(_ card: UIView){
        card.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3){
            self.resetCard(card)
            self.updateWord()
        }
    }
    
    func addHardWord(){
        if itemArray[questionNumber].addedHardWords == false {
            wordBrain.addWordToHardWords(questionNumber)
        }
    }
    
    func updateWord(){
        questionNumber = Int.random(in: 0..<itemArray.count)
        wordEnglish = itemArray[questionNumber].eng ?? "empty"
        wordMeaning = itemArray[questionNumber].tr ?? "empty"
        cardCounter += 1
        lastPoint += 1
        cardLabel.text = wordEnglish
        if cardCounter == 21 { //21
            performSegue(withIdentifier: "goToResult", sender: self)
        } else {
            UserDefault.lastPoint.set(lastPoint)
        }
    }
    
    func configureBackBarButton(){
        let backButton: UIButton = UIButton()
        let image = UIImage(named: "arrow_back");
        backButton.setImage(image, for: .normal)
        backButton.setTitle(" Back", for: .normal);
        backButton.titleLabel?.font =  UIFont.systemFont(ofSize: 17)
        backButton.setTitleColor(.black, for: .normal)
        backButton.sizeToFit()
        backButton.addTarget(self, action: #selector (backButtonPressed(sender:)), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: backButton)
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    //MARK: - Selectors
    
    @objc func respondToSwipeGesture(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        if cardCenter == nil { cardCenter = card.center }
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor)
        
        if xFromCenter > 0 {
            imageView.image = UIImage(named: "checkGreen")
        } else {
            imageView.image = UIImage(named: "hard")?.withTintColor(Colors.yellow ?? .yellow).withRenderingMode(.alwaysOriginal)
        }
        
        imageView.alpha = abs(xFromCenter) / view.center.x
        cardLabel.alpha = 1 - abs(xFromCenter) / view.center.x
        
        if sender.state == UIGestureRecognizer.State.ended {
            if card.center.x <  75 {
                //move off the left side
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x - 200, y: card.center.y + 75)
                    self.updateCard(card)
                    self.addHardWord()
                })
                return
            } else if card.center.x > (view.frame.width - 75) {
                //move off the right side
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    self.updateCard(card)
                })
                return
            }
            resetCard(card)
        }
    }
    
    @objc func backButtonPressed(sender : UIButton) {
        if wheelPressed == 1 {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func flipCard(_ sender:UITapGestureRecognizer){
        if isOpen {
            isOpen = false
            cardLabel.text = wordEnglish
            UIView.transition(with: cardView, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        } else {
            isOpen = true
            cardLabel.text = wordMeaning
            UIView.transition(with: cardView, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
        }
    }
}
