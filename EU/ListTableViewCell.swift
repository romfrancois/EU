//
//  ListTableViewCell.swift
//  EU
//
//  Created by Romain Francois on 03/07/2020.
//  Copyright © 2020 Romain Francois. All rights reserved.
//

import UIKit

protocol ListTableViewCellDelegate: class {
    func checkBoxToggle(sender: ListTableViewCell)
}

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryCapital: UILabel!
    @IBOutlet weak var checkBoxButton: UIButton!
    
    weak var delegate: ListTableViewCellDelegate?
    
    var euCountry: EUMember! {
        didSet {
            countryName.text = euCountry.country
            countryCapital.text = "Capital: \(euCountry.capital)"
            checkBoxButton.isSelected = euCountry.useEuro
        }
    }

    @IBAction func checkToggled(_ sender: UIButton) {
        delegate?.checkBoxToggle(sender: self)
    }
}

