//
//  ViewController.swift
//  Rscuare
//
//  Created by suraj on 8/16/18.
//  Copyright © 2018 suraj. All rights reserved.
//

import UIKit
import Alamofire
import FirebaseDatabase

class ViewController: UITableViewController {
    
    var ref: DatabaseReference!
    
    
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    var isLoading = true
    
    
    lazy var refreshSwipe: UIRefreshControl = {
        let refreshSwipe = UIRefreshControl()
        refreshSwipe.addTarget(self, action: #selector(ViewController.handleRefresh(_:)), for: UIControlEvents.valueChanged)
        refreshSwipe.tintColor = UIColor.gray
        return refreshSwipe
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFirebaseEmotionData()
        self.tableView.backgroundColor = UIColor(red: 248/255, green: 248/255, blue: 248/255, alpha: 1)
        self.tableView.addSubview(self.refreshSwipe)
        
//        let viewController:UIViewController = UIStoryboard(name: "Setting", bundle: nil).instantiateViewController(withIdentifier: "setting_view") as UIViewController
//        let navController = UINavigationController(rootViewController: viewController)
//        self.present(navController, animated: true, completion: nil)
        
//        var emotionTimer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(ViewController.checkEmotionStatus), userInfo: nil, repeats: true)
        
        var frame = spinner.frame
        frame.origin.x = (self.view.frame.size.width / 2 - frame.size.width / 2);
        frame.origin.y = (self.view.frame.size.height / 2.5 - frame.size.height / 2);
        spinner.frame = frame;
        self.view.addSubview(spinner)
        //        spinner.startAnimating()
        loadData()
    }
    
    func loadData(){
        let token = "ewogICJ0eXBlIjogInNlcnZpY2VfYWNjb3VudCIsCiAgInByb2plY3RfaWQiOiAicGVyc29uYWxpdHktbXBlcmNlcHQtMTQ2YzYiLAogICJwcml2YXRlX2tleV9pZCI6ICIxZDhiMWE1YjYwZGE4MzdlZTA5NmU4OTMxMTljNTA5YmQyYWYxYjJlIiwKICAicHJpdmF0ZV9rZXkiOiAiLS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tXG5NSUlFdlFJQkFEQU5CZ2txaGtpRzl3MEJBUUVGQUFTQ0JLY3dnZ1NqQWdFQUFvSUJBUUNrd1RZRk1GM0pGSlhyXG4zVlJQN0hlNEdNS2tsdXEvOER4RUJQNnM0T3NsSWkxMEo3ZXJGMUVnQnE2R3F4L3JRUkF5bU9VY1dsZ0tIRVFaXG5iT3NaSitrdmZ4QjlTbzNHekNHM0lxakxNcTJxd1RndUREVWhIWVBZYjg4QTIyK280N0NnZjNRcERBSHZGQ3ZSXG5nRHE2VVRSTFlVUlBTT2V0UjVuME5QdXBHTkQzTDF3MCtoTDNCeWU5TXBkSlFKcnR2dU5pa3h3YWhtaU94b3N3XG5hRTFabng1WmVtOVJmcGtTWkh4aEZ2SFUwQUdGZDhQSi90OXJseFNuS3hYcUc5Vk5hWHBYcU1XdlQyTGZDQ1FBXG5RQno0anQ3NC84bzAzRStWN3VRVnRPUTZWTlZDdkUxQ0JGUm1nYlVjQ200OWpLNXN4ZDVub3p6ZHExckVzcnZoXG5KeGEwS0RLbkFnTUJBQUVDZ2dFQU5EWjlLYmpSeUJPTGpiUFhiL3JYV0JNVXdIZUpqdW1TRjlaalphTmtNaUQ2XG5PYmtLbHFDdGw1STJoancrUWQ2ZFJRTzZmRGxQZEdqUDFpVHovc1ZzdTU0dnVoMUNBRElhTDBFL01DSnY4bEVJXG52bU1sQlVrbXl4Vm9DM1AvbDQwTklWZ3pGbjBWTWRENU1BeE0wRlpDMWU3TjZMaUluNXcwK0xVLzJpK2dyZTBrXG5jbnZ0V2dYMkZiMnorRmFaNm9BWS9UVG9kNC9Pd3I5NDRIeUliTkg0R0p1R1RTLzF5bmRrZ2FYdUpqck9wOEUyXG45Q2RWMkdkaW0zVkxHVFo1ajRNbVdYbUtNY0ozVzM5VERoZmdMTFQ5YXZQS2pSOEkvZEpSSkpyajNPTUhwUVBRXG4rZ0dVQ0d2ZVpHTWxCb2RKTVFLRlFLb0tGNWJZak9aaW1kQzRuQWUyOFFLQmdRRGNkNWZVbzBlMVp6WEpJazE4XG5hU3ZFTFZsOHRNZzN3K2pPWFRCTHpXR05PMGJLYTMzMHNqUlJOOVVGYUo2cXBoSzdlYkx4RnBQaWRBWFdqUVV2XG4zR0JpcjdJVHZvUmhROS85ZTltTmNrQUF2T2xNTEMrQWFLTzk4dTY3TkMzeWMwYmlNdWwwcXE0RmNGY2FGZWh6XG5VRlNDVG92N2JzWXRKL0VxYklTYnhkdzg4UUtCZ1FDL1R2QzJmZHh5cER2dDJPdW9zMlp0eGxadEFwUXBjNmIvXG5VU0k5WmJyZGo3b0tEQmVSZXpLajUyT3ZzUTBZeXd2aVFObE91cHhtS1RaUDFLMmxWa0ZVbGtWNUh3eXpmNGJCXG5tRWJiQUIyTkdlQUg1NkovVlJiekpTVjRPZHFJbkNEazlQU0hMRTZRWnpyOHVFcjZNWjJwVjJBZzUyWWFuWVBVXG5FdXNQdDk1SkZ3S0JnUUNqU2dDdWdYRHZMczVyZG5pbG1NL05zVGtDWUhPYXVnT0lOUVU4WDVYTklRWkJqblB2XG45TDFER25Nd1dsaUtWQTZ6eEdPQXBSUkxPVnZKbVJFcWJiTUY1Tk9rUkF1UWJ0RkwwWnRFWkVaN1JYQVY5dlFIXG55M2piaXo2K2NOdEhJNUp3bnZ6Q2FGZ1R0eTBNS1FYTndzV1U3ZEJJSGJleVlrOEErUGNPMlBGU1FRS0JnRXlYXG5VQ3ZmeStoaDlGUlBLbG9LS1JIOS9BLzhubERTS3FQQldkSDI3bzlSd1l2UU40ZFpLWGNSWm9tcWVySFlhTk9XXG5YdW4wTURWK2ZtNExtZEc5N0wzdXc3V3dScWQrZ1BiMC9qa2puTEVuRU5oWlZtZGdLNllBMHpXRkJBYjVhdm4vXG5ULzdtTURZRC9rdTdoTmtTRUNzQi9reHVHQ1REdDBtcW9VMVRzYnpWQW9HQUFMTGdVTUtuaWFMTG5qeUpWSDJ4XG55YzBVc2FCWDJUeTVGM1pDRENOM0xGUDdMbDYwV1lmaFJxZWFxMWFrc25qazdzUk9SRTVaWTFIMjAwclVtNTZuXG5kRlBRVEdDWkNGMk51L0NHMUU2U0V5b2dHTjdYZWc1VnhRVUQ0cUNZTjFwakpRNUxzaHpvKzZ4eVlVNi9LeHJMXG5jSEpZUjRiUHhFNGZ0RWtyaXdKK0V3OD1cbi0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS1cbiIsCiAgImNsaWVudF9lbWFpbCI6ICJmaXJlYmFzZS1hZG1pbnNkay11dno2Z0BwZXJzb25hbGl0eS1tcGVyY2VwdC0xNDZjNi5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsCiAgImNsaWVudF9pZCI6ICIxMTYyNTA1ODk2NzM1NjE5OTkzMjEiLAogICJhdXRoX3VyaSI6ICJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20vby9vYXV0aDIvYXV0aCIsCiAgInRva2VuX3VyaSI6ICJodHRwczovL29hdXRoMi5nb29nbGVhcGlzLmNvbS90b2tlbiIsCiAgImF1dGhfcHJvdmlkZXJfeDUwOV9jZXJ0X3VybCI6ICJodHRwczovL3d3dy5nb29nbGVhcGlzLmNvbS9vYXV0aDIvdjEvY2VydHMiLAogICJjbGllbnRfeDUwOV9jZXJ0X3VybCI6ICJodHRwczovL3d3dy5nb29nbGVhcGlzLmNvbS9yb2JvdC92MS9tZXRhZGF0YS94NTA5L2ZpcmViYXNlLWFkbWluc2RrLXV2ejZnJTQwcGVyc29uYWxpdHktbXBlcmNlcHQtMTQ2YzYuaWFtLmdzZXJ2aWNlYWNjb3VudC5jb20iCn0="
        let connection = Connection(url: "https://010bc0fd.ngrok.io/predict/personality/hHI4wbT0v3fxuUlLL2oVMp4ZHMi2", parameters: [
            "token": token
            ])
        connection.start { (result, success) -> Void in
            if success {
                print("result \(result)")
                let open_experience:Double = result["Open to new experiences"].doubleValue
                let organization:Double = result["Organizational and Punctuality"].doubleValue
                let sociability:Double = result["Sociability"].doubleValue
                let trust:Double = result["Trustworthiness and Friendliness"].doubleValue
                let calmness:Double = result["Calmness and even temperedness"].doubleValue
                Pref.storeDouble(Pref.open_new_experience_guy, value: open_experience)
                Pref.storeDouble(Pref.organizational_and_punctuality, value: organization)
                Pref.storeDouble(Pref.sociability, value: sociability)
                Pref.storeDouble(Pref.trustworthy_and_frendly, value: trust)
                Pref.storeDouble(Pref.calmness, value: calmness)
                self.isLoading = false
                self.tableView.reloadData()
                self.spinner.stopAnimating()
                self.refreshSwipe.endRefreshing()
            } else {
                print("Error here")
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        if indexPath.section == 0 {
            return screenHeight - 200
        }else{
            return 50
        }
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.section == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "personality_profile", for: indexPath) as! PieChartCell
            return cell
        }else{
            let open_new_experience_guy = Pref.retrieveDouble(Pref.open_new_experience_guy)
            let organizational_and_punctuality = Pref.retrieveDouble(Pref.organizational_and_punctuality)
            let sociability = Pref.retrieveDouble(Pref.sociability)
            let trustworthy_and_frendly = Pref.retrieveDouble(Pref.trustworthy_and_frendly)
            let calmness = Pref.retrieveDouble(Pref.calmness)
            let cell = tableView.dequeueReusableCell(withIdentifier: "character_profile", for: indexPath) as! DetailViewCell
            if(open_new_experience_guy > organizational_and_punctuality && open_new_experience_guy > sociability && open_new_experience_guy > trustworthy_and_frendly && open_new_experience_guy > calmness){
                cell.detailView.text = String(format: "%.0f", open_new_experience_guy*100) + "% Open to new experience guy"
            } else if(organizational_and_punctuality > open_new_experience_guy && organizational_and_punctuality > sociability && organizational_and_punctuality > trustworthy_and_frendly && organizational_and_punctuality > calmness){
                cell.detailView.text = String(format: "%.0f", organizational_and_punctuality*100) + "% Organizational and Punctuality"
            } else if(sociability > open_new_experience_guy && sociability > organizational_and_punctuality && sociability > trustworthy_and_frendly && sociability > calmness) {
                cell.detailView.text = String(format: "%.0f", sociability*100) + "% Sociability"
            } else if(trustworthy_and_frendly > open_new_experience_guy && trustworthy_and_frendly > organizational_and_punctuality && trustworthy_and_frendly > sociability && trustworthy_and_frendly > calmness) {
                cell.detailView.text = String(format: "%.0f", trustworthy_and_frendly*100) + "% Trustworthiness and Friendliness"
            } else if(calmness > open_new_experience_guy && calmness > organizational_and_punctuality && calmness > sociability && calmness > trustworthy_and_frendly) {
                cell.detailView.text = String(format: "%.0f", calmness*100) + "% Calmness and even temperedness"
            }
            return cell
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if(section == 0){
            return ""
        }else{
            return ""
        }
    }
    
    
    @objc func handleRefresh(_ refreshSwipe: UIRefreshControl) {
        loadData()
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
    }
    
    func checkEmotionStatus()
    {
        getFirebaseEmotionData()
        if(Pref.retrieveInt(Pref.emotion_prediction) == 0){
            self.showToast(message: "Not Enough Data")
        }else{
            let happy = Pref.retrieveDouble(Pref.emotion_happy)
            let sad = Pref.retrieveDouble(Pref.emotion_sad)
            let neutral = Pref.retrieveDouble(Pref.emotion_neutral)
            let hate = Pref.retrieveDouble(Pref.emotion_hate)
            let anger = Pref.retrieveDouble(Pref.emotion_anger)
            if(happy > sad && happy > neutral && happy > hate && happy > anger){
                self.showToast(message: String(format: "%.0f", happy*100) + "% Happy")
            } else if(sad > happy && sad > neutral && sad > hate && sad > anger){
                self.showToast(message: String(format: "%.0f", sad*100) + "% Sad")
            } else if(neutral > happy && neutral > sad && neutral > hate && neutral > anger){
                self.showToast(message: String(format: "%.0f", neutral*100) + "% Neutral")
            } else if(hate > happy && hate > sad && hate > neutral && hate > anger){
                self.showToast(message: String(format: "%.0f", hate*100) + "% Hate")
            }else if(anger > happy && anger > sad && anger > neutral && anger > hate){
                self.showToast(message: String(format: "%.0f", anger*100) + "% Anger")
            }
        }
    }
    
    public func getFirebaseEmotionData(){
        ref = Database.database().reference()
        ref.child("emotion-predictions").child("hHI4wbT0v3fxuUlLL2oVMp4ZHMi2").observe(.value, with: { snapshot in
            // Get user value
            print("snap \(snapshot.value as Any)")
            guard let dict = snapshot.value as? [String:Any] else {
                print("Error")
                return
            }
            let prediction = dict["prediction"] as? Int ?? 0
            let reason = dict["reason"] as? String ?? ""
            let timestamp = dict["timestamp"] as? Int ?? 0
            let anger = dict["anger"] as? Double ?? 0.0
            let happy = dict["happy"] as? Double ?? 0.0
            let neutral = dict["neutral"] as? Double ?? 0.0
            let hate = dict["hate"] as? Double ?? 0.0
            let sad = dict["sad"] as? Double ?? 0.0
            Pref.storeInt(Pref.emotion_fetch_time, value: timestamp)
            Pref.storeInt(Pref.emotion_prediction, value: prediction)
            Pref.storeString(Pref.emotion_reason, value: reason)
            Pref.storeDouble(Pref.emotion_happy, value: happy)
            Pref.storeDouble(Pref.emotion_hate, value: hate)
            Pref.storeDouble(Pref.emotion_anger, value: anger)
            Pref.storeDouble(Pref.emotion_neutral, value: neutral)
            Pref.storeDouble(Pref.emotion_sad, value: sad)
            
            if(Pref.retrieveInt(Pref.emotion_prediction) == 0){
                self.showToast(message: "Not Enough Data")
            }else{
                let happy = Pref.retrieveDouble(Pref.emotion_happy)
                let sad = Pref.retrieveDouble(Pref.emotion_sad)
                let neutral = Pref.retrieveDouble(Pref.emotion_neutral)
                let hate = Pref.retrieveDouble(Pref.emotion_hate)
                let anger = Pref.retrieveDouble(Pref.emotion_anger)
                if(happy > sad && happy > neutral && happy > hate && happy > anger){
                    self.showToast(message: String(format: "%.0f", happy*100) + "% Happy")
                } else if(sad > happy && sad > neutral && sad > hate && sad > anger){
                    self.showToast(message: String(format: "%.0f", sad*100) + "% Sad")
                } else if(neutral > happy && neutral > sad && neutral > hate && neutral > anger){
                    self.showToast(message: String(format: "%.0f", neutral*100) + "% Neutral")
                } else if(hate > happy && hate > sad && hate > neutral && hate > anger){
                    self.showToast(message: String(format: "%.0f", hate*100) + "% Hate")
                }else if(anger > happy && anger > sad && anger > neutral && anger > hate){
                    self.showToast(message: String(format: "%.0f", anger*100) + "% Anger")
                }
            }
            
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
}

extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-115, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.blue.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 20.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }
