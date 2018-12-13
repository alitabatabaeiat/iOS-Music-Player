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

@objc (ShareViewController)

class ShareViewController: UIViewController {
    
    let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("press me", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        self.copySongsAndRedirectToHostApp()
    }
    
    func copySongsAndRedirectToHostApp() {
        let content = extensionContext!.inputItems[0] as! NSExtensionItem
        let contentType = kUTTypeAudio as String
        guard let attachments = content.attachments else { return }
        
        for (_, attachment) in attachments.enumerated() {
            if attachment.hasItemConformingToTypeIdentifier(contentType) {
                attachment.loadItem(forTypeIdentifier: contentType, options: nil) { [weak self] data, error in
                    if error == nil, let url = data as? URL {
                        do {
                            let rawData = try Data(contentsOf: url)
                            let sharedURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ir.alitabatabaei.Music-Player")
                            let dir = sharedURL?.appendingPathComponent("sharedSongs")
                            let songURL = dir?.appendingPathComponent(url.lastPathComponent)
                            guard let path = songURL?.path else { return }
                            FileManager.default.createFile(atPath: path, contents: rawData, attributes: nil)
                        }
                        catch let exp {
                            print("GETTING EXCEPTION \(exp.localizedDescription)")
                        }
                        
                    } else {
                        print("GETTING ERROR")
                        let alert = UIAlertController(title: "Error", message: "Error loading song", preferredStyle: .alert)
                        
                        let action = UIAlertAction(title: "Error", style: .cancel) { _ in
                            self?.dismiss(animated: true, completion: nil)
                        }
                        
                        alert.addAction(action)
                        self?.present(alert, animated: true, completion: nil)
                    }
                    self?.redirectToHostApp()
                }
            }
        }
    }
    
    @objc func redirectToHostApp() {
        print("here")
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
