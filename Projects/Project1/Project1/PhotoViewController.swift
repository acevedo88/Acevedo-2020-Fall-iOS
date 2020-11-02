//
//  PhotoViewController.swift
//  Project1
//
//  Created by Alexander Acevedo on 10/27/20.
//

import UIKit


class PhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
  
    @IBOutlet weak var imageView: UIImageView!

    let imagePickerController = UIImagePickerController()


    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true

    }
    
    @IBAction func photoLibButton(_ sender: Any) {
        self.imagePickerController.sourceType = .photoLibrary
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    
    
    
    @IBAction func cameraButton(_ sender: Any) {
        
        if( UIImagePickerController.isSourceTypeAvailable(.camera) ){
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let choosenImage = info[.editedImage] as! UIImage

        imageView.image = choosenImage

        dismiss(animated: true, completion: nil)
    }

}


