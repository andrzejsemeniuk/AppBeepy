//
//  ViewModel.swift
//  AppBeepy
//
//  Created by andrzej semeniuk on 10/3/17.
//  Copyright © 2017 Andrzej Semeniuk. All rights reserved.
//

import Foundation
import ASToolkit

struct ViewModelData {
    var sections    : [ViewModelSection] = []
}

struct ViewModelSection {
    let title       : String
    var rows        : [ViewModelRow] = []
}

struct ViewModelRow {
    let title       : String
    let value       : String
    let changed     : Bool
    
    init(title:String, value:String, changed:Bool = false) {
        self.title = title
        self.value = value
        self.changed = changed
    }
}

protocol ViewModel {
    
    var update              : BindingValue<Bool> { get }
    
    var data                : ViewModelData { get }
    
}


