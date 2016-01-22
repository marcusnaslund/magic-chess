use base
import Board, Move, Piece

Play: class {
    board: Board = null
    moves: VectorList<Move> = null
    nexts: VectorList<Play> = null
    score := 0.0f
    whiteToMove := true
    
    init: func ~withmove (=board, =whiteToMove, move: Move = null) {
        if (move != null)
            this board doMove(move)
    }    
    evaluate: func (level := 0) -> Float {
        this _calcMoves()
        
        if (level > 0) {
            this _calcFuture()            
            for (i in 0 .. this nexts count)
                this nexts[i] evaluate(level - 1)
       
            bestIndex := 0
            for (i in 1 .. this nexts count) {
                nextScore := this nexts[i] score
                if ((this whiteToMove && nextScore > this nexts[bestIndex] score) ||
                    (!this whiteToMove && nextScore < this nexts[bestIndex] score))
                    bestIndex = i
            }
            this score = this nexts[bestIndex] score
        }
        else
            this score = this _heuristic()

        this score
    }
    toText: func -> Text {
        result := TextBuilder new()
        result append(this board toText())
        result append(t"Score: ")
        result append(this score toText())
        result append(t", ")
        result append(this whiteToMove ? t"(w)" : t"(b)")
        result append(t"\n")
        result join(t"")
    }
    
    _heuristic: func -> Float {
        result := 0.f
        for (_row in 0 .. 8) {
            for (_col in 0 .. 8) {
                col := 'A' + _col
                row: Int = 8 - _row
                piece := this board[col, row]
                if (piece == Piece W_Pawn)
                    result += 1.0f
                else if (piece == Piece B_Pawn)
                    result -= 1.0f
                else if (piece == Piece W_Knight || piece == Piece W_Bishop)
                    result += 3.0f
                else if (piece == Piece B_Knight || piece == Piece B_Bishop)
                    result -= 3.0f
                else if (piece == Piece W_Rook)
                    result += 5.0f
                else if (piece == Piece B_Rook)
                    result -= 5.0f
                else if (piece == Piece W_Queen)
                    result += 9.0f
                else if (piece == Piece B_Queen)
                    result -= 9.0f
            }
        }
        result
    }
    _calcFuture: func {
        this nexts = VectorList<Play> new(this moves count)        
        for (i in 0 .. this moves count)
            this nexts add(Play new(this board copy(), !this whiteToMove, this moves[i]))
    }    
    _calcMoves: func {
        //TODO: Must handle checks
        
        this moves = VectorList<Move> new()
        for (_row in 0 .. 8) {
            for (_col in 0 .. 8) {
                col := 'A' + _col
                row: Int = 8 - _row
                piece := this board[col, row]
                
                if (this whiteToMove) {
                    if (piece == Piece W_Pawn)
                        this moves add(Move new(col, row, col, row + 1))
                    if (piece == Piece W_Pawn && row == 2)
                        this moves add(Move new(col, row, col, row + 2))
                    if (piece == Piece W_Rook || piece == Piece W_Queen) {
                        //TODO
                    }
                    if (piece == Piece W_Bishop || piece == Piece W_Queen) {
                        //TODO
                    }
                    if (piece == Piece W_Knight) {
                        //TODO
                    }
                    if (piece == Piece W_King) {
                        for (x in -1 .. 2)
                            for (y in -1 .. 2)
                                if (x != 0 && y != 0) {
                                    //TODO
                                }
                    }
                }
                else {
                    if (piece == Piece B_Pawn)
                        this moves add(Move new(col, row, col, row - 1))
                    if (piece == Piece B_Pawn && row == 2)
                        this moves add(Move new(col, row, col, row + 2))
                    if (piece == Piece B_Rook || piece == Piece B_Queen) {
                        //TODO
                    }
                    if (piece == Piece B_Bishop || piece == Piece B_Queen) {
                        //TODO
                    }
                    if (piece == Piece B_Knight) {
                        //TODO
                    }
                    if (piece == Piece B_King) {
                        //TODO
                    }
                }
            }
        }
    }
}