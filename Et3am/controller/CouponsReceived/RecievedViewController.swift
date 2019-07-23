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
    var coupounDao = CouponDao.shared
    var usedCouponsCount = 0
    var usedDateArray = [Double]()
    var restaurantArray = [Restaurant]()
    var barCodeArray = [String]()
    var currentPage = 1
    var totalResults = 0
    
    @IBOutlet weak var CouponCollectioonView: UICollectionView!
    fileprivate let CouponCellIdentifier = "CouponCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CouponCollectioonView.dataSource = self
        CouponCollectioonView.register(UINib.init(nibName: CouponCellIdentifier, bundle: nil), forCellWithReuseIdentifier: CouponCellIdentifier)
        
        if let flowLayout = CouponCollectioonView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.estimatedItemSize = CGSize(width: 1,height: 1)
        }
        
        loadData()
    }
    
    func loadData() {
        SVProgressHUD.show()
        coupounDao.getReceivedCoupons(currentPage: currentPage, completionHandler: {
            usedDateArray,restaurantArray,barCode,code in
            SVProgressHUD.dismiss()
            switch code {
            case .success(1):
                
                self.usedCouponsCount += usedDateArray.count
                self.usedDateArray.append(contentsOf: usedDateArray)
                self.restaurantArray.append(contentsOf: restaurantArray)
                self.barCodeArray.append(contentsOf: barCode)
        
                self.CouponCollectioonView.reloadData()
                self.currentPage += 1
            case .success(0):
                let noCouponsLabel = UILabel()
                noCouponsLabel.center = self.view.center
                noCouponsLabel.text = "You don't have any used coupon."
                noCouponsLabel.textAlignment = .center
                noCouponsLabel.textColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
                self.view.addSubview(noCouponsLabel)
                self.CouponCollectioonView.backgroundView = noCouponsLabel
            default:
                break
            }
        })
    }
}

extension RecievedViewController : UICollectionViewDataSource {
    
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
        cell.couponBarCode.text! =  "*******\(self.barCodeArray[indexPath.row])"
        let currentRestaurant = self.restaurantArray[indexPath.row]
        cell.restaurantName.text! = currentRestaurant.restaurantName!
        let path = "https://maps.googleapis.com/maps/api/staticmap?size=500x250"+"&markers=color:red%7C"+"\(currentRestaurant.latitude!),\(currentRestaurant.longitude!)&key=AIzaSyDIJ9XX2ZvRKCJcFRrl-lRanEtFUow4piM"
                
        cell.restaurantLoation.sd_setShowActivityIndicatorView(true)
        cell.restaurantLoation.sd_setIndicatorStyle(.gray)
        cell.restaurantLoation.sd_setImage(with: URL(string: path), completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == usedDateArray.count - 1 {
            if usedDateArray.count < totalResults {
                loadData()
            }
        }
    }
    
}

extension RecievedViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let ScreenWidth = UIScreen.main.bounds.width
        let ItemWidth = ScreenWidth-50
        return CGSize.init(width: ItemWidth, height: ItemWidth/2)
    }
}

