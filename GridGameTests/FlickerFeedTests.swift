//
//  FlickerFeedTests.swift
//  GridGame
//
//  Created by Anurag Solanki on 06/04/17.
//  Copyright © 2017 Anurag Solanki. All rights reserved.
//

import XCTest
@testable import GridGame

class FlickerFeedTests: XCTestCase {
    
    var feed: FlickrFeed!
    var checkedFeed: FlickrFeed!
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        feed = FlickrFeed()
        feed.title = "Feed title"
        feed.media = "http://imageurl.com"
        
        checkedFeed = FlickrFeed()
        checkedFeed.title = "Feed title - checked"
        checkedFeed.media = "http://imageurl-checked.com"
        checkedFeed.checked = true
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        feed = nil
        checkedFeed = nil
        super.tearDown()
    }
    
    func testLeftItems() {
        let result = FlickrFeed.leftItems(totalItems: [feed, checkedFeed])
        XCTAssertTrue(result.count == 1)
    }
    
        
}
