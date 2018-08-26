//
//  PieChartCell.swift
//  Rscuare
//
//  Created by suraj on 8/16/18.
//  Copyright © 2018 suraj. All rights reserved.
//

import Foundation
import UIKit
import Charts

class PieChartCell: UITableViewCell, ChartViewDelegate {
    
    @IBOutlet var chartView: PieChartView!
    
    let parties = ["Open to new experience guy", "Organizational and Punctuality", "Sociability", "Trustworthiness and Friendliness", "Calmness and even temperedness"]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chartView.delegate = self
        initBarChart()
    }
    
    func initBarChart(){
        self.setup(pieChartView: chartView)
        self.setDataCount(5, range: 5)
        
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        var value = [Double]()
        value.append(Pref.retrieveDouble(Pref.open_new_experience_guy))
        value.append(Pref.retrieveDouble(Pref.organizational_and_punctuality))
        value.append(Pref.retrieveDouble(Pref.sociability))
        value.append(Pref.retrieveDouble(Pref.trustworthy_and_frendly))
        value.append(Pref.retrieveDouble(Pref.calmness))
//        let value = [20, 30, 40, 5, 5]
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: Double(String(format: "%.0f", value[i]*100))!,
                                     label: parties[i],
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
        chartView.setExtraOffsets(left: 0, top: 10, right: 0, bottom: 10)
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 0
        l.yEntrySpace = 0
        l.yOffset = 0
        l.xOffset = 5
        //        chartView.legend = l
        
        // entry label styling
        //        chartView.entryLabelColor = .black
        //        chartView.entryLabelFont = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        //        chartView.legend = l
    }
}
