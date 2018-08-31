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
import Charts

class ViewController: UIViewController, ChartViewDelegate {
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet var chartView: PieChartView!
    var prediction = [String]()
    var predictionValue = [Double]()
    var dictValue = [String: Double]()
    
    public var emotionHappy = String()
    public var emotionNeutral = String()
    public var emotionSad = String()
    public var emotionAnger = String()
    public var emotionHate = String()
    
    public var happy = Double()
    public var neutral = Double()
    public var sad = Double()
    public var anger = Double()
    public var hate = Double()
    
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
        chartView.delegate = self        
        var frame = spinner.frame
        frame.origin.x = (self.view.frame.size.width / 2 - frame.size.width / 2)
        frame.origin.y = (self.view.frame.size.height / 2.5 - frame.size.height / 2)
        spinner.frame = frame
        self.view.addSubview(spinner)
        loadKey()
        spinner.startAnimating()
    }
    
    func loadData(){
        let token = "ewogICJ0eXBlIjogInNlcnZpY2VfYWNjb3VudCIsCiAgInByb2plY3RfaWQiOiAici1zY3VhcmUtNWVkOGEiLAogICJwcml2YXRlX2tleV9pZCI6ICJiNjRhODU2NDc1NWMzNTNmMWI4NTQwNDkyMDQ0YWNiZDIxOTEwNTY3IiwKICAicHJpdmF0ZV9rZXkiOiAiLS0tLS1CRUdJTiBQUklWQVRFIEtFWS0tLS0tXG5NSUlFdmdJQkFEQU5CZ2txaGtpRzl3MEJBUUVGQUFTQ0JLZ3dnZ1NrQWdFQUFvSUJBUURCZ2duMGR6Vzg3VXVOXG5NVUdTeThyR1hDYVdUZlVZUk9KVlFTSTNVQStBK0NyZlhlc2tNS2YrYkhSWllQTEQxazdoY0Q3SXQ2ZEYrRkpZXG5vb05NR0NhMEtDSXQ0TlB4NHBEWnV5eEtOSWhQV0R6QXVHdllqZEZvUWZDUjhNRndvSk14L3pWR0FkMVFaTUlKXG5yUXdCUWs0MXB4SkR1UEF1VTdUUTBuUFVhempSVW1UVmg4aGVFZ1FJekk4aER5WjU5MlpLYW5zZUJ0RzNXKzc0XG5QRldMK3JmbS93ZGFUdURaT2h0eUJtSVVLS2hwdDlkcWI1Y2NyVVM4TmFrNkRIL05taS9LVEkvdG0wRWdvQmNMXG45VmZJTGRhNllPTEI3TFJ2THNCbGJvNUoxWm5lcU9CMU5aUXJMclozRUZGR3R6NkptNGZLT1pQcU5yR0JmdWRWXG5kSUJ5MmJVL0FnTUJBQUVDZ2dFQUR6VEd6MzBtcmVmL3plS1hBcEFkS1NWSXF2c0pUWlRzTEVMb0MyeXhLek5WXG5PeVJJUEJuT3VjR1FDdzRCUmI1cmlHK25uMkkvTk5Ka3RpNWZIdld1NU8xYWNqeCtxejFnb0p1Q3lYb0RWQ2pjXG43VkFRdVgyN2ZQUGhrYlpYblNBaE1RYWJDeHRPWnVqa0RwcVluT2kyK0tSZVhSQUZYNzZZTU9pNHpYSjNqb3RGXG4rc0NtMVRBRVJmclkwWnhGSDAzR2VhbGluSlc3S2xTVzFBVXRyUWZSMXoxYjhPRnk3ejFMbDU5U3kvcUs1dEJmXG5TUjc2czdyZzN5YWo3V2dLMlE4S2dqalNqSHdXeFV6MnF5endFdHk2emw1SXJBNk41WGtyWHZuV21Hc1cvZTRtXG43RUh2VGpzdlczSTRuRWtRbWlXMlZLWnJQSnNVQkN5amF5eDRldWFXRVFLQmdRRG4xbTRDdmxxTUhiOG5xQkpTXG5jS3VmakM0cXZnT0xRWGlmZ21QOFR1d214NmtMR2xucXNac0x1V1NlMW9Uc0N2Zzh6U0piSnpmYWczcjVWQmVKXG4wQkpNR1hHZzRJSlF1Ulg4TE0vVkRtWGo4RUI5bHd1YWIvLzFlUDZzaXNYUk1nMHJ6UU5QVEdERW5IZTBaYjF5XG50WlJMTmh6cjlGL3c4ZEFRQ3hlMlN2Vlptd0tCZ1FEVnJQTlJhYkRWa2RHMnlQYnRIRmJzRFhwdnNXc3R6VW5BXG5rUzlCSzBsSGdEVlJWdHB0SDQ2ZHZrRFBUaE9KWnFOMnYvdzN2Mzd0MlZBTzF2SkRsS2FoZy9PbWdzYW9qbE5UXG4xTG90VmdaL25BckZGcUwzeTdzZzBDUngvUU92TERRUi9WckE3MkgvY1ZXQTBXSWo4NGNweFVsTTE4eVVwK2lGXG4rZkJ4RytpdkxRS0JnQmcyMkVTbkZ4UDlZMkxEOWkzd0lLeklXbVlTZEpKTjQwaGR1UTI0UElnTVlJYU5XUWpmXG5SZjlpZkxUdVdQSENiNDBDSysxeldpMFRnSHVjSWQwK0F6czVpUm14ZVVydkdmRzl5SE5MVHE4US85dGVORk1NXG5FYUxVNFZ5cUhlRXNwaDJHQ3l0MEljTkhTR1ZxSHZCbE1ManVUUFVFRUNVOVRHcndqYWgzaWNxekFvR0JBTTZtXG5RM1BiT2JCekpGVVlxdWJLWDY1UG9yZmU2SDhWYVZ5WmpSQUQ0dzBKaTRjczduWlc3TURXUFN2QW9OaGpzWGVwXG5XUzQ1UDNLY2x2YWpIdzRJOTlhQkhPVk8yUDR2RjV1ZHdxa1I1NXNHdU11L2hzRU1BZUJNTE5NcEZhVVdwUTA0XG43OHBrT1d5b21UN0tRWlh2Y2lzTnFFUnUrR1pVdFdiTlFLTERrUmZKQW9HQkFJc0RVZkFlZWZvMkFIZVkyU1FwXG56U28xR3hGRjIrcUtIbVZpcmJpL2tBa2ErSjRtWVdzSVkrWFZEbWtnWFppNHlRR1hZUCtVOGpsK3NaZnhHYkhwXG53QUUrUVZEUmhDVnBlaWhpcjhRRitEb2xuUFNwVlRsdGhlTWtUemwyeUxZYkNONlRNc0M4Q1BoZ1RUVGpJODdIXG5OdVVma3h5cmYxOTVJYjRnM1R6YTZwM2pcbi0tLS0tRU5EIFBSSVZBVEUgS0VZLS0tLS1cbiIsCiAgImNsaWVudF9lbWFpbCI6ICJmaXJlYmFzZS1hZG1pbnNkay03NGhudUByLXNjdWFyZS01ZWQ4YS5pYW0uZ3NlcnZpY2VhY2NvdW50LmNvbSIsCiAgImNsaWVudF9pZCI6ICIxMDQxNjAyMzcxMTE5MjY3MTMxMTQiLAogICJhdXRoX3VyaSI6ICJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20vby9vYXV0aDIvYXV0aCIsCiAgInRva2VuX3VyaSI6ICJodHRwczovL2FjY291bnRzLmdvb2dsZS5jb20vby9vYXV0aDIvdG9rZW4iLAogICJhdXRoX3Byb3ZpZGVyX3g1MDlfY2VydF91cmwiOiAiaHR0cHM6Ly93d3cuZ29vZ2xlYXBpcy5jb20vb2F1dGgyL3YxL2NlcnRzIiwKICAiY2xpZW50X3g1MDlfY2VydF91cmwiOiAiaHR0cHM6Ly93d3cuZ29vZ2xlYXBpcy5jb20vcm9ib3QvdjEvbWV0YWRhdGEveDUwOS9maXJlYmFzZS1hZG1pbnNkay03NGhudSU0MHItc2N1YXJlLTVlZDhhLmlhbS5nc2VydmljZWFjY291bnQuY29tIgp9"
        
        let connection = Connection(url: "http://159.203.12.221:8000/predict/personality/oG7EZmjlh3Oz43wiCXjsEk1UTwh1", parameters: [
            "token": token
            ])
        connection.start { (result, success) -> Void in
            if success {
                let opn:Double = result[Pref.retrieveString(Pref.key_opn)].doubleValue
                let con:Double = result[Pref.retrieveString(Pref.key_con)].doubleValue
                let ext:Double = result[Pref.retrieveString(Pref.key_ext)].doubleValue
                let agr:Double = result[Pref.retrieveString(Pref.key_agr)].doubleValue
                let neu:Double = result[Pref.retrieveString(Pref.key_neu)].doubleValue
                Pref.storeDouble(Pref.value_agr, value: agr)
                Pref.storeDouble(Pref.value_con, value: con)
                Pref.storeDouble(Pref.value_ext, value: ext)
                Pref.storeDouble(Pref.value_neu, value: neu)
                Pref.storeDouble(Pref.value_opn, value: opn)
                self.isLoading = false
//                self.tableView.reloadData()
                self.spinner.stopAnimating()
                self.refreshSwipe.endRefreshing()
                self.initBarChart()
                self.getFirebaseEmotionData()
            } else {
                self.isLoading = false
                self.spinner.stopAnimating()
                self.refreshSwipe.endRefreshing()
                Alert().showAlert(self, msg: "Something went wrong, please try again later.", okAction:{() in
                })
            }
        }
    }
    
    func loadKey(){
        let connection = Connection(url: "http://159.203.12.221:8000/configure/keywords", parameters: [
            "token": ""
            ])
        connection.load { (result, success) -> Void in
            if success {
                print("here")
                dump("Result \(result)")
                let emotionValue = result["emotion"]
                self.emotionHappy = emotionValue["happy"].stringValue
                self.emotionNeutral = emotionValue["neutral"].stringValue
                self.emotionAnger = emotionValue["angry"].stringValue
                self.emotionHate = emotionValue["hate"].stringValue
                self.emotionSad = emotionValue["sad"].stringValue
                
                let personalityValue = result["personality"]
                dump("personality \(personalityValue)")
                let ext = personalityValue["ext"].stringValue
                let con = personalityValue["con"].stringValue
                let opn = personalityValue["opn"].stringValue
                let neu = personalityValue["neu"].stringValue
                let agr = personalityValue["agr"].stringValue
                
                Pref.storeString(Pref.key_happy, value: self.emotionHappy)
                Pref.storeString(Pref.key_hate, value: self.emotionHate)
                Pref.storeString(Pref.key_anger, value: self.emotionAnger)
                Pref.storeString(Pref.key_neutral, value: self.emotionNeutral)
                Pref.storeString(Pref.key_sad, value: self.emotionSad)
                
                Pref.storeString(Pref.key_ext, value: ext)
                Pref.storeString(Pref.key_con, value: con)
                Pref.storeString(Pref.key_neu, value: neu)
                Pref.storeString(Pref.key_agr, value: agr)
                Pref.storeString(Pref.key_opn, value: opn)
                self.loadData()
            } else {
                print("here here")
                self.isLoading = false
                self.spinner.stopAnimating()
                self.refreshSwipe.endRefreshing()
                Alert().showAlert(self, msg: "Something went wrong, please try again later.", okAction:{() in
                })
            }
        }
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func handleRefresh(_ refreshSwipe: UIRefreshControl) {
        loadData()
        // Do some reloading of data and update the table view's data source
        // Fetch more objects from a web service, for example...
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
                    self.anger = dict["anger"] as? Double ?? 0.0
                    self.happy = dict["happy"] as? Double ?? 0.0
                    self.neutral = dict["neutral"] as? Double ?? 0.0
                    self.hate = dict["hate"] as? Double ?? 0.0
                    self.sad = dict["sad"] as? Double ?? 0.0
                    Pref.storeInt(Pref.emotion_fetch_time, value: timestamp)
                    Pref.storeInt(Pref.emotion_prediction, value: prediction)
                    Pref.storeString(Pref.emotion_reason, value: reason)
                    Pref.storeDouble(Pref.emotion_happy, value: self.happy)
                    Pref.storeDouble(Pref.emotion_hate, value: self.hate)
                    Pref.storeDouble(Pref.emotion_anger, value: self.anger)
                    Pref.storeDouble(Pref.emotion_neutral, value: self.neutral)
                    Pref.storeDouble(Pref.emotion_sad, value: self.sad)
                    
                    if(Pref.retrieveInt(Pref.emotion_prediction) != 0){
                        self.showPopUp()
                    }
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    func initBarChart(){
        self.setup(pieChartView: chartView)
        self.setDataCount(5, range: 5)
        
    }
    func setDataCount(_ count: Int, range: UInt32) {
        //        let value = [20, 30, 40, 5, 5]
        prediction.append(Pref.retrieveString(Pref.key_ext))
        prediction.append(Pref.retrieveString(Pref.key_agr))
        prediction.append(Pref.retrieveString(Pref.key_neu))
        prediction.append(Pref.retrieveString(Pref.key_con))
        prediction.append(Pref.retrieveString(Pref.key_opn))
        
        predictionValue.append(Pref.retrieveDouble(Pref.value_ext))
        predictionValue.append(Pref.retrieveDouble(Pref.value_agr))
        predictionValue.append(Pref.retrieveDouble(Pref.value_neu))
        predictionValue.append(Pref.retrieveDouble(Pref.value_con))
        predictionValue.append(Pref.retrieveDouble(Pref.value_opn))
        dictValue = Dictionary(uniqueKeysWithValues: zip(prediction, predictionValue))
        minLabel.text = HelperClass().getMinimumPrediction(dict: dictValue)
        maxLabel.text = HelperClass().getMaximumPrediction(dict: dictValue)
        
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: Double(String(format: "%.0f", predictionValue[i]*100))!,
                                     label: prediction[i],
                                     data: nil)
            //            return PieChartDataEntry(value: Double(value[i]), label: parties[i], data: nil)
        }
        
        let set = PieChartDataSet(values: entries, label: "")
        //        set.drawValuesEnabled = false
        set.sliceSpace = 0
        
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        chartView.data?.setValueTextColor(UIColor.clear)
        
        set.valueLinePart1OffsetPercentage = 0.8
        set.valueLinePart1Length = 0.2
        set.valueLinePart2Length = 0.3
        //set.xValuePosition = .outsideSlice
        //        set.yValuePosition = .outsideSlice
        
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 16, weight: UIFontWeightMedium))
        data.setValueTextColor(.black)
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
    
    func setup(pieChartView chartView: PieChartView) {
        chartView.usePercentValuesEnabled = false
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.51
        chartView.chartDescription?.enabled = false
        chartView.drawCenterTextEnabled = true
        
        
        chartView.highlightPerTapEnabled = false
        chartView.usePercentValuesEnabled = false
        chartView.drawEntryLabelsEnabled = false
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .center
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        let l = chartView.legend
        chartView.setExtraOffsets(left: 10, top: 10, right: 10, bottom: 10)
        l.font = UIFont.systemFont(ofSize: 12)
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 0
        l.yEntrySpace = 2
        l.yOffset = 10
        l.xOffset = 10
        //        chartView.legend = l
        
        // entry label styling
        //        chartView.entryLabelColor = .black
        //        chartView.entryLabelFont = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        //        chartView.legend = l
    }
    
}

extension UIViewController {
    
    func showPopUp() {
        let customAlert = self.storyboard?.instantiateViewController(withIdentifier: "emotionView") as! EmotionView
        customAlert.providesPresentationContextTransitionStyle = true
        customAlert.definesPresentationContext = true
        customAlert.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        customAlert.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        self.present(customAlert, animated: true, completion: nil)
    }
    
}
