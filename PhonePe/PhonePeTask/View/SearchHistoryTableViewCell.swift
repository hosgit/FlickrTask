//
//  SearchHistoryTableViewCell.swift
//  phonepeTask
//
//  Created by hasiyar on 28/03/18.
//  Copyright © 2018 hos.lbox.phonepeTask. All rights reserved.
//

import UIKit

class SearchHistoryTableViewCell: UITableViewCell
{
    var history:History?
    {
        didSet
        {
            searchText.text = history?.text
        }
    }
    override func awakeFromNib()
    {
        super.awakeFromNib()
    }
    @IBOutlet weak var searchText: UILabel!
    
    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

    }

}
