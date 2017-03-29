//
//  SearchTaskExtensionOtherDelegate.swift
//  appapp_TODOList
//
//  Created by  shawn on 24/03/2017.
//  Copyright © 2017 shawn. All rights reserved.
//

import UIKit

extension SearchTaskViewController:UISearchResultsUpdating{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.search1Controller.searchBar.resignFirstResponder()
        dismiss(animated: true, completion: nil)
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        if let searchWord = searchController.searchBar.text {
            resultArray = allTask!.filter{
                ($0.itemName?.contains(searchWord))!
            }
            print("過濾結果\(resultArray)")
        }
        resultTableViewController.tableView.reloadData()
    }
}
