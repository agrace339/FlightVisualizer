//
//  FlightData.swift
//  FlightVisualizerSwift
//
//  Created by Anna Grace on 2/16/19.
//  Copyright © 2019 Anna Grace. All rights reserved.
//

import Foundation
import ArcGIS

class FlightData: NSObject{
    var fileName: URL
    var date: String
    var Coord: [AGSPoint]
    var polyLine: AGSPolyline = AGSPolyline(points: [])
    var time: [String]
    var flightName: String
    var fileSize: Float
    
    init(file: URL, date: String, flightName: String, size: Float){
        self.fileName = file
        self.date = date
        self.time = []
        Coord = [AGSPoint]()
        self.flightName = flightName
        self.fileSize = size
    }
    
    //adds latitude and longitude to Coord
    func addCoordVal(lat: Double, lon: Double){
        if(lat != 0 && lon != 0){
            Coord.append(AGSPoint(x: lon, y: lat, spatialReference: .wgs84()))
        }
    }
    
    //saves flight path
    func setPolyline(poly: AGSPolyline){
        polyLine = poly
    }
    
    //adds times to array
    func addTime(time: String){
        self.time.append(time)
    }
    
    func getFileName()->URL{
        return fileName
    }
    
    func getCoord()-> [AGSPoint]{
        return Coord
    }
    
}
