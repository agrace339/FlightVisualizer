//
//  FlightListViewController.swift
//  FlightVisualizerSwift
//
//  Created by Anna Grace on 2/20/19.
//  Copyright © 2019 Anna Grace. All rights reserved.
//

import Cocoa
import ArcGIS

protocol FlightVCProtocol {
    func clearOverlays()
    func updateDisplayIndi(path: AGSPolyline?, start: AGSPoint?, end: AGSPoint?)
    func updateDisplayAll(path: AGSPolyline?)
}

class FlightListViewController: NSViewController {
    
    var flightDelegate: FlightVCProtocol?
    
    //array that contains all the flights displayed on map
    var flightList = [FlightData?]()
    var allPolyLine = AGSPolylineBuilder(spatialReference: .wgs84())
    
    //names of table Identifiers, put in enum to avoid spelling errors when refering to IDs
    fileprivate enum CellIdentifiers{
        static let dateID = "DateID"
        static let timeID = "TimeID"
        static let nameID = "FileNameID"
        static let sizeID = "FileSizeID"
    }
    
    //tableView that displays the data from flight files
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var instructionsText: NSTextField!
    @IBOutlet weak var box: NSView!
    
    //setting up view
    override func viewDidLoad() {
        super.viewDidLoad()
        box.layer?.backgroundColor = CGColor(red: 145/255, green: 174/255, blue: 235/255, alpha: 1)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 30;
        instructionsText.lineBreakMode = .byWordWrapping
        instructionsText.stringValue = "To begin, import flight data files (G1000 files) using the 'Import Data Files' button below."
    }
    
    
    @IBAction func importBtnClicked(_ sender: Any) {
        //opens file selection window
        let rpFilePicker: NSOpenPanel = NSOpenPanel();
        rpFilePicker.allowsMultipleSelection = true
        rpFilePicker.canChooseDirectories = false
        rpFilePicker.allowedFileTypes = ["csv"]
        rpFilePicker.runModal()
        
        //list of urls selected by user
        var fileList = rpFilePicker.urls
        
        rpFilePicker.close()
        
        //runs through urls
        if fileList.count > 0{
            //reset all data from the user's data import
            flightList = [FlightData]()
            flightDelegate?.clearOverlays()
            allPolyLine = AGSPolylineBuilder(spatialReference: .wgs84())

            //uses different thread so the window doesn't freeze as the files load
            DispatchQueue.global(qos: .userInitiated).async {
                for i in 0...fileList.count-1{
                    
                    //adds flight data to flightList
                    self.flightList.append(readDataFromCSV(fileName: fileList[i]))
                    
                    if(self.flightList[i] != nil){
                        //makes polyline for individual flight and adds it to the FlightData file
                        let flightPathCoords = AGSPolylineBuilder(spatialReference: .wgs84())
                        flightPathCoords.addPart(with: self.flightList[i]!.Coord)
                        self.flightList[i]?.setPolyline(poly: flightPathCoords.toGeometry())
                        
                        self.allPolyLine.addPart(with: self.flightList[i]!.Coord)
                    }
                    
                }
                
                //delegates the responsibility of displaying all the flight path to MainWindowController
                self.flightDelegate?.updateDisplayAll(path: self.allPolyLine.toGeometry())
                
                //reloads table data
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            
            //changes the instructions
            instructionsText.stringValue = "Once the data has loaded, flights will be shown below and flight paths will be displayed on the map to the right. To view an individual flight path, simply click on the row of the desired flight. To load new flights, click the 'Import Data Files' button again."
        }
        
    }
    
    
}
extension FlightListViewController: NSTableViewDataSource{
    //defines the number of rows displayed
    func numberOfRows(in tableView: NSTableView) -> Int {
        return flightList.count
    }
}

extension FlightListViewController: NSTableViewDelegate{
    
    //populate tableView Cells
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        var text: String = ""
        var cellIdentifier: String = ""
        var rounded = Float(0.0)
        
        //changes text and cellIdentifier based on what column is being populated
        if tableColumn == tableView.tableColumns[0] {
            text = flightList[row]?.date ?? "No Date"
            if(text == ""){ text = "No Date" }
            cellIdentifier = CellIdentifiers.dateID
        }
        else if tableColumn == tableView.tableColumns[1] {
            text = flightList[row]?.time[0] ?? "No Time"
            if(text == ""){ text = "No Time" }
            cellIdentifier = CellIdentifiers.timeID
        }
        else if tableColumn == tableView.tableColumns[2] {
            text = flightList[row]?.flightName ?? "No File Name"
            if(text == ""){ text = "No File Name" }
            cellIdentifier = CellIdentifiers.nameID
        }
        else if tableColumn == tableView.tableColumns[3] {
            let num = (flightList[row]?.fileSize ?? 0)/1000000
            rounded = (num * 100).rounded() / 100
            let size: String? = String(describing: rounded) + "MB"
            if let t = size{
                text = t;
            }
            cellIdentifier = CellIdentifiers.sizeID
        }
        
        //checks if cell is in file size column, need to do this because the cells are custom
        if(cellIdentifier == CellIdentifiers.sizeID){
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? TableViewWithImageBtn{
                
                cell.txtField?.stringValue = text
                
                //changes image based on file size
                if(rounded < 1){
                    cell.imagebtn?.image = NSImage(named: "warning")
                    cell.imagebtn?.toolTip = "Small files could contain only taxiing data"
                }
                else{
                    cell.imagebtn?.image = NSImage(named: "check")
                    
                    cell.imagebtn?.toolTip = "Looks like a Flight"
                }
                return cell
            }
        }
            
        else{
            //Creates regular cell for all other rows
            if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView{
                
                cell.textField?.stringValue = text
                
                return cell
            }
        }
        return nil
    }
    
    //is run every time the user selects a row
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        flightDelegate?.clearOverlays()
        
        //makes sure flight is valid
        if let count = flightList[row]?.Coord.count{
            
            //delegates the responsibility of displaying the flight path to MainWindowController
            if(count > 0){
                let start = flightList[row]?.Coord[0];
                let end = flightList[row]?.Coord[count-1]
                
                flightDelegate?.updateDisplayIndi(path: flightList[row]?.polyLine, start: start, end: end)
            }
        }
        
        return true
    }
}
