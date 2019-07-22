//
//  AppDelegate.swift
//  FlightVisualizerSwift
//
//  Created by Anna Grace on 2/12/19.
//  Copyright © 2019 Anna Grace. All rights reserved.
//

import Cocoa
import ArcGIS

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate{
    
    let mainWC = MainWindowController()
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //shows main window
        mainWC.showWindow(nil)
    }
    
    //close application
    func applicationWillTerminate(_ aNotification: Notification) {
        mainWC.close()
        NSApplication.shared.terminate(self)
    }
}
