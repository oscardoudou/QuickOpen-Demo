//
//  ViewController.swift
//  QuickOpen Demo
//
//  Created by 张壹弛 on 11/29/20.
//  Copyright © 2020 oscardoudou. All rights reserved.
//

import Cocoa
import quickopen

class ViewController: NSViewController {
    private var quickOpenWindowController:QuickOpenWindowController!
    var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let search = QuickOpenSearch()
        search.width = 500
        search.height = 50
//        search.delegate = self
        search.persistPosition = true
        search.placeholder = "Dummy"
        
        quickOpenWindowController = QuickOpenWindowController(search: search )
        
        appDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.quickOpenWindowController = quickOpenWindowController
    
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}
