//
//  ViewController.swift
//  GridGame
//
//  Created by Anurag Solanki on 05/04/17.
//  Copyright © 2017 Anurag Solanki. All rights reserved.
//

import UIKit
import Toast_Swift

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timeLeftLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var questionLabel: UILabel!
    
    var timeLeft = 15
    let parser = DataParser()
    var items : [FlickrFeed] = []
    var selectedItem : FlickrFeed?
    var restartedGame = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        parser.delegate = self
        parser.fetchData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startTimer()
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.updateTimerLabel), name: NSNotification.Name(rawValue: Constants.TimerUpdate), object: nil)

    }
    
    func startTimer() {
        GameTimer.sharedInstance.startTimer()
    }
    
    func setData(items: [FlickrFeed]) {
        self.items = items
        collectionView.reloadData()
        if restartedGame {
            showAllGrids()
        }
    }
    
    func updateTimerLabel() {
        timeLeft = timeLeft - 1
        timeLeftLabel.isHidden = false
        if timeLeft > 0 {
            timeLeftLabel.text = "\(timeLeft)"
            questionLabel.isHidden = true
        } else {
            GameTimer.sharedInstance.invalidate()
            timeLeftLabel.isHidden = true
            questionLabel.isHidden = false
            startGame()
        }
    }
    
    func restartNewGame() {
        items = []
        imageView.image = nil
        collectionView.reloadData()
        timeLeft = 15
        restartedGame = true
        parser.fetchData()
        startTimer()
        questionLabel.isHidden = true
    }
    
    func showAllGrids() {
        collectionView.performBatchUpdates({ 
            print("do nothing")
        }) { (finish) in
            for thisCell in self.collectionView.visibleCells {
                (thisCell as? Cell)?.flip = true
                (thisCell as? Cell)?.flipImage()
            }
        }
    }
    
    func startGame() {
        for thisCell in collectionView.visibleCells {
            (thisCell as? Cell)?.flipImage()
        }
        askNextImage()
    }
    
    func askNextImage() {
        let leftItems = FlickrFeed.leftItems(totalItems: items)
        if leftItems.count == 0 {
            let alert = UIAlertController(title: "Mission complete", message: "Try again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default) {[weak self] action in
                self?.restartNewGame()
            })
            present(alert, animated: true, completion: nil)
        }
        else {
            let left = generateRandomNumber(min: 0, max: leftItems.count - 1)
            selectedItem = leftItems[left]
            if let img = selectedItem!.media {
                imageView.sd_setImage(with: NSURL(string:img) as URL?)
            }
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: Constants.TimerUpdate), object: nil);
    }

}


// MARK:- UICollectionViewDataSource Delegate
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.identifier, for: indexPath) as! Cell
        if items.count >= indexPath.row, items.count > 0 {
            cell.configureWith(item: items[indexPath.row])
        }
        
        return cell
    }
}

// MARK:- UICollectionViewDelegate Methods

extension ViewController : UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if timeLeft > 0 {
            return
        }
        
        collectionView.isUserInteractionEnabled = false
        
        let cell = collectionView.cellForItem(at: indexPath) as! Cell
        cell.flipImage()
        
        if selectedItem?.title == cell.flickrItem.title {
            view.makeToast("Whoa.. you got it!")
            selectedItem?.checked = true
            askNextImage()
        }
        
        // Flip after 1 sec
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            cell.flipImage()
            collectionView.isUserInteractionEnabled = true
        }
        

    }
    
}

