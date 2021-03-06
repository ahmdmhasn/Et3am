//
//  ATableViewController.swift
//  Et3am
//
//  Created by Wael M Elmahask on 10/18/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit
import MessageUI
import SVProgressHUD


enum SwitchTitle: String {
    case inBalance = "InBalance"
    case reserved = "Reserved"
    case used = "Used Coupons"
}

class CouponsDonatedVC: UITableViewController {
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var listCoupons = [Coupon]()
    var listUsedCoupon = [UsedCoupon]()
    var listReservedCoupon = [ReservedCoupon]()
    var currentPage = 1
    var totalResults = 0
    var message = UILabel()
    let couponSevices = CouponDao.shared
    

    var valuee = SwitchTitle.inBalance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        message.center = view.center
        //noList.text = "You don't have any used coupon."
        message.text = "No Coupon Found"
        message.textAlignment = .center
        message.textColor = #colorLiteral(red: 0.4078193307, green: 0.4078193307, blue: 0.4078193307, alpha: 1)
        view.addSubview(message)
        message.isHidden = true
        if listCoupons.count == 0 {
            self.tableView.backgroundView = self.message
        } else {
            self.message.isHidden = false
            self.tableView.reloadData()
        }
        tableView.register(UINib(nibName: "ATableViewCell", bundle: nil), forCellReuseIdentifier: "ATableViewCell")
        tableView.register(UINib(nibName: "ReservedViewCell", bundle: nil), forCellReuseIdentifier: "ReservedViewCell")
        tableView.register(UINib(nibName: "UsedViewCell", bundle: nil), forCellReuseIdentifier: "UsedViewCell")
        
