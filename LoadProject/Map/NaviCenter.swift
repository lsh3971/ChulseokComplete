//
//  TEST_MapVC.swift
//  LoadProject
//
//  Created by tigris on 2018. 1. 30..
//  Copyright © 2018년 SeungSAMI. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import SwiftyJSON
import Alamofire

enum Location {
    case startLocation
    case destinationLocation
}

class NaviCenter: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate{
    
    let key = "AIzaSyAONBXi5sUGG_NCAiiQkVQro52dEvmmkGQ"
    var locationMarker: GMSMarker!
    var SegmentControlSwitch = true
    var moveName = String()
    
    
    @IBOutlet weak var googleMaps: GMSMapView!
    
    
    @IBOutlet weak var startLocationTextField: UITextField!
    
    @IBOutlet weak var endLocationTextField: UITextField!
    
    @IBAction func MakeLocation(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
        UserDefaults.standard.removeObject(forKey: "routeTime")
        UserDefaults.standard.removeObject(forKey: "TransitMode")
    }
    
    var locationManager = CLLocationManager() // 클래스 초기화
    var locationSelected = Location.startLocation
    
    var locationStart = CLLocation()
    var locationEnd = CLLocation()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
//        startLocationLabel.layer.cornerRadius = 5
//        startLocationLabel.layer.borderColor = UIColor.gray.cgColor
//        startLocationLabel.layer.borderWidth = 0.3
//        startLocationLabel.layer.masksToBounds = true
//
//        endLocationLabel.layer.cornerRadius = 5
//        endLocationLabel.layer.borderColor = UIColor.gray.cgColor
//        endLocationLabel.layer.borderWidth = 0.3
//        endLocationLabel.layer.masksToBounds = true
        
        markerMode.text = "출발마커"
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startMonitoringSignificantLocationChanges()
        
         busModeButton.isSelected = true

        busModeButton.setBackgroundImage(UIImage(named : "selectBusIcon.png"), for: UIControlState.normal)
        subwayModeButton.setBackgroundImage(UIImage(named : "subwayIcon.png"), for: UIControlState.normal)
        carModeButton.setBackgroundImage(UIImage(named : "carIcon.png"), for: UIControlState.normal)
        
       
        
        // Map initation code
        let camera =  GMSCameraPosition.camera(withLatitude: (self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!, zoom: 12.0) // 시작 위치
        
        self.googleMaps.camera = camera
        self.googleMaps.delegate = self
        self.googleMaps?.isMyLocationEnabled = true
        self.googleMaps.settings.myLocationButton = true
        self.googleMaps.settings.compassButton = true
        self.googleMaps.settings.zoomGestures = true
        
        
        
//        isRouteKindMenuHidden = false // SlideMenu initiallize
//        routeMenuInitiallize() // SlideMenu initiallize
        
        
        UserDefaults.standard.removeObject(forKey: "polylineNumber")
        
    }
    
    
    
    
    
    // MARK: - Loaction Manager delegates
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    
    
    
    
