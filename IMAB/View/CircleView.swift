//
//  CircleView.swift
//  IMAB
//
//  Created by Vijay Rathore on 17/06/23.
//

import UIKit

@IBDesignable class CircleView : UIView {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height/2

    }
}
