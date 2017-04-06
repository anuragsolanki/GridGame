//
//  DataParserTests.swift
//  GridGame
//
//  Created by Anurag Solanki on 06/04/17.
//  Copyright © 2017 Anurag Solanki. All rights reserved.
//

import XCTest
@testable import GridGame

class DataParserTests: XCTestCase {
    
    let str = "https://api.flickr.com/services/feeds/photos_public.gne?format=json&tags=car"
    var parser: DataParser!
    var expectation:XCTestExpectation?
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        parser = DataParser()
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        parser = nil
        super.tearDown()
    }
    
    func testFetchData() {
        expectation = self.expectation(description: "asynchronous request")
        parser.fetchData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            XCTAssertTrue(self.parser.finalItems.count == 9)
            self.expectation?.fulfill()
        }

        self.waitForExpectations(timeout: 10.0, handler:nil)
    }
    
    
}
