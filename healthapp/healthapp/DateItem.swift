//
//  DateItem.swift
//  healthapp
//
//  Created by mac on 2021/10/5.
//

import Foundation
import Firebase



struct DateItem {
    
    var id : String
    var name : String
    var address : String
    var lat : Double
    var lon : Double
    var uuid : String
    var date : String
    var like : String
    var unlike : String
    var usermessage : String
    var key : String

    init(snapshot: DataSnapshot) {
        let snapshotValue: [String: AnyObject] = snapshot.value as! [String: AnyObject]
        self.id = snapshotValue["id"] as! String
        self.name = snapshotValue["name"] as! String
        self.address = snapshotValue["address"] as! String
        self.lat = snapshotValue["lat"] as! Double
        self.lon = snapshotValue["lon"] as! Double
        self.uuid = snapshotValue["uuid"] as! String
        self.date = snapshotValue["date"] as! String
        self.like = snapshotValue["like"] as! String
        self.unlike = snapshotValue["unlike"] as! String
        self.usermessage = snapshotValue["usermessage"] as! String
        self.key = snapshotValue["key"] as! String


    }
    
    
    
    
    
    
    
    
    
}
