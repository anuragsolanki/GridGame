//
//  FlickrFeed.swift
//  GridGame
//
//  Created by Anurag Solanki on 05/04/17.
//  Copyright © 2017 Anurag Solanki. All rights reserved.
//


class FlickrFeed {
    
    var title : String?
    var media : String?
    var checked = false
    
    class func leftItems(totalItems: [FlickrFeed]) -> [FlickrFeed] {
        let items = totalItems.filter{( !$0.checked )}
        return items
    }
    
}
