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
    
    let player = Player.shared
    var songs = [(key: String?, value: [Song])]()
    
    let CELL_ID = "cell_id"
    let tableView = MPTableView()
    let headerView = MPHeaderView(titleText: "SONGS", rightButtonImage: UIImage(from: .iconic, code: "sort-ascending", textColor: .darkGray, backgroundColor: .clear, size: CGSize(width: 30, height: 30)))
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
        
        [self.tableView, self.headerView, self.buttonContainer, self.playButton, self.shuffleButton].forEach { self.view.addSubview($0) }
        
        self.setAnchors()
        self.setTargets()
        self.setDelegates()
        self.setAlertController()
        self.categorizeSongs()
        self.tableView.register(MPSongTableViewCell.self, forCellReuseIdentifier: self.CELL_ID)
    }
    
    func setAnchors () {
        self.headerView.anchor(top: self.view.safeAreaTopAnchor(), right: self.view.safeAreaRightAnchor(), bottom: nil, left: self.view.safeAreaLeftAnchor(), size: CGSize(width: 0, height: 50))
        
        self.buttonContainer.anchor(top: self.headerView.bottomAnchor, right: self.view.safeAreaRightAnchor(), bottom: nil, left: self.view.safeAreaLeftAnchor(), size: CGSize(width: 0, height: 60))
        
        self.tableView.anchor(top: self.buttonContainer.bottomAnchor, right: self.view.safeAreaRightAnchor(), bottom: self.view.safeAreaBottomAnchor(), left: self.view.safeAreaLeftAnchor(), padding: UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0))
        
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
        self.headerView.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    private func setAlertController() {
        self.sortAlertController = UIAlertController(title: "Sort By", message: nil, preferredStyle: .actionSheet)
        
        self.sortAlertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        var actions = [String : UIAlertAction]()
        actions[Sort.ByArtist.rawValue] = UIAlertAction(title: "Artist", style: .default) { action in
            self.player.setSort(.ByArtist)
            self.reloadData()
            actions.forEach { $0.value.setValue(false, forKey: "checked") }
            action.setValue(true, forKey: "checked")
        }
        actions[Sort.ByTitle.rawValue] = UIAlertAction(title: "Title", style: .default) { action in
            self.player.setSort(.ByTitle)
            self.reloadData()
            actions.forEach { $0.value.setValue(false, forKey: "checked") }
            action.setValue(true, forKey: "checked")
        }
        actions[Sort.ByRecentlyAdded.rawValue] = UIAlertAction(title: "Recently Added", style: .default) { action in
            self.player.setSort(.ByRecentlyAdded)
            self.reloadData()
            actions.forEach { $0.value.setValue(false, forKey: "checked") }
            action.setValue(true, forKey: "checked")
        }
        if let sortBy = Defaults.getSortBy(), let action = actions[sortBy.rawValue] {
            action.setValue(true, forKey: "checked")
        }

        actions.forEach { self.sortAlertController.addAction($0.value) }
    }
    
    private func categorizeSongs() {
        let sort = self.player.getSort()
        let songs = self.player.getSongs();
        self.songs.removeAll()
        if sort == .ByRecentlyAdded {
            self.songs = [(nil, songs)]
            return
        }
        
        var songDictionary = [String? : [Song]]()
        for song in songs {
            var string = ""
            if sort == .ByArtist {
                string = song.artist
            } else if sort == .ByTitle {
                string = song.title
            }

            var startWith = "#"
            if let firstLetter = string.first, ("a" <= firstLetter && firstLetter <= "z") || ("A" <= firstLetter && firstLetter <= "Z") {
                startWith = String(firstLetter)
            }
            
            if songDictionary[startWith] != nil {
                songDictionary[startWith]!.append(song)
            } else {
                songDictionary[startWith] = [song]
            }
        }
        self.songs = songDictionary.sorted { $0.key! < $1.key! }
        if let first = self.songs.first, first.key == "#" {
            self.songs.append(self.songs[0])
            self.songs.remove(at: 0)
        }
    }
    
    private func reloadData() {
        self.categorizeSongs()
        self.tableView.reloadData()
    }
}

extension SongsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.songs.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.songs[section].value.count
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            view.backgroundView?.backgroundColor = .white
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return songs[section].key
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_ID, for: indexPath) as! MPSongTableViewCell
        cell.song = self.songs[indexPath.section].value[indexPath.row]
        if self.songs[indexPath.section].value.count - 1 == indexPath.row{
            cell.removeBottomLine()
        } else {
            cell.addBottomLine()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? MPSongTableViewCell, let song = cell.song {
            if !self.player.isPlaying(song: song)  {
                self.player.setNewQueue(with: .default, startingFrom: song)
                self.player.play()
            } else {
                
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let removedSong = self.songs[indexPath.section].value[indexPath.row]
            print(removedSong.title)
            self.player.remove(song: removedSong)
            SongsManager.shared.remove(song: removedSong)
            self.songs[indexPath.section].value.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
//            self.reloadData()
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
        }
    }
}

extension SongsViewController: MPHeaderViewDelegate {
    
    func headerView(_ headerView: MPHeaderView, didRightButtonPressed button: MPButton) {
        present(self.sortAlertController, animated: true)
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
