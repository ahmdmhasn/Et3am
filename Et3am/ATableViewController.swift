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
    case used = "Used"
}
class ATableViewController: UITableViewController {
    
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var commonList = [Any]()
    var listCoupons = [Coupon]()
    var listUsedCoupon = [UsedCoupon]()
    var listReservedCoupon = [ReservedCoupon]()
    
    var message = UILabel()
    let couponSevices = CouponDao.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        couponSevices.getInBalanceCoupon(userId:UserDao.shared.user.userID! , inBalanceHandler:{ listCoupon in
            self.listCoupons = listCoupon
            self.commonList = listCoupon
            self.tableView.reloadData()
        })
    }

    
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
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return listCoupons.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ATableViewCell", for: indexPath) as! ATableViewCell
        cell.delegate = self
        cell.indexPath = indexPath
        
        // Configure the cell
        cell.couponValue.text = String(describing:listCoupons[indexPath.row].couponValue!).appending(" LE")
        cell.barCode.text = listCoupons[indexPath.row].barCode
        //let date = Coupon.getCreationDate(milisecond: listCoupons[indexPath.item].creationDate!)
        cell.creationDate.text = "Created "+String(describing: listCoupons[indexPath.row].creationDate!)
        cell.imageQR.image = generateQRCOde(barCode: listCoupons[indexPath.row].barCode)
        
        switch "" {
        case "InBalance":
            print("")
            let cell = tableView.dequeueReusableCell(withIdentifier: "ATableViewCell", for: indexPath) as! ATableViewCell
            cell.delegate = self
            cell.indexPath = indexPath
            
            // Configure the cell
            cell.couponValue.text = String(describing:listCoupons[indexPath.row].couponValue!).appending(" LE")
            cell.barCode.text = listCoupons[indexPath.row].barCode
            //let date = Coupon.getCreationDate(milisecond: listCoupons[indexPath.item].creationDate!)
            cell.creationDate.text = "Created "+String(describing: listCoupons[indexPath.row].creationDate!)
            cell.imageQR.image = generateQRCOde(barCode: listCoupons[indexPath.row].barCode)
            return cell

        case "Reserved":
            print("")
            let cell = tableView.dequeueReusableCell(withIdentifier: "ReservedViewCell", for: indexPath) as! ReservedViewCell
//            cell.delegate = self
//            cell.indexPath = indexPath
            
            // Configure the cell
//            cell.couponValue.text = String(describing:listCoupons[indexPath.row].couponValue!).appending(" LE")
//            cell.barCode.text = listCoupons[indexPath.row].barCode
//            //let date = Coupon.getCreationDate(milisecond: listCoupons[indexPath.item].creationDate!)
//            cell.creationDate.text = "Created "+String(describing: listCoupons[indexPath.row].creationDate!)
//            cell.imageQR.image = generateQRCOde(barCode: listCoupons[indexPath.row].barCode)
            return cell

        case "Consumed":
            print("")
            let cell = tableView.dequeueReusableCell(withIdentifier: "UsedViewCell", for: indexPath) as! UsedViewCell
            //cell.delegate = self
            //cell.indexPath = indexPath
            
            // Configure the cell
//            cell.couponValue.text = String(describing:listCoupons[indexPath.row].couponValue!).appending(" LE")
//            cell.barCode.text = listCoupons[indexPath.row].barCode
//            //let date = Coupon.getCreationDate(milisecond: listCoupons[indexPath.item].creationDate!)
//            cell.creationDate.text = "Created "+String(describing: listCoupons[indexPath.row].creationDate!)
//            cell.imageQR.image = generateQRCOde(barCode: listCoupons[indexPath.row].barCode)
            return cell

        default:
            print("")
        }
        return cell
    }
 

    // MARK: - Navigation
    @IBAction func displayListAs(_ sender: Any) {
        print("DisplayList")
        let actionSheet = UIAlertController(title: "Show Coupons That", message: nil, preferredStyle: .actionSheet)
        actionSheet.view.tintColor = UIColor.darkGray
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let inBalance = UIAlertAction(title: "InBalance", style: .default) { action in
            self.couponSevices.getInBalanceCoupon(userId:UserDao.shared.user.userID! , inBalanceHandler:{ listCoupon in
                self.listCoupons = listCoupon
                self.tableView.reloadData()
            })
            print(action.title ?? "test")
            //actionSwitch(action: action.title!)
            self.selectTitle(selectedTitle: .inBalance)

        }

        let reserved = UIAlertAction(title: "Reserved", style: .default) { action in
            self.couponSevices.getAllReservedCoupon(userId:UserDao.shared.user.userID! , couponReservedHandler:{ listCouponReserved in
                self.listReservedCoupon = listCouponReserved
                self.tableView.reloadData()
            })
            //actionSwitch(action: action.title!)
            self.selectTitle(selectedTitle: .reserved)

        }
        
        let consumed = UIAlertAction(title: "Consumed", style: .default) { action in
            self.couponSevices.getAllUsedCoupon(userId:UserDao.shared.user.userID! , couponUsedHandler:{ listCouponConsumed in
                self.listUsedCoupon = listCouponConsumed
                self.tableView.reloadData()
            })
            //actionSwitch(action: action.title!)
            self.selectTitle(selectedTitle: .used)

        }
        
        actionSheet.addAction(inBalance)
        actionSheet.addAction(reserved)
        actionSheet.addAction(consumed)
        present(actionSheet, animated: true, completion: nil)
        
    }

    func selectTitle(selectedTitle:SwitchTitle){
        switch selectedTitle {
        case SwitchTitle.inBalance:
            print("d")
            break
        case SwitchTitle.reserved:
            print("ddd")
            break
        default:
            print("dddd")
            break
        }
    }
}




