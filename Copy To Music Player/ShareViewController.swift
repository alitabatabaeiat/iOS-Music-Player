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
    
    var numOfCompletedAttachments: Int = 0 {
        didSet {
            if self.numOfAttachments == self.numOfCompletedAttachments {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    self.redirectToHostApp()
                }
            }
        }
    }
    var numOfAttachments: Int = 0
    
    let view2: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor  = .white
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(view2)
        
        view2.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        view2.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        view2.topAnchor.constraint(equalTo: self.view.centerYAnchor, constant: -30).isActive = true
        view2.bottomAnchor.constraint(equalTo: self.view.centerYAnchor, constant: 30).isActive = true
        
        view.backgroundColor = .white
        self.copySongsAndRedirectToHostApp()
    }
    
    func copySongsAndRedirectToHostApp() {
        let content = extensionContext!.inputItems[0] as! NSExtensionItem
        let contentType = kUTTypeAudio as String
        guard let attachments = content.attachments else { return }
        
        self.numOfAttachments = attachments.count
        for (_, attachment) in attachments.enumerated() {
            if attachment.hasItemConformingToTypeIdentifier(contentType) {
                attachment.loadItem(forTypeIdentifier: contentType, options: nil, completionHandler: self.loadItemCallback(data:error:))
            }
        }
    }
    
    func loadItemCallback(data: NSSecureCoding?, error: Error?) {
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
                self.dismiss(animated: true, completion: nil)
            }
            
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        self.numOfCompletedAttachments += 1
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
