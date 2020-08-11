//
//  ViewController.swift
//  CalculatorClone
//
//  Created by David on 8/10/20.
//  Copyright © 2020 David. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let holder: UIView = {
        let holder = UIView()
        holder.clipsToBounds = true
        return holder
    }()
    
    var firstNumber = 0
    var resultNumber = 0
    var currentOperations: Operation?
    
    enum Operation {
        case add, subtract, multiply, divide
    }
    
    private var resultLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 85, weight: .light)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(holder)
        view.backgroundColor = .black
        holder.backgroundColor = .black
        holder.translatesAutoresizingMaskIntoConstraints = false
        holder.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        holder.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30).isActive = true
        holder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 7).isActive = true
        holder.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -7).isActive = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupNumberPad()
    }
    
    private func setupNumberPad() {
        
        let buttonSize: CGFloat = holder.frame.size.width / 4
        let borderPadding = buttonSize*0.077
        let borderColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        let numberColor = UIColor(red: 58/255, green: 58/255, blue: 60/255, alpha: 1)
        let operatorColor = UIColor(red: 255/255, green: 165/255, blue: 0/255, alpha: 1)
        let fontSize: CGFloat = 34
        
        let zeroButton = UIButton(frame: CGRect(x: 0, y: holder.frame.size.height-buttonSize, width: buttonSize*3, height: buttonSize))
        zeroButton.setTitleColor(.white, for: .normal)
        zeroButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        zeroButton.backgroundColor = numberColor
        zeroButton.setTitle("0", for: .normal)
        zeroButton.tag = 1
        zeroButton.layer.cornerRadius = buttonSize/2
        zeroButton.layer.borderWidth = borderPadding
        zeroButton.layer.borderColor = borderColor
        holder.addSubview(zeroButton)
        
        zeroButton.addTarget(self, action: #selector(zeroTapped), for: .touchUpInside)
        
        for x in 0..<3 {
            let button1 = UIButton(frame: CGRect(x: buttonSize * CGFloat(x), y: holder.frame.size.height-(buttonSize*2), width: buttonSize, height: buttonSize))
            button1.setTitleColor(.white, for: .normal)
            button1.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
            button1.backgroundColor = numberColor
            button1.setTitle("\(x+1)", for: .normal)
            holder.addSubview(button1)
            button1.tag = x+2
            button1.layer.cornerRadius = buttonSize/2
            button1.layer.borderWidth = borderPadding
            button1.layer.borderColor = borderColor
            button1.addTarget(self, action: #selector(numberPressed(_:)), for: .touchUpInside)
        }
        
        for x in 0..<3 {
            let button2 = UIButton(frame: CGRect(x: buttonSize * CGFloat(x), y: holder.frame.size.height-(buttonSize*3), width: buttonSize, height: buttonSize))
            button2.setTitleColor(.white, for: .normal)
            button2.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
            button2.backgroundColor = numberColor
            button2.setTitle("\(x+4)", for: .normal)
            holder.addSubview(button2)
            button2.tag = x+5
            button2.layer.cornerRadius = buttonSize/2
            button2.layer.borderWidth = borderPadding
            button2.layer.borderColor = borderColor
            button2.addTarget(self, action: #selector(numberPressed(_:)), for: .touchUpInside)
        }
        
        for x in 0..<3 {
            let button3 = UIButton(frame: CGRect(x: buttonSize * CGFloat(x), y: holder.frame.size.height-(buttonSize*4), width: buttonSize, height: buttonSize))
            button3.setTitleColor(.white, for: .normal)
            button3.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
            button3.backgroundColor = numberColor
            button3.setTitle("\(x+7)", for: .normal)
            holder.addSubview(button3)
            button3.tag = x+8
            button3.layer.cornerRadius = buttonSize/2
            button3.layer.borderWidth = borderPadding
            button3.layer.borderColor = borderColor
            button3.addTarget(self, action: #selector(numberPressed(_:)), for: .touchUpInside)
        }
        
        let clearButton = UIButton(frame: CGRect(x: 0, y: holder.frame.size.height-(buttonSize*5), width: holder.frame.size.width - buttonSize, height: buttonSize))
        clearButton.setTitleColor(.black, for: .normal)
        clearButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        clearButton.backgroundColor = .systemGray2
        clearButton.setTitle("Clear", for: .normal)
        clearButton.layer.cornerRadius = buttonSize/2
        clearButton.layer.borderWidth = borderPadding
        clearButton.layer.borderColor = borderColor
        holder.addSubview(clearButton)
        
        
        let operations = ["=","+", "-", "x", "/"]
        
        for x in 0..<5 {
            let button4 = UIButton(frame: CGRect(x: buttonSize * 3, y: holder.frame.size.height-(buttonSize * CGFloat(x+1)), width: buttonSize, height: buttonSize))
            button4.setTitleColor(.white, for: .normal)
            button4.titleLabel?.font = UIFont.boldSystemFont(ofSize: 42)
            button4.backgroundColor = operatorColor
            button4.setTitle(operations[x], for: .normal)
            holder.addSubview(button4)
            button4.tag = x+1
            button4.layer.cornerRadius = buttonSize/2
            button4.layer.borderWidth = borderPadding
            button4.layer.borderColor = borderColor
            button4.addTarget(self, action: #selector(operationPressed(_:)), for: .touchUpInside)
        }
        
        resultLabel.frame = CGRect(x: 15, y: clearButton.frame.origin.y - 110.0, width: holder.frame.size.width - 40, height: 100)
        holder.addSubview(resultLabel)
        resultLabel.backgroundColor = .black
        
        clearButton.addTarget(self, action: #selector(clearResult), for: .touchUpInside)
    }
    
    @objc func clearResult() {
        resultLabel.text = "0"
        currentOperations = nil
        firstNumber = 0
    }
    
    @objc func zeroTapped() {
        
        if resultLabel.text != "0" {
            if let text = resultLabel.text {
                resultLabel.text = "\(text)\(0)"
            }
        }
    }
    
    @objc func numberPressed(_ sender: UIButton) {
        let tag = sender.tag - 1
        
        if resultLabel.text == "0" {
            resultLabel.text = "\(tag)"
        }
        else if let text = resultLabel.text {
            resultLabel.text = "\(text)\(tag)"
        }
    }
    
    @objc func operationPressed(_ sender: UIButton) {
        let tag = sender.tag
        
        if let text = resultLabel.text, let value = Int(text), firstNumber == 0 {
            firstNumber = value
            resultLabel.text = "0"
        }
        
        if tag == 1 {
            if let operation = currentOperations {
                var secondNumber = 0
                if let text = resultLabel.text, let value = Int(text) {
                    secondNumber = value
                }
                
                switch operation {
                case .add:
                    
                    let result = firstNumber + secondNumber
                    resultLabel.text = "\(result)"
                    break
                    
                case .subtract:
                    let result = firstNumber - secondNumber
                    resultLabel.text = "\(result)"
                    break
                    
                case .multiply:
                    let result = firstNumber * secondNumber
                    resultLabel.text = "\(result)"
                    break
                    
                case .divide:
                    let result = firstNumber / secondNumber
                    resultLabel.text = "\(result)"
                    break
                }
            }
        }
        else if tag == 2 {
            currentOperations = .add
        }
        else if tag == 3 {
            currentOperations = .subtract
        }
        else if tag == 4 {
            currentOperations = .multiply
        }
        else if tag == 5 {
            currentOperations = .divide
        }
    }
}

