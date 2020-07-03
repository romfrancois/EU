//
//  ViewController.swift
//  EU
//
//  Created by Romain Francois on 30/06/2020.
//  Copyright © 2020 Romain Francois. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addBarButton: UIBarButtonItem!
    
    var members = [
        "Austria",
        "Belgium",
        "Bulgaria",
        "Croatia",
        "Cyprus",
        "Czechia",
        "Denmark",
        "Estonia",
        "Finland",
        "France",
        "Germany",
        "Greece",
        "Hungary",
        "Ireland",
        "Italy",
        "Latvia",
        "Lithuania",
        "Luxembourg",
        "Malta",
        "Netherlands",
        "Poland",
        "Portugal",
        "Romania",
        "Slovakia",
        "Slovenia",
        "Spain",
        "Sweden",
        "United Kingdom"
    ]
    
    let capitals = [
        "Vienna",
        "Brussels",
        "Sofia",
        "Zagreb",
        "Nicosia",
        "Prague",
        "Copenhagen",
        "Tallinn",
        "Helsinki",
        "Paris",
        "Berlin",
        "Athens",
        "Budapest",
        "Dublin",
        "Rome",
        "Riga",
        "Vilnius",
        "Luxembourg (city)",
        "Valetta",
        "Amsterdam",
        "Warsaw",
        "Lisbon",
        "Bucharest",
        "Bratislava",
        "Ljubljana",
        "Madrid",
        "Stockholm",
        "London"
    ]

//    USES EURO
    let euros = [
        true,
        true,
        false,
        false,
        true,
        false,
        false,
        true,
        true,
        true,
        true,
        true,
        false,
        true,
        true,
        true,
        true,
        true,
        true,
        true,
        false,
        true,
        false,
        true,
        true,
        true,
        false,
        false
    ]

    var euCountries: [EUMember] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        for index in 0..<members.count {
            euCountries.append(EUMember(country: members[index], capital: capitals[index], useEuro: euros[index]))
        }
        
        loadData()
    }
    
    func loadData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("eumembers").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: documentURL) else { return }
        
        let jsonDecoder = JSONDecoder()
        do {
            euCountries = try jsonDecoder.decode(Array<EUMember>.self, from: data)
            tableView.reloadData()
        } catch {
            print("Error while saving data! \(error.localizedDescription)")
        }
    }
    
    func saveData() {
        let directoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let documentURL = directoryURL.appendingPathComponent("eumembers").appendingPathExtension("json")
        
        let jsonEncoder = JSONEncoder()
        let data = try? jsonEncoder.encode(euCountries)
        do {
            try data?.write(to: documentURL, options: .noFileProtection)
        } catch {
            print("Error while saving data! \(error.localizedDescription)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            let destination = segue.destination as! EUDetailTableViewController
            let selectedIndexPath = tableView.indexPathForSelectedRow!
            destination.euMember = euCountries[selectedIndexPath.row]
        } else {
           if let selectedIndexPath = tableView.indexPathForSelectedRow {
               tableView.deselectRow(at: selectedIndexPath, animated: true)
           }
       }
    }
    
    @IBAction func unwindFromDetail(segue: UIStoryboardSegue) {
        let source = segue.source as! EUDetailTableViewController
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            euCountries[selectedIndexPath.row] = source.euMember
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
        } else {
            let newIndexPath = IndexPath(row: euCountries.count, section: .zero)
            euCountries.append(source.euMember)
            tableView.insertRows(at: [newIndexPath], with: .bottom)
            tableView.scrollToRow(at: newIndexPath, at: .bottom, animated: true)
        }
        
        saveData()
    }
    
    @IBAction func editButtonPressed(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            tableView.setEditing(false, animated: true)
            sender.title = "Edit"
            addBarButton.isEnabled = true
        } else {
            tableView.setEditing(true, animated: true)
            sender.title = "Done"
            addBarButton.isEnabled = false
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource, ListTableViewCellDelegate {
    func checkBoxToggle(sender: ListTableViewCell) {
        if let selectedIndexPath = tableView.indexPath(for: sender) {
            euCountries[selectedIndexPath.row].useEuro = !euCountries[selectedIndexPath.row].useEuro
            tableView.reloadRows(at: [selectedIndexPath], with: .automatic)
            
            saveData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return euCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ListTableViewCell
//        cell.textLabel?.text = euCountries[indexPath.row].country
//        cell.detailTextLabel?.text = euCountries[indexPath.row].capital
        cell.delegate = self
        cell.euCountry = euCountries[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            euCountries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            saveData()
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let itemToMove = euCountries[sourceIndexPath.row]
        
        euCountries.remove(at: sourceIndexPath.row)
        euCountries.insert(itemToMove, at: destinationIndexPath.row)
        
        saveData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
