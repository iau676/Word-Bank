//
//  ViewController.swift
//  23
//
//  Created by ibrahim uysal on 2.12.2021.
//

import UIKit
import AVFoundation
import CoreData
import UserNotifications

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var darkView: UIView!
    
    @IBOutlet weak var levelStackView: UIStackView!
    @IBOutlet weak var titleView: UIView!
    
    @IBOutlet weak var buttonView: UIView!
    
    @IBOutlet weak var levelView: UIView!
    
    @IBOutlet weak var x2view: UIView!
    
    @IBOutlet weak var x2button: UIButton!
    
    @IBOutlet weak var levelLabel: UILabel!

    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!
    
    @IBOutlet weak var settingsButton: UIButton!
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var scoreView: UIView!
    
    @IBOutlet weak var scoreView2: UIStackView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    
    @IBOutlet weak var firstLabelConstraint: NSLayoutConstraint!
    
    var progressValue:Float = 0.0
    
    var goView = ""
    var goAddPage = 0

    var wordBrain = WordBrain()
    var quizCoreDataArray = [AddedList]()
    var itemArray = [Item]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let cp = CircularProgressView(frame: CGRect(x: 10.0, y: 10.0, width: 100.0, height: 100.0))
    let notificationCenter = UNUserNotificationCenter.current()
    
    override func viewDidLoad() {
        
        //fix sound problem for real device
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playAndRecord)
        } catch {
            assertionFailure("Failed to configure `AVAAudioSession`: \(error.localizedDescription)")
        }
        
        //loadItemsQuiz()
        
        if UserDefaults.standard.integer(forKey: "quizCoreDataArrayCount") < wordBrain.quiz.count {
            Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateCoreData), userInfo: nil, repeats: false)
        }
        
        
        if UserDefaults.standard.integer(forKey: "pointForMyWords") < 10 {
            UserDefaults.standard.set(10, forKey: "pointForMyWords")

        }
        
        if UserDefaults.standard.integer(forKey: "textSize") < 9 {
            UserDefaults.standard.set(15, forKey: "textSize")
        }
        
        notificationCenter.requestAuthorization(options: [.alert, .sound]) {
            (permissionGranted, error) in
            if(!permissionGranted)
            {
                print("Permission Denied")
            }
        }
        
        
        if UserDefaults.standard.object(forKey: "2xTime") == nil {
            //assign two day ago
            let calendar = Calendar.current
            let twoDaysAgo = calendar.date(byAdding: .day, value: -2, to: Date())
            UserDefaults.standard.set(twoDaysAgo, forKey: "2xTime")
            UserDefaults.standard.set(23, forKey: "userSelectedHour")
            UserDefaults.standard.set("empty", forKey: "lastEditLabel")
        }
        
        
        
       // print("SELECTED>>>\(UserDefaults.standard.integer(forKey: "userSelectedHour"))")
        
        settingsButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 23, height: 23)).image { _ in
            UIImage(named: "settingsImage")?.draw(in: CGRect(x: 0, y: 0, width: 23, height: 23)) }, for: .normal)
        
        blueButton.backgroundColor = UIColor(red: 0.11, green: 0.73, blue: 0.92, alpha: 1.00)
        
        greenButton.backgroundColor = UIColor(red: 0.09, green: 0.75, blue: 0.55, alpha: 1.00)
        
        yellowButton.backgroundColor = UIColor(red: 1.00, green: 0.75, blue: 0.28, alpha: 1.00)
        
        firstLabelConstraint.constant = 60

        print("hour>\(UserDefaults.standard.integer(forKey: "lastHour"))")
        getHour()
        check2xTime()
        
    }//viewdidload
    
    func setNotification(){
            
            DispatchQueue.main.async
            {
                let title = "2x Saatijjjjj 🎉"
                let message = "Bir saat boyunca her doğru cevap için 2x puan kazanacaksınız!"
                
             
                    let content = UNMutableNotificationContent()
                    content.title = title
                    content.body = message
                    
                    let date = DateComponents(hour: 23, minute: 44)
                    let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
                    
                    let id = UUID().uuidString
                    
                    let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
                    
                    
                    self.notificationCenter.removeAllPendingNotificationRequests()
                    
                    self.notificationCenter.add(request) { (error) in
                        if(error != nil)
                        {
                            print("Error " + error.debugDescription)
                            return
                        }
                    }
                    
                    print("id>>\(id)")
                    print("selected new date")
            }
    }
    
    func check2xTime(){
        if UserDefaults.standard.integer(forKey: "lastHour") == UserDefaults.standard.integer(forKey: "userSelectedHour") {
            x2view.isHidden = false
            x2button.pulstatex2()
        } else {
            x2view.isHidden = true
        }
        
    }
    
    func getHour() {
        UserDefaults.standard.set(Calendar.current.component(.hour, from: Date()), forKey: "lastHour")
        UserDefaults.standard.synchronize()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        
        if segue.identifier == "goSettings" {
            if segue.destination is SettingsViewController {
                (segue.destination as? SettingsViewController)?.onViewWillDisappear = {
                    self.check2xTime()
                }
            }
        }
        
        
        if segue.identifier == "goMyWords" {
            let destinationVC = segue.destination as! myWordsViewController
            destinationVC.goAddPage = goAddPage
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        loadItemsQuiz()

        progressValue = wordBrain.calculateLevel()
        levelLabel.text = UserDefaults.standard.string(forKey: "level")
        
        
        cp.trackColor = UIColor.white
        cp.progressColor = UIColor(red: 252.0/255.0, green: 141.0/255.0, blue: 165.0/255.0, alpha: 1.0)
        self.view.addSubview(cp)
        cp.setProgressWithAnimation(duration: 1.0, value: progressValue)
        
        let gesture = UITapGestureRecognizer(target: self, action:  #selector(self.checkAction))
        cp.addGestureRecognizer(gesture)
  
        if UserDefaults.standard.integer(forKey: "lastHour") == UserDefaults.standard.integer(forKey: "userSelectedHour") {
            x2view.isHidden = false
        } else {
            x2view.isHidden = true
        }
        

        greenButton.layer.shadowColor = UIColor(red: 0.07, green: 0.60, blue: 0.44, alpha: 1.00).cgColor
        greenButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        greenButton.layer.shadowOpacity = 1.0
        greenButton.layer.shadowRadius = 0.0
        greenButton.layer.masksToBounds = false
        greenButton.layer.cornerRadius = 17.0

        blueButton.layer.shadowColor = UIColor(red: 0.07, green: 0.60, blue: 0.75, alpha: 1.00).cgColor
        blueButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        blueButton.layer.shadowOpacity = 1.0
        blueButton.layer.shadowRadius = 0.0
        blueButton.layer.masksToBounds = false
        blueButton.layer.cornerRadius = 17.0

        yellowButton.layer.shadowColor = UIColor(red: 1.00, green: 0.66, blue: 0.03, alpha: 1.00).cgColor
        yellowButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        yellowButton.layer.shadowOpacity = 1.0
        yellowButton.layer.shadowRadius = 0.0
        yellowButton.layer.masksToBounds = false
        yellowButton.layer.cornerRadius = 17.0

        
        blueButton.layer.cornerRadius = 15
        greenButton.layer.cornerRadius = 15
        yellowButton.layer.cornerRadius = 15
 
        greenButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 35, height: 35)).image { _ in
            UIImage(named: "new")?.draw(in: CGRect(x: 0, y: 0, width: 35, height: 35)) }, for: .normal)
        
        blueButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 40, height: 40)).image { _ in
            UIImage(named: "bank")?.draw(in: CGRect(x: 0, y: 0, width: 40, height: 40)) }, for: .normal)
      
        yellowButton.setImage(UIGraphicsImageRenderer(size: CGSize(width: 35, height: 35)).image { _ in
            UIImage(named: "hard")?.draw(in: CGRect(x: 0, y: 0, width: 35, height: 35)) }, for: .normal)
        
        // back button color
        self.navigationController?.navigationBar.tintColor = UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1.00)
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor(red: 0.11, green: 0.11, blue: 0.11, alpha: 1.00)]

        //delete navigation bar background
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
            self.navigationController?.navigationBar.shadowImage = UIImage()
            self.navigationController?.navigationBar.isTranslucent = true
        
    } //viewWillAppear
    

    override func viewDidLayoutSubviews() {
        cp.center =  CGPoint(x: super.view.center.x, y:  levelView.center.y)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest()){
        do {
            request.sortDescriptors = [NSSortDescriptor(key: "date", ascending: false)]
          itemArray = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
    }
    
     func loadItemsQuiz(with request: NSFetchRequest<AddedList> = AddedList.fetchRequest()){
        do {
           // request.sortDescriptors = [NSSortDescriptor(key: "eng", ascending: false)]
            quizCoreDataArray = try context.fetch(request)
        } catch {
           print("Error fetching data from context \(error)")
        }
    }
    
    @IBAction func greenButtonPressed(_ sender: UIButton) {
        UserDefaults.standard.set("green", forKey: "whichButton")
        UserDefaults.standard.set(1, forKey: "startPressed")
        greenButton.pulstate()
        
        let when = DispatchTime.now() + 0.1
        
        viewDidLayoutSubviews()
        if UserDefaults.standard.integer(forKey: "newWord") == 1 {
            UserDefaults.standard.set("blue", forKey: "whichButton")
            goAddPage = 1
            DispatchQueue.main.asyncAfter(deadline: when){ self.performSegue(withIdentifier: "goMyWords", sender: self) }
        } else {
            var fiveIndex: [Int] = []
            var i = 0
            var firstFalseIndex = -1
            while i < quizCoreDataArray.count {
                //print(">->\(quizCoreDataArray[i].addedMyWords)---\(wordBrain.quiz.count)---\(quizCoreDataArray.count)--\(i)")
                if quizCoreDataArray[i].addedMyWords == false {
                    firstFalseIndex = i
                    i = quizCoreDataArray.count
                }
                i += 1
            }
            
            //print("=>>>\(fiveIndex)>>>\(firstFalseIndex)")
            
            if firstFalseIndex >= 0 {
                for i in 0..<5 {
                    fiveIndex.append(firstFalseIndex+i)
                }
                UserDefaults.standard.set(fiveIndex, forKey: "fiveIndex")
            }
            
            if firstFalseIndex == -1 || firstFalseIndex+4 > quizCoreDataArray.count {
                UserDefaults.standard.set("blue", forKey: "whichButton")
                goAddPage = 1
                DispatchQueue.main.asyncAfter(deadline: when){ self.performSegue(withIdentifier: "goMyWords", sender: self) }
                
            } else {
                DispatchQueue.main.asyncAfter(deadline: when){ self.performSegue(withIdentifier: "goToQuiz", sender: self) }
                
            }
        }
     
    }
    
    @IBAction func yellowButtonPressed(_ sender: UIButton) {
        UserDefaults.standard.set("yellow", forKey: "whichButton")
        yellowButton.pulstate()
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when){
            self.performSegue(withIdentifier: "goWords", sender: self)
        }
    }
    
    @IBAction func blueButtonPressed(_ sender: UIButton) {
        UserDefaults.standard.set("blue", forKey: "whichButton")
        goAddPage = 0
        
        blueButton.pulstate()
        
        let when = DispatchTime.now() + 0.1
        DispatchQueue.main.asyncAfter(deadline: when){
            self.performSegue(withIdentifier: "goMyWords", sender: self)
        }
    }
    
    @IBAction func x2ButtonPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func setNotificationFirstTime(_ sender: UIButton) {
        
        if UserDefaults.standard.integer(forKey: "setNotificationFirstTime") == 0 {
            setNotification()
            UserDefaults.standard.set(1, forKey: "setNotificationFirstTime")

            print("SET NOTİFİCATİON<<")
        }
        
    }
    
    
    
    @IBAction func swipeGesture(_ sender: UISwipeGestureRecognizer) {
        
        performSegue(withIdentifier: "goSettings", sender: self)

    }
    
    
        @objc func checkAction(sender : UITapGestureRecognizer) {
            let vc = CustomModalViewController()
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: false)
        }
    
   @objc func updateCoreData() {
       
       loadItemsQuiz()
       
        for index in quizCoreDataArray.count..<wordBrain.quiz.count {
            _ = index // noneed
            let newItem = AddedList(context: context)
            newItem.add = false
            newItem.addedMyWords = false
            quizCoreDataArray.append(newItem)
           
            //print("(((-####-->\(index)")
        }
       
       
       let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
       
       loadItems()

       do {
         try context.save()
       } catch {
          print("Error saving context \(error)")
       }
        UserDefaults.standard.set(quizCoreDataArray.count, forKey: "quizCoreDataArrayCount")
    } //updateCoreData
    
    func downsample(imageAt imageURL: URL,
                    to pointSize: CGSize,
                    scale: CGFloat = UIScreen.main.scale) -> UIImage? {

        // Create an CGImageSource that represent an image
        let imageSourceOptions = [kCGImageSourceShouldCache: false] as CFDictionary
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, imageSourceOptions) else {
            return nil
        }
        
        // Calculate the desired dimension
        let maxDimensionInPixels = max(pointSize.width, pointSize.height) * scale
        
        // Perform downsampling
        let downsampleOptions = [
            kCGImageSourceCreateThumbnailFromImageAlways: true,
            kCGImageSourceShouldCacheImmediately: true,
            kCGImageSourceCreateThumbnailWithTransform: true,
            kCGImageSourceThumbnailMaxPixelSize: maxDimensionInPixels
        ] as CFDictionary
        guard let downsampledImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, downsampleOptions) else {
            return nil
        }
        
        // Return the downsampled image as UIImage
        return UIImage(cgImage: downsampledImage)
    }
    

}

