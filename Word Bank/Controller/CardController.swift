//
//  CardViewController.swift
//  Twenty Three
//
//  Created by ibrahim uysal on 20.03.2022.
//

import UIKit
import CoreData

class CardController: UIViewController {
    
    //MARK: - Variables
    
    private let exerciseType: String
    private let exerciseFormat: String
    
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
    
    private var questionArray = [String]()
    private var answerArray = [String]()
    private var userAnswerArray = [String]()
    private var userAnswerArrayBool = [Bool]()
    
    //MARK: - Life Cycle
    
    init(exerciseType: String, exerciseFormat: String) {
        self.exerciseType = exerciseType
        self.exerciseFormat = exerciseFormat
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserDefault.addedHardWordsCount.set(0)
        wordBrain.loadItemArray()
        style()
        layout()
        updateWord()
        addGestureRecognizer()
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
    
    private func updateCard(_ card: UIView) {
        card.alpha = 0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3){
            self.resetCard(card)
            self.updateWord()
        }
    }
    
    private func addHardWord() {
        let questionNumber = wordBrain.getQuestionNumber()
        if itemArray[questionNumber].addedHardWords == false {
            wordBrain.addWordToHardWords(questionNumber)
        }
    }
    
    private func updateWord() {
        if cardCounter == 20 {
            let controller = ResultController(exerciseType: exerciseType,
                                                  exerciseFormat: exerciseFormat)
            controller.questionArray = questionArray
            controller.answerArray = answerArray
            controller.userAnswerArray = userAnswerArray
            controller.userAnswerArrayBool = userAnswerArrayBool
            self.navigationController?.pushViewController(controller, animated: true)
        } else {
            wordEnglish = wordBrain.getWordEnglish()
            wordMeaning = wordBrain.getWordMeaning()
            cardCounter += 1
            cardLabel.text = wordEnglish
            questionArray.append(wordEnglish)
            answerArray.append(wordMeaning)
            userAnswerArray.append(wordMeaning)
        }
    }
    
    //MARK: - Selectors
    
    @objc private func flipCard(_ sender:UITapGestureRecognizer) {
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

extension CardController {
    
    private func style() {
        configureNavigationBar()
        view.backgroundColor = Colors.ravenShadow
        
        cardView.backgroundColor = Colors.raven
        cardView.layer.cornerRadius = 16
        
        backgroundCardView.backgroundColor = Colors.raven
        backgroundCardView.layer.cornerRadius = 16
        
        cardLabel.textColor = .white
        cardLabel.font = UIFont(name: Fonts.AvenirNextDemiBold, size: 25)
        cardLabel.textAlignment = .center
        cardLabel.lineBreakMode = .byWordWrapping
        cardLabel.numberOfLines = 0
        
        imageView.alpha = 0
    }
    
    private func layout() {
        
        cardView.addSubview(imageView)
        cardView.addSubview(cardLabel)
        
        view.addSubview(backgroundCardView)
        view.addSubview(cardView)
        
        cardView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                        bottom: view.bottomAnchor, right: view.rightAnchor,
                        paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
        backgroundCardView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,
                                  bottom: view.bottomAnchor, right: view.rightAnchor,
                                  paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        
        imageView.setDimensions(width: 100, height: 100)
        imageView.centerY(inView: cardView)
        imageView.centerX(inView: cardView)
        
        cardLabel.centerX(inView: cardView)
        cardLabel.centerY(inView: cardView)
        cardLabel.anchor(left: cardView.leftAnchor, right: cardView.rightAnchor,
                         paddingLeft: 16, paddingRight: 16)
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.topItem?.backButtonTitle = "Back"
    }
}

//MARK: - Swipe Gesture

extension CardController {
    
    private func addGestureRecognizer() {
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
                    self.userAnswerArrayBool.append(false)
                })
                return
            } else if card.center.x > (view.frame.width - 75) {
                //move off the right side
                UIView.animate(withDuration: 0.3, animations: {
                    card.center = CGPoint(x: card.center.x + 200, y: card.center.y + 75)
                    self.updateCard(card)
                    self.userAnswerArrayBool.append(true)
                })
                return
            }
            resetCard(card)
        }
    }
}