func actionSwitch(action:String) -> String{
    print(action)
    return action
}

// MARK: Extension UICollectionViewDelegate
extension ATableViewController : ATableViewCellDelegate,MFMessageComposeViewControllerDelegate{
    func didPressPost(cellIndex:IndexPath){
        print("Post \(cellIndex)")
        self.couponSevices.publishCoupon(couponId: self.listCoupons[cellIndex.row].couponID!,completedHandler: { (result) in
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
            //composeVC.recipients = ["3142026521"]
            composeVC.body = listCoupons[cellIndex.row].couponID
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
            // @IBOutlet var snapImageView: UIImageView!
            // snapImageView.image = self.view.snapshot(of: rectOfCellInSuperview)
            print(self.view.snapshot(of: rectOfCellInSuperview))
            
            //let finalImage = saveImage(rowImage: snapImageView.image)
            //test final image
            //snapViewImage.image = finalImage
            //return self.view.snapshot(of: rectOfCellInSuperview)
        //}
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
    
    func generateQRCOde(barCode:String!) -> UIImage {
        guard let myString = barCode else { fatalError("image Not founded") }
        let data = myString.data(using: .ascii, allowLossyConversion: false)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter?.setValue(data, forKey: "inputMessage")
        let img = UIImage(ciImage: (filter?.outputImage)!)
        return img
    }
}


extension UIView {
    
    /// Create image snapshot of view.
    ///
    /// - Parameters:
    ///   - rect: The coordinates (in the view's own coordinate space) to be captured. If omitted, the entire `bounds` will be captured.
    ///   - afterScreenUpdates: A Boolean value that indicates whether the snapshot should be rendered after recent changes have been incorporated. Specify the value false if you want to render a snapshot in the view hierarchy’s current state, which might not include recent changes. Defaults to `true`.
    ///
    /// - Returns: The `UIImage` snapshot.
    
    func snapshot(of rect: CGRect? = nil, afterScreenUpdates: Bool = true) -> UIImage {
        return UIGraphicsImageRenderer(bounds: rect ?? bounds).image { _ in
            drawHierarchy(in: bounds, afterScreenUpdates: true)
        }
    }
}
extension UITableView
{
    func snapshotRows(at indexPaths: Set<IndexPath>) -> UIImage?
    {
        guard !indexPaths.isEmpty else { return nil }
        var rect = self.rectForRow(at: indexPaths.first!)
        for indexPath in indexPaths
        {
            let cellRect = self.rectForRow(at: indexPath)
            rect = rect.union(cellRect)
        }
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        for indexPath in indexPaths
        {
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

