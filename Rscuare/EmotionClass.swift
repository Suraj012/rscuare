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
    
    public func getFirebaseEmotionDatas(){
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
            let anger = dict["anger"] as? Double ?? 0.0
            let happy = dict["happy"] as? Double ?? 0.0
            let neutral = dict["neutral"] as? Double ?? 0.0
            let hate = dict["hate"] as? Double ?? 0.0
            let sad = dict["sad"] as? Double ?? 0.0
            Pref.storeInt(Pref.emotion_fetch_time, value: timestamp)
            Pref.storeInt(Pref.emotion_prediction, value: prediction)
            Pref.storeString(Pref.emotion_reason, value: reason)
            Pref.storeDouble(Pref.emotion_happy, value: happy)
            Pref.storeDouble(Pref.emotion_hate, value: hate)
            Pref.storeDouble(Pref.emotion_anger, value: anger)
            Pref.storeDouble(Pref.emotion_neutral, value: neutral)
            Pref.storeDouble(Pref.emotion_sad, value: sad)
            
//            if(Pref.retrieveInt(Pref.emotion_prediction) == 0){
//                self.showToast(message: "Not Enough Data")
//            }else{
//                let happy = Pref.retrieveDouble(Pref.emotion_happy)
//                let sad = Pref.retrieveDouble(Pref.emotion_sad)
//                let neutral = Pref.retrieveDouble(Pref.emotion_neutral)
//                let hate = Pref.retrieveDouble(Pref.emotion_hate)
//                let anger = Pref.retrieveDouble(Pref.emotion_anger)
//                if(happy > sad && happy > neutral && happy > hate && happy > anger){
//                    showToast(message: String(format: "%.0f", happy*100) + "% Happy")
//                } else if(sad > happy && sad > neutral && sad > hate && sad > anger){
//                    self.showToast(message: String(format: "%.0f", sad*100) + "% Sad")
//                } else if(neutral > happy && neutral > sad && neutral > hate && neutral > anger){
//                    self.showToast(message: String(format: "%.0f", neutral*100) + "% Neutral")
//                } else if(hate > happy && hate > sad && hate > neutral && hate > anger){
//                    self.showToast(message: String(format: "%.0f", hate*100) + "% Hate")
//                }else if(anger > happy && anger > sad && anger > neutral && anger > hate){
//                    self.showToast(message: String(format: "%.0f", anger*100) + "% Anger")
//                }
//            }
        
            // ...
        }) { (error) in
            print(error.localizedDescription)
        }
    
}
