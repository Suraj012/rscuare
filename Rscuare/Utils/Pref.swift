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
    internal static let mind_swinging = "MIND_SWINGING"
    
    static func storeDouble(_ key:String, value:Double){
        let defaults = UserDefaults.standard
        defaults.set(value, forKey: key)
    }
    static func retrieveDouble(_ key:String) -> Double {
        let defaults = UserDefaults.standard
        return defaults.double(forKey: key)
    }
}
