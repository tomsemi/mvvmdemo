//
//  SecondViewController.swift
//  mvvmdemo
//
//  Created by Ge on 30/03/2018.
//  Copyright © 2018 Ge. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

/// Every view interacting with a `SayHelloViewModel` instance can conform to this.
protocol SayHelloViewModelBindable {
    var disposeBag: DisposeBag? { get }
    func bind(to viewModel: SayHelloViewModel)
}

/// TableViewCells
final class TextFieldCell: UITableViewCell, SayHelloViewModelBindable {
    @IBOutlet weak var nameTextField: UITextField!
    var disposeBag: DisposeBag?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // Clean Rx subscriptions
        disposeBag = nil
    }
    
    func bind(to viewModel: SayHelloViewModel) {
        let bag = DisposeBag()
        nameTextField.rx
            .text
            .orEmpty
            .bind(to: viewModel.input.name)
            .disposed(by: bag)
        disposeBag = bag
    }
}

final class ButtonCell: UITableViewCell, SayHelloViewModelBindable {
    @IBOutlet weak var validateButton: UIButton!
    var disposeBag: DisposeBag?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = nil
    }
    
    func bind(to viewModel: SayHelloViewModel) {
        let bag = DisposeBag()
        validateButton.rx
            .tap
            .bind(to: viewModel.input.validate)
            .disposed(by: bag)
        disposeBag = bag
    }
}

final class GreetingCell: UITableViewCell, SayHelloViewModelBindable {
    @IBOutlet weak var greetingLabel: UILabel!
    var disposeBag: DisposeBag?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = nil
    }
    
    func bind(to viewModel: SayHelloViewModel) {
        let bag = DisposeBag()
        viewModel.output.greeting
            .drive(greetingLabel.rx.text)
            .disposed(by: bag)
        disposeBag = bag
    }
}

/// View
class SecondViewController: UIViewController, UITableViewDataSource {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    static let cellIdentifiers = [
        "TextFieldCell",
        "ButtonCell",
        "GreetingCell"
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    private let viewModel = SayHelloViewModel()
    private let bag = DisposeBag()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SecondViewController.cellIdentifiers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SecondViewController.cellIdentifiers[indexPath.row])
        (cell as? SayHelloViewModelBindable)?.bind(to: viewModel)
        return cell!
    }
}
