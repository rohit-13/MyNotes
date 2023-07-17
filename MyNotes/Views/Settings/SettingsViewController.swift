//
//  SettingsViewController.swift
//  MyNotes
//
//  Created by Rohit Kumar on 08/07/23.
//

import UIKit

protocol SettingsViewControllerDelegate: AnyObject {
    func refreshNotes()
}

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    @IBOutlet weak var tableView: UITableView!
    var delegate: SettingsViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            if let passwordSettingsVC = storyboard?.instantiateViewController(withIdentifier: "passwordSettingsVC") as? PasswordSettingsViewController {
                self.navigationController?.navigationBar.prefersLargeTitles = false
                navigationController?.pushViewController(passwordSettingsVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row  == 0 || indexPath.row == 1 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell")!
            let switchView = UISwitch(frame: .zero)
            if indexPath.row == 0 {
                cell.textLabel?.text = "Dark Theme"
                switchView.setOn(UserDefaults.standard.darkThemeEnabled ?? false, animated: true)
            }
            else if indexPath.row == 1 {
                cell.textLabel?.text = "Show private notes"
                switchView.setOn(UserDefaults.standard.privateNotesEnabled ?? false, animated: true)
            }
            switchView.tag = indexPath.row
            switchView.addTarget(self, action: #selector(self.switchChanged(_:)), for: .valueChanged)
            cell.accessoryView = switchView
            cell.selectionStyle = .none
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "actionCell")!
        cell.textLabel?.text = "Password settings"
        return cell
    }
    
    @objc func switchChanged(_ sender : UISwitch!){
        if sender.tag == 0 {
            if sender.isOn { UserDefaults.standard.darkThemeEnabled = true }
            else { UserDefaults.standard.darkThemeEnabled = true }
        }
        if sender.tag == 1 {
            if sender.isOn {
                let alertController = UIAlertController(title: "", message: "Please enter the password to access private notes", preferredStyle: .alert)
                alertController.addTextField { textField in
                    textField.placeholder = "Password"
                    textField.isSecureTextEntry = true
                }
                
                let confirmAction = UIAlertAction(title: "OK", style: .default) { _ in
                    if KeychainHelper.shared.checkPassword(password: alertController.textFields?.first?.text ?? "") {
                        UserDefaults.standard.privateNotesEnabled = true
                        self.delegate?.refreshNotes()
                    }
                    else {
                        UserDefaults.standard.privateNotesEnabled = false
                        sender.setOn(false, animated: true)
                        let alertController = UIAlertController(title: "Error", message: "Wrong password", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "Close", style: .default)
                        alertController.addAction(cancelAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                    UserDefaults.standard.privateNotesEnabled = false
                    sender.setOn(false, animated: true)
                }
                alertController.addAction(confirmAction)
                alertController.addAction(cancelAction)
                present(alertController, animated: true, completion: nil)
            }
            else {
                UserDefaults.standard.privateNotesEnabled = false
                self.delegate?.refreshNotes()
            }
        }
    }

}

