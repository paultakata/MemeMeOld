//
//  SentMemesCollectionViewCell.swift
//  MemeMe
//
//  Created by Paul Miller on 23/03/2015.
//  Copyright (c) 2015 PoneTeller. All rights reserved.
//

import UIKit

class SentMemesCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    @IBOutlet weak var cellImageView: UIImageView!
    
    //MARK: - Helper methods
    
    //This method is part of getting the "Delete" menu to appear
    //on long-pressing a cell.
    func deleteItem(sender: AnyObject?) {
        
        if let collectionView = self.superview as? UICollectionView {
            
            let indexPath = collectionView.indexPathForCell(self)
            
            collectionView.delegate?.collectionView!(collectionView,
                performAction: "deleteItem:",
                forItemAtIndexPath: indexPath!,
                withSender: sender)
        }
    }
}