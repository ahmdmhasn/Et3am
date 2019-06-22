//
//  UnpPublishCouponVC.swift
//  Et3am
//
//  Created by Wael M Elmahask on 10/12/1440 AH.
//  Copyright © 1440 AH Ahmed M. Hassan. All rights reserved.
//

import UIKit
import SDWebImage
import MessageUI
//private let reuseIdentifier = "Cell"

class UnpPublishCouponVC: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("UNPUBLISH")
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView?.registerNib(cell: PublishCouponViewCell.self)
        
        // Do any additional setup after loading the view.
//        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
//            flowLayout.estimateItemSize = CGSize(width:1,height:1)
//        }
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

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PublishCouponViewCell", for: indexPath) as! PublishCouponViewCell
        
        // In here we assign teh delegate member of teh cell to make sure once
        // an UI event occurs teh cell will call methods implemented by our controller
        cell.delegate = self
        var x = cell.frame.size
        var z = cell.bounds.size
        
        // Configure the cell
        //cell.valueLabel.text = "20 LE"
        cell.barCodeLabel.text = "123456789999999"
        cell.qrCodeImage.sd_setImage(with: URL(string: "https://global.canon/en/imaging/eosd/samples/eos1300d/downloads/01.jpg"), completed: nil)
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
// MARK: Extension UICollectionViewDelegate
extension UnpPublishCouponVC : PublishCouponViewCellDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate{
    func didPressPost(){
        print("Post")
    }
    func didPressShare(){
        print("SMS")
        // Present the view controller modally.
        if MFMessageComposeViewController.canSendText() {
            let composeVC = MFMessageComposeViewController()
            composeVC.messageComposeDelegate = self
            // Configure the fields of the interface.
            //composeVC.recipients = ["3142026521"]
            composeVC.body = "I love Swift!"
            self.present(composeVC, animated: true, completion: nil)
        } else {
            print("Can't send messages.")
        }
    }
    func didPressPrint(){
        print("Share")
        //share screenshot using other apps
        share(data:captureScreenshot())
    }
    
    func share(data:Any){
        let activityVC = UIActivityViewController(activityItems: [data], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion: nil)
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

extension UICollectionView{
    func registerNib<Cell:UICollectionViewCell>(cell: Cell.Type){
        let nibName = String(describing: Cell.self)
        self.register(UINib(nibName: nibName, bundle: nil), forCellWithReuseIdentifier: nibName)
    }
}
