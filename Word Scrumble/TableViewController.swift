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
        
        // added add button with closure (see below)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promtForAnswer))
        
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
    // added closure for add button
    @objc func promtForAnswer() {
        // created controller
        let ac = UIAlertController(title: "Enter answer", message: nil, preferredStyle: .alert)
        // added TextField
        ac.addTextField()
        
        // created action button
        let submitAction = UIAlertAction(title: "Submit", style: .default) {
            // trying to avoid strong reference
            [weak self, weak ac] action in
            // checked textField is not nil
            guard let answer = ac?.textFields?[0].text else { return }
            // use button Submit using answer and method out of closure
            self?.submit(answer)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func submit(_ answer: String) {
        
    }

}

