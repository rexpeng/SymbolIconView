//
//  ViewController.swift
//  animationview
//
//  Created by Rex Peng on 2019/11/1.
//  Copyright © 2019 Rex Peng. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initView()
    }

    private func initView() {
        let circleView = SymbolIconView(frame: CGRect(x: 10, y: 50, width: 100, height: 100), symbolType: .error)
        view.addSubview(circleView)
        circleView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewClick)))
        let question = SymbolIconView(frame: CGRect(x: 10, y: 200, width: 100, height: 100), symbolType: .question)
        view.addSubview(question)
        question.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewClick)))
        let exclamation = SymbolIconView(frame: CGRect(x: 160, y: 50, width: 100, height: 100), symbolType: .exclamation, lineWidth: 8)
        view.addSubview(exclamation)
        exclamation.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewClick)))
        let check = SymbolIconView(frame: CGRect(x: 160, y: 200, width: 100, height: 100), symbolType: .checkmark)
        view.addSubview(check)
        check.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(viewClick)))
    }

    @objc func viewClick(_ sender: UITapGestureRecognizer) {
        if let view = sender.view as? SymbolIconView {
            view.reDraw()
        }
    }
}

