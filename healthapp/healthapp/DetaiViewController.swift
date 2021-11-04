//
//  DetaiViewController.swift
//  healthapp
//
//  Created by mac on 2021/11/3.
//

import UIKit

class DetaiViewController: UIViewController {
    
    var id : String = ""
    var name : String = ""
    var address : String = ""
    var lat : Double = 0.0
    var lon : Double =  0.0
    var uuid : String = ""
    var date : String = ""
    var like : Int = 0
    var unlike : Int = 0
    var usermessage : String = ""
    var key : String = ""
    var url_1 :String = ""
    var url_2 :String = ""
    var url_3 :String = ""
    var type : Int = 0
    var scroe : Int = 0

    @IBOutlet weak var trrrr: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        print("Jack", name)
        
        trrrr.text = name
    }
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
