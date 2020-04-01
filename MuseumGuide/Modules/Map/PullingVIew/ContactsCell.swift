//
//  ContactsCell.swift
//  MuseumGuide
//
//  Created by Alex on 28.03.2020.
//  Copyright © 2020 Alex. All rights reserved.
//
import UIKit

class ContactsCell: UITableViewCell {
    
    struct Layout {
        static let inset: CGFloat = 18
        static let shapeSize: CGFloat = 24
        static let estimatedHeight: CGFloat = 40
    }
    
    struct Info {
        var address: String
        var phone: String
    }
    
    private let titleLabel = UILabel()
    private let addressButton = UIButton()
    private let addressLabel = UILabel()
    
    private let phoneButton = UIButton()
    private let phoneLabel = UITextView()
    
    private var info: Info?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(with info: Info) {
        self.info = info
        titleLabel.text = "Контакты"
        addressLabel.text = info.address
        phoneLabel.text = info.phone.applyPatternOnNumbers(pattern: "+# (###) ###-####", replacmentCharacter: "#")
    }
    
    private func setupViews() {
        backgroundColor = .white
        
        addSubview(titleLabel)
        titleLabel.font = .boldSystemFont(ofSize: UIFont.labelFontSize)
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .black
        
        addSubview(addressButton)
        addressButton.setImage(UIImage(named: "pin_icon"), for: .normal)
        addressButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        
        addSubview(addressLabel)
        addressLabel.font = .systemFont(ofSize: UIFont.systemFontSize)
        addressLabel.numberOfLines = 0
        addressLabel.textColor = .darkGray
        //
        addSubview(phoneButton)
        phoneButton.setImage(UIImage(named: "phone_icon"), for: .normal)
        phoneButton.addTarget(self, action: #selector(handleButton), for: .touchUpInside)
        
        addSubview(phoneLabel)
        phoneLabel.font = .systemFont(ofSize: UIFont.systemFontSize)
        phoneLabel.dataDetectorTypes = .phoneNumber
        phoneLabel.textContainerInset = .zero
        phoneLabel.isEditable = false
        phoneLabel.isScrollEnabled = false
        phoneLabel.textColor = .darkGray
        phoneLabel.tintColor = .darkGray
        
        setupLayout()
    }
    
    private func setupLayout() {
        let inset = Layout.inset
        let buttonSize = Layout.shapeSize
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: inset).isActive = true
        titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset).isActive = true
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: inset).isActive = true
        
        addressButton.translatesAutoresizingMaskIntoConstraints = false
        addressButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        addressButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        //        button.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        addressButton.centerYAnchor.constraint(equalTo: addressLabel.centerYAnchor).isActive = true
        addressButton.leftAnchor.constraint(equalTo: leftAnchor, constant: inset + inset/2).isActive = true
        
        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.leftAnchor.constraint(equalTo: addressButton.rightAnchor, constant: inset).isActive = true
        addressLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset).isActive = true
        //addressLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset).isActive = true
        addressLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        
        phoneButton.translatesAutoresizingMaskIntoConstraints = false
        phoneButton.widthAnchor.constraint(equalToConstant: buttonSize).isActive = true
        phoneButton.heightAnchor.constraint(equalToConstant: buttonSize).isActive = true
        phoneButton.topAnchor.constraint(equalTo: addressButton.bottomAnchor, constant: 8).isActive = true
        //phoneButton.centerYAnchor.constraint(equalTo: phoneLabel.centerYAnchor).isActive = true
        phoneButton.leftAnchor.constraint(equalTo: leftAnchor, constant: inset + inset/2).isActive = true
        
        phoneLabel.translatesAutoresizingMaskIntoConstraints = false
        phoneLabel.leftAnchor.constraint(equalTo: phoneButton.rightAnchor, constant: inset).isActive = true
        phoneLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -inset).isActive = true
        phoneLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -inset).isActive = true
        phoneLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 8).isActive = true
    }
    
    @objc private func handleButton(sender: UIButton) {
        sender.bounce()
    }
}

extension ContactsCell {
    
    static func makeDefaultInfos() -> [CellModel] {
        return [
            CellModel.contacts(ContactsCell.Info(address: "Александровский парк, 7 м. Горьковская, Санкт-Петербург", phone: "89992318807"))
        ]
    }
}

