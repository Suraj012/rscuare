//
//  BarChartCell.swift
//  Rscuare
//
//  Created by suraj on 8/16/18.
//  Copyright © 2018 suraj. All rights reserved.
//

import Foundation
import UIKit
import Charts

class BarChartCell: UITableViewCell, ChartViewDelegate {
    
    @IBOutlet var chartView: BarChartView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        chartView.delegate = self
        initBarChart()
    }
    
    func initBarChart(){
        
        self.setup(barLineChartView: chartView)
        
        chartView.delegate = self
        
        chartView.drawBarShadowEnabled = false
        chartView.drawValueAboveBarEnabled = true
        
        chartView.maxVisibleCount = 60
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.drawAxisLineEnabled = true
        xAxis.granularity = 10
        
        let leftAxis = chartView.leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.drawAxisLineEnabled = true
        leftAxis.drawGridLinesEnabled = true
        leftAxis.axisMinimum = 0
        
        let rightAxis = chartView.rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.drawAxisLineEnabled = true
        rightAxis.axisMinimum = 0
        
        let l = chartView.legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .square
        l.formSize = 8
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
        //        chartView.legend = l
        chartView.animate(yAxisDuration: 2.5)
        chartView.fitBars = true
        self.setDataCount(4, range: 5)
        
    }
    
    func setDataCount(_ count: Int, range: UInt32) {
        let barWidth = 9.0
        let spaceForBar = 10.0
        
        let yVals = (0..<count).map { (i) -> BarChartDataEntry in
            let mult = range + 1
            let val = Double(arc4random_uniform(mult))
            return BarChartDataEntry(x: Double(i)*spaceForBar, y: val)
        }
        
        let set1 = BarChartDataSet(values: yVals, label: "DataSet")
        set1.drawValuesEnabled = false
        
        let data = BarChartData(dataSet: set1)
        data.setValueFont(UIFont(name:"HelveticaNeue-Light", size:10)!)
        data.barWidth = barWidth
        
        chartView.data = data
    }
    
    func setup(barLineChartView chartView: BarLineChartViewBase) {
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        
        // ChartYAxis *leftAxis = chartView.leftAxis;
        
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        
        chartView.rightAxis.enabled = false
    }
}
