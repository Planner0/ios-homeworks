//
//  LogInViewController.swift
//  Netology_IB_Instruments
//
//  Created by ALEKSANDR POZDNIKIN on 19.03.2022.
//

import UIKit
protocol LoginViewControllerDelegate: AnyObject {
    func validation(login: String, pswd: String) -> Bool
}
class LogInViewController: UIViewController {
    //MARK: Property
    weak var coordinator: AuthCoordinator?
    var passwordCracking = PasswordCracking()
    var viewModel: LoginViewModel!
    var delegate: LoginViewControllerDelegate?
    let user = User(fullName: "1", avatar: "elephant.jpg", status: "Люблю рыбий жир")
    let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.backgroundColor = .white
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    let contentView: UIView = {
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        return contentView
    }()
    let logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "logo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let logInTextField: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.textColor = .black
        textField.backgroundColor = .systemGray6
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.tintColor = UIColor(named: "AccentColor")
        textField.autocapitalizationType = .none
        textField.placeholder = "Email of Phone"
        return textField
    }()
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.backgroundColor = .systemGray6
        textField.isSecureTextEntry = true
        textField.placeholder = "Password"
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        return textField
    }()
    let logInStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.layer.borderColor = UIColor.lightGray.cgColor
        stackView.layer.borderWidth = 0.5
        stackView.layer.cornerRadius = 10
        stackView.spacing = 0.5
        stackView.backgroundColor = UIColor.lightGray
        stackView.layer.masksToBounds = true
        return stackView
    }()
    let logInButton: CustomButton = {
        let button = CustomButton(title: "Log In", color: nil)
        button.titleLabel?.textColor = .white
        let backgrounImageWithCustomAlpha = UIImage(named:"blue_pixel.png")
        let transparentImage = backgrounImageWithCustomAlpha?.image(alpha: 0.8)
        button.setBackgroundImage(backgrounImageWithCustomAlpha, for: .normal)
        button.setBackgroundImage(transparentImage, for: .selected)
        button.setBackgroundImage(transparentImage, for: .highlighted)
        button.setBackgroundImage(transparentImage, for: .disabled)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    let bruteForceButton: CustomButton = {
        let button = CustomButton(title: "Подобрать пароль", color: nil)
        button.titleLabel?.textColor = .white
        let backgrounImageWithCustomAlpha = UIImage(named:"blue_pixel.png")
        let transparentImage = backgrounImageWithCustomAlpha?.image(alpha: 0.8)
        button.setBackgroundImage(backgrounImageWithCustomAlpha, for: .normal)
        button.setBackgroundImage(transparentImage, for: .selected)
        button.setBackgroundImage(transparentImage, for: .highlighted)
        button.setBackgroundImage(transparentImage, for: .disabled)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        return button
    }()
    let activityIndicator: UIActivityIndicatorView = {
       let indicator = UIActivityIndicatorView()
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.color = .blue
        return indicator
    }()
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        constraints()
        setupScrollView()
        showLoginButtonPressed()
        viewStateChange()
        bruteForceButtonPressed()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)    // подписаться на уведомления
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(kbdShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.addObserver(self, selector: #selector(kbdHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)    // отписаться от уведомлений
        let nc = NotificationCenter.default
        nc.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        nc.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    //MARK: Methods
    func addSubview(){
        self.view.addSubview(scrollView)
        self.scrollView.addSubview(self.contentView)
        self.contentView.addSubview(logoImageView)
        logInStackView.addArrangedSubview(logInTextField)
        logInStackView.addArrangedSubview(passwordTextField)
        self.contentView.addSubview(logInStackView)
        self.contentView.addSubview(logInButton)
        self.contentView.addSubview(bruteForceButton)
        self.passwordTextField.addSubview(activityIndicator)
    }
    func constraints(){
        NSLayoutConstraint.activate([
            self.scrollView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
            self.contentView.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            self.contentView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor),
            self.contentView.trailingAnchor.constraint(equalTo: self.scrollView.trailingAnchor),
            self.contentView.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
            self.contentView.widthAnchor.constraint(equalTo: self.scrollView.widthAnchor),
            self.contentView.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor),
            
            self.logoImageView.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor),
            self.logoImageView.topAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.topAnchor, constant: 120),
            self.logoImageView.widthAnchor.constraint(equalToConstant: 100),
            self.logoImageView.heightAnchor.constraint(equalToConstant: 100),
            
            self.logInStackView.topAnchor.constraint(equalTo: self.logoImageView.bottomAnchor, constant: 120),
            self.logInStackView.heightAnchor.constraint(equalToConstant: 100),
            self.logInStackView.leadingAnchor.constraint(equalTo: self.contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            self.logInStackView.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -16),
            
            self.logInTextField.heightAnchor.constraint(equalTo: self.passwordTextField.heightAnchor),
            
            self.activityIndicator.trailingAnchor.constraint(equalTo: self.passwordTextField.trailingAnchor, constant: -16),
            self.activityIndicator.centerYAnchor.constraint(equalTo: self.passwordTextField.centerYAnchor),

            self.logInButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 16),
            self.logInButton.topAnchor.constraint(equalTo: self.logInStackView.bottomAnchor,constant: 16),
            self.logInButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -16),
            self.logInButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.bruteForceButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 16),
            self.bruteForceButton.topAnchor.constraint(equalTo: self.logInButton.bottomAnchor,constant: 16),
            self.bruteForceButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -16),
            self.bruteForceButton.heightAnchor.constraint(equalToConstant: 50)
            
        ])
    }
    func setupScrollView(){
        self.scrollView.keyboardDismissMode = .onDrag
    }
   
    func viewStateChange () {
        viewModel.stateChanged = { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .first:
                print("first")
            case .second:
                    guard let login = self.logInTextField.text, let password = self.passwordTextField.text else { return }
                    //print("логин \(login) пароль:\(password)")
                    if let check = self.delegate?.validation(login: login, pswd: password), check != false {
                        //print("Верификация пройдена логин \(login) пароль:\(password)")
                        if self.user.fullName == login {
                            self.viewModel!.goToHome()
                        }
                    } else {
#if DEBUG
                        self.viewModel!.goToHome()
#endif
                        print("Верификация не пройдена")
                        let alertVC = UIAlertController(title: "Error", message: "Необходима регистрация", preferredStyle: .alert)
                        let actionOk = UIAlertAction(title: "OK", style: .cancel) { actionOk in
                            print("Tap Ok")
                        }
                        alertVC.addAction(actionOk)
                        self.present(alertVC, animated: true, completion: nil)
                    }
                print("second")
            }
        }
    }
    func showLoginButtonPressed() {
        logInButton.tapAction = { [self] in
            self.viewModel?.changeState(.isReady)
        }
    }
    func bruteForceButtonPressed() {
        bruteForceButton.tapAction = {
            self.bruteForceButton.isEnabled = false
            let password = randomPassword()
            print("Сгенерирован пароль: \(password)")
            let queue = DispatchQueue.global(qos: .background)
            queue.async {
                self.passwordCracking.bruteForce(passwordToUnlock: password)
                DispatchQueue.main.async {
                    self.passwordTextField.isSecureTextEntry = false
                    self.passwordTextField.text = password
                    self.activityIndicator.stopAnimating()
                    self.bruteForceButton.isEnabled = true
                }
            }
            DispatchQueue.main.async {
                self.activityIndicator.startAnimating()
            }
        }
    }
    @objc
    private func kbdShow(notification: NSNotification) {
        if let kbdSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.scrollView.contentInset.bottom = kbdSize.height
            self.scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: kbdSize.height, right: 0)
        }
    }
    @objc
    private func kbdHide(notification: NSNotification) {
        self.scrollView.contentInset.top = .zero
        self.scrollView.verticalScrollIndicatorInsets = .zero
    }

}

extension UIImage {
    func image(alpha: CGFloat) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: .zero, blendMode: .normal, alpha: alpha)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
