// NOTE: A model should not import UIKit!

import Foundation

typealias Point = (x: Int, y: Int)

enum CellState {
    case Born
    case Alive
    case Died
    case Empty
}

/** Part of C) of UIBible: notification system **/
struct ModelMsgs {
    /* @@HP: use implicit var name and sign the string message that only for debugging. 
            so that we can reuse that and only change the string message HERE for displaying */
    static let notificationName = "CellGridModel"
    static let notificationEventKey = "CG Model Message Key"
    static let modelChangeDidSucceed = "CG Model Change Succeeded"
    static let modelChangeDidFail = "CG Model Change Failed"
}

protocol CellGridDataSource: class /* adopters must be class (reference type) */ {
    // encapsulates the idea of a dictionary of named parameters, each of which is floating-point
//    subscript(index: String) -> Double? { get set }
    func notifyObservers(#success: Bool)
    func getSize() -> Int
    func getState(p: Point) -> CellState
    func nextGeneration()
    func getGeneration() -> Int
}

class CellGridModel: CellGridDataSource{
    var grid: [[CellState]]
    var generation: Int
    
    func getGeneration() -> Int {
        return generation
    }

    // This is a failable initializer. That is, invalid values will cause the constructor invocation to return nil.
    init?(size: Int) {
        generation = 0
        if size < 1 || size > 10000 {
            grid = [[CellState]]()
            return nil
        }
        grid = [[CellState]](count: size, repeatedValue: [CellState](count: size, repeatedValue: .Empty))
        makeGlider()
        grid[12][12] = .Born
        grid[15][13] = .Died
    }
    
    private func makeGlider() {
        grid[5][5] = .Alive
        grid[6][6] = .Alive
        grid[4][7] = .Alive
        grid[5][7] = .Alive
        grid[6][7] = .Alive
    }
    
    private func countNeighbors(p: Point) -> Int {
        var count = 0
        
        if p.y > 0 && (grid[p.x][p.y - 1] == CellState.Alive || grid[p.x][p.y - 1] == CellState.Born) {
            count++
        }
        if p.y < grid.count - 1 && (grid[p.x][p.y + 1] == .Alive || grid[p.x][p.y + 1] == .Born) {
            count++
        }
        
        if p.x > 0 && (grid[p.x - 1][p.y] == .Alive || grid[p.x - 1][p.y] == .Born) {
            count++
        }
        
        if p.x < grid.count - 1 && (grid[p.x + 1][p.y] == .Alive || grid[p.x + 1][p.y] == .Born) {
            count++
        }
        
        
        if p.y > 0 && p.x > 0 && (grid[p.x - 1][p.y - 1] == .Alive || grid[p.x - 1][p.y - 1] == .Born) {
            count++
        }
        
        if p.y > 0 && p.x < grid.count - 1 && (grid[p.x + 1][p.y - 1] == .Alive || grid[p.x + 1][p.y - 1] == .Born) {
            count++
        }
        
        if p.y < grid.count - 1 && p.x > 0 && (grid[p.x - 1][p.y + 1] == .Alive || grid[p.x - 1][p.y + 1] == .Born) {
            count++
        }
        
        if p.y < grid.count - 1 && p.x < grid.count - 1 && (grid[p.x + 1][p.y + 1] == .Alive || grid[p.x + 1][p.y + 1] == .Born) {
            count++
        }
        
        return count
    }
    
    private func newState(p: Point) -> CellState {
        let count = countNeighbors(p)
        let oldState = grid[p.x][p.y]
        
        switch oldState {
        case .Born: fallthrough
        case .Alive:
            if (count == 2) || (count == 3) {
                return .Alive
            }
            else {
                return .Died
            }
        case .Died: fallthrough
        case .Empty:
            if count == 3 {
                return .Born
            }
            else {
                return .Empty
            }
        }
    }
    
    // MARK: Public interface
    var size: Int {
        return grid.count
    }
    
    func getSize() -> Int {
        return size
    }
    
    func nextGeneration() {
        // We need a brand new grid because modifying the grid in-place will corrupt the clean snapshot of previous state
        var newGrid = [[CellState]](count: grid.count, repeatedValue: [CellState](count: grid.count, repeatedValue: .Empty))
        for col in 0..<grid.count {
            for row in 0..<grid.count {
                newGrid[col][row] = newState((col, row))
            }
        }
        // What happens here to the old two-dim array?
        grid = newGrid
        generation++
        
        /* @@HP: After "set" a new grid, send notification to the center that the model is new and need to display a new view */
        notifyObservers(success: true)
    }
    
    func getState(p: Point) -> CellState {
        return grid[p.x][p.y]
    }
    
    /** Part of "C)" of UIBible: notification system **/
    func notifyObservers(#success: Bool) {
        let message = success ? ModelMsgs.modelChangeDidSucceed : ModelMsgs.modelChangeDidFail
        let notification = NSNotification(
            name: ModelMsgs.notificationName, object: self,
            userInfo: [ ModelMsgs.notificationEventKey : message ])
        NSNotificationCenter.defaultCenter().postNotification(notification)
    }
}
