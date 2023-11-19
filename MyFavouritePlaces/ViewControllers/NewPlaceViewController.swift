//
//  NewPlaceViewController.swift
//  MyFavouritePlaces
//
//  Created by Шахова Анастасия on 17.11.2023.
//

import UIKit
import Cosmos

class NewPlaceViewController: UITableViewController {

    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var typeName: UITextField!
    @IBOutlet weak var locationName: UITextField!
    @IBOutlet weak var cosmosView: CosmosView!
    
    var currentPlace: Place!
    var currentRating = 0.0
    
    var imageIsChanged = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 1))
        
        saveButton.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        setUpEditScreen()
        
        cosmosView.didTouchCosmos = { rating in
            self.currentRating = rating
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            let cameraItem = UIImage(named: "camera")
            let photoItem = UIImage(named: "photo-1")
            
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            
            let camera = UIAlertAction(title: "Camera", style: .default, handler: { _ in
                self.chooseImagePicker(source: .camera)
            })
            
            camera.setValue(cameraItem, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default, handler: { _ in
                self.chooseImagePicker(source: .photoLibrary)
            })
            
            photo.setValue(photoItem, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
    
    private func setUpEditScreen() {
        if currentPlace != nil {
            
            setUpNavigationBar()
            imageIsChanged = true
            
            guard let data = currentPlace?.imageData,
                  let image = UIImage(data: data) else { return }
            
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            placeName.text = currentPlace?.name
            locationName.text = currentPlace?.location
            typeName.text = currentPlace?.type
            cosmosView.rating = currentPlace.rating
        }
    }
    
    private func  setUpNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
    
    func savePlace() {
        
        let image = imageIsChanged ? placeImage.image : UIImage(named: "imagePlaceholder")
        let imageData = image?.pngData()
        
        let newPlace = Place(name: placeName.text!, location: locationName.text, type: typeName.text, imageData: imageData, rating: currentRating)
        
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            }
        } else {
            StorageManager.saveObject(newPlace)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let id = segue.identifier, let mapVc  = segue.destination as? MapViewController else { return }
        if segue.identifier != "showPlace" { return }
        
        mapVc.incomeSegueIdentifier = id
        mapVc.mapViewControllerDelegate = self
        
        if id == "ShowPlace" {
            mapVc.place.name = placeName.text!
            mapVc.place.location = locationName.text
            mapVc.place.type = typeName.text
            mapVc.place.imageData = placeImage.image?.pngData()
        }
    }
    
    @IBAction func cancelAction(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
}

extension NewPlaceViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChange() {
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
}

extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        
        imageIsChanged = true
        dismiss(animated: true)
    }
}

extension NewPlaceViewController: MapViewControllerDelegate {
    func getAddress(_ address: String?) {
        locationName.text = address
    }
}
