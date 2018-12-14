//
//  SongsViewController.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/1/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

class SongsViewController: UIViewController {
    
    var player = Player.shared
    
    let CELL_ID = "cell_id"
    let tableView = MPTableView()
    let nowPlayingView = MPNowPlayingView()
    let headerView = MPHeaderView(titleText: "SONGS")
    let buttonContainer = MPView()
    let playButton: MPButton = {
        let button = MPButton()
        button.setImage(UIImage(from: .ionicon, code: "ios-play", textColor: .blue1, size: CGSize(width: 30, height: 30)), for: .normal)
        button.setTitle("play", for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.backgroundColor = .grey2
        button.setTitleColor(.blue1, for: .normal)
        button.titleLabel?.font = UIFont.lato?.withSize(18)
        
        return button
    }()
    let shuffleButton: MPButton = {
        let button = MPButton()
        button.setImage(UIImage(from: .ionicon, code: "ios-shuffle", textColor: .blue1, size: CGSize(width: 30, height: 30)), for: .normal)
        button.setTitle("shuffle", for: .normal)
        button.layer.cornerRadius = 4
        button.clipsToBounds = true
        button.backgroundColor = .grey2
        button.setTitleColor(.blue1, for: .normal)
        button.titleLabel?.font = UIFont.lato?.withSize(18)
        
        return button
    }()
    
    var sortAlertController: UIAlertController! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        [self.tableView, self.nowPlayingView, self.headerView, self.buttonContainer, self.playButton, self.shuffleButton].forEach { view.addSubview($0) }
        
        self.setAnchors()
        self.setTargets()
        self.setDelegates()
        self.setAlertController()
        self.tableView.register(MPTableViewCell.self, forCellReuseIdentifier: self.CELL_ID)
    }
    
    func setAnchors () {
        self.headerView.anchor(top: self.view.safeAreaTopAnchor(), right: self.view.safeAreaRightAnchor(), bottom: nil, left: self.view.safeAreaLeftAnchor(), size: CGSize(width: 0, height: 50))
        
        self.buttonContainer.anchor(top: self.headerView.bottomAnchor, right: self.view.safeAreaRightAnchor(), bottom: nil, left: self.view.safeAreaLeftAnchor(), size: CGSize(width: 0, height: 60))
        
        self.tableView.anchor(top: self.buttonContainer.bottomAnchor, right: self.view.safeAreaRightAnchor(), bottom: self.nowPlayingView.topAnchor, left: self.view.safeAreaLeftAnchor())
        
        self.nowPlayingView.anchor(top: nil, right: self.view.safeAreaRightAnchor(), bottom: self.view.safeAreaBottomAnchor(), left: self.view.safeAreaLeftAnchor(), size: CGSize(width: 0, height: 60))
        
        self.nowPlayingView.anchor(top: nil, right: self.view.safeAreaRightAnchor(), bottom: self.view.safeAreaBottomAnchor(), left: self.view.safeAreaLeftAnchor(), size: CGSize(width: 0, height: 60))
        
        self.playButton.centerYAnchor.constraint(equalTo: self.buttonContainer.centerYAnchor).isActive = true
        self.playButton.anchor(top: nil, right: self.buttonContainer.centerXAnchor, bottom: nil, left: self.buttonContainer.leftAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 40))
        
