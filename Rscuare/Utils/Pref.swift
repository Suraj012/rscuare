//
//  Pref.swift
//  Rscuare
//
//  Created by suraj on 8/19/18.
//  Copyright © 2018 suraj. All rights reserved.
//

import Foundation
class Pref {
    internal static let emotion_fetch_time = "EMOTION_FETCH_TIME"
    internal static let emotion_prediction = "EMOTION_PREDICTION"
    internal static let emotion_reason = "EMOTION_REASON"
    internal static let emotion_anger = "EMOTION_ANGER"
    internal static let emotion_happy = "EMOTION_HAPPY"
    internal static let emotion_hate = "EMOTION_HATE"
    internal static let emotion_neutral = "EMOTION_NEUTRAL"
    internal static let emotion_sad = "EMOTION_SAD"
    
    internal static let key_anger = "KEY_ANGER"
    internal static let key_happy = "KEY_HAPPY"
    internal static let key_hate = "KEY_HATE"
    internal static let key_neutral = "KEY_NEUTRAL"
    internal static let key_sad = "KEY_SAD"
    
    internal static let key_ext = "KEY_EXT"
    internal static let key_con = "KEY_CON"
    internal static let key_opn = "KEY_OPN"
    internal static let key_neu = "KEY_NEU"
    internal static let key_agr = "KEY_AGR"
    
    internal static let value_ext = "VALUE_EXT"
    internal static let value_con = "VALUE_CON"
    internal static let value_opn = "VALUE_OPN"
    internal static let value_neu = "VALUE_NEU"
    internal static let value_agr = "VALUE_AGR"
    
    static func storeDouble(_ key:String, value:Double){
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    static func retrieveDouble(_ key:String) -> Double {
        let defaults = UserDefaults.standard
        return defaults.double(forKey: key)
    }
    
    static func storeString(_ key:String, value:String){
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    static func retrieveString(_ key:String) -> String {
        let defaults = UserDefaults.standard
        return defaults.string(forKey: key)!
    }
    
    static func storeInt(_ key:String, value:Int){
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    static func retrieveInt(_ key:String) -> Int {
        let defaults = UserDefaults.standard
        return defaults.integer(forKey: key)
    }
}
