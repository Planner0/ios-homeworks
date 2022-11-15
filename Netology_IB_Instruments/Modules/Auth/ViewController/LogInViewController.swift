//
//  LogInViewController.swift
//  Netology_IB_Instruments
//
//  Created by ALEKSANDR POZDNIKIN on 19.03.2022.
//

import UIKit

protocol LoginViewControllerDelegate: AnyObject {
    
    func checkCredentials(email: String, password: String, completion: @escaping (Result<AuthModel, NetworkError>) -> Void)
    func signUp(with email: String, password: String, completion: @escaping (Result<AuthModel, NetworkError>) -> Void)
}

class LogInViewController: UIViewController {
    
    //MARK: Property
    
    weak var coordinator: AuthCoordinator?
    
    var passwordCracking = PasswordCracking()
    var viewModel: LoginViewModel!
    var delegate: LoginViewControllerDelegate?
    private let databaseCoordinator: DatabaseCoordinatable

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
    
    let emailField: UITextField = {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: textField.frame.height))
        textField.leftViewMode = .always
        textField.textColor = .black
        textField.backgroundColor = .systemGray6
        textField.font = .systemFont(ofSize: 16, weight: .regular)
        textField.tintColor = UIColor(named: "AccentColor")
        textField.autocapitalizationType = .none
        textField.placeholder = "Email"
        return textField
    }()
    
    let passwordField: UITextField = {
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
    let signUpButton: CustomButton = {
        let button = CustomButton(title: "Не зарегистрированы? Создайте аккаунт сейчас", color: nil)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.systemGray, for: .selected)
        button.setTitleColor(.systemGray, for: .highlighted)
        button.setTitleColor(.systemGray, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 13.0)
        return button
    }()

    // MARK: Init
    
    init(with delegate: LoginViewControllerDelegate, databaseCoordinator: DatabaseCoordinatable) {
        self.delegate = delegate
        self.databaseCoordinator = databaseCoordinator
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: LifeCycle
//    override func loadView() {
//        super.loadView()
//        self.viewModel!.goToHome()
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubview()
        constraints()
        setupScrollView()
        loginButtonTapped()
        signUpButtonTapped()
        viewStateChange()
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
        logInStackView.addArrangedSubview(emailField)
        logInStackView.addArrangedSubview(passwordField)
        self.contentView.addSubview(logInStackView)
        self.contentView.addSubview(logInButton)
        self.contentView.addSubview(signUpButton)
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
            
            self.emailField.heightAnchor.constraint(equalTo: self.passwordField.heightAnchor),

            self.logInButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 16),
            self.logInButton.topAnchor.constraint(equalTo: self.logInStackView.bottomAnchor,constant: 16),
            self.logInButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -16),
            self.logInButton.heightAnchor.constraint(equalToConstant: 50),
            
            self.signUpButton.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor,constant: 16),
            self.signUpButton.topAnchor.constraint(equalTo: self.logInButton.bottomAnchor,constant: 16),
            self.signUpButton.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor,constant: -16),
            self.signUpButton.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func setupScrollView(){
        self.scrollView.keyboardDismissMode = .onDrag
    }
   
    func viewStateChange () {
        viewModel.stateChanged = { [weak self] state in
            guard let strongSelf = self else { return }
            guard let email = strongSelf.emailField.text, !email.isEmpty, email.isValidEmail,
                  let password = strongSelf.passwordField.text, !password.isEmpty, !password.contains(" ") else {
                      print("Missing field data")
                      let alert = customAlert(message: "Не корректно заполнены поля")
                      strongSelf.present(alert, animated: true, completion: nil)
                      return
                  }
            switch state {
                
            case .second:
                strongSelf.checkAccountInDatabase(email: email, password: password)
                print("second")
            case .first:
                strongSelf.createAccountInDatabase(email: email, password: password)
                print("first")
            }
        }
    }
    
    private func checkAccountInDatabase(email: String, password: String) {
        let model = AuthorizationModel(email: email, password: password)
        self.databaseCoordinator.check(checkModel: model) { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case .success(.save):
                print("🍋 Find model")
                strongSelf.viewModel!.goToHome()
            case .failure(let error):
                let alert = customAlert(message: "\(error)")
                strongSelf.present(alert, animated: true, completion: nil)
                print(error)
            }
        }
    }
    
    private func createAccountInDatabase(email: String, password: String) {
        let model = AuthorizationModel(email: email, password: password)
        let alert = UIAlertController(title: "Создать Аккаунт?",
                                      message: "Один шаг и вы с нами",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Создать",
                                      style: .default,
                                      handler: { _ in
            self.databaseCoordinator.create(AuthorizationModel.self, createModel: model) { [weak self] result in
                guard let strongSelf = self else { return }
                switch result {
                case .success(.save):
                    print("🍋 Save model")
                    strongSelf.viewModel!.goToHome()
                case .failure(let error):
                    let alert = customAlert(message: "\(error)")
                    strongSelf.present(alert, animated: true, completion: nil)
                    print("🍋 \(error)")
                }
            }
        }))
        alert.addAction(UIAlertAction(title: "Отмена",
                                      style: .cancel,
                                      handler: { _ in
        }))
        self.present(alert, animated: true, completion: nil)
    }

    private func loginButtonTapped() {
        logInButton.tapAction = { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.viewModel?.changeState(.isLogin)
        }
    }
    
    private func signUpButtonTapped() {
        signUpButton.tapAction = { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.viewModel?.changeState(.isSignUp)
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
extension String {
    var isValidEmail: Bool {
        NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}").evaluate(with: self)
    }
}

