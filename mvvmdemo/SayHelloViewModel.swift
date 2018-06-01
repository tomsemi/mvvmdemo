//
//  SayHelloViewModel.swift
//  mvvmdemo
//
//  Created by Ge on 30/03/2018.
//  Copyright © 2018 Ge. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ViewModelType {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }

}

protocol nameAndValidate {
    var name: AnyObserver<String> { get }
    var validate: AnyObserver<Void> { get }
}

protocol otherProtocol {
    var other: AnyObserver<String> { get }
}

class SayHelloViewModel: ViewModelType {
    let input: Input
    let output: Output
    
    struct Input:nameAndValidate {
        var name: AnyObserver<String>
        var validate: AnyObserver<Void>
    }
    
    struct Output {
        let greeting: Driver<String>
    }
    
    private let nameSubject = ReplaySubject<String>.create(bufferSize: 1)
    private let validateSubject = PublishSubject<Void>()
    
    init() {
        let greeting = validateSubject
            .withLatestFrom(nameSubject)
            .map { name in
                return "Hello \(name)!"
            }
            .asDriver(onErrorJustReturn: ":-(")
        
        self.output = Output(greeting: greeting)
        self.input = Input(name: nameSubject.asObserver(), validate: validateSubject.asObserver())
    }
}

class InheritViewModel: SayHelloViewModel {
    
    struct Input:nameAndValidate,otherProtocol {
        var other: AnyObserver<String>
        var name: AnyObserver<String>
        var validate: AnyObserver<Void>
    }

}
