use ooc-base
import Board, Move

Play: class {
    board: Board
    moves: VectorList<Move>
    next: VectorList<Board>
    score := 0.0f
    whiteToMove: Bool
    
    init: func ~board (=board, =whiteToMove) {
        this _calcMoves()
    }
    init: func ~withmove (=board, =whiteToMove, move: Move) {
        //TODO
    }
    
    evaluate: func (level := 0) -> Float {
        //TODO
        
        //TODO if level > 0 evaluate all nexts, pick max/min of them
        
        //TODO heuristic
        
        this score
    }
    
    _calcMoves: func {
        
    }
}