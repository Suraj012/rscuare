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
    
    let parties = ["Open to new experience guy", "Organizational and Punctuality", "Sociability", "Trustworthiness and Friendliness", "Mind Swinging"]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chartView.delegate = self
        initBarChart()
    }
    
    func initBarChart(){
        self.setup(pieChartView: chartView)
        let l = chartView.legend
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        //        chartView.legend = l
        
        // entry label styling
        chartView.entryLabelColor = .white
        chartView.entryLabelFont = .systemFont(ofSize: 14, weight: UIFontWeightLight)
        
        chartView.animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
        self.setDataCount(5, range: 5)
        
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let entries = (0..<count).map { (i) -> PieChartDataEntry in
            print(Double(arc4random_uniform(range) + range / 5))
            let values = [20, 30, 40, 15, 5]
            // IMPORTANT: In a PieChart, no values (Entry) should have the same xIndex (even if from different DataSets), since no values can be drawn above each other.
            return PieChartDataEntry(value: Double(values[i]),
                                     label: parties[i],
                                     data: nil)
        }
        
        let set = PieChartDataSet(values: entries, label: "")
        set.drawValuesEnabled = false
        set.sliceSpace = 5
        
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
            + [UIColor(red: 51/255, green: 181/255, blue: 229/255, alpha: 1)]
        
        let data = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 5
        pFormatter.percentSymbol = " %"
        data.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        data.setValueFont(.systemFont(ofSize: 14, weight: UIFontWeightLight))
        data.setValueTextColor(.white)
        
        chartView.data = data
        chartView.highlightValues(nil)
    }
    
    func setup(pieChartView chartView: PieChartView) {
        chartView.usePercentValuesEnabled = true
        chartView.drawSlicesUnderHoleEnabled = false
        chartView.holeRadiusPercent = 0.58
        chartView.transparentCircleRadiusPercent = 0.51
        chartView.chartDescription?.enabled = false
        chartView.setExtraOffsets(left: 5, top: 10, right: 5, bottom: 5)
        
        chartView.drawCenterTextEnabled = true
        
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
        l.horizontalAlignment = .right
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = false
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        l.yOffset = 0
        //        chartView.legend = l
    }
}
