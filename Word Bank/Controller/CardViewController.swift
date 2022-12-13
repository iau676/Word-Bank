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
    
    private var wordBrain = WordBrain()
    private var itemArray: [Item] { return wordBrain.itemArray }
    private let cardView = UIView()
    private let backgroundCardView = UIView()
    private let cardLabel = UILabel()
    private let imageView = UIImageView()
    private var divisor: CGFloat!
    private var cardCenter: CGPoint!
    private var cardCounter = 0
    private var wordEnglish = ""
    private var wordMeaning = ""
    private var isOpen = false
    var wheelPressed = 0
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        wordBrain.loadItemArray()
        UserDefault.addedHardWordsCount.set(0)
        style()
        layout()
        updateWord()
        addGestureRecognizer()
        configureBackBarButton()
        divisor = (view.frame.width/2)/0.61
    }

    //MARK: - Helpers
    
    private func resetCard(_ card: UIView) {
        card.center = cardCenter
        self.imageView.alpha = 0
        self.cardLabel.alpha = 1
        self.cardView.alpha = 1
        self.cardView.transform = .identity
        self.isOpen = false
    }
    
    private func updateCard(_ card: UIView){
        card.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3){
            self.resetCard(card)
            self.updateWord()
        }
    }
    
    private func addHardWord(){
        let questionNumber = wordBrain.getQuestionNumber()
        if itemArray[questionNumber].addedHardWords == false {
            wordBrain.addWordToHardWords(questionNumber)
        }
    }
    
    private func updateWord(){
        if cardCounter == 20 {
            let vc = ResultViewController()
            self.navigationController?.pushViewController(vc, animated: true)

        } else {
            wordEnglish = wordBrain.getWordEnglish()
            wordMeaning = wordBrain.getWordMeaning()
            cardCounter += 1
            cardLabel.text = wordEnglish
        }
    }
    
    private func configureBackBarButton(){
        let backButton: UIButton = UIButton()
        let image = Images.arrow_back
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
    
    @objc private func backButtonPressed(sender : UIButton) {
        if wheelPressed == 1 {
            self.navigationController?.popToRootViewController(animated: true)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc private func flipCard(_ sender:UITapGestureRecognizer){
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

//MARK: - Layout

extension CardViewController {
    
    private func style(){
        view.backgroundColor = Colors.ravenShadow
        
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.backgroundColor = Colors.raven
        cardView.layer.cornerRadius = 16
        
        backgroundCardView.translatesAutoresizingMaskIntoConstraints = false
        backgroundCardView.backgroundColor = Colors.raven
        backgroundCardView.layer.cornerRadius = 16
        
        cardLabel.translatesAutoresizingMaskIntoConstraints = false
        cardLabel.textColor = .white
        cardLabel.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 25)
        cardLabel.textAlignment = .center
        cardLabel.lineBreakMode = .byWordWrapping
        cardLabel.numberOfLines = 0
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.alpha = 0
    }
    
    private func layout(){
        
        cardView.addSubview(imageView)
        cardView.addSubview(cardLabel)
        
        view.addSubview(backgroundCardView)
        view.addSubview(cardView)
        
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            
            backgroundCardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            backgroundCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            backgroundCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16),
            
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
}

//MARK: - Swipe Gesture

extension CardViewController {
    
    private func addGestureRecognizer(){
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        cardView.addGestureRecognizer(swipeGesture)
        
        let flipCardGesture = UITapGestureRecognizer(target: self, action:  #selector (self.flipCard(_:)))
        cardView.addGestureRecognizer(flipCardGesture)
    }
    
    @objc private func respondToSwipeGesture(_ sender: UIPanGestureRecognizer) {
        let card = sender.view!
        if cardCenter == nil { cardCenter = card.center }
        let point = sender.translation(in: view)
        let xFromCenter = card.center.x - view.center.x
        card.center = CGPoint(x: view.center.x + point.x, y: view.center.y + point.y)
        
        card.transform = CGAffineTransform(rotationAngle: xFromCenter/divisor)
        
        if xFromCenter > 0 {
            imageView.image = Images.check
        } else {
            imageView.image = Images.hard?.withTintColor(Colors.yellow ?? .yellow).withRenderingMode(.alwaysOriginal)
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
                    self.wordBrain.userSwipeLeft()
                })
                return
            } else if card.center.x > (view.frame.width - 75) {
                //move off the right side
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    self.updateCard(card)
                    self.wordBrain.userSwipeRight()
                })
                return
            }
            resetCard(card)
        }
    }
}
