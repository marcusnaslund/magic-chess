use base
import Piece, Move

Board: class {
    pieces := Piece[64] new()
    
    init: func ~blank {
        this clear()
    }
    init: func ~default {
        this clear()
        for (col in 0 .. 8) {
            this['A' + col, 2] = Piece W_Pawn
            this['A' + col, 7] = Piece B_Pawn
        }
        this['A', 1] = Piece W_Rook
        this['B', 1] = Piece W_Knight
        this['C', 1] = Piece W_Bishop
        this['D', 1] = Piece W_Queen
        this['E', 1] = Piece W_King
        this['F', 1] = Piece W_Bishop
        this['G', 1] = Piece W_Knight
        this['H', 1] = Piece W_Rook
        this['A', 8] = Piece B_Rook
        this['B', 8] = Piece B_Knight
        this['C', 8] = Piece B_Bishop
        this['D', 8] = Piece B_Queen
        this['E', 8] = Piece B_King
        this['F', 8] = Piece B_Bishop
        this['G', 8] = Piece B_Knight
        this['H', 8] = Piece B_Rook
    }
    free: override func {
        this pieces free()
        super()
    }
    clear: func {
        for (i in 0 .. 64)
            this pieces[i] = Piece Blank
    }
    copy: func -> This {
        result := This new()
        for (i in 0 .. 64)
            result pieces[i] = this pieces[i]
        result
    }
    toText: func -> Text {
        result := TextBuilder new()
        result append(t"--------\n")
        for (row in 0 .. 8) {
            for (col in 0 .. 8) {
                match (this['A' + col, 8 - row]) {
                    case Piece W_Pawn => result append(t"P")
                    case Piece W_Bishop => result append(t"B")
                    case Piece W_Knight => result append(t"N")
                    case Piece W_Rook => result append(t"R")
                    case Piece W_Queen => result append(t"Q")
                    case Piece W_King => result append(t"K")
                    case Piece B_Pawn => result append(t"p")
                    case Piece B_Bishop => result append(t"b")
                    case Piece B_Knight => result append(t"n")
                    case Piece B_Rook => result append(t"r")
                    case Piece B_Queen => result append(t"q")
                    case Piece B_King => result append(t"k")
                    case => result append(t" ")
                }
            }
            result append(t"\n")
        } 
        result append(t"--------\n")
        text := result join(t"")
        result free()
        text
    }
    doMove: func (move: Move) {
        this[move colTo, move rowTo] = this[move colFrom, move rowFrom]
        this[move colFrom, move rowFrom] = Piece Blank
    }
    inCheck: func (white: Bool) -> Bool {
        kingCol: Char = 'A'
        kingRow: Int = 1
        for (row in 0 .. 8)
            for (col in 0 .. 8)
                if ((white && this['A' + col, 8 - row] == Piece W_King) || (!white && this['A' + col, 8 - row] == Piece B_King))
                    (kingCol, kingRow) = ('A' + col, 8 - row)
        result := false
        
        //TODO: Check by opposite pawn?
        //TODO: Check by opposite knight?
        //TODO: Check by opposite rook/queen?
        //TODO: Check by opposite bishop/queen?
        //TODO: Check by opposite king? (To avoid king stepping in to check)
        
        result
    }
    
    operator [] (col: Char, row: Int) -> Piece {
        _col: Int = (col - 'A')
		this pieces[_col * 8 + (row - 1)]
	}
	operator []= (col: Char, row: Int, piece: Piece) {
		_col: Int = (col - 'A')
		this pieces[_col * 8 + (row - 1)] = piece
	}
}