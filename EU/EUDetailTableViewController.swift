//
//  EUDetailTableViewController.swift
//  EU
//
//  Created by Romain Francois on 01/07/2020.
//  Copyright © 2020 Romain Francois. All rights reserved.
//

import UIKit

class EUDetailTableViewController: UITableViewController {

    @IBOutlet weak var saveBarButton: UIBarButtonItem!
    @IBOutlet weak var countryField: UITextField!
    @IBOutlet weak var capitalField: UITextField!
    @IBOutlet weak var useEuroSwitch: UISwitch!
    
    var euMember: EUMember!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if euMember == nil {
            euMember = EUMember(country: "", capital: "", useEuro: false)
        }
        
        countryField.text = euMember.country
        capitalField.text = euMember.capital
        useEuroSwitch.isOn = euMember.useEuro
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        euMember = EUMember(country: countryField.text!, capital: capitalField.text!, useEuro: useEuroSwitch.isOn)
    }
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        let isPresentingInAddMode = presentingViewController is UINavigationController
        
        if isPresentingInAddMode {
            dismiss(animated: true, completion: nil)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
}
