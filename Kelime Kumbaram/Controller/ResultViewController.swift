//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import CoreData
import AVFoundation
import Combine

class ResultViewController: UIViewController {
    
    //This didn't crash my app but caused a memory leak every time AVSpeechSynthesizer was declared. I solved this by declaring the AVSpeechSynthesizer as a global variable
    static let synth = AVSpeechSynthesizer()
    
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var homeButton: UIButton!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var addedHardWordsLabel: UILabel!
    @IBOutlet weak var confettiButton: UIButton!
    
    @IBOutlet weak var showWordsButton: UIButton!
    
    var playerMP3: AVAudioPlayer!
    
    var itemArray = [Item]()
    var HardItemArray = [HardItem]()
    var quizCoreDataArray = [AddedList]()
    var isWordAddedToHardWords = 0
    var showTable = 1
    
    var wordBrain = WordBrain()
    var option = ""
    var textForLabel = ""
    var userWordCount = ""
    var scoreLabelText = ""
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let fiveIndex =  UserDefaults.standard.array(forKey: "fiveIndex") as? [Int] ?? [Int]()
    
    let arrayOfIndex =  UserDefaults.standard.array(forKey: "rightOnce") as? [Int] ?? [Int]()
    
    let arrayOfBool =  UserDefaults.standard.array(forKey: "rightOnceBool") as? [Bool] ?? [Bool]()
    
    let arrayForResultViewENG = UserDefaults.standard.array(forKey: "arrayForResultViewENG") as? [String] ?? [String]()
    
    let arrayForResultViewTR = UserDefaults.standard.array(forKey: "arrayForResultViewTR") as? [String] ?? [String]()
    
    let arrayForResultViewUserAnswer = UserDefaults.standard.array(forKey: "arrayForResultViewUserAnswer") as? [String] ?? [String]()
    
    var selectedSegmentIndex = UserDefaults.standard.integer(forKey: "selectedSegmentIndex")
    
    var numberOfTrue = 0
    
    var whichStartPressed = 0
    
