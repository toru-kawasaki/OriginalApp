//
//  Schedule.swift
//  Groupware
//
//  Created by PC-SYSKAI556 on 2023/04/10.
//

import Foundation
import Firebase

class Schedule: NSObject {
    var startDateTime: Date?
    var endDateTime: Date?
    var title: String?
    var contents: String?

    init(document: [String: AnyObject]){
        let scheduleDic = document
        let startDate = scheduleDic["startDate"] as? Timestamp
        self.startDateTime = startDate?.dateValue()
        let endDate = scheduleDic["endDate"] as? Timestamp
        self.endDateTime = endDate?.dateValue()
        self.title = scheduleDic["title"] as? String
        self.contents = scheduleDic["contents"] as? String
    }
}
