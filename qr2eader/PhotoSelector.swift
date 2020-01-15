//
//  PhotoSelector.swift
//  qr2eader
//
//  Created by Benjamin on 2020/1/13.
//  Copyright © 2020 BDG. All rights reserved.
//

import SwiftUI

struct PhotoSelector: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIImagePickerController
    
    var delegate: ImageSelectDelegate?
    
    init(delegate :ImageSelectDelegate?) {
        self.delegate = delegate
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<PhotoSelector>) -> PhotoSelector.UIViewControllerType {
        UIImagePickerController()
    }
    
    func updateUIViewController(_ uiViewController: PhotoSelector.UIViewControllerType, context: UIViewControllerRepresentableContext<PhotoSelector>) {
        uiViewController.delegate = self.delegate
        uiViewController.allowsEditing = true
        uiViewController.mediaTypes = ["public.image"]
        uiViewController.sourceType = UIImagePickerController.SourceType.photoLibrary
    }
}

struct PhotoSelector_Previews: PreviewProvider {
    static var previews: some View {
        PhotoSelector(delegate: nil)
    }
}
