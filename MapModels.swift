//
//  MapModels.swift
//  gpsBuoy Watch App
//
//  Created by 世吉 on 2024/04/08.
//

import WatchKit
import MapKit


 func deg2rad(_ deg:CGFloat ) -> Double {
    return CGFloat.pi / 180.0 * deg
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // CLLocationManagerをインスタンス化
    let manager = CLLocationManager()
    var locationDistanceFlag = 500
    
    // 更新のたびに変化するので@Publishedを付与して観測
    @Published  var region =  MKCoordinateRegion()
    
    
    override init() {
        super.init()                                        // スーパクラスのイニシャライザを実行
        manager.delegate = self                             // 自身をデリゲートプロパティに設定
        manager.requestWhenInUseAuthorization()             // 位置情報を利用許可を要求
        manager.desiredAccuracy = kCLLocationAccuracyBest   // 最高精度の位置情報を要求
        manager.distanceFilter = 3.0                        // 更新距離(m)
        manager.startUpdatingLocation()                     //現在位置アップデートの生成を開始
    }
     
        // 領域の更新をするデリゲートメソッド
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // 配列の最後に最新のロケーションが格納される
        // map関数を使って全要素にアクセス map{ $0←要素に参照 }
        locations.last.map {
            let center = CLLocationCoordinate2D(
                latitude: $0.coordinate.latitude,
                longitude: $0.coordinate.longitude)
            if locationDistanceFlag == 500 {
                manager.startUpdatingLocation()
                //地図を表示するための領域を再構築
                region = MKCoordinateRegion(
                    center: center,
                    latitudinalMeters: 600.0,
                    longitudinalMeters: 600.0
                )
            }
            else if locationDistanceFlag == 200 {
                manager.startUpdatingLocation()
                region = MKCoordinateRegion(
                    center: center,
                    latitudinalMeters: 200,
                    longitudinalMeters: 200
                )
            }
            else if locationDistanceFlag == 0 {
                manager.stopUpdatingLocation()
            }
        }
    }
    
    
    func locationmanagerStop()->Bool{
        locationDistanceFlag = 0
        let status = manager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
                                                        //3:authorizedAlways 常に利用許可
                                                        //4:authorizedAlways 使用中のみ利用許可
            manager.stopUpdatingLocation()
        case .notDetermined:                            //0:notDetermined 未選択
            manager.requestWhenInUseAuthorization()
        case .denied:                                   //2: 利用拒否
            //アラートを表示して、アプリの位置情報サービスをオンにするように促す
            return false
        case .restricted:                               //1:ペアレンタルコントロールなどの影響で制限中
            break
        default:
            break
        }
        return true
    }
    
    func locationmanagerStart() -> Bool{
        locationDistanceFlag = 500
        let status = manager.authorizationStatus
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.startUpdatingLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied:
            return false
        case .restricted:
            break
        default:
            break
        }
        return true
    }

    func locationDistance() -> Int {
        if let location = manager.location {
            let a = CGFloat.pi / 180.0 * pointList[0].latitude
            let b = CGFloat.pi / 180.0 * pointList[0].longitude
            let c = CGFloat.pi / 180.0 * location.coordinate.latitude
            let d = CGFloat.pi / 180.0 * location.coordinate.longitude
            let e = Int( cal_distance(x1: a, y1: b, x2: c, y2: d) * 1000.0 ) % 10000
            return( e )

        }else{
            return( 0 )
        }
    }
    
    func reloadRegion (bouyNo: Int)-> Bool{
        // オプショナルバインディング
        if let location = manager.location {
            
            let center = CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude
            )
            
            if bouyNo == 0 || bouyNo == 1 || bouyNo == 2 {
                //GPSブイ投下を記録
                pointList[bouyNo] = Point(
                    name: "No.\(bouyNo + 1)",
                    latitude: location.coordinate.latitude ,
                    longitude: location.coordinate.longitude
                )
            }else{
                if bouyNo == 3 {
                    locationDistanceFlag = 200
                    region = MKCoordinateRegion(
                        center: center,
                        latitudinalMeters: 200.0,
                        longitudinalMeters: 200.0
                    )
                }else if bouyNo == 4 {
                    locationDistanceFlag = 500
                    region = MKCoordinateRegion(
                        center: center,
                        latitudinalMeters: 600.0,
                        longitudinalMeters: 600.0
                    )
                }
            }
        }
        //位置情報サービスがデバイス上で有効になっているか?
        if CLLocationManager.locationServicesEnabled() {
            let status = manager.authorizationStatus
            switch status {
            case .authorizedAlways, .authorizedWhenInUse:
                //ユーザーは、アプリがいつでも位置情報サービスを開始することを許可している
                //ユーザーは、アプリの使用中に位置情報サービスを開始することを許可した
                //この時は
                //ユーザーの現在位置を報告するアップデートの生成を開始
                manager.startUpdatingLocation()
            case .notDetermined:
                //アプリの使用中に位置情報サービスを使用する許可をユーザーに要求
                manager.requestWhenInUseAuthorization()
            case .denied:
                //ユーザーがアプリの位置情報サービスの使用を拒否しているので、アラートで知らせる
                return false
            case .restricted:
                //このアプリは位置情報サービスを使用する権限がない
                break
            default:
                break
            }
        }else {
            //ユーザーがアプリの位置情報サービスの使用を拒否しているので、アラートで知らせる
            return false
        }
        return true
    }
}



private func cal_distance(x1: Double, y1: Double, x2: Double, y2: Double)->(Double) {
    let dx = x2 - x1
    let dy = y2 - y1
    let mu = (y1 + y2) / 2.0 // μ
    let RX = 6378.137; // 回転楕円体の長半径（赤道半径）[km]
    let RY = 6356.752; // 回転楕円体の短半径（極半径) [km]
    let E = sqrt(1 - pow(RY / RX, 2.0)) // 離心率
    let W = sqrt(1 - pow(E * sin(mu), 2.0))
    let M = RX * (1 - pow(E, 2.0)) / pow(W, 3.0) // 子午線曲率半径
    let N = RX / W // 卯酉線曲率半径
    return sqrt(pow(M * dy, 2.0) + pow(N * dx * cos(mu), 2.0)) // 距離[km]
}


