use base, math
import Board, Move, Piece

Play: class {
    board: Board = null
    lastMove: Move = null
    moves: VectorList<Move> = null
    nexts: VectorList<Play> = null
    score := 0.0f
    bestMoveIndex: Int
    whiteToMove := true
    
    init: func ~withmove (=board, =whiteToMove, move: Move = null) {
        if (move != null) {
            this lastMove = move
            this board doMove(move)
        }
    }    
    free: override func {
        if (this moves != null)
            this moves free()
        if (this nexts != null) {
            for (i in 0 .. this nexts count - 1)
                this nexts[i] free()
            this nexts free()
        }            
        if (this board != null)
            this board free()
        /*if (this lastMove != null) //TODO
            this lastMove free()*/
        super()
    }
    evaluate: func (level := 0) -> Float {
        this _calcMoves()
        this score = this _heuristic()
        
        if (level > 0) {
            this _calcFuture()            
            for (i in 0 .. this nexts count)
                this nexts[i] evaluate(level - 1)
            
            if (this moves count > 0) {
                bestIndex := 0
                for (i in 1 .. this nexts count) {
                    nextScore := this nexts[i] score
                    if ((this whiteToMove && nextScore > this nexts[bestIndex] score) ||
                        (!this whiteToMove && nextScore < this nexts[bestIndex] score))
                        bestIndex = i
                }
                this score = this nexts[bestIndex] score
                this bestMoveIndex = bestIndex
            }
            else
                this score = this whiteToMove ? Float minimumValue : Float maximumValue
        }

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
        text := result join(t"")
        result free()
        text
    }
    
    _heuristic: func -> Float {
        generator := FloatUniformRandomGenerator new(-0.1f, 0.1f)
        result := generator next()
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
        generator free()
        result
    }
    _calcFuture: func {
        this nexts = VectorList<Play> new(this moves count, false)        
        for (i in 0 .. this moves count)
            this nexts add(Play new(this board copy(), !this whiteToMove, this moves[i]))
    }    
    _calcMoves: func {
        tempMoves := VectorList<Move> new(32, false)
        this moves = VectorList<Move> new()
        for (_row in 0 .. 8) {
            for (_col in 0 .. 8) {
                col := 'A' + _col
                row: Int = 8 - _row
                piece := this board[col, row]
                
                if (this whiteToMove) {
                    if (piece == Piece W_Pawn)
                        tempMoves add(Move new(col, row, col, row + 1))
                    if (piece == Piece W_Pawn && row == 2)
                        tempMoves add(Move new(col, row, col, row + 2))
                    //TODO: Add en passant
                    if (piece == Piece W_Rook || piece == Piece W_Queen) {
                        x := col + 1
                        while (x <= 'H') {
                            if (this board[x, row] isWhite())
                                break
                            tempMoves add(Move new(col, row, x, row))
                            if (this board[x, row] isBlack())
                                break
                            x = x + 1
                        }
                        x = col - 1
                        while (x >= 'A') {
                            if (this board[x, row] isWhite())
                                break
                            tempMoves add(Move new(col, row, x, row))
                            if (this board[x, row] isBlack())
                                break
                            x = x - 1
                        }
                        y := row + 1
                        while (y <= 8) {
                            if (this board[col, y] isWhite())
                                break
                            tempMoves add(Move new(col, row, col, y))
                            if (this board[col, y] isBlack())
                                break
                            y = y + 1
                        }
                        y = row - 1
                        while (y >= 1) {
                            if (this board[col, y] isWhite())
                                break
                            tempMoves add(Move new(col, row, col, y))
                            if (this board[col, y] isBlack())
                                break
                            y = y - 1
                        }
                    }
                    if (piece == Piece W_Bishop || piece == Piece W_Queen) {
                        (x, y) := (col + 1, row + 1)
                        while (x <= 'H' && y <= 8) {
                            if (this board[x, y] isWhite())
                                break
                            tempMoves add(Move new(col, row, x, y))
                            if (this board[x, y] isBlack())
                                break
                            (x, y) = (x + 1, y + 1)
                        }
                        (x, y) = (col + 1, row - 1)
                        while (x <= 'H' && y >= 1) {
                            if (this board[x, y] isWhite())
                                break
                            tempMoves add(Move new(col, row, x, y))
                            if (this board[x, y] isBlack())
                                break
                            (x, y) = (x + 1, y - 1)
                        }
                        (x, y) = (col - 1, row + 1)
                        while (x >= 'A' && y <= 8) {
                            if (this board[x, y] isWhite())
                                break
                            tempMoves add(Move new(col, row, x, y))
                            if (this board[x, y] isBlack())
                                break
                            (x, y) = (x - 1, y + 1)
                        }
                        (x, y) = (col - 1, row - 1)
                        while (x >= 'A' && y >= 1) {
                            if (this board[x, y] isWhite())
                                break
                            tempMoves add(Move new(col, row, x, y))
                            if (this board[x, y] isBlack())
                                break
                            (x, y) = (x - 1, y - 1)
                        }
                        
                    }
                    if (piece == Piece W_Knight) {
                        if (col + 1 <= 'H' && row + 2 <= 8 && !this board[col + 1, row + 2] isWhite())
                            tempMoves add(Move new(col, row, col + 1, row + 2))
                        if (col + 2 <= 'H' && row + 1 <= 8 && !this board[col + 2, row + 1] isWhite())
                            tempMoves add(Move new(col, row, col + 2, row + 1))
                        if (col + 1 <= 'H' && row - 2 >= 1 && !this board[col + 1, row - 2] isWhite())
                            tempMoves add(Move new(col, row, col + 1, row - 2))
                        if (col + 2 <= 'H' && row - 1 >= 1 && !this board[col + 2, row - 1] isWhite())
                            tempMoves add(Move new(col, row, col + 2, row - 1))
                            
                        if (col - 1 >= 'A' && row + 2 <= 8 && !this board[col - 1, row + 2] isWhite())
                            tempMoves add(Move new(col, row, col - 1, row + 2))
                        if (col - 2 >= 'A' && row + 1 <= 8 && !this board[col - 2, row + 1] isWhite())
                            tempMoves add(Move new(col, row, col - 2, row + 1))
                        if (col - 1 >= 'A' && row - 2 >= 1 && !this board[col - 1, row - 2] isWhite())
                            tempMoves add(Move new(col, row, col - 1, row - 2))
                        if (col - 2 >= 'A' && row - 1 >= 1 && !this board[col - 2, row - 1] isWhite())
                            tempMoves add(Move new(col, row, col - 2, row - 1))
                    }
                    if (piece == Piece W_King) {
                        for (x in -1 .. 2)
                            for (y in -1 .. 2)
                                if (this board[col + y, row + x] isBlack() || this board[col + y, row + x] == Piece Blank)
                                    tempMoves add(Move new(col, row, col + y, row + x))
                    }
                }
                else {
                    if (piece == Piece B_Pawn)
                        tempMoves add(Move new(col, row, col, row - 1))
                    if (piece == Piece B_Pawn && row == 7)
                        tempMoves add(Move new(col, row, col, row - 2))
                    //TODO: Add en passant
                    if (piece == Piece B_Rook || piece == Piece B_Queen) {
                        x := col + 1
                        while (x <= 'H') {
                            if (this board[x, row] isBlack())
                                break
                            tempMoves add(Move new(col, row, x, row))
                            if (this board[x, row] isWhite())
                                break
                            x = x + 1
                        }
                        x = col - 1
                        while (x >= 'A') {
                            if (this board[x, row] isBlack())
                                break
                            tempMoves add(Move new(col, row, x, row))
                            if (this board[x, row] isWhite())
                                break
                            x = x - 1
                        }
                        y := row + 1
                        while (y <= 8) {
                            if (this board[col, y] isBlack())
                                break
                            tempMoves add(Move new(col, row, col, y))
                            if (this board[col, y] isWhite())
                                break
                            y = y + 1
                        }
                        y = row - 1
                        while (y >= 1) {
                            if (this board[col, y] isBlack())
                                break
                            tempMoves add(Move new(col, row, col, y))
                            if (this board[col, y] isWhite())
                                break
                            y = y - 1
                        }
                    }
                    if (piece == Piece B_Bishop || piece == Piece B_Queen) {
                        (x, y) := (col + 1, row + 1)
                        while (x <= 'H' && y <= 8) {
                            if (this board[x, y] isBlack())
                                break
                            tempMoves add(Move new(col, row, x, y))
                            if (this board[x, y] isWhite())
                                break
                            (x, y) = (x + 1, y + 1)
                        }
                        (x, y) = (col + 1, row - 1)
                        while (x <= 'H' && y >= 1) {
                            if (this board[x, y] isBlack())
                                break
                            tempMoves add(Move new(col, row, x, y))
                            if (this board[x, y] isWhite())
                                break
                            (x, y) = (x + 1, y - 1)
                        }
                        (x, y) = (col - 1, row + 1)
                        while (x >= 'A' && y <= 8) {
                            if (this board[x, y] isBlack())
                                break
                            tempMoves add(Move new(col, row, x, y))
                            if (this board[x, y] isWhite())
                                break
                            (x, y) = (x - 1, y + 1)
                        }
                        (x, y) = (col - 1, row - 1)
                        while (x >= 'A' && y >= 1) {
                            if (this board[x, y] isBlack())
                                break
                            tempMoves add(Move new(col, row, x, y))
                            if (this board[x, y] isWhite())
                                break
                            (x, y) = (x - 1, y - 1)
                        }
                    }
                    if (piece == Piece B_Knight) {
                        if (col + 1 <= 'H' && row + 2 <= 8 && !this board[col + 1, row + 2] isBlack())
                            tempMoves add(Move new(col, row, col + 1, row + 2))
                        if (col + 2 <= 'H' && row + 1 <= 8 && !this board[col + 2, row + 1] isBlack())
                            tempMoves add(Move new(col, row, col + 2, row + 1))
                        if (col + 1 <= 'H' && row - 2 >= 1 && !this board[col + 1, row - 2] isBlack())
                            tempMoves add(Move new(col, row, col + 1, row - 2))
                        if (col + 2 <= 'H' && row - 1 >= 1 && !this board[col + 2, row - 1] isBlack())
                            tempMoves add(Move new(col, row, col + 2, row - 1))
                            
                        if (col - 1 >= 'A' && row + 2 <= 8 && !this board[col - 1, row + 2] isBlack())
                            tempMoves add(Move new(col, row, col - 1, row + 2))
                        if (col - 2 >= 'A' && row + 1 <= 8 && !this board[col - 2, row + 1] isBlack())
                            tempMoves add(Move new(col, row, col - 2, row + 1))
                        if (col - 1 >= 'A' && row - 2 >= 1 && !this board[col - 1, row - 2] isBlack())
                            tempMoves add(Move new(col, row, col - 1, row - 2))
                        if (col - 2 >= 'A' && row - 1 >= 1 && !this board[col - 2, row - 1] isBlack())
                            tempMoves add(Move new(col, row, col - 2, row - 1))
                    }
                    if (piece == Piece B_King) {
                        for (x in -1 .. 2)
                            for (y in -1 .. 2)
                                if (this board[col + y, row + x] isWhite() || this board[col + y, row + x] == Piece Blank)
                                    tempMoves add(Move new(col, row, col + y, row + x))
                    }
                }
            }
        }
        
        //TODO: Obvious bug: Capturing the king is not allowed :)
        
        
        for (i in 0 .. tempMoves count) {
            move := tempMoves[i]
            if (tempMoves[i] isValid) { // This works but I have no idea how
                //t"Invalid: " print()
                //move toText() println()
                continue
            }
            else if (this board[move colTo, move rowTo] == Piece W_King || this board[move colTo, move rowTo] == Piece B_King) {
                continue
            }
            else {
                next := this board copy()
                next doMove(move)
                if (!(next inCheck(!this whiteToMove) || !next inCheck(this whiteToMove))) {
                    continue
                }
                else {
                    this moves add(move)
                }
            }
        }
        
        tempMoves free()
    }
}