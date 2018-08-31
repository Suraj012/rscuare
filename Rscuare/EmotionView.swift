//
//  EmotionView.swift
//  Rscuare
//
//  Created by suraj on 8/26/18.
//  Copyright © 2018 suraj. All rights reserved.
//

import Foundation
import UIKit
import Charts

class EmotionView: UIViewController, ChartViewDelegate {
    @IBOutlet weak var minLabel: UILabel!
    @IBOutlet weak var maxLabel: UILabel!
    @IBOutlet weak var chartView: PieChartView!
    var emotion = [String]()
    var emotionValue = [Double]()
    var dictValue = [String: Double]()
    
    @IBAction func closeAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        Timer.scheduledTimer(withTimeInterval: 15, repeats: false) { (timer) in
            self.dismiss(animated: true, completion: nil)
        }
        chartView.roundCorners(radius: 50)
        let happy = Pref.retrieveDouble(Pref.emotion_happy)
        let sad = Pref.retrieveDouble(Pref.emotion_sad)
        let neutral = Pref.retrieveDouble(Pref.emotion_neutral)
        let hate = Pref.retrieveDouble(Pref.emotion_hate)
        let angry = Pref.retrieveDouble(Pref.emotion_anger)
        emotionValue.append(happy)
        emotionValue.append(angry)
        emotionValue.append(hate)
        emotionValue.append(neutral)
        emotionValue.append(sad)
        
        let happyText = Pref.retrieveString(Pref.key_happy)
        let sadText = Pref.retrieveString(Pref.key_sad)
        let neutralText = Pref.retrieveString(Pref.key_neutral)
        let hateText = Pref.retrieveString(Pref.key_hate)
        let angryText = Pref.retrieveString(Pref.key_anger)
        emotion.append(happyText)
        emotion.append(angryText)
        emotion.append(hateText)
        emotion.append(neutralText)
        emotion.append(sadText)
        dictValue = Dictionary(uniqueKeysWithValues: zip(emotion, emotionValue))        
        minLabel.text = HelperClass().getMinimumEmotion(dict: dictValue)
        maxLabel.text = HelperClass().getMaximumEmotion(dict: dictValue)
        // Initialization code
        chartView.delegate = self
        self.setup(pieChartView: chartView)
        self.setDataCount(5, range: 5)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
        animateView()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layoutIfNeeded()
    }
    
    func setupView() {
        chartView.layer.cornerRadius = 15
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
    }
    
    func animateView() {
        chartView.alpha = 0;
        self.chartView.frame.origin.y = self.chartView.frame.origin.y + 50
        UIView.animate(withDuration: 0.4, animations: { () -> Void in
            self.chartView.alpha = 1.0
            self.chartView.frame.origin.y = self.chartView.frame.origin.y - 50
        })
    }
    func setDataCount(_ count: Int, range: UInt32) {
        //        let value = [20, 30, 40, 5, 5]
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: Double(String(format: "%.0f", emotionValue[i]*100))!,
                                     label: emotion[i],
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
        set.valueLinePart1Length = 0.4
        set.valueLinePart2Length = 0.3
        
//        for i in 0..<emotionValue.count {
//            if((emotionValue[i]*100) < 10){
//                set.yValuePosition = .outsideSlice
//            }
//        }
//        set.yValuePosition = .outsideSlice
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
        
        //        let centerText = NSMutableAttributedString(string: "Charts\nby Daniel Cohen Gindi")
        //        centerText.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 13)!, range: NSRange(location: 0, length: centerText.length))
        //        centerText.addAttribute(NSFontAttributeName, value: UIFont(name: "HelveticaNeue-Light", size: 11)!, range: NSRange(location: 10, length: centerText.length))
        
        //        centerText.setAttributes([UIFont(name: "HelveticaNeue-Light", size: 13)
        //                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        //
        //        centerText.setAttributes([UIFont(name: "HelveticaNeue-Light", size: 13)!,
        //                                  .paragraphStyle : paragraphStyle], range: NSRange(location: 0, length: centerText.length))
        //        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
        //                                  .foregroundColor : UIColor.gray], range: NSRange(location: 10, length: centerText.length - 10))
        //        centerText.addAttributes([.font : UIFont(name: "HelveticaNeue-Light", size: 11)!,
        //                                  .foregroundColor : UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)], range: NSRange(location: centerText.length - 19, length: 19))
        //        chartView.centerAttributedText = centerText;
        
        chartView.drawHoleEnabled = true
        chartView.rotationAngle = 0
        chartView.rotationEnabled = true
        chartView.highlightPerTapEnabled = true
        
        let l = chartView.legend
        chartView.setExtraOffsets(left: 16, top: 0, right: 16, bottom: 16)
        l.horizontalAlignment = .right
        l.verticalAlignment = .bottom
        l.orientation = .vertical
        l.xEntrySpace = 0
        l.yEntrySpace = 0
        l.yOffset = 0
        l.xOffset = 10
        //        chartView.legend = l
        
        // entry label styling
        //        chartView.entryLabelColor = .black
        //        chartView.entryLabelFont = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        //        chartView.legend = l
    }
}

extension PieChartView {
    
    func roundCorners(radius: CGFloat) {
        self.layer.cornerRadius = CGFloat(radius)
        self.clipsToBounds = true
    }
    
}
