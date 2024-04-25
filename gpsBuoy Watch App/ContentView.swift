//
//  ContentView.swift
//  gpsBuoy Watch App
//
//  Created by 世吉 on 2024/04/08.
//

import SwiftUI
import MapKit

struct Point: Identifiable {
    let id = UUID()         //ユニークID
    let name: String
    let latitude: Double    // 緯度
    let longitude: Double   // 経度
    // 座標
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

var pointList = [
    Point(name: "1", latitude: 35.709152712026265, longitude: 139.80771829999996),
    Point(name: "2", latitude: 35.711554715026265, longitude: 139.81371829999996),
    Point(name: "3", latitude: 35.712527719026265, longitude: 139.81071829999996)
]

struct ContentView: View {
    @ObservedObject  var manager = LocationManager()
    @State private var isShowAlert = false
    //ユーザートラッキングモードを追従モード変数 .follow　ユーザーを追跡  .none　ユーザーの追跡を停止
    @State  var trackingMode = MapUserTrackingMode.follow
    @State  var showsUserLocationFlag: Bool = true
    @State  var isOn:Bool = false
    var body: some View {
        ZStack{
            Map(coordinateRegion: $manager.region,  //状態変数をバインディング指定
                showsUserLocation: showsUserLocationFlag, // マップ上にユーザーの場所を表示するオプションをBool値で指定
                userTrackingMode: $trackingMode,
                annotationItems: pointList,
                annotationContent: { (pointList) in
                    MapAnnotation(coordinate: pointList.coordinate) {
                        VStack {
                            Image(systemName: "mappin")
                                .foregroundColor(.orange)
                                .font(.system(size: 20))
                            Text(pointList.name)
                                .foregroundColor(.orange)
                                .font(.system(size: 12))
                        }
                    }
                }
            )
            .edgesIgnoringSafeArea(.all)
            
            

            VStack{

                HStack{
                    let dis = manager.locationDistance()
                    Text("\(dis)")
                        .foregroundColor(.white)
                        .font(.system(size: 14))

                    Button(action: {
                        showsUserLocationFlag = true
                        if false == manager.locationmanagerStart(){
                            isShowAlert.toggle()
                        }
                    }) {
                        Image(systemName: "location")
                            .foregroundColor(.white)
                            .font(.system(size: 18))

//                        Text("On")
//                            .foregroundColor(.white)
//                            .font(.system(size: 11))
                    }
                    .frame(width: 34, height: 23)
                    .cornerRadius(30.0)
                    
                    Button(action: {
                        showsUserLocationFlag = false
                        if false == manager.locationmanagerStop(){
                            isShowAlert.toggle()
                        }
                    }) {
                        Image(systemName: "location.slash")
                            .foregroundColor(.white)
                            .font(.system(size: 18))

//                        Text("Off")
//                            .foregroundColor(.white)
//                            .font(.system(size: 11))
                    }
                    .frame(width: 34, height: 23)
                    .cornerRadius(40.0)
                }
                .background(Color(red: 0.4, green: 0.5, blue: 0.2))   //背景色
                .cornerRadius(30.0)
                .offset(x: -20, y: -38)
                
                
                Spacer()
                HStack{
                     Button(action: {
                         if false == manager.reloadRegion(bouyNo: 0){
                             isShowAlert.toggle()
                         }
                    }) {
                        Image(systemName: "p1.button.horizontal")
                            .foregroundColor(.white)
                            .font(.system(size: 23))
//                        Image(systemName: "mappin.circle.fill")
//                            .foregroundColor(.white)
//                            .font(.system(size: 12))
//                        Text("1")
//                            .foregroundColor(.white)
//                            .font(.system(size: 12))
                    }
                    .frame(width: 36, height: 23)
                    .cornerRadius(30.0)
                    
                    Button(action: {
                        if false == manager.reloadRegion(bouyNo: 1){
                            isShowAlert.toggle()
                        }
                    }) {
                        Image(systemName: "p2.button.horizontal")
                            .foregroundColor(.white)
                            .font(.system(size: 23))

//                        Image(systemName: "mappin.circle.fill")
//                            .foregroundColor(.white)
//                            .font(.system(size: 12))
//                        Text("2")
//                            .foregroundColor(.white)
//                            .font(.system(size: 12))
                    }
                    .frame(width: 36, height: 23)
                    .cornerRadius(30.0)
                    
                    Button(action: {
                        // No.2 GPSブイを登録する際、GPS情報入手可能でない時、isShowAlertでアラート発生
                        //          manager.reloadRegion(bouyNo: 2)
                        if false == manager.reloadRegion(bouyNo: 2){
                            isShowAlert.toggle()
                        }
                    }) {
                        Image(systemName: "p3.button.horizontal")
                            .foregroundColor(.white)
                            .font(.system(size: 23))

//                        Image(systemName: "mappin.circle.fill")
//                            .foregroundColor(.white)
//                            .font(.system(size: 12))
//                        Text("3")
//                            .foregroundColor(.white)
//                            .font(.system(size: 12))
                    }
                    .frame(width: 36, height: 23)
                    .cornerRadius(30.0)

                    Button(action: {
                        if isOn == false {
                            if false == manager.reloadRegion(bouyNo: 3){
                                isShowAlert.toggle()
                            }

//                            manager.reloadRegion(bouyNo: 3)
                            isOn = true
                        }else{
                            if false == manager.reloadRegion(bouyNo: 4){
                                isShowAlert.toggle()
                            }

//                            manager.reloadRegion(bouyNo: 4)
                            isOn = false
                        }
                    }) {
                        if isOn == true {
                            Image(systemName: "minus.magnifyingglass")
                                .foregroundColor(.white)
                                .font(.system(size: 22))
                        }else{
                            Image(systemName: "plus.magnifyingglass")
                                .foregroundColor(.white)
                                .font(.system(size: 22))
                        }
                    }
                    .frame(width: 26, height: 23)
                    .cornerRadius(30.0)
                    
                }
                .background(Color(red: 0.4, green: 0.5, blue: 0.2))   //背景色
                .cornerRadius(30.0)
                .offset(x: 0, y: 17)
                
                //OkAlertを記載
                .alert("Error", isPresented: $isShowAlert) {
                    // ダイアログ内で行うアクション処理...
                } message: {
                    // アラートのメッセージ...
                    Text("アプリの位置情報サービスを\niPhoneから\nオンにして下さい\n設定>プライバシとセキュリティ>位置情報サービス＞gpsBuoy")
                }

            }
        }
    }
}

