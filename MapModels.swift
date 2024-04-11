//
//  MapModels.swift
//  gpsBuoy Watch App
//
//  Created by 世吉 on 2024/04/08.
//

import WatchKit
import MapKit

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // CLLocationManagerをインスタンス化
    let manager = CLLocationManager()
    
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
            
            // 地図を表示するための領域を再構築
//            region = MKCoordinateRegion(
//                center: center,
//                latitudinalMeters: 500.0,
//                longitudinalMeters: 500.0
//            )
        }
    }
    
    func reloadRegion (bouyNo: Int){
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
                region = MKCoordinateRegion(
                    center: center,
                    latitudinalMeters: 50.0,
                    longitudinalMeters: 50.0
                )
            } else {
                //ロケーションボタン
                region = MKCoordinateRegion(
                    center: center,
                    latitudinalMeters: 200.0,
                    longitudinalMeters: 200.0
                )
            }
        }
    }
}
