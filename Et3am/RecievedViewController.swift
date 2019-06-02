//
//  RecievedViewController.swift
//  Et3am
//
//  Created by Jets39 on 6/2/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit

class RecievedViewController: UIViewController {

    @IBOutlet weak var CouponCollectioonView: UICollectionView!
   fileprivate let CouponCellIdentifier = "CouponCollectionViewCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        CouponCollectioonView.delegate = self
        CouponCollectioonView.dataSource = self
        CouponCollectioonView.register(UINib.init(nibName: CouponCellIdentifier, bundle: nil), forCellWithReuseIdentifier: CouponCellIdentifier)
        
    }
}
    extension RecievedViewController : UICollectionViewDataSource
    {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 1
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = CouponCollectioonView.dequeueReusableCell(withReuseIdentifier: CouponCellIdentifier, for: indexPath) as! CouponCollectionViewCell
        //    cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.cornerRadius = 10
            cell.contentView.layer.borderWidth = 1.0
            
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            
            return cell
        }
    }
    extension RecievedViewController: UICollectionViewDelegateFlowLayout

    {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let ScreenWidth = UIScreen.main.bounds.width
            let ItemWidth = ScreenWidth-30
            return CGSize.init(width: ItemWidth, height: ItemWidth/2)
        }
        }
    
