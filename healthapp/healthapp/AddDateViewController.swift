//
//  AddDateViewController.swift
//  healthapp
//
//  Created by mac on 2021/10/5.
//

import UIKit
import AARatingBar
import CoreLocation
import FirebaseStorage
import FirebaseDatabase
import CLImagePickerTool

class AddDateViewController: UIViewController , CLLocationManagerDelegate{
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var addTF: UITextField!
    
    @IBOutlet weak var detailTF: UITextField!
    
    @IBOutlet weak var imageName_1: UILabel!
    
    @IBOutlet weak var imageName_2: UILabel!
    
    @IBOutlet weak var imageName_3: UILabel!
    
    @IBOutlet weak var scoreTF: UILabel!
    @IBOutlet weak var scoreStepper: UIStepper!
    
    @IBOutlet weak var pickerView: UIPickerView!
    let locationManager:CLLocationManager = CLLocationManager()
    var addStr = ""
    var lat : Double = 0.0
    var lon : Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getUserLoction()

        

    }
    func getUserLoction(){
        
           //设置定位服务管理器代理
           locationManager.delegate = self
           //设置定位进度
           locationManager.desiredAccuracy = kCLLocationAccuracyBest
           //更新距离
           locationManager.distanceFilter = 100
           ////发送授权申请
           locationManager.requestAlwaysAuthorization()
           if (CLLocationManager.locationServicesEnabled())
           {
               //允许使用定位服务的话，开启定位服务更新
               locationManager.startUpdatingLocation()
               print("定位开始")
           }

    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 取得目前的座標位置
        let _curLocation = locations[0]
        
        // curLocation.coordinate.latitude 目前緯度
        // curLocation.coordinate.longitude 目前經度
        let _nowLocationCoordinate2D = CLLocationCoordinate2D(
            latitude: _curLocation.coordinate.latitude,
            longitude: _curLocation.coordinate.longitude
        )
        
        lat = (_curLocation.coordinate.latitude)
        lon = (_curLocation.coordinate.longitude)
        self.reverseGeocodeLocation(_latitude: (_curLocation.coordinate.latitude), _longitude: (_curLocation.coordinate.longitude))
    }

    private func reverseGeocodeLocation(_latitude: Double, _longitude: Double) -> Void {
        let geoCoder = CLGeocoder()
        let currentLocation = CLLocation(
            latitude: _latitude,
            longitude: _longitude
        )
        geoCoder.reverseGeocodeLocation(
            currentLocation, completionHandler: { [self]
                (placemarks, error) -> Void in
                if error != nil {
                    // 這邊可以加入一些你的 Try Error 機制
                    return
                }
                /*  name            街道地址
                 *  country         國家
                 *  province        省籍
                 *  locality        城市
                 *  sublocality     縣市、區
                 *  route           街道、路名
                 *  streetNumber    門牌號碼
                 *  postalCode      郵遞區號
                 */
                if placemarks != nil && (placemarks?.count)! > 0{
                    let placemark = (placemarks?[0])! as CLPlacemark
                    addStr = placemark.country!
                        + placemark.subAdministrativeArea!
                        + placemark.locality!
                        + placemark.name!
                    //這邊拼湊轉回來的地址
                }
            }
        )
    }
    
    func addressToLatlon(address : String){
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(address, completionHandler: {(placemarks:[CLPlacemark]!,error:Error!) in
            if error != nil{
                print(error!)
                return
            }
            if placemarks != nil && placemarks.count > 0{
                let placemark = placemarks[0] as CLPlacemark
                print("\(placemark.location?.coordinate.latitude ?? 0.0),\(placemark.location?.coordinate.longitude ?? 0.0)")
            }
        })

    }

    @IBAction func addressButtonAction(_ sender: Any) {
        addTF.text = addStr
        
        
        
    }
    @IBAction func addImage_1(_ sender: Any) {
        
        // 建立一個 UIImagePickerController 的實體
             let imagePickerController = UIImagePickerController()
             
             // 委任代理
             imagePickerController.delegate = self
             
             // 建立一個 UIAlertController 的實體
             // 設定 UIAlertController 的標題與樣式為 動作清單 (actionSheet)
             let imagePickerAlertController = UIAlertController(title: "上傳圖片", message: "請選擇要上傳的圖片", preferredStyle: .actionSheet)
             
             // 建立三個 UIAlertAction 的實體
             // 新增 UIAlertAction 在 UIAlertController actionSheet 的 動作 (action) 與標題
             let imageFromLibAction = UIAlertAction(title: "照片圖庫", style: .default) { (Void) in
                 
                 // 判斷是否可以從照片圖庫取得照片來源
                 if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                     
                     // 如果可以，指定 UIImagePickerController 的照片來源為 照片圖庫 (.photoLibrary)，並 present UIImagePickerController
                     imagePickerController.sourceType = .photoLibrary
                     self.present(imagePickerController, animated: true, completion: nil)
                 }
             }
       
             
             // 新增一個取消動作，讓使用者可以跳出 UIAlertController
             let cancelAction = UIAlertAction(title: "取消", style: .cancel) { (Void) in
                 
                 imagePickerAlertController.dismiss(animated: true, completion: nil)
             }
             
             // 將上面三個 UIAlertAction 動作加入 UIAlertController
             imagePickerAlertController.addAction(imageFromLibAction)
         imagePickerAlertController.addAction(cancelAction)
             
             // 當使用者按下 uploadBtnAction 時會 present 剛剛建立好的三個 UIAlertAction 動作與
             present(imagePickerAlertController, animated: true, completion: nil)
         }
        
        
    @IBAction func sendButton(_ sender: Any) {
        
        print("jack",lat)
        print("jack",lon)
        
        
        
    }
    
    
    func setAlert(){
        
        let controller = UIAlertController(title: "訊息通知", message:"您的發文已經發布！！", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "好的", style: .default) { (_) in
                   }
                   controller.addAction(okAction)
                
                   present(controller, animated: true, completion: nil)
    }
    
}
extension AddDateViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController,
       didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
                var selectedImageFromPicker: UIImage?


         let image = info[.originalImage] as? UIImage
        selectedImageFromPicker = image
        // 可以自動產生一組獨一無二的 ID 號碼，方便等一下上傳圖片的命名
              let uniqueString = NSUUID().uuidString
//        let useid :String = userDefaults.string(forKey: "userID") as! String
        

              // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
              if let selectedImage = selectedImageFromPicker {
                  
                  let storageRef = Storage.storage().reference().child("").child("\(uniqueString).png")
                  
                  if let uploadData = selectedImage.pngData() {
                      // 這行就是 FirebaseStroge 關鍵的存取方法。
                      storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
                          
                          if error != nil {
                              
                              // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
                              return
                          }
                    
                          
                          // 連結取得方式就是：data?.downloadURL()?.absoluteString。
                          storageRef.downloadURL { (url
                              , error) in
                              guard let downloadUrl = url else{
                                 return
                              }
//                            self.photoarray.append(downloadUrl.absoluteString)
//                            if(self.photoarray.count != 0 ){
//                                self.responseTv.text = "已上傳圖片數量:" + String(self.photoarray.count)
//                                self.closeKeyBoard()
//                                self.add_btn.isHidden = false
//
//                            }
                         
                            

                          }
          
                      })
                  }
     }

        
        dismiss(animated: true, completion: nil)
    }
}
