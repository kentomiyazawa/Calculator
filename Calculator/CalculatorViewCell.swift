//
//  CalculatorViewCell.swift
//  Calculator
//
//  Created by 宮沢建人 on 2020/06/26.
//  Copyright © 2020 miyazawa. All rights reserved.
//

import Foundation
import UIKit

class CalculatorViewCell: UICollectionViewCell {
    
    // ボタン押した時少しと色を薄くする
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                self.numberLabel.alpha = 0.3
            } else {
                self.numberLabel.alpha = 1
            }
        }
    }
    
    let numberLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.text = "1"
        label.font = .boldSystemFont(ofSize: 32)
        // labelからはみ出さないように設定
        label.clipsToBounds = true
        label.backgroundColor = .orange
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(numberLabel)
        
        // セルとテキストラベルの大きさを一緒にする
        numberLabel.frame.size = self.frame.size
        // 丸くする
        numberLabel.layer.cornerRadius = self.frame.height / 2
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