extension Int {
    func withCommas() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: NSNumber(value:self))!
    }
}

/*
 
 let newConstraint = constraintToChange.constraintWithMultiplier(4)
 constraintToChange.isActive = false
 view.addConstraint(newConstraint)
 view.layoutIfNeeded()
 constraintToChange = newConstraint
 
 */
//change constraint multiplier
extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}

extension UIButton {
    func pulstate(){
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.95
        pulse.toValue = 1
        pulse.autoreverses = true
        pulse.repeatCount = 1
        pulse.initialVelocity = 0.5
        //pulse.damping = 1.0
        
        layer.add(pulse, forKey: nil)
    }
    
    func pulstatex2(){
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 0.4
        pulse.fromValue = 0.85
        pulse.toValue = 1
        pulse.autoreverses = true
        pulse.repeatCount = 23
        pulse.initialVelocity = 0.5
        pulse.damping = 2.5

        layer.add(pulse, forKey: nil)
    }
    
    
    func flash(){
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.5
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 1
        
        
        layer.add(flash, forKey: nil)
    }

    func shake() {
        let shake = CABasicAnimation(keyPath: "position")
        shake.duration = 0.1
        shake.repeatCount = 2
        shake.autoreverses = true
        
        let fromPoint = CGPoint(x: center.x - 2, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 2, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)
        
        shake.fromValue = fromValue
        shake.toValue = toValue
        layer.add(shake, forKey: nil)
    }
    
