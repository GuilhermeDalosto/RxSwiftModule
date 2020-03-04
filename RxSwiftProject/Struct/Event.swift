//
//  Event.swift
//  RxSwiftProject
//
//  Created by Guilherme Martins Dalosto de Oliveira on 03/03/20.
//  Copyright © 2020 Guilherme Martins Dalosto de Oliveira. All rights reserved.
//

public enum Event<Element>{
    case next(Element)
    case error(Swift.Error)
    case completed
}
