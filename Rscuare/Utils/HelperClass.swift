//
//  HelperClass.swift
//  Rscuare
//
//  Created by suraj on 8/26/18.
//  Copyright © 2018 suraj. All rights reserved.
//

import Foundation

class HelperClass {
    
    public func getMinimumPrediction(dict: Dictionary<String, Double>) -> String {
        let minimumValue = dict.min { a, b in a.value < b.value }
        let valuePercent = (minimumValue?.value)!*100
        let valueLabel = String(format: "%.0f", valuePercent) + "% " + (minimumValue?.key)!
        return valueLabel
    }
    
    public func getMaximumPrediction(dict: Dictionary<String, Double>) -> String {
        let maximumValue = dict.max { a, b in a.value < b.value }
        let valuePercent = (maximumValue?.value)!*100
        let valueLabel = String(format: "%.0f", valuePercent) + "% " + (maximumValue?.key)!
        return valueLabel
    }
    
    public func getMinimumEmotion(dict: Dictionary<String, Double>) -> String {
        let minimumValue = dict.min { a, b in a.value < b.value }
        let valuePercent = (minimumValue?.value)!*100
        let valueLabel = String(format: "%.0f", valuePercent) + "% " + (minimumValue?.key)!
        return valueLabel
    }
    
    public func getMaximumEmotion(dict: Dictionary<String, Double>) -> String {
        let maximumValue = dict.max { a, b in a.value < b.value }
         let valuePercent = (maximumValue?.value)!*100
        let valueLabel = String(format: "%.0f", valuePercent) + "% " + (maximumValue?.key)!
        return valueLabel
    }
}