    // MARK: - 시작위치 검색버튼
    @IBAction func openStartLocation(_ sender: UIButton) {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        // selected location
        locationSelected = .startLocation
        
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    // MARK: - 도착위치 검색버튼
    @IBAction func openDestinationLocation(_ sender: UIButton) {
        
        let autoCompleteController = GMSAutocompleteViewController()
        autoCompleteController.delegate = self
        
        // selected location
        locationSelected = .destinationLocation
        
        self.locationManager.stopUpdatingLocation()
        
        self.present(autoCompleteController, animated: true, completion: nil)
    }
    
    // MARK: - 마커생성
    var StartLatitude:[Any] = []
    var StartLongitude:[Any] = []
    
    var EndLatitude:[Any] = []
    var EndLongitude:[Any] = []
    
    let marker = GMSMarker()
    let DestinationMarker = GMSMarker()
    
    
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees){ // 출발 마커 생성
        //let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.map = googleMaps
        
    }
    
    
    func deleteMarker(latitude: CLLocationDegrees, longitude: CLLocationDegrees){ // 출발 마커 삭제
        //let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.map = nil
    }
    
    
    func DestinationCreateMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees){ // 도착 마커 생성
        DestinationMarker.position = CLLocationCoordinate2DMake(latitude, longitude)
        DestinationMarker.title = titleMarker
        DestinationMarker.icon = iconMarker
        DestinationMarker.map = googleMaps
        
    }
    
    func DestinationDeleteMarker(latitude: CLLocationDegrees, longitude: CLLocationDegrees){ // 도착 마커 삭제
        //        let marker = GMSMarker()
        DestinationMarker.position = CLLocationCoordinate2DMake(latitude, longitude)
        DestinationMarker.map = nil
    }
    
    @IBOutlet weak var markerMode: UITextField!
    
    @IBAction func segControl(_ sender: UIButton) {
        
        let locationAlert = UIAlertController(title:"화면터치 마커 종류", message: "화면터치시 마커의 종류를 선택합니다", preferredStyle: .actionSheet)
        
        let informantTrueAction = UIAlertAction(title:"출발마커 Mode",style: .default, handler: {(action:UIAlertAction) -> Void in
            self.SegmentControlSwitch = true
            self.markerMode.text = "출발마커"
        })
        let informantFalseAction = UIAlertAction(title:"도착마커 Mode",style: .default, handler: {(action:UIAlertAction) -> Void in
            self.SegmentControlSwitch = false
            self.markerMode.text = "도착마커"
        })
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: UIAlertActionStyle.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        
        locationAlert.addAction(cancelAction)
        locationAlert.addAction(informantTrueAction)
        locationAlert.addAction(informantFalseAction)
        
        
        self.present(locationAlert, animated: true,completion: nil)
        
    }
    
    
    
    // MARK: - 출발, 도착 현재위치눌렀을때 마커표시
    @IBAction func MyLocationButton(_ sender: Any) { // 현재위치 버튼
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        let MyLatitude = (self.locationManager.location?.coordinate.latitude)!
        let MyLongitude = (self.locationManager.location?.coordinate.longitude)!
            
            if StartLatitude.isEmpty{
                StartLatitude.insert(MyLatitude, at: 0)
                StartLongitude.insert(MyLongitude, at: 0)
            } else{
                StartLatitude[0] = MyLatitude
                StartLongitude[0] = MyLongitude
                
            }
            createMarker(titleMarker: "출발지점", iconMarker: #imageLiteral(resourceName: "StartIcon2.png") , latitude: StartLatitude[0] as! CLLocationDegrees, longitude: StartLongitude[0] as! CLLocationDegrees)
            removePolyline()
            
            popStartName()
            print("Mylatitude: \(MyLatitude) &&& MyLongtitude: \(MyLongitude)") // when you tapped coordinate
    }
    
    
    @IBAction func myLocationButtonEnd(_ sender: UIButton) {
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        let MyLatitude = (self.locationManager.location?.coordinate.latitude)!
        let MyLongitude = (self.locationManager.location?.coordinate.longitude)!
        
        if EndLatitude.isEmpty{
            EndLatitude.insert(MyLatitude, at: 0)
            EndLongitude.insert(MyLongitude, at: 0)
        } else{
            EndLatitude[0] = MyLatitude
            EndLongitude[0] = MyLongitude
            
        }
        
        DestinationCreateMarker(titleMarker: "도착지점", iconMarker: #imageLiteral(resourceName: "DestinationIcon2.png") , latitude: EndLatitude[0] as! CLLocationDegrees, longitude: EndLongitude[0] as! CLLocationDegrees)
        removePolyline()
        popEndName()
        print("Mylatitude: \(MyLatitude) &&& MyLongtitude: \(MyLongitude)") // when you tapped coordinate
        
    }
    
    
    
    
    
    // MARK: - 지도를 터치했을때 마커표시
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        // 지도를 터치하였을때의 반응
        
        
                if SegmentControlSwitch == true{
                
                if StartLatitude.isEmpty{
                    StartLatitude.insert(coordinate.latitude, at: 0)
                    StartLongitude.insert(coordinate.longitude, at: 0)
                } else{
                    StartLatitude[0] = coordinate.latitude
                    StartLongitude[0] = coordinate.longitude
                    
                }
                
                createMarker(titleMarker: "출발지점", iconMarker: #imageLiteral(resourceName: "StartIcon2") , latitude: StartLatitude[0] as! CLLocationDegrees, longitude: StartLongitude[0] as! CLLocationDegrees)
                removePolyline()
                
                let camera =  GMSCameraPosition.camera(withLatitude: StartLatitude[0] as! CLLocationDegrees, longitude: StartLongitude[0] as! CLLocationDegrees, zoom: 12.0)
                self.googleMaps.animate(to: camera)
                self.googleMaps.delegate = self
                
                popStartName()
            } else {
                
                if EndLatitude.isEmpty{
                    EndLatitude.insert(coordinate.latitude, at: 0)
                    EndLongitude.insert(coordinate.longitude, at: 0)
                } else{
                    EndLatitude[0] = coordinate.latitude
                    EndLongitude[0] = coordinate.longitude
                    
                }
                
                DestinationCreateMarker(titleMarker: "도착지점", iconMarker: #imageLiteral(resourceName: "DestinationIcon2") , latitude: EndLatitude[0] as! CLLocationDegrees, longitude: EndLongitude[0] as! CLLocationDegrees)
                removePolyline()
                
                let camera =  GMSCameraPosition.camera(withLatitude: EndLatitude[0] as! CLLocationDegrees, longitude: EndLongitude[0] as! CLLocationDegrees, zoom: 12.0)
                self.googleMaps.animate(to: camera)
                self.googleMaps.delegate = self
                
                popEndName()
            }
        
        
    }
    
    
    
    
    // MARK: - GMSAutocompeteViewController delegate
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        // 사용 가능한 자동 완성 예상 검색어에서 장소를 선택하면 호출됩니다.
        // Change map location
        
        let camera = GMSCameraPosition.camera(withLatitude: place.coordinate.latitude, longitude: place.coordinate.longitude, zoom: 12.0) // 검색이후 검색한 위치로 이동
        
        
        
        // set coordinate to text
        if locationSelected == .startLocation {
            //            startLocation.text = "\(place.coordinate.latitude), \(place.coordinate.longitude)"
            locationStart = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            
            if StartLatitude.isEmpty{
            } else {
                deleteMarker(latitude: StartLatitude[0] as! CLLocationDegrees, longitude: StartLongitude[0] as! CLLocationDegrees)
                StartLatitude.removeAll()
                StartLongitude.removeAll()
            }
            
            createMarker(titleMarker: "출발지점", iconMarker: #imageLiteral(resourceName: "StartIcon2") , latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            
            StartLatitude.insert(place.coordinate.latitude, at: 0)
            StartLongitude.insert(place.coordinate.longitude, at: 0)
            popStartName()
            removePolyline()
        } else {
            //            destinationLocation.text = "\(place.coordinate.latitude), \(place.coordinate.longitude)"
            locationEnd = CLLocation(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            
            if EndLatitude.isEmpty{
            } else {
                DestinationDeleteMarker(latitude: EndLatitude[0] as! CLLocationDegrees, longitude: EndLongitude[0] as! CLLocationDegrees)
                EndLatitude.removeAll()
                EndLongitude.removeAll()
            }
            
            DestinationCreateMarker(titleMarker: "도착지점", iconMarker: #imageLiteral(resourceName: "DestinationIcon2") , latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
            
            EndLatitude.insert(place.coordinate.latitude, at: 0)
            EndLongitude.insert(place.coordinate.longitude, at: 0)
            popEndName()
            removePolyline()
        }
        
        self.googleMaps.camera = camera
        self.dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error \(error)")
        // 자동 완성 예상 검색어 또는 장소 세부 정보를 검색 할 때 재 시도 할 수없는 오류가 발생하면 호출됩니다.
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        // 사용자가 GMSAutocompleteViewController의 [Cancel] 버튼을 누를 때 호출됩니다.
        self.dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        // 자동 완성 예상 요청이 발생한 직후에 한 번 호출됩니다.
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        // 새로운 자동 완성 예측이 수신 될 때마다 한 번 호출됩니다.
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    // GMSAutocompeteViewController delegate END
    
    
    //MARK: - 좌표이름표시
    var startName = String()
    
    func popStartName(){
        var startAddressSimple = ""
        let popCoordinate = "\(StartLatitude[0]),\(StartLongitude[0])"

        print(popCoordinate)
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(popCoordinate)&key=\(key)"
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            if let json = try? JSON(data: response.data!){
                let startAddress = json["results"][0]["formatted_address"].stringValue
                let startAddressSimpleBe = json["results"][1]["address_components"].arrayValue
                
                for i in (0..<2).reversed(){
                    let startAddressSimpleEle = startAddressSimpleBe[i]["short_name"].stringValue
                    startAddressSimple = startAddressSimple + " \(startAddressSimpleEle)"
                }
                
                self.startLocationTextField.text = startAddress
                self.startName = startAddressSimple
            } else{
                print("Error")
            }
        }
    }
    var endName = String()
    func popEndName(){
        var endAddressSimple = ""
        let popCoordinate = "\(EndLatitude[0]),\(EndLongitude[0])"
        
        print(popCoordinate)
        let url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(popCoordinate)&key=\(key)"
        
        Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
            if let json = try? JSON(data: response.data!){
                let endAddress = json["results"][0]["formatted_address"].stringValue
                let endAddressSimpleBe = json["results"][1]["address_components"].arrayValue
                
                for i in (0..<2).reversed(){
                    let endAddressSimpleEle = endAddressSimpleBe[i]["short_name"].stringValue
                    endAddressSimple = endAddressSimple + " \(endAddressSimpleEle)"
                }
                
                self.endLocationTextField.text = endAddress
                self.endName = endAddressSimple
            } else{
                print("Error")
            }
        }
    }
    
    
    
    //MARK: - 시간파싱
//    @IBAction func TestButton(_ sender: UIButton) {
//        let timeInterval = NSDate().timeIntervalSince1970
//        print(timeInterval)
//        let timeInterval2 = NSDate().timeIntervalSinceNow
//        print(timeInterval2)
//
//
//    }
    
    
    //MARK: - 폴리라인 그리기
    var pointKind:[Any] = []
    var routeTimeData = [String]()
    var routeTimeValueData = [Int]()
    var routeTimeValueEle = Int()
    var routeStationData = [Array<Any>]()
    var polylineNum = UserDefaults.standard.integer(forKey: "polylineNumber")
    
    @IBOutlet weak var timeLabel: UILabel!
    
    func drawPath(startLocation: CLLocation, endLocation: CLLocation)
    {
        print("가즈아아아아")
        pointKind.removeAll()
        UserDefaults.standard.removeObject(forKey: "routeTime")
        UserDefaults.standard.removeObject(forKey: "routeStation")
        UserDefaults.standard.removeObject(forKey: "routeStationTime")
        if StartLatitude.isEmpty && EndLatitude.isEmpty{
            print("시작점,도착점 미입력")
        }
        else if StartLatitude.isEmpty{
            print("시작점 미입력")
        }
        else if EndLatitude.isEmpty{
            print("도착점 미입력")
        }
        else{
            
            routeTimeValueData.removeAll()
            
            print("시작 좌표 \(StartLatitude[0]),\(StartLongitude[0])")
            print("도착 좌표 \(EndLatitude[0]),\(EndLongitude[0])")
            let origin = "\(StartLatitude[0]),\(StartLongitude[0])"
            let destination = "\(EndLatitude[0]),\(EndLongitude[0])"
            var transitMode = ""
            let receiveTransitMode = transitNum
            var mode = ""
            let arrivalTime = UserDefaults.standard.object(forKey: "sinceTime")
            
            
            
            switch receiveTransitMode{
            case 1:
                mode = "transit"
                transitMode = "bus"
            case 2:
                mode = "transit"
                transitMode = "subway"
            case 3:
                mode = "driving"
                transitMode = ""
            default:
                transitMode = "driving"
            }
            
            
            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&arrival_time=\(arrivalTime!)&avoid=highways&mode=\(mode)&transit_mode=\(transitMode)&alternatives=true&key=\(key)"

        
            Alamofire.request(url, method: .post, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response:DataResponse<Any>) in
                if let json = try? JSON(data: response.data!){
                    //                print("JSON data 출력")
                    //                print(json)
                    let routes = json["routes"].arrayValue
                    if routes.isEmpty{
                        let alertController = UIAlertController(title: "주의",message: "교통수단 혹은 깃발의 위치를 확인하세요(국내의 경우 자가용 길찾기 서비스는 지원되지 않습니다)", preferredStyle: UIAlertControllerStyle.alert)
                        let cancelButton = UIAlertAction(title: "확인", style: UIAlertActionStyle.cancel, handler: nil)
                        alertController.addAction(cancelButton)
                        self.present(alertController,animated: true,completion: nil)
                        UserDefaults.standard.removeObject(forKey: "routeTime")
                        
                    } else{
                        print("여기를 잘봐라\(UserDefaults.standard.integer(forKey: "polylineNumber"))")
                        if var routeOverviewPolyline = routes[UserDefaults.standard.integer(forKey: "polylineNumber")]["overview_polyline"].dictionary{
                            var i = 0
                            
                            routeOverviewPolyline = routes[UserDefaults.standard.integer(forKey: "polylineNumber")]["overview_polyline"].dictionary!
                            let points = routeOverviewPolyline["points"]?.stringValue
                            self.pointKind.append(points as Any)
                            
                            
                            for _ in routes{
                                let routeLegs = routes[i]["legs"].arrayValue
                                let routeTimeKind = routeLegs[0]["duration"].dictionary!
                                let routeTime = routeTimeKind["text"]?.stringValue
                                self.routeTimeSave(routeTime: routeTime!)
                                
                                let routeTimeValue = routeTimeKind["value"]?.intValue
                                
                                self.routeTimeValueData.append(routeTimeValue!)
                                

                                
                                
                                
                                var w = 0
                                var routeStationAll = [String]()
                                var routeStationTimeAll = [String]()
                                let routeStep = routeLegs[0]["steps"].arrayValue
                                
                                for _ in routeStep{
                                    let routeStationKind = routeStep[w]["html_instructions"].stringValue
                                    let routeStationTimeOf = routeStep[w]["duration"].dictionary!
                                    let routeStationTimeEle = routeStationTimeOf["text"]!.stringValue
                                    
                                    routeStationAll.append(routeStationKind)
                                    routeStationTimeAll.append(routeStationTimeEle)
                                    w = w+1
                                }
                                self.routeStation.append(routeStationAll)
                                self.routeStationTime.append(routeStationTimeAll)
                                i = i+1
                            }
                            
                            self.routeStationSave(station: self.routeStation)
                            self.routeStationTimeSave(routestationtime: self.routeStationTime)
                            self.drawPolySub(points: self.pointKind[0] as! String)
                            self.routeTimeValueEle = self.routeTimeValueData[UserDefaults.standard.integer(forKey: "polylineNumber")]
                            self.timeLabel.text = self.routeTimeData[UserDefaults.standard.integer(forKey: "polylineNumber")]
                            self.alarmTime = self.routeTimeData[UserDefaults.standard.integer(forKey: "polylineNumber")]
                            
                            if self.routeTimeData.isEmpty{
                                
                            }else{
                                
                            }
                        }
                        else{
                        }
                    }
                } else{
                    print("Error")
                }
            }
        }
    }
    
    
    
//    var stations = [Any]()
    var routeStation = [Any]()
    var routeStationTime = [Any]()
    
    func routeStationTimeSave(routestationtime: [Any]){
        let defaults = UserDefaults.standard
        defaults.set(routestationtime, forKey: "routeStationTime")
        defaults.synchronize()
    }
    
    func routeStationSave(station: [Any]){
        let defaults = UserDefaults.standard
        defaults.set(station, forKey: "routeStation")
    }

    
    func routeTimeSave(routeTime : String){
        let defaults = UserDefaults.standard
        routeTimeData.append(routeTime)
        defaults.set(routeTimeData, forKey: "routeTime")
        defaults.synchronize()
    }
    
    func drawPolySub( points : String){
        let path = GMSPath.init(fromEncodedPath: points)
        let polyline = GMSPolyline.init(path: path)
        polyline.strokeWidth = 3
        polyline.geodesic = true
        let redBlue = GMSStrokeStyle.gradient(from: .red, to: .blue)
        polyline.spans = [GMSStyleSpan(style: redBlue)]
        polyline.map = self.googleMaps
        
        
    }
    

    func Direction(){
        removePolyline()
        routeStation.removeAll()
        routeTimeData.removeAll()
        routeStationTime.removeAll()
        
        self.drawPath(startLocation: locationStart, endLocation: locationEnd)
        
        UserDefaults.standard.removeObject(forKey: "routeStation")
        UserDefaults.standard.removeObject(forKey:  "routeStationTime")
        UserDefaults.standard.removeObject(forKey:  "polylineNumber")
        
        
        
        
    }
    
    @IBAction func ShowDirenction(_ sender: Any) {
        removePolyline()
        routeStation.removeAll()
        routeTimeData.removeAll()
        self.drawPath(startLocation: locationStart, endLocation: locationEnd)
        
    }
    
    
    @IBAction func saveNaviButton(_ sender: UIBarButtonItem) {
        if routeStation.isEmpty{
            
            let alertController = UIAlertController(title: "선행사항",message: "경로를 선택하세요.", preferredStyle: UIAlertControllerStyle.alert)
            let cancelButton = UIAlertAction(title: "확인", style: UIAlertActionStyle.cancel, handler: nil)
            alertController.addAction(cancelButton)
            self.present(alertController,animated: true,completion: nil)
            
        }else{
            performSegue(withIdentifier: "saveAlarm", sender: sender)
        }
    }
    
    

    // MARK: - 시간 가져오기
    var nuckNuck = Int()
    var alarmTime = String()
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            
            
            if segue.identifier == "saveAlarm"{
                var second = UserDefaults.standard.integer(forKey: "arrivalSecond")
                
                
                let durationTime = routeTimeValueEle
                
                var departureTime = Int()
                
                print("넋넋 \(nuckNuck)")
                
                switch nuckNuck {
                case 1:
                    departureTime = second-durationTime
                    break
                case 2:
                    departureTime = second-durationTime - 600
                    break
                case 3:
                    departureTime = second-durationTime - 900
                    break
                default:
                    break
                }
                
                if departureTime < 0{
                    second = second+60*60*24
                    departureTime = second - durationTime
                }
                
                
                
                UserDefaults.standard.set(departureTime, forKey: "alarmTime")
                
                let departureHour = departureTime / 3600
                let departureMinute = departureTime % 3600 / 60
                
                print("\(departureHour)시 \(departureMinute)분에 출발")
                
                let vc = segue.destination as? AlarmTableVC
                vc?.identifier = moveName
                print("여기서의 이름은 \(moveName)")
                
                var arrivalTime = String()
                
                
                if second/3600 > 12{
                    if second%3600/60 < 10{
                         arrivalTime = "오후 \(second/3600-12):0\(second%3600/60) 도착"
                    }else{
                         arrivalTime = "오후 \(second/3600-12):\(second%3600/60) 도착"
                    }
                }else{
                    if second%3600/60 < 10{
                       arrivalTime = "오전 \(second/3600):0\(second%3600/60) 도착"
                    }else{
                        arrivalTime = "오전 \(second/3600):\(second%3600/60) 도착"
                    }
                    
                    
                }
                vc?.alarmTime = alarmTime
                
                vc?.startName = startName
                vc?.endName = endName
                
                vc?.arrivalTime = arrivalTime
                
                vc?.addAlarm()
                
                vc?.alarmTable.reloadData()
                
                vc?.viewDidLoad()
                
            }
            
            if segue.identifier == "routeSearch"{
                if routeTimeData.isEmpty{
                    
                }else{
//                    let kindvc = segue.destination as? RoutesKindTableVC
                    
                }
            }
        }
    @IBAction func test(_ sender: UIButton) {
////        ShowDirenction(AnyIndex.self)
////        drawPath(startLocation: locationStart, endLocation: locationEnd)
//        performSegue(withIdentifier: "routeSearch", sender: sender)
//        self.drawPath(startLocation: locationStart, endLocation: locationEnd)
        Direction()
        let uvc = self.storyboard!.instantiateViewController(withIdentifier: "SecondVC") // 1
        uvc.modalTransitionStyle = UIModalTransitionStyle.crossDissolve // 2
        self.present(uvc, animated: true, completion: nil)
        
        

    }
    

    
    //MARK: - 표시된 경로 삭제
    func removePolyline(){
        googleMaps.clear()
        if StartLatitude.isEmpty && EndLatitude.isEmpty{
            
        } else if StartLatitude.isEmpty{
            DestinationCreateMarker(titleMarker: "도착지점", iconMarker: #imageLiteral(resourceName: "DestinationIcon2") , latitude: EndLatitude[0] as! CLLocationDegrees, longitude: EndLongitude[0] as! CLLocationDegrees)
        } else if EndLatitude.isEmpty{
            createMarker(titleMarker: "출발지점", iconMarker: #imageLiteral(resourceName: "StartIcon2") , latitude: StartLatitude[0] as! CLLocationDegrees, longitude: StartLongitude[0] as! CLLocationDegrees)
        } else{
            createMarker(titleMarker: "출발지점", iconMarker: #imageLiteral(resourceName: "StartIcon2") , latitude: StartLatitude[0] as! CLLocationDegrees, longitude: StartLongitude[0] as! CLLocationDegrees)
            DestinationCreateMarker(titleMarker: "도착지점", iconMarker: #imageLiteral(resourceName: "DestinationIcon2") , latitude: EndLatitude[0] as! CLLocationDegrees, longitude: EndLongitude[0] as! CLLocationDegrees)
        }
        
    }
    
    
    //MARK: - 교통수단선택
    
    @IBAction func transitMode(_ sender: UIButton) {

    }
    
    var transitNum = 1
    
    
    
   
    @IBOutlet weak var busModeButton: UIButton!
    @IBOutlet weak var subwayModeButton: UIButton!
    @IBOutlet weak var carModeButton: UIButton!
    
    
    func busButtonOn(){
        //        let image = UIImage(named: "DestinationIcon.png")
        //        subwayModeButton.setBackgroundImage(image, for: .normal)
        
        if busModeButton.isSelected == false{
            
            busModeButton.isSelected = true
            subwayModeButton.isSelected = false
            carModeButton.isSelected = false
            
            busModeButton.setBackgroundImage(UIImage(named : "selectBusIcon.png"), for: UIControlState.normal)
            subwayModeButton.setBackgroundImage(UIImage(named : "subwayIcon.png"), for: UIControlState.normal)
            carModeButton.setBackgroundImage(UIImage(named : "carIcon.png"), for: UIControlState.normal)
        }
    }
    
    
    func subwayButtonOn(){
//        let image = UIImage(named: "DestinationIcon.png")
//        subwayModeButton.setBackgroundImage(image, for: .normal)
        
        if subwayModeButton.isSelected == false{
            
            busModeButton.isSelected = false
            subwayModeButton.isSelected = true
            carModeButton.isSelected = false
            
            busModeButton.setBackgroundImage(UIImage(named : "busIcon.png"), for: UIControlState.normal)
            subwayModeButton.setBackgroundImage(UIImage(named : "selectSubwayIcon.png"), for: UIControlState.normal)
            carModeButton.setBackgroundImage(UIImage(named : "carIcon.png"), for: UIControlState.normal)
            
        }
    }
    
    
    func carButtonOn(){
//        let image = UIImage(named: "DestinationIcon.png")
//        carModeButton.setBackgroundImage(image, for: .normal)
        if carModeButton.isSelected == false{
            
            busModeButton.isSelected = false
            subwayModeButton.isSelected = false
            carModeButton.isSelected = true
            
            busModeButton.setBackgroundImage(UIImage(named : "busIcon.png"), for: UIControlState.normal)
            busModeButton.layer.cornerRadius = 10
            subwayModeButton.setBackgroundImage(UIImage(named : "subwayIcon.png"), for: UIControlState.normal)
            carModeButton.setBackgroundImage(UIImage(named : "selectCarIcon.png"), for: UIControlState.normal)
            
        }
    }
    
    

    @IBAction func busMode(_ sender: UIButton) {
        transitNum = 1
        busButtonOn()
    }
    
    @IBAction func subwayMode(_ sender: UIButton) {
        transitNum = 2
        subwayButtonOn()
    }
    
    
    @IBAction func carMode(_ sender: UIButton) {
        transitNum = 3
//        let loopButton = sender as UIButton
//
//        let selected = !loopButton.isSelected
//
//        if selected {
//            carButtonOn()
//            subwayButtonOff()
//            busButtonOff()
//            print("자가용selected")
//        } else {
//            print("자가용deselected")
//            carButtonOff()
//
//        }
//
//        loopButton.isSelected = selected
        carButtonOn()
    }
    
    
    func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.portrait
    }
    

    
    
    @IBAction func unwindToReservationList(segue: UIStoryboardSegue){
        print("요기로 복귀")
    }


    @IBAction func Test(_ sender: UIButton) {
        routeStation.removeAll()
        routeStationTime.removeAll()
        UserDefaults.standard.removeObject(forKey: "routeStation")
        UserDefaults.standard.removeObject(forKey:  "routeStationTime")
        
    }
    
}

