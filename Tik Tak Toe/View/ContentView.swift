//
//  ContentView.swift
//  Tik Tak Toe
//
//  Created by Илья Александрович on 01.01.24.
//

import SwiftUI


struct ContentView: View {
    
    let collums: [GridItem] = [GridItem(.flexible()),
                              GridItem(.flexible()),
                              GridItem(.flexible())]

    @State private var moves: [Move?] = Array(repeating: nil, count: 9)
    @State private var isHumanTurn: Bool = true
    @State private var alertItem: AlertName? // Вызов объета структыры AlertContent, для корректного показать окна Alert
    @State private var isGameBoardDisabled: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack() {
                Spacer()
                LazyVGrid(columns: collums, spacing: 5) {
                    ForEach(0..<9) { i in
                        ZStack {
                            Circle()
                                .foregroundStyle(.blue).opacity(0.4)
                                .frame(width: geometry.size.width / 3 - 10,
                                       height: geometry.size.width / 3 - 10)
                            
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 50, height: 50)
                        }.onTapGesture {
                            if isItemOccupped(in: moves, forIndex: i) { return }
                            moves[i] = Move(player: .human, boardIndex: i)
                            isGameBoardDisabled = true
                            
                            if checkWinState(for: .human, in: moves) {
                                alertItem = AlertContent.humanAlert
                                return
                            }
                            
                            else if checkDraw(in: moves) {
                                alertItem = AlertContent.drawAlert
                                return
                            }
                            
                            // Отделение основного потока, пока компьютер делает ход (для корректной отрисовки символов, 
                            // если ИИ будет делать ход слишком долго)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerPosition = computerStep(in: moves)
                            
                                moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
                                isGameBoardDisabled = false
                                
                                if checkWinState(for: .computer, in: moves) {
                                    alertItem = AlertContent.computerAlert
                                    return
                                }
    
                            }
                            
                            isHumanTurn.toggle()
                            
                        }
                    }
                }
                Spacer()
            }
        }
        .disabled(isGameBoardDisabled) // блокирует нажатия на item, пока не наступит следующий ход
        .padding()
        .alert(item: $alertItem, content: { alertItem in
            Alert(title: alertItem.title,
                  message: alertItem.message,
                  dismissButton: .default(alertItem.buttonTitle, action: { resetGame() } ))
        })
    }
    
    // Проверка, что данное клетка занята
    func isItemOccupped(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: { $0?.boardIndex == index })
    }
    
    // Проверка на состояние победы игрока
    func checkWinState(for player: Player, in moves: [Move?]) -> Bool {
        let winStates : Set<Set<Int>> = [[0, 1, 2], [3, 4, 5], [6, 7, 8], [0, 3, 6], [1, 4, 7], [2, 5, 8], [0, 4, 8], [2, 4, 6]]
        
        // Запись всех ходов игрока
        let playerMoves = moves.compactMap { $0 }.filter { $0.player == player}
        let playerPositions = Set(playerMoves.map { $0.boardIndex } )
        
        // проверка на нахождения хотя бы одной победной комбинации
        for pattern in winStates where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    func computerStep(in moves: [Move?]) -> Int {
        
        var compPosition = Int.random(in: 0..<9)
        
        while isItemOccupped(in: moves, forIndex: compPosition) {
            compPosition = Int.random(in: 0..<9)
        }
        
        return compPosition
    }
    
    func checkDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap {$0}.count == 9
    }
    
    func resetGame() {
        moves = Array(repeating: nil, count: 9)
        isHumanTurn = true
        isGameBoardDisabled = false
    }
}

#Preview {
    ContentView()
}
