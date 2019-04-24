//
//  WeekView.swift
//  Calendar
//
//  Created by WY NG on 18/4/2019.
//  Copyright © 2019 lumanmann. All rights reserved.
//

import UIKit

class WeekView: UIView {
    
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    var weekArray = ["Su", "Mo", "Tu", "We", "Th", "Fr", "Sa"]

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor=UIColor.clear
        
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    
    func setupViews() {
        addSubview(stackView)
        stackView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        for i in 0..<7 {
            let lable = UILabel()
            lable.text = weekArray[i]
            lable.textAlignment = .center
            
            stackView.addArrangedSubview(lable)
        }
    }
   
}