        selectTitle(selectedTitle: valuee)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch valuee {
        case .inBalance:
            return listCoupons.count
        case .reserved:
            return listReservedCoupon.count
        case .used:
            return listUsedCoupon.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch valuee {
        case SwitchTitle.inBalance:
            let cell = tableView.dequeueReusableCell(withIdentifier: "ATableViewCell", for: indexPath) as! ATableViewCell
            cell.delegate = self
            cell.indexPath = indexPath
            cell.couponValue.text = String(describing:listCoupons[indexPath.row].couponValue!).appending(" LE")
            cell.barCode.text = listCoupons[indexPath.row].barCode
            cell.creationDate.text = "Created: "+String(describing: listCoupons[indexPath.row].creationDate!)
            cell.imageQR.image = Helper.generateQRCOde(barCode: listCoupons[indexPath.row].barCode)
            print("i")
            return cell
        case SwitchTitle.reserved:
            print("reserved")
            let cell1 = tableView.dequeueReusableCell(withIdentifier: "ReservedViewCell", for: indexPath) as! ReservedViewCell
            cell1.delegate = self
            cell1.indexPath = indexPath
            cell1.couponBarCode.text = listReservedCoupon[indexPath.row].couponQrCode
            cell1.couponValue.text = String(describing:listReservedCoupon[indexPath.row].couponValue!).appending(" LE")
            cell1.couponBarCode.text = listReservedCoupon[indexPath.row].couponBarcode
            cell1.reservationDate.text = "Reserved: "+String(describing: listReservedCoupon[indexPath.row].reservationDate!)
            cell1.qrImage.image = Helper.generateQRCOde(barCode: listReservedCoupon[indexPath.row].couponBarcode)
            return cell1
        case .used:
            let cell2 = tableView.dequeueReusableCell(withIdentifier: "UsedViewCell", for: indexPath) as! UsedViewCell
            cell2.couponBarCode.text = listUsedCoupon[indexPath.row].barCode
            cell2.usedDate.text = "Used at: "+String(describing:listUsedCoupon[indexPath.row].useDate!)
            cell2.priceMeal.text = "Value: "+String(describing: listUsedCoupon[indexPath.row].price!).appending(" LE")
            cell2.restaurantAddress.text = "Address: "+String(describing:listUsedCoupon[indexPath.row].restaurantAddress!)
            cell2.restaurantName.text = "Restaurant: "+String(describing:listUsedCoupon[indexPath.row].restaurantName!)
            cell2.usedBy.text = listUsedCoupon[indexPath.row].userName
            return cell2
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == listCoupons.count - 1 {
            if listCoupons.count < totalResults {
                loadMoreData()
            }
        }
    }

    func loadMoreData(){
        currentPage += 1
        print("currentPage: \(currentPage)")
        self.selectTitle(selectedTitle: .inBalance)
    }
    

    // MARK: - Navigation
    @IBAction func displayListAs(_ sender: Any) {
        print("DisplayList")
        let actionSheet = UIAlertController(title: "Show your coupons", message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = UIColor.darkGray
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let inBalance = UIAlertAction(title: "In Balance", style: .default) { action in
            self.listCoupons.removeAll()
            self.selectTitle(selectedTitle: .inBalance)
        }

        let reserved = UIAlertAction(title: "Reserved", style: .default) { action in
            self.listReservedCoupon.removeAll()
            self.selectTitle(selectedTitle: .reserved)
            
        }
        
        let consumed = UIAlertAction(title: "Consumed", style: .default) { action in
            self.listUsedCoupon.removeAll()
            self.selectTitle(selectedTitle: .used)
        }
        
        actionSheet.addAction(inBalance)
        actionSheet.addAction(reserved)
        actionSheet.addAction(consumed)
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    
    func selectTitle(selectedTitle:SwitchTitle){
        switch selectedTitle {
        case .inBalance:
            print("inBalance")
            self.couponSevices.getInBalanceCoupon(userId:UserDao.shared.user.userID! , inBalanceHandler:{ [unowned self](listCoupon,totalResult) in
                self.valuee = .inBalance
                self.listReservedCoupon.removeAll()
                self.listUsedCoupon.removeAll()
                self.totalResults = totalResult
                self.listCoupons.append(contentsOf:listCoupon)
                self.tableView.reloadData()
            })
            if self.listCoupons.count == 0 {
                self.tableView.backgroundView = self.message
                self.message.text = "No Coupon in your balance"
            }else {
                self.message.isHidden = false
                self.tableView.reloadData()
            }
            
        case .reserved:
            print("reserved")
            self.couponSevices.getAllReservedCoupon(userId:UserDao.shared.user.userID! , couponReservedHandler:{ [unowned self](listCouponReserved,totalResult) in
                self.valuee = .reserved
                self.listCoupons.removeAll()
                self.listUsedCoupon.removeAll()
                self.totalResults = totalResult
                self.listReservedCoupon.append(contentsOf:listCouponReserved)
                self.tableView.reloadData()
            })
            if self.listReservedCoupon.count == 0 {
                self.tableView.backgroundView = self.message
                self.message.text = "No Coupon reserved from your balance yet"
            }else {
                self.message.isHidden = false
                self.tableView.reloadData()
            }
            
        case .used:
            print("used")
            self.couponSevices.getAllUsedCoupon(userId:UserDao.shared.user.userID! , couponUsedHandler:{ [unowned self](listCouponConsumed,totalResult) in
                self.valuee = .used
                self.listCoupons.removeAll()
                self.listReservedCoupon.removeAll()
                self.totalResults = totalResult
                self.listUsedCoupon.append(contentsOf:listCouponConsumed)
                self.tableView.reloadData()
            })
            if self.listUsedCoupon.count == 0 {
                self.tableView.backgroundView = self.message
                self.message.text = "No Coupon used from your balance yet"
            }else {
                self.message.isHidden = false
                self.tableView.reloadData()
            }
        }
    }
}


// MARK: Extension UICollectionViewDelegate
extension CouponsDonatedVC : ATableViewCellDelegate,ReservedCellDelegate,MFMessageComposeViewControllerDelegate{
    func didPressPost(cellIndex:IndexPath){
        print("Post \(cellIndex)")
        self.couponSevices.publishCoupon(couponId: self.listCoupons[cellIndex.row].couponID!,completedHandler: { [unowned self](result) in
            switch result {
            case true :
                self.listCoupons.remove(at: cellIndex.row)
                self.tableView.deleteRows(at: [cellIndex], with: .automatic)
                self.tableView.reloadData()
                 SVProgressHUD.showSuccess(withStatus: "Donated successfully!")
            case false:
                 SVProgressHUD.showSuccess(withStatus: "Donated unSuccessfully!")
            }
        })
        
        if listCoupons.count == 0 {
            self.tableView.backgroundView = self.message
        } else {
            self.message.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    func didPressShare(cellIndex:IndexPath){
        print("SMS")
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            // Configure the fields of the interface.
            let coupon = listCoupons[cellIndex.row]
            composeVC.body = "Hi! I'm inviting you on a meal with coupon code \(coupon.barCode!). It's valid within 48 hours from now at any of the restaurants supported by Et3am. Happy Meal!"
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    func didPressPrint(cellIndex:IndexPath){
        print("Share")
        //share screenshot using other apps
        //share(data:captureScreenshot())
        //share(data: snapshotrow(sender: cellIndex))
        share(data:tableView.snapshotRows(at: Set([cellIndex])) ?? 0)
//        share(data: snapshotrow(sender: cellIndex))
    }
    
    func didPressCancel(cellIndex:IndexPath){
        print("Post \(cellIndex)")
        self.couponSevices.cancelReservation(couponId: self.listReservedCoupon[cellIndex.row].couponId!,cancelHandler: { (result) in
            switch result {
            case true :
                self.listReservedCoupon.remove(at: cellIndex.row)
                self.tableView.deleteRows(at: [cellIndex], with: .automatic)
                self.tableView.reloadData()
                SVProgressHUD.showSuccess(withStatus: "Cancel successfully!")
            case false:
                SVProgressHUD.showSuccess(withStatus: "Cancel unSuccessfully!")
            }
        })
        
        if listReservedCoupon.count == 0 {
            self.tableView.backgroundView = self.message
        } else {
            self.message.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    func share(data:Any){
        let activityVC = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: { (response) in
            print("testtt \(response)")
        })
    }
    
    func snapshotrow(sender: IndexPath) -> UIImage {
            let rectOfCellInTableView = tableView.rectForRow(at: IndexPath(row: sender.row, section: sender.section))
            let rectOfCellInSuperview = tableView.convert(rectOfCellInTableView, to: tableView.superview)
        return saveImage(rowImage:self.view.snapshot(of: rectOfCellInSuperview))
    }
    
    func saveImage(rowImage: UIImage) -> UIImage {
        let bottomImage = rowImage
        //let topImage = UIImage(named: "myLogo")!
        
        let newSize = CGSize.init(width: 41, height: 41) // set this to what you need
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        
        bottomImage.draw(in: CGRect(origin: .zero, size: newSize))
        //topImage.draw(in: CGRect(origin: .zero, size: newSize))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    func captureScreenshot() -> UIImage {
        let layer = UIApplication.shared.keyWindow!.layer
        let scale = UIScreen.main.scale
        // Creates UIImage of same size as view
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let screenshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return screenshot!
        // THIS IS TO SAVE SCREENSHOT TO PHOTOS
        //UIImageWriteToSavedPhotosAlbum(screenshot!, nil, nil, nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        switch (result) {
        case .cancelled:
            print("Message was cancelled")
            dismiss(animated: true, completion: nil)
        case .failed:
            print("Message failed")
            dismiss(animated: true, completion: nil)
        case .sent:
            print("Message was sent")
            dismiss(animated: true, completion: nil)
        }
    }
    
    }


extension UITableView {
    
    func snapshotRows(at indexPaths: Set<IndexPath>) -> UIImage?
    {
        guard !indexPaths.isEmpty else { return nil }
        var rect = self.rectForRow(at: indexPaths.first!)
        for indexPath in indexPaths {
            let cellRect = self.rectForRow(at: indexPath)
            rect = rect.union(cellRect)
        }
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        for indexPath in indexPaths {
            let cell = self.cellForRow(at: indexPath)
            cell?.layer.bounds.origin.y = self.rectForRow(at: indexPath).origin.y - rect.minY
            cell?.layer.render(in: context)
            cell?.layer.bounds.origin.y = 0
        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}

