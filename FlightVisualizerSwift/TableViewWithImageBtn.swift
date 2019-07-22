//
//  TableViewWithImageBtn.swift
//  FlightVisualizerSwift
//
//  Created by Anna Grace on 3/1/19.
//  Copyright © 2019 Anna Grace. All rights reserved.
//

import Cocoa

class TableViewWithImageBtn: NSTableCellView {
    
    //custom Cell for size column, contains button (used for image) and textfield
    
    @IBOutlet weak var imagebtn: NSButton?
    @IBOutlet weak var txtField: NSTextFieldCell?
    
    required init?(coder decoder: NSCoder) {
        super.init(coder: decoder)
    }
    
}
