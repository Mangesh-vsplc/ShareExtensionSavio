//
//  ShareViewController.swift
//  Share
//
//  Created by Mangesh on 03/06/16.
//  Copyright © 2016 Mangesh  Tekale. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class ShareViewController: UIViewController {

    @IBOutlet var lblImagePagingCount: UILabel!
    @IBOutlet var textView: UITextView!
    @IBOutlet var imageView: UIImageView!
    var currentImagePosition: Int = 0;
    var dictGlobal: Dictionary = [String: AnyObject]()
    @IBAction func cancelButtonTapped(sender: AnyObject) {

    }
    
    @IBAction func postButtonTapped(sender: AnyObject) {
        self.extensionContext?.completeRequestReturningItems(nil, completionHandler: nil)
        
    }
    @IBAction func leftBtnPressed(sender: AnyObject) {
        currentImagePosition -= 1;
        if currentImagePosition < 0 {
            currentImagePosition += 1;
        } else {
            self.showImage(currentImagePosition)
        }
    }

    @IBAction func rightButtonPressed(sender: AnyObject) {
        let imgString = self.dictGlobal["image"] as! String
        let arrayImgUrl:  Array? = imgString.componentsSeparatedByString("#~@")   // #~@ taken from ShareExtensio.js file
        currentImagePosition += 1;
        if currentImagePosition >= arrayImgUrl?.count {
            currentImagePosition -= 1
        }
        else
        {
            self.showImage(currentImagePosition)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        for item: AnyObject in (self.extensionContext?.inputItems)! {
            let inputItem = item as! NSExtensionItem
            for provider: AnyObject in inputItem.attachments! {
                let itemProvider = provider as! NSItemProvider
                
                if itemProvider.hasItemConformingToTypeIdentifier(kUTTypePropertyList as String) {
                    itemProvider.loadItemForTypeIdentifier(kUTTypePropertyList as String, options: nil, completionHandler: { (result: NSSecureCoding?, error: NSError!) -> Void in
                        if let resultDict = result as? NSDictionary {
                            print(resultDict)
                            dispatch_async(dispatch_get_main_queue(), { 
                                self.dictGlobal = resultDict[NSExtensionJavaScriptPreprocessingResultsKey] as! [String : AnyObject]
                                self.textView.text = self.dictGlobal["title"] as! String
                            });
                            self.showImage(self.currentImagePosition)

                        }
                    })
                }
            }
        }

        
    }

    func showImage(idx: Int)  {
        dispatch_async(dispatch_get_main_queue(), {
            let imgString = self.dictGlobal["image"] as! String
            let arrayImgUrl:  Array? = imgString.componentsSeparatedByString("#~@")   // #~@ taken from ShareExtensio.js file
            
            var imgURLString: String? = arrayImgUrl![idx] as String
            imgURLString = imgURLString?.stringByReplacingOccurrencesOfString("'", withString: "")
            
            let imgURL: NSURL? = NSURL.init(string: imgURLString!)
            
            let imgData:  NSData? = NSData.init(contentsOfURL: imgURL!)
            
            if imgData != nil {
                self.imageView.image = UIImage(data: imgData!)

            }
            
            self.lblImagePagingCount.text = String(format: "%d / %d", arguments:[idx+1, (arrayImgUrl?.count)!])

        });
    }
    
//    override func isContentValid() -> Bool {
//        // Do validation of contentText and/or NSExtensionContext attachments here
//        return true
//    }
//
//    override func didSelectPost() {
//        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
//    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
    
//    }
//
//    override func configurationItems() -> [AnyObject]! {
//        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
//        return []
//    }

}
