//
//  ShareViewController.swift
//  Copy to Music Player
//
//  Created by Ali Tabatabaei on 12/2/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices
import MBProgressHUD

@objc (ShareViewController)

class ShareViewController: UIViewController {
    
    var validAttachments: Int = 0
    var filesSize = 0.0
    var urls = [URL]() {
        didSet {
            if self.urls.count == self.validAttachments {
                if self.filesSize < 110 {
                    for url in self.urls {
                        do {
                            let rawData = try Data(contentsOf: url)
                            let sharedURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ir.alitabatabaei.Music-Player")
                            let dir = sharedURL?.appendingPathComponent("sharedSongs")
                            let songURL = dir?.appendingPathComponent(url.lastPathComponent)
                            guard let path = songURL?.path else { return }
                            FileManager.default.createFile(atPath: path, contents: rawData, attributes: nil)
                        }
                        catch let error {
                            print("Error on create Data from url: \(error.localizedDescription)")
                        }
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.redirectToHostApp()
                        if let hud = self.hud {
                            hud.hide(animated: true)
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.displayExceededLimit()
                        if let hud = self.hud {
                            hud.hide(animated: true)
                        }
                    }
                }
            }
        }
    }
    
    var hud: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        if let hud = self.hud {
            hud.mode = .indeterminate
        }
        
//        DispatchQueue.global(qos: .background).async {
            self.copySongsAndRedirectToHostApp()
//        }
        
    }
    
    func copySongsAndRedirectToHostApp() {
        let content = extensionContext!.inputItems[0] as! NSExtensionItem
        let contentType = kUTTypeAudio as String
        guard let attachments = content.attachments else { return }
        
        for attachment in attachments {
            if attachment.hasItemConformingToTypeIdentifier(contentType) {
                self.validAttachments += 1
                attachment.loadItem(forTypeIdentifier: contentType, options: nil, completionHandler: self.loadItemCallback(data:error:))
            }
        }
    }
    
    func loadItemCallback(data: NSSecureCoding?, error: Error?) {
        if error == nil, let url = data as? URL {
            self.urls.append(url)
            do {
                let attr = try FileManager.default.attributesOfItem(atPath: url.path)
                let fileSize = attr[FileAttributeKey.size] as! UInt64
                self.filesSize += Double(fileSize) / pow(1000.0, 2.0)
                return
            } catch let error {
                print("Error getting attributes of item: \(error.localizedDescription)")
            }
        }
        self.validAttachments -= 1
    }
    
    private func displayExceededLimit() {
        let alert = UIAlertController(title: "Error", message: "Exceed memory limit (110 MB)", preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .cancel) { _ in
            self.dismiss(animated: true, completion: nil)
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }

        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func redirectToHostApp() {
        let url = URL(string: "MusicPlayer://")
        var responder = self as UIResponder?
        let selectorOpenURL = sel_registerName("openURL:")
        
        while (responder != nil) {
            if (responder?.responds(to: selectorOpenURL))! {
                let _ = responder?.perform(selectorOpenURL, with: url)
            }
            responder = responder!.next
        }
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }
}

extension UIColor {
    
    static let blue0 = UIColor(rgb: 0x64E4FF)
    static let blue1 = UIColor(rgb: 0x3A7BD5)
    static let grey0 = UIColor(rgb: 0x9B9B9B)
    static let grey1 = UIColor(rgb: 0x424242)
    static let grey2 = UIColor(rgb: 0xf4f6ff)
    
    
    convenience init(red: Int, green: Int, blue: Int) {
        self.init(
            red: CGFloat(red) / 255.0,
            green: CGFloat(green) / 255.0,
            blue: CGFloat(blue) / 255.0,
            alpha: 1
        )
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
