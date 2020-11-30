//
//  AppDelegate.swift
//  QuickOpen Demo
//
//  Created by 张壹弛 on 11/29/20.
//  Copyright © 2020 oscardoudou. All rights reserved.
//

import Cocoa
import Carbon
import quickopen

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var quickOpenWindowController: QuickOpenWindowController!
    
    func register() {
          var hotKeyRef: EventHotKeyRef?
          let modifierFlags: UInt32 = UInt32(optionKey)
            
          let keyCode = kVK_Space
          var gMyHotKeyID = EventHotKeyID()

          gMyHotKeyID.id = UInt32(keyCode)
          gMyHotKeyID.signature = OSType("swat".fourCharCodeValue)

          var eventType = EventTypeSpec()
          eventType.eventClass = OSType(kEventClassKeyboard)
          eventType.eventKind = OSType(kEventHotKeyReleased)
            
            let observer = UnsafeMutableRawPointer(Unmanaged.passUnretained(self).toOpaque())
          // Install handler.
          InstallEventHandler(GetApplicationEventTarget(), {
            (nextHanlder, theEvent, observer) -> OSStatus in
            let mySelf = Unmanaged<AppDelegate>.fromOpaque(observer!).takeUnretainedValue()
            mySelf.quickOpenWindowController.toggle()
            print("Option +  Space Released!")
            return noErr
          }, 1, &eventType, observer, nil)

          // Register hotkey.
          let status = RegisterEventHotKey(UInt32(keyCode),
                                           modifierFlags,
                                           gMyHotKeyID,
                                           GetApplicationEventTarget(),
                                           0,
                                           &hotKeyRef)
          assert(status == noErr)
        }

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        register()
        
        NSApp.windows.forEach{window in
            if(window.className.contains("NSWindow")){
                window.close()
            }
        }
    }

}

extension String{
    public var fourCharCodeValue: Int {
      var result: Int = 0
      if let data = self.data(using: String.Encoding.macOSRoman) {
        data.withUnsafeBytes({ (rawBytes) in
          let bytes = rawBytes.bindMemory(to: UInt8.self)
          for i in 0 ..< data.count {
            result = result << 8 + Int(bytes[i])
          }
        })
      }
      return result
    }
}
