//
//  AddDateViewController.swift
//  healthapp
//
//  Created by mac on 2021/10/5.
//

import UIKit
import AARatingBar
import CoreLocation

class AddDateViewController: UIViewController , CLLocationManagerDelegate{
    
    @IBOutlet weak var nameTF: UITextField!
    
    @IBOutlet weak var addTF: UITextField!
    
    @IBOutlet weak var detailTF: UITextField!
    
    @IBOutlet weak var imageName_1: UILabel!
    
    @IBOutlet weak var imageName_2: UILabel!
    
    @IBOutlet weak var imageName_3: UILabel!
    
    @IBOutlet weak var ratingBar: AARatingBar!
    
    @IBOutlet weak var pickerView: UIPickerView!
    let locationManager:CLLocationManager = CLLocationManager()
    var addStr = ""
    
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
        
        print("jack","in")
        
        print("latitude = \(_curLocation.coordinate.latitude)")
        print("longitude = \(_curLocation.coordinate.longitude)")
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
                    print("jack",placemark)
                    print(placemark.country)
                                        print(placemark.locality)
                             
                                        print(placemark.thoroughfare)
                                        print(placemark.postalCode)
                                        print(placemark.subThoroughfare)
                    addStr = placemark.country!
                        + placemark.subAdministrativeArea!
                        + placemark.locality!
                        + placemark.name!
                    //這邊拼湊轉回來的地址
                    self.addressToLatlon(address: "台中市南區復興路一段460號")
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
    }
    
    @IBAction func addImgage_2(_ sender: Any) {
    }
    
    
    @IBAction func addImage_3(_ sender: Any) {
    }
    
    @IBAction func sendButton(_ sender: Any) {
    }
    
    
}
