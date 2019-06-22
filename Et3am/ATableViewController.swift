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

class ATableViewController: UITableViewController {

    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func displayListAs(_ sender: Any) {
    }
    var listCoupons = [Coupon]()
    var message = UILabel()
    let couponSevices = CouponDao.shared
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        couponSevices.getInBalanceCoupon(userId:UserDao.shared.user.userID! , inBalanceHandler:{ listCoupon in
            self.listCoupons = listCoupon
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
        return cell
    }
 

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

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
        share(data:captureScreenshot())
    }
    
    func share(data:Any){
        let activityVC = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: { (response) in
            print("testtt \(response)")
        })
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
