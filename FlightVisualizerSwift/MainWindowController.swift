//
//  MainWindowController.swift
//  FlightVisualizerSwift
//
//  Created by Anna Grace on 2/20/19.
//  Copyright © 2019 Anna Grace. All rights reserved.
//

import Cocoa
import ArcGIS

class MainWindowController: NSWindowController {
    
    let mapViewVC = MapViewController()
    
    convenience init(){
        self.init(windowNibName: "MainWindowController")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        window?.setFrame(NSRect(x: 100, y: 100, width: 900, height: 600), display: true)
        window?.titlebarAppearsTransparent = true
        window?.titleVisibility = .hidden

        //adding the flight table and the map into main window
        let flightListVC = FlightListViewController()
        let splitVC = NSSplitViewController()
        splitVC.addSplitViewItem(NSSplitViewItem(viewController: flightListVC))
        splitVC.addSplitViewItem(NSSplitViewItem(viewController: mapViewVC))
        window?.contentViewController = splitVC
        
        flightListVC.flightDelegate = self
    }
}
extension MainWindowController: FlightVCProtocol{
    
    //displaying flight paths for individual flights
    func updateDisplayIndi(path: AGSPolyline?, start: AGSPoint?, end: AGSPoint?) {
        if(path != nil){
            let overlay = AGSGraphicsOverlay()
            
            //adding flight path
            let lineSymbol = AGSSimpleLineSymbol(style: .solid, color: NSColor(calibratedRed: 55.0/255, green: 108.0/255, blue: 219.0/255, alpha: 1), width: 4)
            let flightPath = AGSGraphic(geometry: path, symbol: lineSymbol)
            overlay.graphics.add(flightPath)
            
            //adding start point
            if(start != nil){
                let startSymbol = AGSSimpleMarkerSymbol(style: .circle, color: NSColor(calibratedRed: 0, green: 142/255, blue: 83/255, alpha: 1), size: 14)
                let startPoint = AGSGraphic(geometry: start, symbol: startSymbol)
                overlay.graphics.add(startPoint)
            }
            
            //adding end point
            if(end != nil){
                let endSymbol = AGSSimpleMarkerSymbol(style: .circle, color: NSColor(calibratedRed: 250/255, green: 74/255, blue: 71/255, alpha: 1), size: 14)
                let endPoint = AGSGraphic(geometry: end, symbol: endSymbol)
                overlay.graphics.add(endPoint)
            }
            
            //adding overlay to map
            mapViewVC.mapView.graphicsOverlays.add(overlay)
            
            //changeing zoom of the map to show path
            mapViewVC.mapView.setViewpointGeometry(path!, padding: 30, completion: nil)
        }
        
    }
    
    //display all flights
    func updateDisplayAll(path: AGSPolyline?) {
        if(path != nil){
            let lineSymbol = AGSSimpleLineSymbol(style: .solid, color: NSColor(calibratedRed: 55.0/255, green: 108.0/255, blue: 219.0/255, alpha: 1), width: 4)
            let flightPath = AGSGraphic(geometry: path, symbol: lineSymbol)
            
            let overlay = AGSGraphicsOverlay()
            overlay.graphics.add(flightPath)
            
            mapViewVC.mapView.graphicsOverlays.add(overlay)
            
            mapViewVC.mapView.setViewpointGeometry(path!, padding: 30, completion: nil)
        }
    }
    
    //clearing all flight paths from map
    func clearOverlays() {
        mapViewVC.mapView.graphicsOverlays.removeAllObjects()
    }

    
}
