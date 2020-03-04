//
//  ViewController.swift
//  RxSwiftProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 03/03/20.
//  Copyright © 2020 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

var screen = UIScreen.main.bounds.size

class ViewController: UIViewController {
    
    var rxSwitch = UISwitch()
    var one = 1
    var two = 2
    var three = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupSwitch()
     //   setupBehaviorSubject()
        setupVariableSubject()
     //   setupThreadSubject()
     //   setupReplaySubject()
    }
    
    func setupRX(){
        let observable = Observable.of(one, two, three)
        
        let subs = observable.subscribe { event in
            switch event {
            case .next(let value):
                print(value)
            case .error(let error):
                print(error)
            case .completed:
                print("completed")
            }
        }
        subs.disposed(by: DisposeBag())
    }
    
    func setupPublishSubject(){
        let disposeBag = DisposeBag()
        let publishSubject = PublishSubject<String>()
        publishSubject.onNext("Hello")
        publishSubject.onNext("World")
        
        publishSubject.subscribe(onNext:{
            print($0)
        }).disposed(by: disposeBag)
        
        publishSubject.onNext("Hello")
        publishSubject.onNext("Again")
        
        publishSubject.subscribe(onNext:{
            print(#line,$0)
        })
        publishSubject.onNext("Both Subscriptions receive this message")
    }
    
    func setupBehaviorSubject(){
       let disposeBag = DisposeBag()
        let subject = BehaviorSubject<String>(value: "Initial value")
        
        subject.onNext("nop")
        subject.onNext("nop")
        subject.onNext("yep")
        
        subject
          .subscribe(onNext: { text in
            print(text)
          })
          .addDisposableTo(disposeBag)
        
        subject.onNext("yep2")
        subject.onNext("yep3")
    }

    func setupReplaySubject(){
        let disposeBag = DisposeBag()
        let subject = ReplaySubject<String>.create(bufferSize: 10)
        subject.onNext("1")
        subject.onNext("2")
        subject.onNext("3")
        subject.onNext("4")
        
        subject
          .subscribe(onNext: { text in
            print(text)
          })
          .addDisposableTo(disposeBag)
        
        subject.onNext("Printed end!")
    }
    
    func setupVariableSubject(){
        let disposeBag = DisposeBag()
        let variable = Variable("Current String")
        
        /// Getting the value
        print(variable.value)
        
        /// Setting the value
        variable.value = "Second String"
        
        /// Observing the value
        variable.asObservable()
          .subscribe(onNext: { text in
            print(text)
          })
          .addDisposableTo(disposeBag)
        
        variable.value = "Third String"
    }
    
    func setupThreadSubject(){
        let publish1 = PublishSubject<Int>()
        let publish2 = PublishSubject<Int>()
        let concurrentScheduler = ConcurrentDispatchQueueScheduler(qos: .background)
        
        Observable.of(publish1,publish2)
            .observeOn(concurrentScheduler)
            .merge()
            .subscribeOn(MainScheduler())
            .subscribe({ event in
                switch event {
                case .next(let value):
                    print(value)
                case .error(let error):
                    print(error)
                case .completed:
                    print("completed")
                }
            })
        
        publish1.onNext(20)
        publish1.onNext(40)
        publish2.onNext(10)
        publish2.onNext(20)
        
    }
    
    
    func setupSwitch(){
        self.view.addSubview(rxSwitch)
        rxSwitch.layer.position = CGPoint(x: screen.width/2, y: screen.height/2)
        rxSwitch.rx.isOn
            .subscribe(onNext: {(enabled) in
                print(enabled ? "Its ON" : "Its OFF")
            })
    }
    
    
    
}

