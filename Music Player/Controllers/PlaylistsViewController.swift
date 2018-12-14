//
//  PlaylistsViewController.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/1/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit

class PlaylistsViewController: UIViewController {

    var player = Player.shared
    
    let CELL_ID = "cell_id"
    let tableView = MPTableView()
    let headerView = MPHeaderView(titleText: "PLAYLISTS")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        [self.tableView, self.headerView].forEach { view.addSubview($0) }
        
        self.setAnchors()
        self.setDelegates()
        self.tableView.register(MPPlaylistTableViewCell.self, forCellReuseIdentifier: self.CELL_ID)
    }
    
    private func setAnchors() {
        self.headerView.anchor(top: self.view.safeAreaTopAnchor(), right: self.view.safeAreaRightAnchor(), bottom: nil, left: self.view.safeAreaLeftAnchor(), size: CGSize(width: 0, height: 50))
        
        self.tableView.anchor(top: self.headerView.bottomAnchor, right: self.view.safeAreaRightAnchor(), bottom: self.view.safeAreaBottomAnchor(), left: self.view.safeAreaLeftAnchor())
    }
    
    private func setDelegates() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
}

extension PlaylistsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.player.getPlaylists().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CELL_ID, for: indexPath) as! MPPlaylistTableViewCell
        let playlist = self.player.getPlaylist(at: indexPath.row)
        cell.playlist = playlist
        
        return cell
    }
}
