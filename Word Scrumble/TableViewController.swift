//
//  TableViewController.swift
//  Word Scrumble
//
//  Created by Марк Голубев on 14.12.2022.
//

import UIKit

class TableViewController: UITableViewController {
    var allWords = [String]()
    var usedWords = [String]()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // find file
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            // create string from file using try? keyword
            if let startWords = try? String(contentsOf: startWordsURL) {
                // create array using separator \n
                allWords = startWords.components(separatedBy: "\n")
            }
        }
        if allWords.isEmpty {
            allWords = ["silkworm"]
        }
        
        startGame()
    }
    
    func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return usedWords.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Word", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = usedWords[indexPath.row]
        cell.contentConfiguration = content
        
        return cell
        
        
    }


}

