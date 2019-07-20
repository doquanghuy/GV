//
//  AddContactViewController.swift
//  ContactApp
//
//  Created by Quang Huy on 7/19/19.
//  Copyright © 2019 RezaIlham. All rights reserved.
//

import UIKit

class AddContactViewController: UIViewController {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var mobileTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    private let viewModel = AddContactViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        createGradientLayer()
        setupTextField()
        setupBinding()
    }
    
    private func setupTextField() {
        firstNameTextField.addTarget(self, action: #selector(firstNameTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        lastNameTextField.addTarget(self, action: #selector(lastNameTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        mobileTextField.addTarget(self, action: #selector(mobileTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: UIControl.Event.editingChanged)
    }
    
    @objc private func firstNameTextFieldDidChange(_ sender: UITextField) {
        viewModel.setFirstName(name: sender.text)
    }
    @objc private func lastNameTextFieldDidChange(_ sender: UITextField) {
        viewModel.setLastName(name: sender.text)
    }
    @objc private func mobileTextFieldDidChange(_ sender: UITextField) {
        viewModel.setMobile(mobile: sender.text)
    }
    @objc private func emailTextFieldDidChange(_ sender: UITextField) {
        viewModel.setEmail(email: sender.text)
    }
    
    private func setupBinding() {
        viewModel.errorMessage.bind { (message) in
            guard let message = message else { return }
            DispatchQueue.main.async {
                self.presentErrorAlert(message: message)
            }
        }
        
        viewModel.success.bind { (success) in
            if success {
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
    private func presentErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func createGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.headerView.bounds
        gradientLayer.colors = [UIColor.white.cgColor, UIColor(red:0.31, green:0.89, blue:0.76, alpha:0.3).cgColor]
        self.headerView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    @IBAction func cancelButtonClick(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButtonClick(_ sender: Any) {
        viewModel.createContact()
    }
}