        self.shuffleButton.centerYAnchor.constraint(equalTo: self.buttonContainer.centerYAnchor).isActive = true
        self.shuffleButton.anchor(top: nil, right: self.buttonContainer.rightAnchor, bottom: nil, left: self.buttonContainer.centerXAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 40))
    }
    
    private func setTargets() {
        self.playButton.addTarget(self, action: #selector(self.playButtonPressed), for: .touchUpInside)
        self.shuffleButton.addTarget(self, action: #selector(self.shuffleButtonPressed), for: .touchUpInside)
    }
    
    private func setDelegates() {
        self.player.delegate = self
        self.headerView.delegate = self
        self.nowPlayingView.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func setAlertController() {
        self.sortAlertController = UIAlertController(title: "Sort By", message: nil, preferredStyle: .actionSheet)
        
        self.sortAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        var actions = [String : UIAlertAction]()
        actions[Sort.ByArtist.rawValue] = UIAlertAction(title: "Artist", style: .default) { action in
            self.player.sortSongs(by: .ByArtist)
            self.tableView.reloadData()
            actions.forEach { $0.value.setValue(false, forKey: "checked") }
            action.setValue(true, forKey: "checked")
        }
        actions[Sort.ByTitle.rawValue] = UIAlertAction(title: "Title", style: .default) { action in
            self.player.sortSongs(by: .ByTitle)
            self.tableView.reloadData()
            actions.forEach { $0.value.setValue(false, forKey: "checked") }
            action.setValue(true, forKey: "checked")
        }
        actions[Sort.ByRecentlyAdded.rawValue] = UIAlertAction(title: "Recently Added", style: .default) { action in
            self.player.sortSongs(by: .ByRecentlyAdded)
            self.tableView.reloadData()
            actions.forEach { $0.value.setValue(false, forKey: "checked") }
            action.setValue(true, forKey: "checked")
        }
        if let sortBy = Defaults.getSortBy(), let action = actions[sortBy.rawValue] {
            action.setValue(true, forKey: "checked")
        }

        actions.forEach { self.sortAlertController.addAction($0.value) }
    }
}

extension SongsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.player.getSongs().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_ID, for: indexPath) as! MPTableViewCell
        cell.song = self.player.getSong(at: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MPTableViewCell, let song = cell.song {
            if !self.player.isPlaying(song: song)  {
                self.player.setNewQueue(with: .default, startingFrom: song)
                self.player.play()
            } else {
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.player.removeSong(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

extension SongsViewController: PlayerDelegate {
    func player(_ player: Player, didPlay song: Song?) {
        if let playingSong = song {
            self.nowPlayingView.configure(with: playingSong)
        }
    }
    
    func player(_ player: Player, didPause song: Song?) {
        self.nowPlayingView.pause()
    }
    
    func player(_ player: Player, didAdvanceToNext song: Song?) {
        if let playingSong = song {
            self.nowPlayingView.configure(with: playingSong)
        }
    }
    
    func player(_ player: Player, willRemoveSong song: Song) {
        let fileManager = FileManager.default
        guard let container = fileManager.containerURL(forSecurityApplicationGroupIdentifier: "group.ir.alitabatabaei.Music-Player") else { return }
        let dir = container.appendingPathComponent("sharedSongs")
        let path = dir.appendingPathComponent(song.path)
        do {
            try fileManager.removeItem(at: path)
        } catch let ex {
            print("Error in removing song: \(ex)")
        }
    }
}

extension SongsViewController: MPHeaderViewDelegate, MPNowPlayingViewDelegate {
    
    func headerView(_ headerView: MPHeaderView, didSortButtonPressed button: MPButton) {
        present(self.sortAlertController, animated: true)
    }
    
    func play(in nowPlayingView: MPNowPlayingView) {
        self.player.play()
    }
    
    func pause(in nowPlayingView: MPNowPlayingView) {
        self.player.pause()
    }
    
    func next(in nowPlayingView: MPNowPlayingView) {
        self.player.next()
    }
    
    func previous(in nowPlayingView: MPNowPlayingView) {
        self.player.previous()
    }
}

extension SongsViewController {
    
    @objc private func playButtonPressed() {
        self.playButton.animate(completion: nil)
        let song = self.player.getSong(at: 0)
        self.player.setNewQueue(with: .default, startingFrom: song)
        self.player.play()
    }
    
    @objc private func shuffleButtonPressed() {
        self.shuffleButton.animate(completion: nil)
        self.player.setNewQueue(with: .shuffle, startingFrom: nil)
        self.player.play()
    }
}
