//
//  ProfileHeaderView.swift
//  Netology_IB_Instruments
//
//  Created by ALEKSANDR POZDNIKIN on 27.02.2022.
//

import UIKit

class ProfileHeaderView: UIView {
    
    let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "elephant.jpg"))
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.cornerRadius = 55
        imageView.layer.masksToBounds = true
        return imageView
    }()
    func addAvatarImageView(){
        self.addSubview(avatarImageView)
        self.avatarImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.avatarImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            self.avatarImageView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 16),
            
            self.avatarImageView.widthAnchor.constraint(equalToConstant: 110),
            
            self.avatarImageView.heightAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    let fullNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Слон редкий"
        label.textColor = .black
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    func addFullNameLabel(){
        self.addSubview(fullNameLabel)
        NSLayoutConstraint.activate([
            self.fullNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 150),
            
            self.fullNameLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 27),
            
            self.fullNameLabel.widthAnchor.constraint(equalToConstant: 150),
            
            self.fullNameLabel.heightAnchor.constraint(equalToConstant: 18)
        ])
    }
    
    let statusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Люблю рыбий жир"
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    func addStatusLabel(){
        self.addSubview(statusLabel)
        NSLayoutConstraint.activate([
            self.statusLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 150),
            
            self.statusLabel.topAnchor.constraint(equalTo: self.setStatusButton.topAnchor, constant: -80),
            
            self.statusLabel.widthAnchor.constraint(equalToConstant: 190),
            
            self.statusLabel.heightAnchor.constraint(equalToConstant: 14)
        ])
    }
    
    let statusTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.layer.backgroundColor = UIColor.white.cgColor
        textField.layer.borderWidth = 1
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.cornerRadius = 12
        textField.font = .systemFont(ofSize: 15, weight: .regular)
        textField.textColor = .black
        textField.textAlignment = .center
        return textField
    }()
    
    func addStatusTextField(){
        self.addSubview(statusTextField)
        NSLayoutConstraint.activate([
            self.statusTextField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 140),
            
            self.statusTextField.topAnchor.constraint(equalTo: self.setStatusButton.topAnchor, constant: -50),
            
            self.statusTextField.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            self.statusTextField.heightAnchor.constraint(equalToConstant: 40)
        ])
        self.statusTextField.addTarget(self, action: #selector( statusTextChanged(_:)), for: .editingChanged)
    }
    
    let setStatusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Показать статус", for: .normal)
        button.titleLabel?.textColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 4
        button.layer.shadowOpacity = 0.7
        button.layer.shadowOffset = CGSize(width: 4, height: 4)
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.cornerRadius = 4
        return button
    }()
    func addSetStatusButton(){
        self.addSubview(setStatusButton)
        NSLayoutConstraint.activate([
            self.setStatusButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            
            self.setStatusButton.topAnchor.constraint(equalTo: self.avatarImageView.bottomAnchor, constant: 16),
            
            self.setStatusButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            self.setStatusButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        self.setStatusButton.addTarget(self, action: #selector(showStatusButtonPressed), for: .touchUpInside)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addAvatarImageView()
        addFullNameLabel()
        addSetStatusButton()
        addStatusLabel()
        addStatusTextField()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var statusText:String = ""

@objc
    func showStatusButtonPressed() {
        statusLabel.text = statusText
        print(statusLabel.text ?? "nil")
    }
@objc
    func statusTextChanged(_ textField: UITextField){
        if let text = textField.text {
            statusText = text
        }
    }
}