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
import Firebase
import Toaster
import MLKit
import MLKitTranslate

class AddDateViewController: UIViewController , CLLocationManagerDelegate,UITextFieldDelegate,UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    // UIPickerViewDataSource 必須實作的方法：
    // UIPickerView 各列有多少行資料
    func pickerView(
        _ pickerView: UIPickerView,
      numberOfRowsInComponent component: Int) -> Int {
        // 返回陣列 meals 的成員數量
        return pickerData.count
    }

    // UIPickerView 每個選項顯示的資料
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        // 設置為陣列 meals 的第 row 項資料
        return pickerData[row]
    }

    // UIPickerView 改變選擇後執行的動作
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        // 依據元件的 tag 取得 UITextField
        Toast(text: "選擇了:" + pickerData[row],duration: 0.5).show()
        pickerType =  row

    }
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var addTF: UITextField!
    
    @IBOutlet weak var detailTF: UITextField!
    
    @IBOutlet weak var imageName_1: UILabel!
    
    
    @IBOutlet weak var uploadImagButton: UIButton!
    
    @IBOutlet weak var scoreTF: UILabel!
    @IBOutlet weak var scoreStepper: UIStepper!
    
    @IBOutlet weak var pickerView: UIPickerView!
    let locationManager:CLLocationManager = CLLocationManager()
    var addStr = ""
    var lat : Double = 0.0
    var lon : Double = 0.0
    var photoarray: Array<String> = []
    var useid :String = ""

    var pickerData: [String] =  ["食", "衣", "住", "行", "育", "樂"]
    var pickerType  = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  Auth.auth().currentUser != nil{
            useid = Auth.auth().currentUser!.uid
        }
        
        getUserLoction()
        addStepper()
        setTF()
        setPicker()


        

    }
    
    func setPicker(){
        
        pickerView.delegate = self
        pickerView.dataSource  = self
        
        }
    
    func setTF(){
        nameTF.placeholder = "請輸入名稱"
        nameTF.borderStyle = .roundedRect
        nameTF.clearButtonMode = .whileEditing
        nameTF.returnKeyType = .done
        nameTF.delegate  = self
        
        
        addTF.placeholder = "請輸入地址"
        addTF.borderStyle = .roundedRect
        addTF.clearButtonMode = .whileEditing
        addTF.returnKeyType = .done
        addTF.delegate  = self

        
        
        
        detailTF.placeholder = "請輸入內容"
        detailTF.borderStyle = .roundedRect
        detailTF.clearButtonMode = .whileEditing
        detailTF.returnKeyType = .done
        detailTF.delegate  = self

    }
    
    func addStepper(){
        // 建立一個 UIStepper
        // UIStepper 預設值
        
        scoreStepper.value = 100
        scoreTF.text = String(Int(scoreStepper.value))
               
        // UIStepper 最小值
        scoreStepper.minimumValue = 0
               
        // UIStepper 最大值
        scoreStepper.maximumValue = 100
        scoreStepper.stepValue = 1
        scoreStepper.autorepeat = true
        scoreStepper.addTarget(self, action: #selector(onStepperChange), for: .valueChanged)
        
        
        
    }
    
    
    @objc func onStepperChange() {
        // 將 UILabel 的值設置為 UIStepper 目前的值
        scoreTF.text = String(Int(scoreStepper.value))
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
        var url_1 = ""
        var url_2 = ""
        var url_3 = ""

        var name = nameTF.text!.isEmpty ? "" :  nameTF.text!
        var address = addTF.text!.isEmpty ?   "": addTF.text!
        var  usermessage = detailTF.text!.isEmpty ? ""  :  detailTF.text!
        var count = photoarray.count
        switch count {
        case 1:
            
            url_1 = photoarray[0].isEmpty ? "" :   photoarray[0]
            break
            
        case 2:
            url_1 = photoarray[0].isEmpty ? "" :   photoarray[0]
            url_2 = photoarray[1].isEmpty ? "" :   photoarray[1]
            break
            
        case 3:
            url_1 = photoarray[0].isEmpty ? "" :   photoarray[0]
           url_2 = photoarray[1].isEmpty ? "" :   photoarray[1]
            url_3 = photoarray[2].isEmpty ? "" :   photoarray[2]
            break
          
            
        default: break
            
            
        }
        var languageId = LanguageIdentification.languageIdentification()
        languageId.identifyLanguage(for: name) { (languageTag, error) in
            if let error = error {
              print("jack","Failed with error: \(error)")
              return
            }
            print("jack","Identified Language: \(self.displayName(for:languageTag!))")
            if let languageCode = languageTag, languageTag != "Chinese" {
               print("jack","Language: \(languageCode)")
             } else {
               print("jack","No language was identified")
             }
          }
    
        
   
    
        FirebaseDatabaseManager.addData(id: useid, name: name, address: address, lat: lat, lon: lon, like: 0, unlike: 0, usermessage: usermessage, url_1: url_1, url_2: url_2, url_3: url_3, type: pickerType, scroe: Int(scoreStepper.value))
        
        setAlert()

        
        
    }
    func displayName(for languageTag: String) -> String {
      if languageTag == IdentifiedLanguage.undetermined {
        return "Undetermined Language"
      }
      return Locale.current.localizedString(forLanguageCode: languageTag)!
    }
    
    func setAlert(){
        
        let controller = UIAlertController(title: "訊息通知", message:"您的發文已經發布！！", preferredStyle: .alert)
      let okAction = UIAlertAction(title: "好的", style: .default) {
        (_) in
        let stroyboard = UIStoryboard(name: "Main", bundle: nil);
        let HomeVc = stroyboard.instantiateViewController(withIdentifier: "select")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        appDelegate.window?.rootViewController = HomeVc
        
        
                   }
                   controller.addAction(okAction)
                
                   present(controller, animated: true, completion: nil)
    }
    
    
    @IBAction func dissViewButton(_ sender: Any) {
        

        
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
  
              // 當判斷有 selectedImage 時，我們會在 if 判斷式裡將圖片上傳
              if let selectedImage = selectedImageFromPicker {
                  
                  let storageRef = Storage.storage().reference().child(useid).child("\(uniqueString).png")
                  
                  if let uploadData = selectedImage.pngData() {
                      // 這行就是 FirebaseStroge 關鍵的存取方法。
                      storageRef.putData(uploadData, metadata: nil, completion: { (data, error) in
                          
                          if error != nil {
                              
                              // 若有接收到錯誤，我們就直接印在 Console 就好，在這邊就不另外做處理。
                              return
                          }
                    
                          
                          // 連結取得方式就是：data?.downloadURL()?.absoluteString。
                        storageRef.downloadURL { [self] (url
                              , error) in
                              guard let downloadUrl = url else{
                                 return
                              }
                            self.photoarray.append(downloadUrl.absoluteString)
                            if(self.photoarray.count != 0 ){
                                self.imageName_1.text = "已上傳圖片數量:" + String(self.photoarray.count)
                                
                                if(self.photoarray.count >= 3 ){
                                    uploadImagButton.isEnabled = false
                                    uploadImagButton.setTitle("已達上傳上限", for:.normal)
                                }
                            

                            

                         

                            }
                         
                            

                          }
          
                      })
                  }
     }

        
        dismiss(animated: true, completion: nil)
    }
    // 按下Return後會反應的事件
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            //利用此方式讓按下Return後會Toogle 鍵盤讓它消失
            textField.resignFirstResponder()
            return false
        }
     override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
         self.view.endEditing(true)
     }
    
    
    
}
