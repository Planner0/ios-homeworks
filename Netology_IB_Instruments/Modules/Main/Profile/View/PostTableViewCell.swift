//
//  PostTableViewCell.swift
//  Netology_IB_Instruments
//
//  Created by ALEKSANDR POZDNIKIN on 31.03.2022.
//

import UIKit
import SnapKit
//import iOSIntPackage
protocol PostTableViewCellDelegate: AnyObject {
    func wasLikedPost(authorLabel: UILabel?)
}

class PostTableViewCell: UITableViewCell {

    enum State {
        case isFavorite
        case none
    }
    private(set) var state: State = .none
//    {
//        didSet {
//            stateChanged?(state)
//        }
//    }
    weak var delegate: PostTableViewCellDelegate?
    private let databaseCoordinator = CreateService.shared.coreDataCoordinator

    //let post: Post?
    private lazy var doubleTap: UITapGestureRecognizer = {
        let recognizer = UITapGestureRecognizer()
        recognizer.numberOfTapsRequired = 2
        recognizer.addTarget(self, action: #selector(processDoubleTap))
        return recognizer
    }()
    let authorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 20, weight: .bold)
        return label
    }()
    let postImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    let postTextView: UILabel = {
        let textView = UILabel()
        textView.font = .systemFont(ofSize: 15, weight: .regular)
        textView.isEnabled = false
        textView.lineBreakStrategy = .hangulWordPriority
        textView.numberOfLines = 0
        textView.textAlignment = .left
        return textView
    }()
    let likesLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    let viewsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .systemFont(ofSize: 15, weight: .regular)
        return label
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview()
        constraints()
        self.addGestureRecognizer(doubleTap)
        self.separatorInset.right = 15
        self.separatorInset.left = 15
    }
    func constraints(){
        
        self.viewsLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(5)
            make.right.equalToSuperview().inset(20)
            make.height.equalTo(15)
        }
        self.authorLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(5)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(25)
        }
        self.likesLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(5)
            make.height.equalTo(15)
        }

        self.postImageView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.top.equalTo(self.authorLabel.snp.bottom).inset(-5)
            make.right.equalToSuperview()
            make.height.equalTo(230)
        }
        self.postTextView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(self.postImageView.snp.bottom).inset(-5)
            make.right.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(25)
        }
    }
    func addSubview(){
        self.contentView.addSubview(viewsLabel)
        self.contentView.addSubview(authorLabel)
        self.contentView.addSubview(postImageView)
        self.contentView.addSubview(postTextView)
        self.contentView.addSubview(likesLabel)
    }
//    func setupCell(image: String) {
//        guard let filter = ColorFilter.allCases.randomElement() else {return}
//        guard let inputImage = UIImage(named: image) else {return}
//        imageProcessor.processImage(sourceImage: inputImage, filter: filter) { outputImage in
//            postImageView.image = outputImage
//        }
//    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        //print(#function)
    }
    @objc func processDoubleTap() {
        print(#function)

//        let post = Post(author: authorLabel.text!, descript: postTextView.text!, image: "panda", likes: 1, views: 1)
//        self.savePostInDatabase(post)
        //self.state = .isFavorite
        self.delegate?.wasLikedPost(authorLabel: authorLabel)
    }
}

extension PostTableViewCell {
        
    func savePostInDatabase(_ filterPost: Post) {
            //let filterPost: Post
            self.databaseCoordinator.create(PostCoreDataModel.self, keyedValues: [filterPost.keyedValues]) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let post):
                let userInfo = ["Post": filterPost]
                NotificationCenter.default.post(name: .wasLikedArticle, object: nil, userInfo: userInfo)
            case .failure(let error):
                print("🍋 \(error)")

            }
        }
    }
}
