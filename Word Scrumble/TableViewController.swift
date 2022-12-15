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
    
    enum errorType {
        case notPossible
        case notOriginal
        case notReal
        case startWord
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // added add button with closure (see below)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(promtForAnswer))
        // added new game button
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New game", style: .plain, target: self, action: #selector(startGame))
        
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
    
    @objc func startGame() {
        title = allWords.randomElement()
        usedWords.removeAll(keepingCapacity: true)
        // update table data
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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
    
    // added submit function with word checking
    func submit(_ answer: String) {
        let lowerAnswer = answer.lowercased()
        
        if isPossible(word: lowerAnswer) {
            if isOriginal(word: lowerAnswer) {
                if isReal(word: lowerAnswer) {
                    if isStartWord(word: lowerAnswer){
                        usedWords.insert(lowerAnswer, at: 0)
                        
                    // update one row
                        let indexPath = IndexPath(row: 0, section: 0)
                        tableView.insertRows(at: [indexPath], with: .automatic)
                        return
                    } else {
                        showErrorMessage(error: .startWord)
                    }
                } else {
                    showErrorMessage(error: .notReal)
                }
            } else {
                showErrorMessage(error: .notOriginal)
            }
        } else {
            showErrorMessage(error: .notPossible)
        }
    }
    
    func isPossible(word: String) -> Bool {
        guard var tempWord = title?.lowercased() else { return false }
        
        for letter in word {
            
            if let position = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: position)
            } else {
                return false
            }
        }
        
        return true
    }
    
    func isOriginal(word: String) -> Bool {
        return !usedWords.contains(word)
    }

    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
        return misspelledRange.location == NSNotFound && word.utf16.count > 2
    }
    
    func isStartWord(word: String) -> Bool {
        return word != title
    }
    
    func showErrorMessage(error: errorType) {
        let errorTitle: String
        let errorMessage: String
        
        switch error {
        case .notPossible:
            guard let title = title else { return }
            errorTitle = "Word not possible"
            errorMessage = "You can't spell that word from \(title.lowercased())."
        case .notOriginal:
            errorTitle = "Word already used"
            errorMessage = "Be more original!"
        case .notReal:
            errorTitle = "Word not recognized"
            errorMessage = "You can't just make them up, you know!"
        case .startWord:
            errorTitle = "Word is equal to start word"
            errorMessage = "You can't use start word!"
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        
        present(ac, animated: true)
    }


}

