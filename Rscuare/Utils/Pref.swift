//
//  Pref.swift
//  Rscuare
//
//  Created by suraj on 8/19/18.
//  Copyright © 2018 suraj. All rights reserved.
//

import Foundation
class Pref {
    internal static let open_new_experience_guy = "OPEN_NEW_EXPERIENCE_GUY"
    internal static let organizational_and_punctuality = "ORGANIZATIONAL_AND_PUNCTUALITY"
    internal static let sociability = "SOCIABILITY"
    internal static let trustworthy_and_frendly = "TRUSTWORTHY_AND_FRENDLY"
    internal static let calmness = "CALMNESS_AND_TEMPEREDNESS"
    
    internal static let emotion_fetch_time = "EMOTION_FETCH_TIME"
    internal static let emotion_prediction = "EMOTION_PREDICTION"
    internal static let emotion_reason = "EMOTION_REASON"
    internal static let emotion_anger = "EMOTION_ANGER"
    internal static let emotion_happy = "EMOTION_HAPPY"
    internal static let emotion_hate = "EMOTION_HATE"
    internal static let emotion_neutral = "EMOTION_NEUTRAL"
    internal static let emotion_sad = "EMOTION_SAD"
    
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
