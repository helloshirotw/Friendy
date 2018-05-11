//
//  PageCell.swift
//  Auto Layout Programmatically
//
//  Created by SnoopyKing on 2017/11/12.
//  Copyright © 2017年 SnoopyKing. All rights reserved.
//

import UIKit
//View
class PageCell : UICollectionViewCell{
    
    var page : Page? {
        didSet{
            guard let unwrappedPage = page else {return}
            bearImageView.image = UIImage(named: unwrappedPage.imgName)

            headerLabel.text = unwrappedPage.headerText
            bodyLabel.text = unwrappedPage.bodyText
        }
    }
    
    let bearImageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "KarenAndGary1"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    let headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        label.font = UIFont(name: "Futura", size: 25)
        return label
    }()
    
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.text = ""
        label.font = UIFont(name: "Futura", size: 20)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [headerLabel, bodyLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 8
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupLayout()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var topViewContainerView: UIView!
    
    private func setupLayout(){
        topViewContainerView = UIView()
        addSubview(topViewContainerView)
        topViewContainerView.translatesAutoresizingMaskIntoConstraints = false
        topViewContainerView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        topViewContainerView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        topViewContainerView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        topViewContainerView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        //覆蓋塗層
        topViewContainerView.addSubview(bearImageView)
        
        bearImageView.centerXAnchor.constraint(equalTo: topViewContainerView.centerXAnchor).isActive = true
        bearImageView.centerYAnchor.constraint(equalTo: topViewContainerView.centerYAnchor).isActive = true

        bearImageView.heightAnchor.constraint(equalTo: topViewContainerView.heightAnchor, multiplier: 0.5).isActive = true
        
        
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topViewContainerView.bottomAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 48).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor,  constant: -48).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -150).isActive = true
    }
}
