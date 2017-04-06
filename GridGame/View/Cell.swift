//
//  Cell.swift
//  GridGame
//
//  Created by Anurag Solanki on 05/04/17.
//  Copyright © 2017 Anurag Solanki. All rights reserved.
//

import UIKit
import SDWebImage

class Cell: UICollectionViewCell {
    
    var flip = false
    
    var flickrItem: FlickrFeed!
    @IBOutlet var image: UIImageView!
    @IBOutlet var backView: UIView!
    
    
    func configureWith(item: FlickrFeed) {
        self.flickrItem = item
        image.sd_setImage(with: URL(string: item.media!))
    }
    
    func flipImage() {
        if flip {
            addSubview(backView)
            bringSubview(toFront: backView)
            UIView.transition(from: backView, to: image, duration: 1.0, options: .transitionFlipFromRight, completion: nil)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[image]|", options: .alignAllCenterY, metrics: nil, views: ["image": image]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[image]|", options: .alignAllCenterY, metrics: nil, views: ["image": image]))
        } else {
            UIView.transition(from: image, to: backView, duration: 1.0, options: .transitionFlipFromLeft, completion: nil)
        }
        flip = !flip

    }
}
