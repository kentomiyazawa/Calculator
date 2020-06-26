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
        var width: CGFloat = 0
        // コレクションビューから隙間を引いてから4でわる
        width = ((collectionView.frame.width - 10) - 14 * 5) / 4
        // 0の高さは他の物の高さと一緒で良いのでhightに代入
        let height = width
        // ０の大きさを変えている。
        if indexPath.section == 4 && indexPath.row == 0 {
            width = width * 2 + 14 + 9
        }
        return .init(width: width, height: height)
    }
    
    // cell同士の横の隙間を設定
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }
    
    // セル一個一個の設定
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        //calculatorCollectionViewの中のcellにidentifierをcellIdとした
        let cell = calculatorCollectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! CalculatorViewCell
        // 一つ一つのセクションを選んだのち、その中を一つ一つ選ぶ
        cell.numberLabel.text = numbers[indexPath.section][indexPath.row]
        
        // ボタンの背景色を変更
        numbers[indexPath.section][indexPath.row].forEach{ (numberString) in
            // .descriptionで文字に変換
            if "0"..."9" ~= numberString || numberString.description == "." {
                cell.numberLabel.backgroundColor = .darkGray
            }else if numberString == "C" || numberString == "%" || numberString == "$" {
                cell.numberLabel.backgroundColor = UIColor.init(white: 1, alpha: 0.7)
                cell.numberLabel.textColor = .black
            }
        }
        
        
        return cell
    }
    
    // セルがタッチされた時に認識させるメソッド
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let number = numbers[indexPath.section][indexPath.row]
        
        
        // 足算をする時の条件分岐
        if calculateStatus == .none {
            switch number {
            // 数字を押した時
            case "0"..."9":
                numberLabel.text = number
            // プラスを押した時
            case "+":
                firstNumber = numberLabel.text ?? ""
                calculateStatus = .plus
            // クリアを押した時
            case "C":
                clear()
            default:
                break
            }
        }else if calculateStatus == .plus {
            switch number {
            // ２回目の数宇を押した時
            case "0"..."9":
                numberLabel.text = number
            // =を押した時
            case "=":
                secondNumber = numberLabel.text ?? ""
                
                // text型だtたので小数点付きの数字にする
                let firstNum = Double(firstNumber) ?? 0
                let secondNum = Double(secondNumber) ?? 0
                
                // 足してからString型にして、表示する
                numberLabel.text = String(firstNum + secondNum)
            // クリアを押した時
            case "C":
                clear()
            default:
                break
            }
        }
    }
    
    
    //　Cを押した時のメソッド
    func clear(){
        numberLabel.text = "0"
        calculateStatus = .none
    }
    
    // CalculateStatusと言う分類にnoneとplusがある
    enum CalculateStatus {
        case none, plus
    }
    
    var secondNumber = ""
    var firstNumber = ""
    // 上のenumを呼び出している。最初はnoneにしている
    var calculateStatus: CalculateStatus = .none
    
    // 配列の作成
    let numbers = [
        ["C", "%", "$", "÷" ],
        ["7", "8", "9", "×" ],
        ["4", "5", "6", "-" ],
        ["1", "2", "3", "+" ],
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
        
        // 両端にスペースを開ける
        calculatorCollectionView.contentInset = .init(top: 0, left: 14, bottom: 0, right: 14)
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

