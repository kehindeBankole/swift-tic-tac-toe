//
//  ContentView.swift
//  tic-tac-toe
//
//  Created by kehinde on 21/01/2024.
//

import SwiftUI

enum Player : String {
    case O = "O"
    case X = "X"
}
struct ContentView: View {
    @State var row:[[String]] = [["1","2","3"] , ["4","5","6"] , ["7","8","9"]]
    @State var currentPlayer:Player = Player(rawValue: "O")!
    @State var playerWin = false
    @State var winner:String? = nil
    
    func horizontalScore(arr:[[String]])  {
        for val in arr {
            if(val.allSatisfy{$0 == val.first}){                winner = val[0]
                playerWin = true
                row = [["1","2","3"] , ["4","5","6"] , ["7","8","9"]]
            }
            
        }
    }
    
    func verticalScore(){
        
        var newRow:[String] = []
        var y = 0
        repeat{
            for x in 0..<row.count {
                newRow.append(row[x][y])
            }
            y += 1
        }while(y < 3)
        
        let groupedArray = stride(from: 0, to: newRow.count, by: 3).map { startIndex in
            
            Array(newRow[startIndex..<min(startIndex + 3, newRow.count)])
        }
        horizontalScore(arr: groupedArray)
        
    }
    
    func diagonalScore(matrix: [[String]]) {
        var diagonalElements: [String] = []
        var reverseDiagonalElements: [String] = []
        
        for i in 0..<matrix.count {
            print(matrix[i][i] , i)
            if i < matrix[i].count {
                diagonalElements.append(matrix[i][i])
            }
        }
        
        for i in 0..<matrix.count {
              let columnIndex = matrix[i].count - 1 - i
              if columnIndex >= 0 {
                  reverseDiagonalElements.append(matrix[i][columnIndex])
              }
          }

        
        if(diagonalElements.allSatisfy{$0 == diagonalElements.first}){
            playerWin = true
            winner = diagonalElements[0]
            row = [["1","2","3"] , ["4","5","6"] , ["7","8","9"]]
        }
        if(reverseDiagonalElements.allSatisfy{$0 == reverseDiagonalElements.first}){
            playerWin = true
            winner = reverseDiagonalElements[0]
            row = [["1","2","3"] , ["4","5","6"] , ["7","8","9"]]
        }
    }
    

    
    var body: some View {
        VStack {
            ForEach(Array(row.enumerated()) , id:\.element){rowIndex , rowItem in
                HStack{
                    
                    ForEach(Array(rowItem.enumerated()) , id:\.element){colIndex , col in
                        Button(action: {
                            
                            if(row[rowIndex][colIndex]=="X" || row[rowIndex][colIndex]=="O"){
                                return
                            }else{
                                row[rowIndex][colIndex]=currentPlayer.rawValue
                            }
                            if(currentPlayer == .O){
                                currentPlayer = .X
                            }else{
                                currentPlayer = .O
                            }
                            horizontalScore(arr: row)
                            verticalScore()
                            diagonalScore(matrix: row)
                        }){
                            Text(col).foregroundStyle(.white).opacity((col != "O" && col != "X") ? 0 : 1)     .background(Rectangle().fill(.black).cornerRadius(15).frame(width: 70, height: 70)).padding()               }
                        
                    }.padding()
                }
            }
        }.sheet(isPresented: $playerWin, content: {
            Text("player \(winner!) wins").presentationDetents([.medium , .large ]).presentationDragIndicator(.visible)
        })
    }
}

#Preview {
    ContentView()
}
