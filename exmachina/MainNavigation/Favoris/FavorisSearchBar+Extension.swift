//
//  FavorisSearchBar+Extension.swift
//  exmachina
//
//  Created by M'haimdat omar on 05-06-2019.
//  Copyright © 2019 M'haimdat omar. All rights reserved.
//

import UIKit

extension FavorisViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text ?? ""
        
        self.filtered = files.filter { file in
            return file.matiere.lowercased().contains(searchString.lowercased()) || file.titre.lowercased().contains(searchString.lowercased())
        }
        
        newCollection.reloadData()
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        
    }
}

extension FavorisViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        searchActive = false
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
        newCollection.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = true
        newCollection.reloadData()
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        if !searchActive {
            searchActive = true
            newCollection.reloadData()
        }
        
        self.searchBar.searchBar.resignFirstResponder()
    }
}