    var lastLevel:Int = 0
    var newLevel:Int = 0
    var cardCounter = 0
    var textSize = CGFloat()
    var soundSpeed = Float()
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?
    private let notificationCenter = NotificationCenter.default
    private var appEventSubscribers = [AnyCancellable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        whichStartPressed = UserDefaults.standard.integer(forKey: "startPressed")
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "WordCell", bundle: nil), forCellReuseIdentifier:"ReusableCell")
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(red: 0.20, green: 0.24, blue: 0.35, alpha: 1.00)
        tableView.layer.cornerRadius = 10
        
        lastLevel = UserDefaults.standard.integer(forKey: "level")
         _ = wordBrain.calculateLevel()
        newLevel = UserDefaults.standard.integer(forKey: "level")
         
        
        
        soundSpeed = UserDefaults.standard.float(forKey: "soundSpeed")
        textSize = CGFloat(UserDefaults.standard.integer(forKey: "textSize"))
        scoreLabel.font = scoreLabel.font.withSize(23)
        addedHardWordsLabel.font = addedHardWordsLabel.font.withSize(textSize)
        showWordsButton.titleLabel?.font =  showWordsButton.titleLabel?.font.withSize(textSize)
        
        
        showWordsButton.isHidden = true
        showTable = 1
        
        for i in 0..<arrayOfBool.count {
            if arrayOfBool[i] == true {
                numberOfTrue += 1
            }
        }
        UserDefaults.standard.set(0, forKey: "goLevelUp")
     
        
        if newLevel - lastLevel > 0 {
            performSegue(withIdentifier: "goLevelUp", sender: self)
        }
        
        if UserDefaults.standard.string(forKey: "whichButton") == "blue" {
            
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "blueExerciseCount")+1, forKey: "blueExerciseCount")
            
            if numberOfTrue == arrayOfBool.count {
                UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "blueAllTrue")+1, forKey: "blueAllTrue")
            }
            
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "blueTrueCount")+numberOfTrue, forKey: "blueTrueCount")
            
            UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "blueFalseCount")+(arrayOfBool.count-numberOfTrue), forKey: "blueFalseCount")
            
            
            switch whichStartPressed {
            case 1:
                UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "start1count")+1, forKey: "start1count")
                break
            case 2:
                UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "start2count")+1, forKey: "start2count")
                break
            case 3:
                UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "start3count")+1, forKey: "start3count")
                break
            case 4:
                UserDefaults.standard.set(UserDefaults.standard.integer(forKey: "start4count")+1, forKey: "start4count")
                break
            default:
                print("success_")
            }
        }//blue
        

    } //viewdidload
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)

        if UserDefaults.standard.string(forKey: "whichButton") == "yellow" && UserDefaults.standard.integer(forKey: "hardWordsCount") < 2 {
            refreshButton.isHidden = true
        } else {
            refreshButton.isHidden = false
        }
      
        
        print("whichStartPressed>>\(whichStartPressed)")
        
        if whichStartPressed == 4 {
            scoreLabelText = "25 kelime inceleyerek\n25 puan kazandınız!"
            numberOfTrue = arrayOfBool.count
         
        } else {
            
            updateHardWordText()
            loadsQuizCoreDataArray()
            
            scoreLabel.text = "\(numberOfTrue)/\(arrayOfBool.count)"
            
            scoreLabelText = "Hepsi doğru!"
            
            if UserDefaults.standard.string(forKey: "whichButton") == "green" {
                numberOfTrue = arrayOfBool.count
                scoreLabelText = "5 yeni \nkelime öğrendiniz"
            }
           
            
        } // whichStartPressed == 4
        
        
        if numberOfTrue == arrayOfBool.count {
            showWordsButton.isHidden = false
            tableView.backgroundColor = .clear
            showTable = 0
            observeAppEvents()
            setupPlayerIfNeeded()
            restartVideo()
            confettiButton.isHidden = true
            scoreLabel.text = scoreLabelText
            
//                let when = DispatchTime.now() + 26
//                                    DispatchQueue.main.asyncAfter(deadline: when){
//                                        self.pauseVideo()
//                                    }
        }
        
        if whichStartPressed == 4 {
            addedHardWordsLabel.isHidden = true
            showWordsButton.isHidden = true
        }
        
    }


    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        removeAppEventsSubscribers()
        removePlayer()
    }

    
    //MARK: - findUserPoint
    func findUserPoint(){ //using after delete a word
        
        let userWordCountIntVariable = UserDefaults.standard.integer(forKey: "userWordCount")
        let lastPoint = UserDefaults.standard.integer(forKey: "pointForMyWords")
        print("userWordCountIntVariable>>\(userWordCountIntVariable)")
        print("lastPoint>>\(lastPoint)")
        if userWordCountIntVariable >= 100 {
           let newPoint = userWordCountIntVariable/100*2 + 12
            if newPoint - lastPoint > 0 {
                textForLabel = "Her doğru cevap için\n +\(newPoint-10) puan alacaksınız."
                userWordCount = String(userWordCountIntVariable)
                UserDefaults.standard.set(newPoint, forKey: "pointForMyWords")
                UserDefaults.standard.set(1, forKey: "goLevelUp")
                performSegue(withIdentifier: "goNewPoint", sender: self)
            }
        } else {
            var newPoint = 0
            if  userWordCountIntVariable >= 10{
                if userWordCountIntVariable < 50 {
                    newPoint = 11
                } else {
                    newPoint = 12
                }
                if newPoint - lastPoint > 0 {
                    textForLabel = "Her doğru cevap için\n +\(newPoint-10) puan kazanacaksınız."
                    userWordCount = String(userWordCountIntVariable)
                    UserDefaults.standard.set(newPoint, forKey: "pointForMyWords")
                    UserDefaults.standard.set(1, forKey: "goLevelUp")
                    performSegue(withIdentifier: "goNewPoint", sender: self)
                }
            }
        }
    }
    
    func updateHardWordText(){
        //print how many words added to hard words
        if isWordAddedToHardWords > 0 {
            addedHardWordsLabel.text = "Zor Kelimeler sayfasına \(isWordAddedToHardWords) kelime eklendi."
        } else {
            addedHardWordsLabel.text = ""
        }
    }

    @IBAction func showWordsButtonPressed(_ sender: UIButton) {
        showTable = (showTable==0) ? 1 : 0
        let title = (showTable==0) ? "Kelimeleri Göster" : "Kelimeleri Gizle"
        showWordsButton.setTitle(title, for: UIControl.State.normal)
        self.tableView.reloadData()
    }
    
    
    @IBAction func goHomePressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func refreshPressed(_ sender: Any) {
        
        if option == "my"
        {
            performSegue(withIdentifier: "goToMyQuiz", sender: self)
        }
        else
        {

            if whichStartPressed == 4 {
                performSegue(withIdentifier: "goCard", sender: self)
            } else {
                performSegue(withIdentifier: "goToQuiz", sender: self)
            }
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToMyQuiz" {
            let destinationVC = segue.destination as! MyQuizViewController
            destinationVC.itemArray = itemArray
        }
        
        
        if segue.identifier == "goCard" {
            let destinationVC = segue.destination as! CardViewController
            
            if UserDefaults.standard.string(forKey: "whichButton") == "green" {
                destinationVC.quizCoreDataArray = quizCoreDataArray
            } else {
                destinationVC.itemArray = itemArray
            }
        }
        
        if segue.identifier == "goNewPoint" {
            let destinationVC = segue.destination as! NewPointViewController
            destinationVC.textForLabel = textForLabel
            destinationVC.userWordCount = userWordCount
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer?.frame = view.bounds
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    private func setupViews() {

    }
    
    private func buildPlayer() -> AVPlayer? {
        guard let filePath = Bundle.main.path(forResource: "newpoint", ofType: "mp4") else { return nil }
        let url = URL(fileURLWithPath: filePath)
        let player = AVPlayer(url: url)
        player.actionAtItemEnd = .none
        player.isMuted = true
        // None of our movies should interrupt system music playback.
            _ = try? AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: .default, options: .mixWithOthers)
        return player
    }
    
    private func buildPlayerLayer() -> AVPlayerLayer? {
        let layer = AVPlayerLayer(player: player)
        layer.videoGravity = .resizeAspectFill
        return layer
    }
    
    private func playVideo() {
        player?.play()
    }
    
    private func restartVideo() {
        player?.seek(to: .zero)
        playVideo()
    }
    
    private func pauseVideo() {
        player?.pause()
    }
    
    private func setupPlayerIfNeeded() {
        player = buildPlayer()
        playerLayer = buildPlayerLayer()
        
        if let layer = self.playerLayer,
            view.layer.sublayers?.contains(layer) == false {
            view.layer.insertSublayer(layer, at: 0)
        }
    }
    
    private func removePlayer() {
        player?.pause()
        player = nil
        playerLayer?.removeFromSuperlayer()
        playerLayer = nil
    }
    
    private func observeAppEvents() {
        
        notificationCenter.publisher(for: .AVPlayerItemDidPlayToEndTime).sink { [weak self] _ in
            self?.restartVideo()
        }.store(in: &appEventSubscribers)
        
        notificationCenter.publisher(for: UIApplication.willResignActiveNotification).sink { [weak self] _ in
            self?.pauseVideo()
        }.store(in: &appEventSubscribers)
        
        notificationCenter.publisher(for: UIApplication.didBecomeActiveNotification).sink { [weak self] _ in
            self?.playVideo()
        }.store(in: &appEventSubscribers)
    }
    
    private func removeAppEventsSubscribers() {
        appEventSubscribers.forEach { subscriber in
            subscriber.cancel()
        }
    }
    
    
    func playMP3(_ soundName: String)
    {
        if UserDefaults.standard.integer(forKey: "playAppSound") == 0 {
            let url = Bundle.main.url(forResource: "/sounds/\(soundName)", withExtension: "mp3")
            playerMP3 = try! AVAudioPlayer(contentsOf: url!)
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback)
                 try AVAudioSession.sharedInstance().setActive(true)
               } catch {
                 print(error)
               }
            playerMP3.play()
        }
        
    }
}

