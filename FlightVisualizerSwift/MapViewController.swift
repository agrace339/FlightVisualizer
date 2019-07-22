//
//  MapViewController.swift
//  FlightVisualizerSwift
//
//  Created by Anna Grace on 2/20/19.
//  Copyright © 2019 Anna Grace. All rights reserved.
//

import Cocoa
import ArcGIS

class MapViewController: NSViewController {
    
    @IBOutlet var mapView: AGSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loads map
        let map = AGSMap(basemapType: .lightGrayCanvasVector, latitude: 37.0902, longitude: -95.7129, levelOfDetail: 3)
        self.mapView.map = map

    }
    
}
