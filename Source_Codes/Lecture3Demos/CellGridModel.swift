typealias Point = (x: Int, y: Int)

enum CellState {
    case Born
    case Alive
    case Died
    case Empty
}

class CellGridModel {
    var grid: [[CellState]]
    var generation: Int

    // This is a failable initializer. That is, invalid values will cause the constructor invocation to return nil.
    init?(size: Int) {
        generation = 0
        if size < 1 || size > 10000 {
            grid = [[CellState]]()
            return nil
        }
        grid = [[CellState]](count: size, repeatedValue: [CellState](count: size, repeatedValue: .Empty))
        makeGlider()
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
    
    func nextGeneration() {
        // We need a brand new grid because modifying the grid in-place will corrupt the clean snapshot of previous state
        var newGrid = [[CellState]](count: grid.count, repeatedValue: [CellState](count: grid.count, repeatedValue: .Empty))
        for col in 0..<grid.count {
            for row in 0..<grid.count {
                newGrid[col][row] = newState((col, row))
            }
        }
        grid = newGrid
        generation++
    }
    
    func getState(p: Point) -> CellState {
        return grid[p.x][p.y]
    }
}
