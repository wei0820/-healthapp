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
    var like : Int
    var unlike : Int
    var usermessage : String
    var key : String
    var url_1 :String
    var url_2 :String
    var url_3 :String
    var type : Int
    var scroe : Int


    init(snapshot: DataSnapshot) {
        let snapshotValue: [String: AnyObject] = snapshot.value as! [String: AnyObject]
        self.id = snapshotValue["id"] as! String
        self.name = snapshotValue["name"] as! String
        self.address = snapshotValue["address"] as! String
        self.lat = snapshotValue["lat"] as! Double
        self.lon = snapshotValue["lon"] as! Double
        self.uuid = snapshotValue["uuid"] as! String
        self.date = snapshotValue["date"] as! String
        self.like = snapshotValue["like"] as! Int
        self.unlike = snapshotValue["unlike"] as! Int
        self.usermessage = snapshotValue["usermessage"] as! String
        self.key = snapshotValue["key"] as! String
        self.url_1 = snapshotValue["url_1"] as! String
        self.url_2 = snapshotValue["url_2"] as! String
        self.url_3 = snapshotValue["url_3"] as! String
        self.type = snapshotValue["type"] as! Int
        self.scroe = snapshotValue["scroe"] as! Int


    }
    
    
    
    
    
    
    
    
    
}
