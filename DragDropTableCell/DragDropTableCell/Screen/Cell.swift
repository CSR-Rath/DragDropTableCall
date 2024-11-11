//
//  Cell.swift
//  DragDropTableCell
//
//  Created by Rath! on 11/11/24.
//

import UIKit

class Cell: UITableViewCell {
    
    lazy var lblName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "_"
        lbl.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        return lbl
    }()
    
    lazy var bgView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .gray
        view.layer.cornerRadius = 10
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        contentView.backgroundColor = .clear
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

   private func setupUI(){
       addSubview(bgView)
       addSubview(lblName)
       
        NSLayoutConstraint.activate([
        
            bgView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            bgView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            bgView.widthAnchor.constraint(equalTo: widthAnchor , multiplier: 0.9),
            bgView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            lblName.centerXAnchor.constraint(equalTo: centerXAnchor),
            lblName.centerYAnchor.constraint(equalTo: centerYAnchor),

        ])

    }
    


}
