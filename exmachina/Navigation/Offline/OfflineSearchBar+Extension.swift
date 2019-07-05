//
//  OfflineSearchBar+Extension.swift
//  exmachina
//
//  Created by M'haimdat omar on 05-06-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit

extension OfflineViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text ?? ""
        
        self.filtered = files.filter { file in
            return file.titre.lowercased().contains(searchString.lowercased())
        }
        
        self.newCollection.reloadData()
        print(self.filtered)
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        
    }
}

extension OfflineViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchActive = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchActive = true
        newCollection.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchActive = true
        newCollection.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if !self.searchActive {
            self.searchActive = true
            newCollection.reloadData()
        }
        
        self.searchBar.searchBar.resignFirstResponder()
    }
}