extension ResultViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if whichStartPressed == 4 {
            return 0
        }
        
        if UserDefaults.standard.string(forKey: "whichButton") == "green" {
            return (showTable==1) ? 5 : 0
        } else {
            return (showTable==1) ? arrayOfBool.count : 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReusableCell", for: indexPath) as! WordCell
        
        cell.numberLabel.text = String(indexPath.row+1)
        
        cell.engLabel.textColor = UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.00)
        cell.trLabel.textColor = UIColor(red: 0.17, green: 0.17, blue: 0.18, alpha: 1.00)

            let i = arrayOfIndex[indexPath.row]
            
            if whichStartPressed != 1 {
                selectedSegmentIndex = 1
            }
            
            if option == "my"
            {
                if selectedSegmentIndex == 0 {
                    cell.engLabel.text = itemArray[i].eng
                    cell.trLabel.text = itemArray[i].tr
                } else {
                    cell.engLabel.text = itemArray[i].tr
                    cell.trLabel.text = itemArray[i].eng
                }
                
            } else {
           
                    if selectedSegmentIndex == 0 {
                        cell.engLabel.text = arrayForResultViewENG[indexPath.row]
                        cell.trLabel.text = arrayForResultViewTR[indexPath.row]
                    } else {
                        cell.engLabel.text = arrayForResultViewTR[indexPath.row]
                        cell.trLabel.text = arrayForResultViewENG[indexPath.row]
                    }
            }
            
            
            if arrayOfBool[indexPath.row] == false {
                cell.trView.backgroundColor = UIColor(red: 1.00, green: 0.56, blue: 0.62, alpha: 1.00)
                cell.engView.backgroundColor = UIColor(red: 0.92, green: 0.36, blue: 0.44, alpha: 1.00)
                
                if option == "my" {
                    cell.trLabel.attributedText = writeAnswerCell(arrayForResultViewUserAnswer[indexPath.row].strikeThrough(), (selectedSegmentIndex==0 ? itemArray[i].tr : itemArray[i].eng) ?? "empty")
                } else {
                    
                        cell.trLabel.attributedText = writeAnswerCell(arrayForResultViewUserAnswer[indexPath.row].strikeThrough(), selectedSegmentIndex == 0 ? arrayForResultViewTR[indexPath.row] : arrayForResultViewENG[indexPath.row])
                    
                }
                
            }
            else
            {
                cell.trView.backgroundColor = UIColor(red: 0.44, green: 0.86, blue: 0.73, alpha: 1.00)
                cell.engView.backgroundColor = UIColor(red: 0.09, green: 0.75, blue: 0.55, alpha: 1.00)
            }
            
            
            cell.engLabel.font = cell.engLabel.font.withSize(CGFloat(textSize))
            
            cell.trLabel.font = cell.trLabel.font.withSize(CGFloat(textSize))
            
            cell.numberLabel.font = cell.numberLabel.font.withSize(CGFloat(textSize-4))
            
            if whichStartPressed == 3 {
                cell.engView.isHidden = true
                cell.trLabel.textAlignment = .center
            }
  
        return cell
    }
    
    
    func writeAnswerCell(_ userAnswer: NSAttributedString, _ trueAnswer: String) -> NSMutableAttributedString{
        
        let boldFontAttributes = [NSAttributedString.Key.font: UIFont(name: "AvenirNext-Medium", size: 17)]
            let normalFontAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 15)]
        let partOne = NSMutableAttributedString(string: "Cevabınız:\n", attributes: normalFontAttributes)
        
        let partTwo = userAnswer
        let partThree = NSMutableAttributedString(string: userAnswer.length == 0 ? "Doğru cevap: \n" : "\nDoğru cevap: \n", attributes: normalFontAttributes)
       
        let partFour = NSMutableAttributedString(string: trueAnswer, attributes: boldFontAttributes as [NSAttributedString.Key : Any])

        let combination = NSMutableAttributedString()
            
        if userAnswer.length != 0 {
            combination.append(partOne)
            combination.append(partTwo)
        }
            
            combination.append(partThree)
            combination.append(partFour)
        
        return combination
        
    }
    
    

    
    
    func loadsQuizCoreDataArray(with request: NSFetchRequest<AddedList> = AddedList.fetchRequest()){
       do {
          // request.sortDescriptors = [NSSortDescriptor(key: "eng", ascending: false)]
           quizCoreDataArray = try context.fetch(request)
       } catch {
          print("Error fetching data from context \(error)")
       }
         self.tableView.reloadData()
   }
    
}


//MARK: - when cell swipe
extension ResultViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if whichStartPressed == 3 {
            //playSound(text, "en-US")
            var soundName = ""
            
            switch UserDefaults.standard.string(forKey: "whichButton") {
            case "blue":
                soundName = itemArray[arrayOfIndex[indexPath.row]].eng ?? "empty"
                break
            case "yellow":
                soundName =  arrayForResultViewENG[indexPath.row]
                break
            default:
                print("nothing#tableView")
            }

            
            let u = AVSpeechUtterance(string: soundName)
                u.voice = AVSpeechSynthesisVoice(language: "en-US")
                //        u.voice = AVSpeechSynthesisVoice(language: "en-GB")
            u.rate = soundSpeed
            ResultViewController.synth.speak(u)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

}

extension String {

  /// Apply strike font on text
  func strikeThrough() -> NSAttributedString {
    let attributeString = NSMutableAttributedString(string: self)
    attributeString.addAttribute(
      NSAttributedString.Key.strikethroughStyle,
      value: 1,
      range: NSRange(location: 0, length: attributeString.length))

      return attributeString
     }
   }
