//
//  EmotionClass.swift
//  Rscuare
//
//  Created by suraj on 8/19/18.
//  Copyright © 2018 suraj. All rights reserved.
//

import Foundation
import FirebaseDatabase

    var ref: DatabaseReference!
    
    public func getFirebaseEmotionData(){
        ref = Database.database().reference()
        ref.child("emotion-prediction").child("LK60QCEKrOH2Cg1odZB").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? NSDictionary
            let prediction = value?["prediction"] as? String ?? ""
            let result = value?["result"] as? String ?? ""
            let timestamp = value?["timestamp"] as? String ?? ""
            let uid = value?["uid"] as? String ?? ""
            dump("here -\(String(describing: value))")
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    
}
