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
    let latitude: Double    // 緯度
    let longitude: Double   // 経度
    // 座標
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

var pointList = [
    Point(latitude: 35.709152712026265, longitude: 139.80771829999996),
    Point(latitude: 35.711554715026265, longitude: 139.81371829999996),
    Point(latitude: 35.712527719026265, longitude: 139.81071829999996)
]

struct ContentView: View {
    @ObservedObject  var manager = LocationManager()
    
    //ユーザートラッキングモードを追従モード変数 .follow　ユーザーを追跡  .none　ユーザーの追跡を停止
    @State  var trackingMode = MapUserTrackingMode.follow
    
    var body: some View {
        ZStack{
            Map(coordinateRegion: $manager.region,  //状態変数をバインディング指定
                showsUserLocation: true, // マップ上にユーザーの場所を表示するオプションをBool値で指定
                userTrackingMode: $trackingMode,
                annotationItems: pointList,
                annotationContent: {
                point in MapPin(    //「マーカー(MapMarker)」「ピン(MapPin)」
                    coordinate: point.coordinate,
                    tint: .orange   //色
                )
            }
            )
            .edgesIgnoringSafeArea(.bottom)
            .edgesIgnoringSafeArea(.top)
            VStack{
                Spacer()
                HStack{
                    Button(action: {
                        manager.reloadRegion(bouyNo: 0)
                    }) {
                        Image(systemName: "pencil.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    }
                    .frame(width: 30, height: 25)
                    .cornerRadius(30.0)
                    
                    Button(action: {
                        manager.reloadRegion(bouyNo: 1)
                    }) {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    }
                    .frame(width: 30, height: 25)
                    .cornerRadius(30.0)
                    
                    Button(action: {
                        manager.reloadRegion(bouyNo: 2)
                    }) {
                        Image(systemName: "mappin.square.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 16))
                    }
                    .frame(width: 30, height: 25)
                    .cornerRadius(30.0)
                    
                }
                .background(Color(red: 0.4, green: 0.5, blue: 0.2))   //背景色
                .cornerRadius(30.0)
            }
        }
    }
}

