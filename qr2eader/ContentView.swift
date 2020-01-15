//
//  ContentView.swift
//  qr2eader
//
//  Created by Benjamin on 2020/1/9.
//  Copyright © 2020 BDG. All rights reserved.
//

import SwiftUI
//import AVFoundation

struct QReader {
    let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy : CIDetectorAccuracyHigh])
    func scan(uiImage: UIImage) -> String {
        var result = ""
        let features = detector?.features(in:CIImage(cgImage: uiImage.cgImage!))
        for f in features as! [CIQRCodeFeature] {
            result += f.messageString!
        }
        print(result)
        return result
    }
}


struct ContentView: View {

    public var picker = ImageSelectDelegate()
    private var reader = QReader()
    @State private var refresh = 0
    @State private var display_text = ""
    
    var body: some View {
        VStack {
            if refresh == 0 {
                VStack {
                    if picker.image == nil {
                        Text("Click me!!")
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: CGFloat(10))
                            .onTapGesture {
                                self.invalidate()
                                self.picker.url = "selecting"
                                self.picker.v = self
                            }
                    } else {
                        Image(uiImage: picker.image!)
                            .frame(width: 250, height: 250)
                            .clipShape(Capsule())
                            .overlay(Capsule().stroke(Color.gray, lineWidth: 4))
                            .shadow(radius: 10)
                            .offset(y: -120)
                            .onTapGesture {
                                self.invalidate()
                                self.picker.v = self
                            }
                        Text(display_text)
                            .bold()
                            .italic()
                            .onTapGesture {
                                if UIPasteboard.general.hasStrings {
                                    print("replacing pasteboard string: "+UIPasteboard.general.string!)
                                }
                                UIPasteboard.general.string = self.display_text.lowercased()
                            }
                    }
                }
            } else {
                PhotoSelector(delegate: self.picker)
            }
        }
    }
    
    func scan(uiImage: UIImage?) {
        var displayText = reader.scan(uiImage: uiImage!)
        if displayText.isEmpty {
            displayText = "N/A"
        }
        
        display_text = displayText
        invalidate()
    }
    
    func invalidate() {
        if self.refresh < 1 {
            self.refresh = 1
        } else {
            self.refresh = 0
        }
    }
}


class ImageSelectDelegate: NSObject, UIImagePickerControllerDelegate {
    
    public var image: UIImage?
    public var url = "long press"
    public var v :ContentView?
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print("picked")
        print(info)
        picker.dismiss(animated: true) {
            self.url = info[.imageURL] as? String ?? ""
            self.image = info[.editedImage] as? UIImage
            self.v?.scan(uiImage: self.image)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancled")
        picker.dismiss(animated: true) {
            self.v?.invalidate()
        }
    }
}

extension ImageSelectDelegate: UINavigationControllerDelegate {
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