    func animateDown(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.fromValue = CGPoint(x: center.x , y: center.y)
        animation.toValue = CGPoint(x: center.x, y:  4*center.y)
        animation.duration = 1
        animation.fillMode = .forwards
      
        layer.add(animation, forKey: nil)
    }
    
}

extension UIButton {
    func alignVertical(spacing: CGFloat = 6.0) {
        if let image = self.imageView?.image {
                    let imageSize: CGSize = image.size
            self.titleEdgeInsets = UIEdgeInsets(top: 60, left: -imageSize.width, bottom: -(imageSize.height), right: 0.0)
                    let labelString = NSString(string: self.titleLabel!.text!)
            let titleSize = labelString.size(withAttributes: [NSAttributedString.Key.font: self.titleLabel!.font!])
            self.imageEdgeInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: -titleSize.width)
                }
    }
}

extension String {
    subscript(i: Int) -> String {
        return String(self[index(startIndex, offsetBy: i)])
    }
}

extension UILabel {
    func flash(){
        let flash = CABasicAnimation(keyPath: "opacity")
        flash.duration = 0.2
        flash.fromValue = 1
        flash.toValue = 0.1
        flash.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        flash.autoreverses = true
        flash.repeatCount = 2
        
        layer.add(flash, forKey: nil)
    }
}
