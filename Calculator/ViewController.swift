//
//  ViewController.swift
//  Calculator
//
//  Created by 宮沢建人 on 2020/06/26.
//  Copyright © 2020 miyazawa. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // セクションの数
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return numbers.count
    }
    
    // セクションの中の数
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return numbers[section].count
    }
    
    // cell同士の高さの隙間を設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: collectionView.frame.width, height: 10)
    }
           
    // セルの大きさを設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // コレクションビューから隙間を引いてから4でわる
        let width = (collectionView.frame.width - 3 * 10) / 4
        return .init(width: width, height: width)
    }
    
    // cell同士の横の隙間を設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    // セル一個一個の設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //calculatorCollectionViewの中のcellにidentifierをcellIdとした
        let cell = calculatorCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CalculatorViewCell
        // 一つ一つのセクションを選んだのち、その中を一つ一つ選ぶ
        cell.numberLabel.text = numbers[indexPath.section][indexPath.row]
        return cell
    }
    
    // 配列の作成
    let numbers = [
        ["C", "%", "$", "+" ],
        ["7", "8", "9", "×" ],
        ["4", "5", "6", "-" ],
        ["1", "2", "3", "＋" ],
        ["0", ".", "=", ],
    ]
    

    @IBOutlet weak var calculatorHeightConstrain: NSLayoutConstraint!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var calculatorCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calculatorCollectionView.delegate = self
        calculatorCollectionView.dataSource = self
        calculatorCollectionView.register(CalculatorViewCell.self, forCellWithReuseIdentifier: "cellId")
        // セルの大元の大きさを設定
        calculatorHeightConstrain.constant = view.frame.width * 1.4
        calculatorCollectionView.backgroundColor = .clear
        view.backgroundColor = .black
    }
}

class CalculatorViewCell: UICollectionViewCell {
    
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

