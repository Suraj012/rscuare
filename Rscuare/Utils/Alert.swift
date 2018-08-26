//
//  Alert.swift
//  Rscuare
//
//  Created by suraj on 8/26/18.
//  Copyright © 2018 suraj. All rights reserved.
//

import Foundation
import UIKit

class Alert {
    
    func showAlert(_ this : UIViewController, msg: String, title: String = "Oops!", actionTitle: String = "Close", okAction: (()-> Void)?){
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        let ok = UIAlertAction(title: actionTitle, style: .default){ _ in
            okAction?()
        }
        alert.addAction(ok)
        //        let height:NSLayoutConstraint = NSLayoutConstraint(item: alert.view, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: alert.view.frame.height * 0.60)
        //        alert.view.addConstraint(height);
        this.present(alert, animated: true){}
    }
    
    func showAlertWithMultipleActions(_ this : UIViewController, msg: String, title: String = "Oops!", actionTitleFirst: String = "Ok", actionTitleSecond: String = "Cancel", cancelAction: (()-> Void)?, okAction: (()-> Void)?){
        
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
        
        let ok = UIAlertAction(title: actionTitleFirst, style: .default){ _ in
            okAction?()
        }
        
        let cancel = UIAlertAction(title: actionTitleSecond, style: .default) { _ in
            cancelAction?()
        }
        
        alert.addAction(cancel)
        alert.addAction(ok)
        this.present(alert, animated: true){}
    }
}


