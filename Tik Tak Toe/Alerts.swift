//
//  Alerts.swift
//  Tik Tak Toe
//
//  Created by Илья Александрович on 01.01.24.
//

import Foundation
import SwiftUI

struct AlertName : Identifiable {
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContent {
    static let humanAlert = AlertName(title: Text("Win"),
                               message: Text(""),
                               buttonTitle: Text("OK"))
    
    static let computerAlert = AlertName(title: Text("Lose"),
                               message: Text(""),
                               buttonTitle: Text("OK"))
    
    static let drawAlert = AlertName(title: Text("Draw"),
                               message: Text(""),
                               buttonTitle: Text("OK"))
}
