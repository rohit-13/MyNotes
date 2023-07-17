//
//  PasswordSettingsViewController.swift
//  MyNotes
//
//  Created by Rohit Kumar on 16/07/23.
//

import UIKit

class PasswordSettingsViewController: UIViewController {
    @IBOutlet weak var currentPasswordView: UIStackView!
    @IBOutlet weak var currentPassword: UITextField!
    @IBOutlet weak var newPasword: UITextField!
    @IBOutlet weak var confirmNewPassword: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        currentPasswordView.isHidden = KeychainHelper.shared.checkKeyChain() ? false : true
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if !KeychainHelper.shared.checkKeyChain() {
            guard !newPasword.text!.isEmpty && !confirmNewPassword.text!.isEmpty && (newPasword.text == confirmNewPassword.text) else { return }
            KeychainHelper.shared.savePassword(password: newPasword.text!)
            showAlert()
        }
        else {
            guard !currentPassword.text!.isEmpty && !newPasword.text!.isEmpty && !confirmNewPassword.text!.isEmpty && (newPasword.text == confirmNewPassword.text) else { return }
            if KeychainHelper.shared.checkPassword(password: currentPassword.text!) {
                KeychainHelper.shared.savePassword(password: newPasword.text!)
                showAlert()
            }
        }
    }
    
    private func showAlert() {
        let alertController = UIAlertController(title: "", message: "Password saved successfully!", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Close", style: .default)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
