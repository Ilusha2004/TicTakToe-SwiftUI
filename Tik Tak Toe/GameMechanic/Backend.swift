//
//  Backend.swift
//  Tik Tak Toe
//
//  Created by Илья Александрович on 01.01.24.
//

import Foundation

enum Player {
    case human, computer
}

struct Move {
    
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}
