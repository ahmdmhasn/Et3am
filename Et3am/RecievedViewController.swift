//
//  RecievedViewController.swift
//  Et3am
//
//  Created by Jets39 on 6/2/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit

class RecievedViewController: UIViewController {
  var coupounDao = CouponDao()
    var usedCouponsCount = 0
    var usedDateArray:NSArray = []
    var restaurantNameArray:NSArray = []
     var barCodeArray:NSArray = []
    
    @IBOutlet weak var CouponCollectioonView: UICollectionView!
   fileprivate let CouponCellIdentifier = "CouponCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CouponCollectioonView.delegate = self
        CouponCollectioonView.dataSource = self
        CouponCollectioonView.register(UINib.init(nibName: CouponCellIdentifier, bundle: nil), forCellWithReuseIdentifier: CouponCellIdentifier)
     
        coupounDao.getReceivedCoupons(completionHandler: {
            useDate,restaurantName,barCode,code in
            self.usedCouponsCount = useDate.count
            
            
              
                self.usedDateArray = useDate
         
             self.restaurantNameArray = restaurantName
              self.barCodeArray = barCode
      
        
          
            
            self.CouponCollectioonView.reloadData()
           
        })
        
    }
}
    extension RecievedViewController : UICollectionViewDataSource
    {
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.usedCouponsCount
        }
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = CouponCollectioonView.dequeueReusableCell(withReuseIdentifier: CouponCellIdentifier, for: indexPath) as! CouponCollectionViewCell
          
        
            let dateFormatter = DateFormatter()
            dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
            dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
          
            let localDate = dateFormatter.string(from: NSDate(timeIntervalSince1970:self.usedDateArray[indexPath.row] as! TimeInterval) as Date)
            print(localDate)
                   cell.useDate.text! = String(describing: localDate)
                cell.couponBarCode.text! = String(describing: self.barCodeArray[indexPath.row])
            
             cell.restaurantName.text! = String(describing: self.restaurantNameArray[indexPath.row])
            
            
            return cell
        }
    }
    extension RecievedViewController: UICollectionViewDelegateFlowLayout

    {
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let ScreenWidth = UIScreen.main.bounds.width
            let ItemWidth = ScreenWidth-50
            return CGSize.init(width: ItemWidth, height: ItemWidth/2)
        }
        }
    
