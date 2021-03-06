//
//  OptionsViewController.swift
//  Pig Dice
//
//  Created by Denis Goloborodko on 11/1/20.
//

import UIKit

// Delegation Protocol for instant updates of the Main Game Screen for some Options
protocol ViewControllerDelegate: UIViewController {
    func optionsViewControllerWillDismiss()
}

class OptionsViewController: UIViewController {
        
    // MARK: - Property(s)
    var is2ndPlayer: Bool?
    
    var optionsList: OptionsTableViewController!
    
    weak var delegate: ViewControllerDelegate?

    // MARK: - Outlet(s)
        
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet private weak var backgroundOptionsView: UIView! // To make edges rounded
    
    @IBOutlet private weak var CancelButton: UIButton!
    @IBOutlet private weak var SaveButton: UIButton!

    // MARK: - Action(s)
    
    // Return to the main screen without saving any changes to the Options
    @IBAction private func CancelButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: {
            Options.load()
            
            self.updateColorMode()
            self.updateBackgroundImage()
            self.localizeUI()
            self.updateUI()

            self.optionsList.updateColorMode()
            self.localizeUI()
            self.optionsList.updateUI()
        })
    }
    
    @IBAction private func SaveButtonPressed(_ sender: UIButton) {
        switch optionsList.LanguageSelectionSegmentedControl.selectedSegmentIndex {
        case 0:
            Options.language = .En
        case 1:
            Options.language = .Ru
        default:
            Options.language = Const.DefaultLanguage
            NSLog("Localization not found")
        }
        
        Options.isSoundEnabled = optionsList.SoundEnabledSwitch.isOn
        Options.isMusicEnabled = optionsList.MusicEnabledSwitch.isOn
        Options.isVibrationEnabled = optionsList.VibrationEnabledSwitch.isOn
        
        switch optionsList.GameTypeSegmentedControl.selectedSegmentIndex {
        case 0:
            Options.gameType = .PigGame1Dice
        case 1:
            Options.gameType = .PigGame2Dice
        default:
            Options.gameType = Const.DefaultGameType
            NSLog("Game Type not found")
        }
        
        Options.player1Name = optionsList.Player1NameTextField.text ?? Options.player1Name
        Options.player2Name = optionsList.Player2NameTextField.text ?? Options.player2Name
        Options.is2ndPlayerAI = optionsList.Is2ndPlayerAISwitch.isOn
        
        if let newScoreLimit = Int(optionsList.ScoreLimitTextField.text ?? "Invalid input") {
            Options.scoreLimit = newScoreLimit
        }
            
        // Save options, call delegate to localize the Game screen and dismiss view controller
        Options.save()
        
        delegate?.optionsViewControllerWillDismiss()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
             
        makeViewsRounded([SaveButton, CancelButton], withRadius: Const.cornerRadius)
        makeViewRounded(backgroundOptionsView, withRadius: Const.cornerRadius)
        
        Options.load()
        
        updateColorMode()
        updateBackgroundImage()
        localizeUI()
        updateUI()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "EmbeddedTableViewControllerSegue" else { return }
        
        if let optionsTableViewController = segue.destination as? OptionsTableViewController {
            optionsList = optionsTableViewController
        } else {
            fatalError("Could not downcast UITableViewController to OptionsTableViewController")
        }
    }
    
    func localizeUI() {
        SaveButton.setTitle(LocalizedUI.saveButton.translate(to: Options.language), for: .normal)
        CancelButton.setTitle(LocalizedUI.cancelButton.translate(to: Options.language), for: .normal)
    }
    
    func updateBackgroundImage() {
        backgroundImageView.image = UIImage(named: Options.backgroundImage.rawValue)
    }
    
    func updateUI() {
        guard let is2ndPlayer = is2ndPlayer else { return }
        let playerColor = is2ndPlayer ? Const.Player2Color : Const.Player1Color
        
        SaveButton.backgroundColor = playerColor
        CancelButton.backgroundColor = playerColor
    }
}
