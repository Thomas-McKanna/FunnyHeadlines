//
//  CollectionViewController.swift
//  FunnyHeadlines
//
//  Created by Thomas McKanna on 2/20/17.
//  Copyright © 2017 ISYS 220. All rights reserved.
//

// this file will be used to control the collection view, which will contain an array of cells, each containing a headline

// TODO: 1) Set up the UI for the collection view 2) Allow clicking on a headline to link to the full story in a browser (such as Safari) 3) Allow user to traverse to a settings view (using the navigation bar)

import UIKit

private let reuseIdentifier = "Cell"
// specifies the distance of one cell from the border and other cells
private let sectionInsets = UIEdgeInsets(top: 15.0, left: 50.0, bottom: 15.0, right: 50.0)
// specifies the height of a cell
private let cellHeight: CGFloat = 75.0

class CollectionViewController: UICollectionViewController {
    
    var translatedNewsArray = [News]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // temporary display of how the news API and fun translations work together. Right now, only the first five requests go through because of a rate limit (will be payint $5 for upgrade)
        News.getNews(ForSource: "cnn") { newsArray in
            
            self.translatedNewsArray = newsArray
            self.refreshUI()
            /*
            for article in newsArray {
                translate(Headline: article.title!, WithTranslation: "yoda", completion: {translation in
                    self.translatedNewsArray.append(News(title: translation, url: article.url!)!)
                    // when a new translated headline comes in, update the collection view to show it
                    self.refreshUI()
                })
            }
             */
        }
        
        // Do any additional setup after loading the view.
    }
    
    // used to refresh UI on main thread (for faster refresh)
    func refreshUI() {
        DispatchQueue.main.async(execute: {
            self.collectionView?.reloadData()
        })
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        //bgImageView.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        
        
        self.refreshUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    // this function specifies the number of "columns"
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    // this function specifies the number of "rows"
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return translatedNewsArray.count
    }

    // this function enables us to customize each cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell

        // Configure the cell
        cell.headlineLabel.text = translatedNewsArray[indexPath.row].title
    
        return cell
    }
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     */
    
    /*
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    // the following three functions specify the dimensions of each cell
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // width of a cell
        let widthPerItem = view.frame.width - sectionInsets.left - sectionInsets.right
        
        return CGSize(width: widthPerItem, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        print(section)
        return sectionInsets.top
    }

}
