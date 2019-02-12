//
//  SearchViewController.swift
//  Music Player
//
//  Created by Ali Tabatabaei on 12/1/18.
//  Copyright © 2018 Ali Tabatabaei. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    let player = Player.shared
    var songs = [Song]()
    var searchedSongs = [Song]()
    
    let CELL_ID = "search_view_controller_cell_id"
    let headerView = MPHeaderView(titleText: "SEARCH", rightButtonImage: nil)
    let tableView = MPTableView()
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = .blue1
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.cancelButton?.setTitleColor(.white, for: .normal)
        
        return searchBar
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        [self.tableView, self.headerView, self.searchBar].forEach { self.view.addSubview($0) }
        
        self.songs = self.player.getSongs()
        self.setAnchors()
//        self.setTargets()
        self.setDelegates()
//        self.setAlertController()
//        self.categorizeSongs()
//        self.addObservers()
        self.tableView.register(MPSongTableViewCell.self, forCellReuseIdentifier: self.CELL_ID)
    }
    
    func setAnchors () {
        self.headerView.anchor(top: self.view.safeAreaTopAnchor(), right: self.view.safeAreaRightAnchor(), bottom: nil, left: self.view.safeAreaLeftAnchor(), size: CGSize(width: 0, height: 50))
        
        self.searchBar.anchor(top: self.headerView.bottomAnchor, right: self.view.safeAreaRightAnchor(), bottom: nil, left: self.view.safeAreaLeftAnchor(), size: CGSize(width: 0, height: 50))
        
        self.tableView.anchor(top: self.searchBar.bottomAnchor, right: self.view.safeAreaRightAnchor(), bottom: self.view.safeAreaBottomAnchor(), left: self.view.safeAreaLeftAnchor(), padding: UIEdgeInsets(top: 0, left: 0, bottom: 60, right: 0))
    }
    
    private func setDelegates() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.searchBar.delegate = self
    }

}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.searchedSongs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.CELL_ID, for: indexPath) as! MPSongTableViewCell
        cell.song = self.searchedSongs[indexPath.row]
        cell.addBottomLine()
        
        return cell
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            self.searchedSongs = self.songs.filter {
                $0.title.lowercased().prefix(searchText.count) == searchText.lowercased()
            }
        } else {
            self.searchedSongs.removeAll()
        }
        self.tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchedSongs.removeAll()
        self.tableView.reloadData()
    }
}
