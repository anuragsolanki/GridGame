//
//  DataParser.swift
//  GridGame
//
//  Created by Anurag Solanki on 05/04/17.
//  Copyright © 2017 Anurag Solanki. All rights reserved.
//

import Alamofire

class DataParser {
    
    weak var delegate: ViewController?
    
    var finalItems: [FlickrFeed] = []

    func fetchData() {
        finalItems = []
        
        // FIXME: Response is not valid json, hence a longer way to parse response
        Alamofire.request(Constants.urlString).responseString {[weak self] response in
            
            if let JSON = response.result.value {
                print("JSON: \(JSON)")
                let endIndex = JSON.index(JSON.endIndex, offsetBy: -1)
                let truncated = JSON.substring(to: endIndex)
                let finalJSON = truncated.replacingOccurrences(of: "jsonFlickrFeed(", with: "")
                let data = finalJSON.data(using: .utf8)!
                do {
                    let parsedData = try JSONSerialization.jsonObject(with: data, options: []) as! [String:AnyObject]
                    if let items = parsedData["items"] as? [[String: AnyObject]] {
                        for i in items {
                            if let t = i["title"] as? String, let media = i["media"] as? [String:String] {
                                let newObject = FlickrFeed()
                                newObject.title = t
                                newObject.media = media["m"]
                                self?.finalItems.append(newObject)
                            }
                        }
                    }
                } catch let error as NSError {
                    print(error)
                }
                if (self?.finalItems.count)! > 9 {
                    self?.finalItems = Array(self!.finalItems.prefix(9))
                }
                if let item = self?.finalItems {
                    self?.delegate?.setData(items: item)
                }

            }
            
        }
    }
    
}
