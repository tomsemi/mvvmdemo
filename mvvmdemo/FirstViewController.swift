//
//  FirstViewController.swift
//  mvvmdemo
//
//  Created by Ge on 30/03/2018.
//  Copyright © 2018 Ge. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class FirstViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var triggerButton: UIButton!
    @IBOutlet weak var greetingLabel: UILabel!
    
    private let viewModel = SayHelloViewModel()
    private let bag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
    
        nameTextField.rx
            .text
            .orEmpty
            .bind(to: viewModel.input.name)
            .disposed(by: bag)
        
        triggerButton.rx
            .tap
            .bind(to: viewModel.input.validate)
            .disposed(by: bag)

        viewModel.output.greeting
            .drive(greetingLabel.rx.text)
            .disposed(by: bag)
    }


}




