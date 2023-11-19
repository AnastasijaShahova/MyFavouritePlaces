//
//  CustomTableViewCell.swift
//  MyFavouritePlaces
//
//  Created by Шахова Анастасия on 17.11.2023.
//

import UIKit
import Cosmos

class CustomTableViewCell: UITableViewCell {

    @IBOutlet weak var imageOfPlaces: UIImageView! {
        didSet {
            imageOfPlaces.layer.cornerRadius = imageOfPlaces.frame.height / 2
            imageOfPlaces.clipsToBounds = true
        }
    }
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var cosmosView: CosmosView! {
        didSet {
            cosmosView.settings.updateOnTouch = false
        }
    }
}
