//
//  InAppNotification.swift
//  FetchRecipes
//
//  Created by Gina Mullins on 8/17/24.
//

import Foundation

// MARK: defines all notifications which can be triggered in app via NotificationCenter

enum InAppNotification: String {
    case connectivityDidChange
    
    var notification: Notification {
        let name = Notification.Name.init(rawValue: rawValue)
        return Notification(name: name)
    }
    
    var notificationName: String {
        notification.name.rawValue
    }
}

