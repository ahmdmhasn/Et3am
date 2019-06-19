//
//  RecievedViewController.swift
//  Et3am
//
//  Created by Jets39 on 6/2/19.
//  Copyright © 2019 Ahmed M. Hassan. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD
class RecievedViewController: UIViewController {
    var coupounDao = CouponDao()
    var usedCouponsCount = 0
    var usedDateArray:NSArray = []
    var restaurantArray = [Restaurant]()
    var barCodeArray:NSArray = []
    
    @IBOutlet weak var CouponCollectioonView: UICollectionView!
    fileprivate let CouponCellIdentifier = "CouponCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        CouponCollectioonView.delegate = self
        CouponCollectioonView.dataSource = self
        CouponCollectioonView.register(UINib.init(nibName: CouponCellIdentifier, bundle: nil), forCellWithReuseIdentifier: CouponCellIdentifier)
        
        if let flowLayout = CouponCollectioonView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
        
        let noCouponsLabel = UILabel()
        noCouponsLabel.center = view.center
        noCouponsLabel.text = "There are not used Coupons yet....."
        noCouponsLabel.textColor = #colorLiteral(red: 0.9334495664, green: 0.3899522722, blue: 0.2985906601, alpha: 1)
        view.addSubview(noCouponsLabel)
        SVProgressHUD.show()
        coupounDao.getReceivedCoupons(completionHandler: {
            useDate,restaurantArray,barCode,code in
            SVProgressHUD.dismiss()
            switch code
            {
            case .success(1):
                self.usedCouponsCount = useDate.count
                self.usedDateArray = useDate
                self.restaurantArray = restaurantArray
                self.barCodeArray = barCode
                noCouponsLabel.isHidden = false
                self.CouponCollectioonView.reloadData()
            case .success(0):
                self.CouponCollectioonView.backgroundView = noCouponsLabel
                break
            default:
                break
                
            }
            
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
        cell.useDate.text! = String(describing: localDate)
        cell.couponBarCode.text! =  String(describing: self.barCodeArray[indexPath.row])+"*********"
        let currentRestaurant = self.restaurantArray[indexPath.row]
        cell.restaurantName.text! = currentRestaurant.restaurantName!
        let path = "https://maps.googleapis.com/maps/api/staticmap?size=500x250"+"&markers=color:red%7C"+"\(currentRestaurant.latitude!),\(currentRestaurant.longitude!)&key=AIzaSyDIJ9XX2ZvRKCJcFRrl-lRanEtFUow4piM"
        cell.restaurantLoation.sd_setShowActivityIndicatorView(true)
        cell.restaurantLoation.sd_setIndicatorStyle(.gray)
        cell.restaurantLoation.sd_setImage(with: URL(string: path), completed: nil)
        return cell
    }
}

//extension RecievedViewController: UICollectionViewDelegateFlowLayout {
//
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let ScreenWidth = UIScreen.main.bounds.width
//        let ItemWidth = ScreenWidth-100
//        return CGSize.init(width: ItemWidth, height: 270)
//    }
//}


