//
//  UIAlertController+Extension.swift
//
//  Created by TriDH on 6/22/18.
//

import UIKit

struct AlertHelper {
    var title:String
    var message:String
    var titleForOkButton:String
}

extension UIAlertController {
    
    final class func alertController(forTitle title: String, message: String, titleForOkButton:String = "Ok" ,preferredStyle: UIAlertController.Style = .alert, actions: [UIAlertAction]? = nil) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        
        let actionsToAdd: [UIAlertAction] = {
            guard let actions = actions else {
                let okAction = UIAlertAction(title: titleForOkButton, style: .cancel, handler: nil)
                
                return [okAction]
            }
            return actions
        }()
        
        for action in actionsToAdd {
            alertController.addAction(action)
        }
        
        return alertController
    }
    
    final class func alertController(alertData: AlertHelper ,preferredStyle: UIAlertController.Style = .alert, actions: [UIAlertAction]? = nil) -> UIAlertController {
        let alertController = UIAlertController.alertController(forTitle: alertData.title,
                                                                message: alertData.message,
                                                                titleForOkButton: alertData.titleForOkButton,
                                                                preferredStyle: preferredStyle,
                                                                actions: actions)
        return alertController
    }
    
    
}
