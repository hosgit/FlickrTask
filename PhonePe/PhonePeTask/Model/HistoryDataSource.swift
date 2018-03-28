//
//  HistoryDataSource.swift
//  phonepeTask
//
//  Created by hasiyar on 28/03/18.
//  Copyright © 2018 hos.lbox.phonepeTask. All rights reserved.
//

import Foundation
import UIKit

protocol HistoryDataSourceEvents:class
{
    func beginDraging()
    func didSelectQuery(text:String)
    func dataRegenRated() 
}

final class HistoryDataSource:NSObject
{
    static let sharedHistory = HistoryDataSource()
    weak var delegate:HistoryDataSourceEvents?
    var searchHistory = [History]()
    private override init()
    {
        super.init()
        getSavedhistoryFromDB()
    }
    
     func getSavedhistoryFromDB()
    {
        guard let historyText =  History.getHistoryData()else{
            return
        }
        searchHistory = historyText
        self.delegate?.dataRegenRated()
    }
    
    func getHistoryWithText(text:String)
    {
        guard let historyPredicatedData = History.getHistoryDataWithPredicateText(text: text)  else {
            return
        }
        searchHistory = historyPredicatedData
        self.delegate?.dataRegenRated()
    }
    
}

extension HistoryDataSource :UITableViewDelegate
{
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView)
    {
        self.delegate?.beginDraging()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        guard let query = searchHistory[indexPath.row].text else {
            return
        }
        self.delegate?.didSelectQuery(text: query)
    }
}

extension HistoryDataSource :UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let historyCell =  tableView.dequeueReusableCell(withIdentifier: CellIds.serahcHistoyCellId, for: indexPath) as! SearchHistoryTableViewCell
        historyCell.history = searchHistory[indexPath.row]
        return historyCell
    }
}

