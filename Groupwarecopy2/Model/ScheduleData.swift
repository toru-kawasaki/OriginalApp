//
//  ScheduleData.swift
//  Groupware
//
//  Created by PC-SYSKAI556 on 2023/04/06.
//

import Foundation
import Firebase
import RealmSwift

class ScheduleData: Object {
    @objc dynamic var id = 0
    @objc dynamic var userId = ""
    @objc dynamic var startDateTime: Date?
    @objc dynamic var endDateTime: Date?
    @objc dynamic var title: String?
    @objc dynamic var contents: String?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    convenience init(documentID: String, data: [String: AnyObject]){
        self.init()
        self.userId = documentID
        //let scheduleDic = document.data()
        //let schedule:Schedule = Schedule(document: scheduleDic["202304"] as! [String : Any])
        //let mapData = scheduleDic["schedule"] as? [Any]
        //FireStoreの型からSwiftで使用する型に変換する
        //let dicData = data as! NSMutableDictionary
        let scheduleDic = data //dicData  as NSDictionary as! [String : AnyObject]
        self.id = scheduleDic["id"] as! Int
        let startDate = scheduleDic["startDate"] as? Timestamp
        self.startDateTime = startDate?.dateValue()
        let endDate = scheduleDic["endDate"] as? Timestamp
        self.endDateTime = endDate?.dateValue()
        self.title = scheduleDic["title"] as? String
        self.contents = scheduleDic["contents"] as? String
        print("DEBUG_PRINT: \(self.startDateTime)")
            
        
        //self.startDateTime = (scheduleDic["startDate"] as? Timestamp)?.dateValue()
        //self.endDateTime = (scheduleDic["endDate"] as? Timestamp)?.dateValue()
        //self.title = scheduleDic["title"] as? String
        //self.contents = scheduleDic["contents"] as? String
    }
}
