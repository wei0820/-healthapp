//
//  SelectPageViewController.swift
//  healthapp
//
//  Created by mac on 2021/10/22.
//

import UIKit
import Firebase
import Toaster
class SelectPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLiftButton(s: "去登入")
        setRightButton(s: "新增")


        // Do any additional setup after loading the view.
    }
    
    @IBAction func listTypeButtonAction(_ sender: Any) {
    
        jumpViewController(name: "list")

    }
    
    @IBAction func mapTypeButtonAction(_ sender: Any) {

        jumpViewController(name: "home")
        
    }
    
    
    
    func jumpViewController(name :String){
        
        
        
        let stroyboard = UIStoryboard(name: "Main", bundle: nil);
        let HomeVc = stroyboard.instantiateViewController(withIdentifier: name)
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        appDelegate.window?.rootViewController = HomeVc
        
    }
    
    
    
    
func setLiftButton(s: String){
       let LeftButton = UIBarButtonItem(
           title:s,
           style:.plain,
           target:self,
           action:#selector(SelectPageViewController.liftAction))
       // 加到導覽列中
       self.navigationItem.leftBarButtonItem = LeftButton
   }
   @objc func liftAction() {
    
    jumpViewController(name: "login")

       
   }
    
func setRightButton(s: String){
       let RightButton = UIBarButtonItem(
           title:s,
           style:.plain,
           target:self,
           action:#selector(SelectPageViewController.rightAction))
       // 加到導覽列中
       self.navigationItem.rightBarButtonItem = RightButton
   }
   @objc func rightAction() {
    
    
    if  Auth.auth().currentUser != nil{
        jumpViewController(name: "adddate")
    }else{
        Toast(text: "請先登入後再使用!!",duration: 0.5).show()

    }

    
       
   }
}
