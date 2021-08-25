//
//  MainTableViewCell.swift
//  listProductTest
//
//  Created by Кирилл Харьковский on 23.08.2021.
//

import UIKit
protocol  TapLikeDelegation: AnyObject {
    func tapLike(id: String)
}

class MainTableViewCell: UITableViewCell {
    //MARK: - Properties
    public var productListVM: ProductListViewModel?
    static let productListCellReuseIdentifier = "productListCellReuseIdentifier"
    static let favsProductListCellReuseIdentifier = "productListCellReuseIdentifier"
    public var delegate: TapLikeDelegation?
    
    public let proguctPicture: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 14
        iv.layer.masksToBounds = true
        iv.setHeight(UIScreen.main.bounds.height / 3)
        iv.contentMode = .scaleAspectFill
        iv.setWidth(UIScreen.main.bounds.width)
        
        return iv
    }()
    
    
    private var proguctTitle: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        var sizeTitle = 18.0
        label.font = .boldSystemFont(ofSize: CGFloat(sizeTitle))
        label.setWidth(UIScreen.main.bounds.width)
        label.numberOfLines = 2
        return label
    }()
    
    private var proguctShortDescription: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        var sizeTitle = 10.0
        label.font = .boldSystemFont(ofSize: CGFloat(sizeTitle))
        label.setWidth(UIScreen.main.bounds.width)
        label.numberOfLines = 0
        return label
    }()
    
    private var proguctLongDescription: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        var sizeTitle = 12.0
        label.font = .boldSystemFont(ofSize: CGFloat(sizeTitle))
        label.setWidth(UIScreen.main.bounds.width)
        label.numberOfLines = 0
        return label
    }()
    
    private var proguctPrice: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        var sizeTitle = 12.0
        label.font = .boldSystemFont(ofSize: CGFloat(sizeTitle))
        //        label.setWidth(20)
        label.numberOfLines = 0
        return label
    }()
    
    private var proguctRating: UILabel = {
        let label = UILabel()
        label.sizeToFit()
        var sizeTitle = 12.0
        label.font = .boldSystemFont(ofSize: CGFloat(sizeTitle))
        //        label.setWidth(20)
        label.numberOfLines = 0
        return label
    }()
    
    public lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "hand.thumbsup"), for: .normal)
        
//        if productListVM?.isSelect == true {
//            button.tintColor = .red
//        } else {
//            button.tintColor = .black
//        }
//
        return button
    }()
    
    //MARK: - Action
    // Like button Tap
    @objc func handleTapLike() {
        guard let productListVM = productListVM else {return}
        delegate?.tapLike(id: productListVM.id)
        if productListVM.isSelect == false {
            likeButton.tintColor = .red
        } else {
            likeButton.tintColor = .black
        }
    }
    
    
    //MARK: - Lifycicle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        likeButton.addTarget(self, action: #selector(handleTapLike), for: .touchUpInside)
    }
    //MARK: - Private Methods
    private func setupSubviews(){
        let hStack = UIStackView(arrangedSubviews: [proguctPrice, proguctRating, likeButton])
        hStack.axis = .horizontal
        
        hStack.distribution = .equalCentering
        hStack.spacing = 5
        
        let vStack = UIStackView(arrangedSubviews: [proguctPicture, proguctTitle, proguctShortDescription,proguctLongDescription, hStack])
        vStack.axis = .vertical
        vStack.spacing = 10
        
        addSubview(vStack)
        vStack.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10)
        
    }
    
    //MARK: - Public Methods
    public func configureUIWithProsuctListViewModel(productListVM: ProductListViewModel?){
        self.productListVM = productListVM
        
        self.proguctTitle.text = productListVM?.name
        self.proguctLongDescription.text = productListVM?.desc.htmlToString
        self.proguctPrice.text = "Цена: \( productListVM?.price ?? 0)"
        self.proguctRating.text = "Рейтинг:  \( productListVM?.weight ?? 0)"
        
    }
    public func clearCell() {
        proguctPicture.image = nil
        proguctShortDescription.text = ""
        proguctLongDescription.text = ""
        proguctPrice.text = ""
        proguctRating.text = ""
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}


