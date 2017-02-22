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

// reusable identifiers for the various components of the collection view
private let reuseIdentifier = "Cell"
private let reusableIdentifierForHeader = "Header"
private let reusableIdentifierForFooter = "Footer"

// specifies the distance of one cell from the border and other cells
private let sectionInsets = UIEdgeInsets(top: 15.0, left: 50.0, bottom: 15.0, right: 50.0)
// specifies the height of a cell
private let cellHeight: CGFloat = 125.0

class CollectionViewController: UICollectionViewController {
    
    var translatedNewsArray = [News]()
    
    var source: String? = ""
    var translation: String? = ""
    
    var header: (String, UIImage)?
    
    // used to keep track of the corresponding row in settings view
    var sourceRow = 0
    var translationRow = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(CollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        // set defaults from last time the app ran
        sourceRow = userDefaults.integer(forKey: "SourceRow")
        translationRow = userDefaults.integer(forKey: "TranslationRow")
        
        // if there is no past settings, use cnn by default
        source = userDefaults.string(forKey: "Source")
        if source == nil {
            source = "cnn"
        }
        
        // if there is no past settings, use yoda by default
        translation = userDefaults.string(forKey: "Translation")
        if translation == nil {
            translation = "yoda"
        }
        
        prepareHeader()
        loadData()
        
        // TODO: implement persistent settings - alter source and translation variables here
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // when we segue to setting, update the title of the navigation bar
        if segue.identifier == "Settings" {
            let vc = segue.destination as! SettingsViewController
            
            vc.delegate = self
            
            // not working
            segue.destination.navigationController?.title = "Settings"
        }
    }

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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = URL(string: translatedNewsArray[indexPath.row].url!)
        UIApplication.shared.open(url!)
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

extension CollectionViewController {
    func loadData() {
        
        translatedNewsArray = []
        
        News.getNews(ForSource: source!) { newsArray in
            
            // if you want to avoid using up API calls to Fun Translations, uncomment the following line and comment out the entire "for in" loop
            //self.translatedNewsArray = newsArray
            self.refreshUI()
            
             for article in newsArray {
             translate(Headline: article.title!, WithTranslation: self.translation!, completion: {translation in
             self.translatedNewsArray.append(News(title: translation, url: article.url!)!)
             // when a new translated headline comes in, update the collection view to show it
             self.refreshUI()
             })
             }

        }
    }
    
    func prepareHeader() {
        // currently supported translations: yoda, elmer fudd, pirate, shakespeare
        if translation == "yoda" {
            header = ("YODA", #imageLiteral(resourceName: "yoda"))
        }
        else if translation == "fudd" {
            header = ("ELMER FUDD", #imageLiteral(resourceName: "fudd"))
        }
        else if translation == "pirate" {
            header = ("A PIRATE", #imageLiteral(resourceName: "pirate"))
        }
        else if translation == "shakespeare" {
            header = ("SHAKESPEARE", #imageLiteral(resourceName: "shakespeare"))
        } else {
            header = ("ERROR", #imageLiteral(resourceName: "settingsIcon"))
        }
    }
}

extension CollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableView: UICollectionReusableView? = nil
        
        if kind == UICollectionElementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: reusableIdentifierForHeader, for: indexPath) as! HeaderCollectionReusableView
            
            headerView.nameLabel.text = header?.0
            headerView.imageView.image = header?.1
            
            reusableView = headerView
        }
        
        if kind == UICollectionElementKindSectionFooter {
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: reusableIdentifierForFooter, for: indexPath) as! FooterCollectionReusableView
            
            reusableView = footerView
        }
        
        return reusableView!
    }
}
