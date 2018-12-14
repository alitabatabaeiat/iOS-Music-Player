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
    let headerView = MPHeaderView(titleText: "PLAYLISTS", rightButtonImage: UIImage(from: .iconic, code: "plus", textColor: .darkGray, backgroundColor: .clear, size: CGSize(width: 20, height: 20)))
    
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
        self.headerView.delegate = self
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

extension PlaylistsViewController: MPHeaderViewDelegate {
    func headerView(_ headerView: MPHeaderView, didRightButtonPressed button: MPButton) {
        let alertController = UIAlertController(title: "New Playlist", message: "please type new playlist title", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "playlist title"
            textField.isSecureTextEntry = true
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first, let title = textField.text else { return }
            Defaults.add(playlist: title)
            self.tableView.reloadData()
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}
