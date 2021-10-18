//
//  ViewController.swift
//  healthapp
//
//  Created by mac on 2021/8/25.
//

import UIKit
import MapKit
import CoreLocation
import JJFloatingActionButton

class ViewController: UIViewController , MKMapViewDelegate, CLLocationManagerDelegate,JJFloatingActionButtonDelegate{
    let locationManager = CLLocationManager()
    var array = [["test1",25.053621048961702, 121.55708460423104],["test2",25.054729004292337, 121.5598258176044]]
    @IBOutlet weak var mapView: MKMapView!
    let ENTERED_REGION_MESSAGE = "Welcome to Playa Grande! If the waves are good, you can try surfing!"
    let ENTERED_REGION_NOTIFICATION_ID = "EnteredRegionNotification"
    let EXITED_REGION_MESSAGE = "Bye! Hope you had a great day at the beach!"
    let EXITED_REGION_NOTIFICATION_ID = "ExitedRegionNotification"
    var monitoredRegions: Dictionary<String, Date> = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        initLocationManager()
        initMap()
        let center = UNUserNotificationCenter.current()
           center.requestAuthorization(options: [.badge, .alert, .sound]) { (granted, error) in
           }
        setLiftButton(s: "去登入")
        setRightButton(s: "新增")
  

        // Do any additional setup after loading the view.
    }
    func initLocationManager(){
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()

    }
    
    
    
    func initMap(){
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
    }
    
    func createLocalNotification(message: String, identifier: String) {
         //Create a local notification
         let content = UNMutableNotificationContent()
         content.body = message
        content.sound = UNNotificationSound.default
         
         // Deliver the notification
         let request = UNNotificationRequest.init(identifier: identifier, content: content, trigger: nil)
         
         // Schedule the notification
         let center = UNUserNotificationCenter.current()
         center.add(request) { (error) in
         }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // 1. 還沒有詢問過用戶以獲得權限
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        }
        // 2. 用戶不同意
        else if CLLocationManager.authorizationStatus() == .denied {
        }
        // 3. 用戶已經同意
        else if CLLocationManager.authorizationStatus() == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }
    
    func setupData() {
        // check if can monitor regions
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
//            setRegion(title: "test1",lat: 25.053496478478866, lon: 121.55742548727964)
//            setRegion(title: "test2",lat: 25.054729004292337, lon: 121.5598258176044)
            setRegion(title: "test3",lat: 25.052371400771978, lon: 121.55879907566712)


        }
        else {
            print("test","System can't track regions")
        }
    }
    
    
    func setRegion(title: String,lat :Double,lon :Double){

        
        let geofenceRegionCenter = CLLocationCoordinate2DMake(lat, lon);
             let geofenceRegion = CLCircularRegion(center: geofenceRegionCenter, radius: 150, identifier: title);
             geofenceRegion.notifyOnExit = true
             geofenceRegion.notifyOnEntry = true
            
             
            let span = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
            let mapRegion = MKCoordinateRegion(center: geofenceRegionCenter, span: span)
            self.mapView.setRegion(mapRegion, animated: true)
            let regionCircle = MKCircle(center: geofenceRegionCenter, radius: 150)
            self.mapView.addOverlay(regionCircle)
            self.mapView.showsUserLocation = true;
            self.locationManager.startMonitoring(for: geofenceRegion)
            self.locationManager.requestState(for: geofenceRegion)

    }
    
    

 
    
    //MARK - MKMapViewDelegate
      
      func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
          let overlayRenderer : MKCircleRenderer = MKCircleRenderer(overlay: overlay);
          overlayRenderer.lineWidth = 4.0
          overlayRenderer.strokeColor = UIColor(red: 7.0/255.0, green: 106.0/255.0, blue: 255.0/255.0, alpha: 1)
          overlayRenderer.fillColor = UIColor(red: 0.0/255.0, green: 203.0/255.0, blue: 208.0/255.0, alpha: 0.7)
          return overlayRenderer
      }

    //MARK - CLLocationManagerDelegate
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if (status == CLAuthorizationStatus.authorizedAlways) {
                self.setupData()
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
            print("test","Started Monitoring Region: \(region.identifier)")
        }
        
        func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
            print("test","Enter!")
//            self.message.text = ENTERED_REGION_MESSAGE
            self.createLocalNotification(message: ENTERED_REGION_MESSAGE, identifier: ENTERED_REGION_NOTIFICATION_ID)
        }
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print("test","didDetermineStat!")
        print("test",region.identifier)
        if (state == .inside){
            print("test","inside")
            
            self.createLocalNotification(message: "test" + region.identifier, identifier: region.identifier)


        }
        if(state == .outside){
            print("test","outside")

        }

    }
        func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
           print("test","exit!")
//            self.message.text = EXITED_REGION_MESSAGE
            self.createLocalNotification(message: EXITED_REGION_MESSAGE, identifier: EXITED_REGION_NOTIFICATION_ID)

        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            print("test","didUpdateLocations")
            
            
            let location = locations[locations.count - 1]
            //簡單檢查一下取得的值
             if location.horizontalAccuracy > 0 {  //this line will check if the location is available
             // 由於定位功能十分耗電，我們既然已經取得了位置，就該速速把它關掉
//               locationManager.stopUpdatingLocation()
                print("latitude: \(location.coordinate.latitude), longtitude: \(location.coordinate.longitude)")
                }

        }
        
    func setLiftButton(s: String){
           let LeftButton = UIBarButtonItem(
               title:s,
               style:.plain,
               target:self,
               action:#selector(ViewController.liftAction))
           // 加到導覽列中
           self.navigationItem.leftBarButtonItem = LeftButton
       }
       @objc func liftAction() {
        
        let stroyboard = UIStoryboard(name: "Main", bundle: nil);
        let HomeVc = stroyboard.instantiateViewController(withIdentifier: "adddate")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        appDelegate.window?.rootViewController = HomeVc
           
       }
        
    func setRiButton(s: String){
           let rightButton = UIBarButtonItem(
               title:s,
               style:.plain,
               target:self,
               action:#selector(ViewController.RightAction))
           // 加到導覽列中
        self.navigationItem.rightBarButtonItem = rightButton
       }
       @objc func RightAction() {
  
        
       }

    func setRightButton(s: String){
           let RightButton = UIBarButtonItem(
               title:s,
               style:.plain,
               target:self,
               action:#selector(ViewController.rightAction))
           // 加到導覽列中
           self.navigationItem.rightBarButtonItem = RightButton
       }
       @objc func rightAction() {
        
        let stroyboard = UIStoryboard(name: "Main", bundle: nil);
        let HomeVc = stroyboard.instantiateViewController(withIdentifier: "adddate")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        appDelegate.window?.rootViewController = HomeVc
           
       }
        
    func setFloatingAction(){

        let actionButton = JJFloatingActionButton()
        actionButton.addItem(title: "item 1", image: UIImage(named: "First")?.withRenderingMode(.alwaysTemplate)) { item in
          // do something
            item.titlePosition = .bottom
            
        }

        view.addSubview(actionButton)
        
    }
    func floatingActionButtonDidOpen(_ button: JJFloatingActionButton) {
        
    }
}

