//
//  FirebaseDatabaseManager.swift
//  healthapp
//
//  Created by mac on 2021/10/4.
//

import Foundation
import Firebase
import FirebaseDatabase

class FirebaseDatabaseManager{
    
    static func addData(id : String , name :String ,address :String , lat :Double,lon :Double,like : Int ,unlike:Int ,usermessage :String,
                        url_1 : String, url_2 : String ,url_3 : String ,type : Int,scroe : Int){
        let reference: DatabaseReference! = Database.database().reference().child("SharePlace").child("SharePlace")
            let childRef = reference.childByAutoId() // 隨機生成的節點唯一識別碼，用來當儲存時的key值
            let dateReviewReference = reference.child(childRef.key!)
            // 新增節點資料
            var dateReview: [String : AnyObject] = [String : AnyObject]()
        
            dateReview["id"] = id as AnyObject
            dateReview["name"] = name as AnyObject
            dateReview["address"] = address as AnyObject
            dateReview["lat"] = lat as AnyObject
            dateReview["lon"] = lon as AnyObject
            dateReview["uuid"] = getUUID() as AnyObject
            dateReview["date"]  = DateManager.setDate() as AnyObject
            dateReview["like"]  = like as AnyObject
            dateReview["unlike"]  = unlike as AnyObject
            dateReview["usermessage"]  = usermessage as AnyObject
            dateReview["key"]  = childRef.key as AnyObject
            dateReview["url_1"] = url_1 as AnyObject
            dateReview["url_2"] = url_2 as AnyObject
            dateReview["url_3"] = url_3 as AnyObject
            dateReview["type"] = type as AnyObject
            dateReview["scroe"] = scroe as AnyObject

        dateReviewReference.updateChildValues(dateReview) { (err, ref) in
              if err != nil{
                  print("jack： \(err!)")
                  return
              }
              
              print("jack",ref.description())
          }



    }
    
    static func  getDataForLabel(){
        let reference: DatabaseReference! = Database.database().reference().child("SharePlace").child("SharePlace")
                   
                   reference.queryOrderedByKey().observe(.value, with: { snapshot in
                       if snapshot.childrenCount > 0 {
                           
                           for item in snapshot.children {
                               let data = DateItem(snapshot: item as! DataSnapshot)
                            
                            print("Jack",data.address)
                            print("Jack",data.type)
                            print("Jack",data.name)

                           }
                           
                           
                       }
                       
                   })
    }
    
    
    static func getUUID() -> String{
        return UIDevice.current.identifierForVendor?.uuidString ?? UUID().uuidString
    }
}
