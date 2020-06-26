//
//  ViewController.swift
//  Calculator
//
//  Created by 宮沢建人 on 2020/06/26.
//  Copyright © 2020 miyazawa. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    // CalculateStatusと言う分類がある
    enum CalculateStatus {
        case none, plus, minus, multiplication, division
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
        
        numberLabel.text = "0"
        view.backgroundColor = .black
    }
    
    //　Cを押した時のメソッド
    func clear(){
        firstNumber = ""
        secondNumber = ""
        numberLabel.text = "0"
        calculateStatus = .none
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
        switch calculateStatus {
        case .none:
            switch number {
            // 数字を押した時
            case "0"..."9":
                // 押した数字をfirstNumberに入れている。+=にしているのは2桁以上の場合
                firstNumber += number
                numberLabel.text = firstNumber
                
                // 最初の数が0だった、0を表示させない
                if firstNumber.hasPrefix("0") {
                    firstNumber = ""
                }
                // .を押した時。
            case ".":
                if !confirmIncludeDecimalPoint(numberString: firstNumber) {
                    firstNumber += number
                    numberLabel.text = firstNumber
                }
            // プラスを押した時
            case "+":
                
                calculateStatus = .plus
            case "-":
                calculateStatus = .minus
            case "×":
                calculateStatus = .multiplication
            case "÷":
                calculateStatus = .division
            // クリアを押した時
            case "C":
                clear()
            default:
                break
            }
            
        case .plus, .minus, .multiplication, .division:
            switch number {
            // ２回目の数宇を押した時
            case "0"..."9":
                secondNumber += number
                numberLabel.text = secondNumber
                // 最初の数が0だった、0を表示させない
                if secondNumber.hasPrefix("0") {
                    secondNumber = ""
                }
            case ".":
                if !confirmIncludeDecimalPoint(numberString: secondNumber) {
                    secondNumber += number
                    numberLabel.text = secondNumber
                }
            // =を押した時
            case "=":
                // text型だtたので小数点付きの数字にする
                let firstNum = Double(firstNumber) ?? 0
                let secondNum = Double(secondNumber) ?? 0
                
                var resultString: String?
                switch calculateStatus {
                case .plus:
                    // 足算してからString型にして、表示する
                    resultString = String(firstNum + secondNum)
                case .minus:
                    // 引き算してからString型にして、表示する
                    resultString = String(firstNum - secondNum)
                case .multiplication:
                    // 掛け算してからString型にして、表示する
                    resultString = String(firstNum * secondNum)
                case .division:
                    // 割り算してからString型にして、表示する
                   resultString = String(firstNum / secondNum)
                default:
                    break
                }
                
                // 計算結果に.０が入っていたら表示させない
                if  let  result = resultString, result.hasSuffix(".0") {
                    resultString = result.replacingOccurrences(of: ".0", with: "")
                }
                
                numberLabel.text = resultString
                // 計算結果に改めて計算する場合
                firstNumber = ""
                secondNumber = ""
                firstNumber += resultString ?? ""
                calculateStatus = .none
                
            // クリアを押した時
            case "C":
                clear()
            default:
                break
            }
        }
    }
    
    // .を押した時のメソッド
    private func confirmIncludeDecimalPoint(numberString: String) -> Bool {
        // 0か.が入っていたら返す
        if numberString.range(of: ".") != nil || numberString.count == 0 {
            return true
        } else {
            return false
        }
    }
}

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

