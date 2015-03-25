//
//  SentMemesTableViewCell.swift
//  MemeMe
//
//  Created by Paul Miller on 23/03/2015.
//  Copyright (c) 2015 PoneTeller. All rights reserved.
//

import UIKit

class SentMemesTableViewCell: UITableViewCell {
    
    //MARK: - Properties

    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var cellMainTextLabel: UILabel!
    @IBOutlet weak var cellDetailTextLabel: UILabel!
    
    //MARK: - Overrides
    //MARK: View methods
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    //MARK: UITableViewCell

    override func setSelected(selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
}
