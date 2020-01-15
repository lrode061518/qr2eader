//
//  ActionViewController.swift
//  AE
//
//  Created by Benjamin on 2020/1/15.
//  Copyright © 2020 BDG. All rights reserved.
//

import UIKit
import MobileCoreServices

class ActionViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    private let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])

    @IBAction func mouseDown(_ sender: Any) {
        if UIPasteboard.general.hasStrings {
            print("replacing pasteboard string: "+UIPasteboard.general.string!)
        }
        UIPasteboard.general.string = textField.text?.lowercased()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Get the item[s] we're handling from the extension context.
        
        // For example, look for an image and place it into an image view.
        // Replace this with something appropriate for the type[s] your extension supports.
        var imageFound = false
        for item in self.extensionContext!.inputItems as! [NSExtensionItem] {
            for provider in item.attachments! {
                if provider.hasItemConformingToTypeIdentifier(kUTTypeImage as String) {
                    // This is an image. We'll load it, then place it in our image view.
                    weak var weakImageView = self.imageView
                    provider.loadItem(forTypeIdentifier: kUTTypeImage as String, options: nil, completionHandler: { (imageURL, error) in
                        OperationQueue.main.addOperation {
                            if let strongImageView = weakImageView {
                                if let imageURL = imageURL as? URL {
                                    let image = UIImage(data: try! Data(contentsOf: imageURL))
                                    strongImageView.image = image
                                    var result = ""
                                    let features = self.detector?.features(in:CIImage(cgImage: (image?.cgImage!)!))
                                    for f in features as! [CIQRCodeFeature] {
                                        result += f.messageString!
                                    }
                                    if !result.isEmpty {
                                        self.textField.text = result
                                    } else {
                                        self.textField.text = "N/A"
                                    }
                                }
                            }
                        }
                    })
                    
                    imageFound = true
                    break
                }
            }
            
            if (imageFound) {
                // We only handle one image, so stop looking for more.
                break
            }
        }
    }

    @IBAction func done() {
        // Return any edited content to the host app.
        // This template doesn't do anything, so we just echo the passed in items.
        self.extensionContext!.completeRequest(returningItems: self.extensionContext!.inputItems, completionHandler: nil)
    }

}
