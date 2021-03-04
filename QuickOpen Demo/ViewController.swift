//
//  ViewController.swift
//  QuickOpen Demo
//
//  Created by 张壹弛 on 11/29/20.
//  Copyright © 2020 oscardoudou. All rights reserved.
//

import Cocoa
import quickopen
struct Record{
    var name: String
    var content: String
    var image: NSImage
}

var records: [Record] = [
    Record(name: "text", content: "Generic Text", image:  NSWorkspace.shared.icon(forFileType: ".java")),
                          Record(name: "file", content: "File from finder File from finder" , image: NSWorkspace.shared.icon(forFileType: ".swift")),
                          Record(name: "screenshot", content: "Screenshot captured", image: NSWorkspace.shared.icon(forFileType: ".js"))
]
class ViewController: NSViewController {
    private var quickOpenWindowController:QuickOpenWindowController!
    private var dataController: DataController!
    private var results: [URL]!
    var appDelegate: AppDelegate!
    var folderPath: URL!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let search = QuickOpenOption()
        search.width = 650
        search.height = 50
        search.persistPosition = true
        search.persistMatches = true
        search.placeholder = "Dummy"
        //textWasEntered and quickOpen both method are instance methods of delegate, while delegate is a property of option/search.
        //this line tell where to find those delegate instance methods' implementation, namely in the current class itself as ViewController implement the QuickOpenDelegate protocol
        search.delegate = self
        dataController = DataController()
        quickOpenWindowController = QuickOpenWindowController(search: search )
        logger.log(category: .app, message: "\(quickOpenWindowController)")
        
        appDelegate = NSApplication.shared.delegate as! AppDelegate
        appDelegate.quickOpenWindowController = quickOpenWindowController
        let home = getHomeDirectoryURL()
        let home1 = FileManager.default.homeDirectoryForCurrentUser
        print("home:\(home)")
        print("home1:\(home1)")
        folderPath = home.appendingPathComponent("Pictures")
//        let folderPath = URL(fileURLWithPath: completePath)
        results = dataController.contentsOf(folderPath: folderPath)
        for result in results{
            if result.pathExtension.lowercased() == "png" {
                records.append(Record(name: "file", content: result.lastPathComponent , image: NSWorkspace.shared.icon(forFileType: ".swift")))
            }
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    func getHomeDirectoryURL() -> URL {
        let pw = getpwuid(getuid());
        let home = pw?.pointee.pw_dir
        let homePath = FileManager.default.string(withFileSystemRepresentation: home!, length: Int(strlen(home!)))
        return URL(fileURLWithPath: homePath)
    }


}
extension ViewController: QuickOpenDelegate{
    func recordWasSelected(selected record: Any) -> NSImage?{
        guard let item = record as? Record else { return nil}
        let fileName = item.content
        let filePath = folderPath.appendingPathComponent(fileName).path
        let image = NSImage(contentsOfFile: filePath)
        return image
    }
    func textWasEntered(toBeSearched text: String) -> [Any] {
        print("text to be searched: \(text.lowercased())")
        let matches = records.filter{
            $0.content.lowercased().contains(text.lowercased())
        }
        print("matches.count:\(matches.count)")
        return matches
    }
    func quickOpen(_ record: Any) -> NSView? {
        guard let item = record as? Record else { return nil}

        let view = NSStackView()
        let title = NSTextField()
        let imageView = NSImageView(image: item.image)
        let subtitle = NSTextField()
        let text = NSStackView()

        title.stringValue = item.name
        subtitle.stringValue = item.content
        text.orientation = .vertical
        text.alignment = .left

        text.addArrangedSubview(title)
        text.addArrangedSubview(subtitle)

        view.addArrangedSubview(imageView)
        view.addArrangedSubview(text)
        return view
    }
}
