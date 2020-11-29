//
//  OptionsViewController.swift
//  Pig Game (Dice)
//
//  Created by Denis Goloborodko on 11/1/20.
//

import UIKit

// Options screen
class OptionsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Options.load()
        
        localiseUI()
        updateUI()
    }

    func localiseUI() {
        SaveButton.setTitle(LocalisedUI.saveButton.translate(to: Options.language), for: .normal)
        CancelButton.setTitle(LocalisedUI.cancelButton.translate(to: Options.language), for: .normal)
        
        Player1NameTitle.text = LocalisedUI.player1NameTitle.translate(to: Options.language)
        
        Player2NameTitle.text = LocalisedUI.player2NameTitle.translate(to: Options.language)
        
        ScoreLimitTitle.text = LocalisedUI.scoreLimitTitle.translate(to: Options.language)
        
        NoteLabel.text = LocalisedUI.noteLabel.translate(to: Options.language)
        NoteLabel.textAlignment = .natural
    }
    
    func updateUI() {
        // Note: view controller knows too much about options - might need refactoring
        switch Options.language {
        case .En:
            LanguageSelectionSegmentedControl.selectedSegmentIndex = 0
        case .Ru:
            LanguageSelectionSegmentedControl.selectedSegmentIndex = 1
        }
            
        Player1NameTextField.text = Options.player1Name
        Player2NameTextField.text = Options.player2Name
        ScoreLimitTextField.text = String(Options.scoreLimit)
    }
    
    @IBOutlet weak var LanguageSelectionSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var Player1NameTitle: UILabel!
    @IBOutlet weak var Player1NameTextField: UITextField!
    
    @IBOutlet weak var Player2NameTitle: UILabel!
    @IBOutlet weak var Player2NameTextField: UITextField!
    
    @IBOutlet weak var ScoreLimitTitle: UILabel!
    @IBOutlet weak var ScoreLimitTextField: UITextField!
    
    @IBOutlet weak var NoteLabel: UILabel!
    
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var SaveButton: UIButton!
    
    // Returt to the main screen without saving any changes to the Options
    @IBAction func CancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIButton) {
        switch LanguageSelectionSegmentedControl.selectedSegmentIndex {
        case 0:
            Options.language = .En
        case 1:
            Options.language = .Ru
        default:
            print("Localization not found")
        }
        
        Options.player1Name = Player1NameTextField.text ?? Options.player1Name
        Options.player2Name = Player2NameTextField.text ?? Options.player2Name
        
        if let scoreLimitString = ScoreLimitTextField.text {
            if let scoreLimitInt = Int(scoreLimitString) {
                Options.scoreLimit = scoreLimitInt
            } else {
                print("Invalid score limit input")
            }
        }
        
        // Dismiss view controller and save options
        self.dismiss(animated: true, completion: Options.save)
    }
}
