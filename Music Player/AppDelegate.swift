//
//  AppDelegate.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/1/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit
import CoreData
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ir.alitabatabaei.Music-Player")
        do {
            if let container = container {
                
                let dir = container.appendingPathComponent("sharedSongs")
                
                if FileManager.default.fileExists(atPath: dir.path) {
                    let items = try FileManager.default.contentsOfDirectory(atPath: dir.path)
                    
                    Player.shared.songs = getAllSongs(from: dir, songsPath: items)
                } else {
                    // file or directory does not exist
                    try FileManager.default.createDirectory(at: dir, withIntermediateDirectories: false, attributes: nil)
                }
            }
        } catch let error as NSError {
            print(error.description)
        }
        
        let ctrl = MainTabBarController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = ctrl
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Music_Player")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

extension AppDelegate {
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        do {
            guard let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.ir.alitabatabaei.Music-Player") else { return false }
            let dir = container.appendingPathComponent("sharedSongs")
            let items = try FileManager.default.contentsOfDirectory(atPath: dir.path)
            
            Player.shared.songs = getAllSongs(from: dir, songsPath: items)
        } catch let error {
            print("filemanager: \(error)")
        }
        
        let ctrl = MainTabBarController()
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = ctrl
        
        return true
    }
    
    private func getAllSongs(from dir: URL, songsPath: [String]) -> [Song] {
        var songs = [Song]()
        for path in songsPath {
            let url = dir.appendingPathComponent(path)
            let playerItem = AVPlayerItem(url: url)
            let song = Song(playerItem: playerItem)
            self.setSongInfo(song, fileName: String(path.split(separator: ".")[0]))
            
            songs.append(song)
        }
        return songs
    }
    
    private func setSongInfo(_ song: Song, fileName: String) {
        for item in song.playerItem.asset.metadata {
    
            guard let key = item.commonKey?.rawValue, let value = item.value else {
                continue
            }
    
            print(key)
            switch key {
                case "title" : song.title = value as? String ?? ""
                case "artist" : song.artist = value as? String ?? ""
                case "artwork" where value is Data : song.artwork = UIImage(data: value as! Data)
                default: continue
            }
        }
        
        if song.title == "" {
            song.title = fileName
        }
    }
}
