//
//  ViewController.swift
//  FlightVisualizerSwift
//
//  Created by Anna Grace on 2/13/19.
//  Copyright © 2019 Anna Grace. All rights reserved.
//

import Foundation

func readDataFromCSV(fileName:URL)->FlightData?{
    
    do {
        //gets file size
        let resources = try fileName.resourceValues(forKeys:[.fileSizeKey])
        let fileSize = resources.fileSize!
        
        
        do{
            //gets contents of css file as a String
            let fileContent = try NSString(contentsOf: fileName, usedEncoding: nil)
            
            //separates file by line
            let fileLines = fileContent.components(separatedBy: "\n")
            
            //checks if the file line count is large enough
            if(fileLines.count > 5){
                
                //separates line 3 (the first line with data) by commas
                var fileLinesContents = fileLines[3].components(separatedBy: ",")
                
                //initialize flight with data
                let flight = FlightData(file: fileName, date: fileLinesContents[0], flightName: String(fileName.lastPathComponent.split(separator: ".")[0]), size: Float(fileSize))
                
                //runs through all lines of flight file adding time data and lat/lon data
                for i in 4...fileLines.count-2{
                    fileLinesContents = fileLines[i].components(separatedBy: ",")
                    flight.addTime(time: fileLinesContents[1])
                    flight.addCoordVal(lat: (fileLinesContents[4] as NSString).doubleValue, lon: (fileLinesContents[5] as NSString).doubleValue)
                }
                
                return flight
            }
            //if the file line count isn't large enough
            else{
                print(fileName.absoluteString + " not in g1000 format" )
                return nil
            }
        }
            
        //if file count not be opened
        //thrown by "try NSString(contentsOf: fileName, usedEncoding: nil)"
        catch {
            print(fileName.absoluteString + " could not be accessed");
            return nil
        }
        
    }
    //if file size cannot be retrieved
    catch {
        print("Error: \(error)")
        return nil
    }
}
