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
    let headerView = MPHeaderView(titleText: "SEARCH", rightButtonImage: nil, withBottomBorder: false)
    let tableView = MPTableView()
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.barTintColor = .ghostWhite
        searchBar.searchBarStyle = UISearchBar.Style.minimal
        searchBar.addBorders(edges: [.bottom], color: .gray, thickness: 0.2)
        searchBar.placeholder = "artist or song"
        
        return searchBar
    }()
    lazy var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        [self.tableView, self.headerView, self.searchBar].forEach { self.view.addSubview($0) }
        
        self.songs = self.player.getSongs()
        self.setAnchors()
//        self.setTargets()
        self.setDelegates()
//        self.setAlertController()
//        self.addObservers()
        self.setGestures()
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
        self.tapGestureRecognizer.delegate = self
    }
    
    private func setGestures() {
        self.view.addGestureRecognizer(self.tapGestureRecognizer)
    }
    
    @objc private func dismissKeyboard() {
        self.searchBar.resignFirstResponder()
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismissKeyboard()
        if let cell = self.tableView.cellForRow(at: indexPath) as? MPSongTableViewCell, let song = cell.song {
            cell.animate()
            if !self.player.isPlaying(song: song)  {
                self.player.setNewQueue(with: .shuffle, startingFrom: song)
                self.player.play()
            } else {
                
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.dismissKeyboard()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            self.searchedSongs = self.songs.filter {
                $0.title.lowercased().prefix(searchText.count) == searchText.lowercased() ||
                $0.artist.lowercased().prefix(searchText.count) == searchText.lowercased()
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
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.resignFirstResponder()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        searchBar.cancelButton?.setTitleColor(.royalBlue, for: .normal)
        searchBar.image(for: .search, state: .focused)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)
    }
}

extension SearchViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.tableView) ?? false {
            return false
        }
        return true
    }
}
