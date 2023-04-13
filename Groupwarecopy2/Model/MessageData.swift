//
//  MessageData.swift
//  Groupware
//
//  Created by PC-SYSKAI556 on 2023/04/04.
//

import Foundation

class MessageData: NSObject {
    var user: String
    var title: String
    var contents: String
    
    init(json: [String: Any]){
        self.user = json["userid"] as! String
        self.title = json["title"] as! String
        self.contents = json["contents"] as! String
    }
}
