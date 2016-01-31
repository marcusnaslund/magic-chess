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
        this promote()
    }
    promote: func {
        for (i in 0 .. 8) {
            // TODO: Handle promotion to other pieces than queen
            
            if (this['A' + i, 1] == Piece B_Pawn)
                this['A' + i, 1] = Piece B_Queen
            if (this['A' + i, 8] == Piece W_Pawn)
                this['A' + i, 8] = Piece W_Queen
        }
    }
    inCheck: func (white: Bool) -> Bool {
        kingCol: Char = 'A'
        kingRow: Int = 1
        for (row in 0 .. 8)
            for (col in 0 .. 8)
                if ((white && this['A' + col, 8 - row] == Piece W_King) || (!white && this['A' + col, 8 - row] == Piece B_King))
                    (kingCol, kingRow) = ('A' + col, 8 - row)
        
        // Check by opposite pawn?
        if (white && kingRow + 1 <= 8) {
            if (kingCol - 1 >= 'A' && this[kingCol - 1, kingRow + 1] == Piece B_Pawn) return true
            if (kingCol + 1 <= 'H' && this[kingCol + 1, kingRow + 1] == Piece B_Pawn) return true
        }
        if (!white && kingRow - 1 >= 1) {
            if (kingCol - 1 >= 'A' && this[kingCol - 1, kingRow - 1] == Piece W_Pawn) return true
            if (kingCol + 1 <= 'H' && this[kingCol + 1, kingRow - 1] == Piece W_Pawn) return true
        }
        
        // Check by opposite rook/queen?
        x := kingCol + 1
        while (x <= 'H') {
            if (white && (this[x, kingRow] == Piece B_Rook || this[x, kingRow] == Piece B_Queen)) return true
            if (!white && (this[x, kingRow] == Piece W_Rook || this[x, kingRow] == Piece W_Queen)) return true
            if (this [x, kingRow] != Piece Blank) break
            x = x + 1
        }
        x = kingCol - 1
        while (x >= 'A') {
            if (white && (this[x, kingRow] == Piece B_Rook || this[x, kingRow] == Piece B_Queen)) return true
            if (!white && (this[x, kingRow] == Piece W_Rook || this[x, kingRow] == Piece W_Queen)) return true
            if (this [x, kingRow] != Piece Blank) break
            x = x - 1
        }
        y := kingRow + 1
        while (y <= 8) {
            if (white && (this[kingCol, y] == Piece B_Rook || this[kingCol, y] == Piece B_Queen)) return true
            if (!white && (this[kingCol, y] == Piece W_Rook || this[kingCol, y] == Piece W_Queen)) return true
            if (this [kingCol, y] != Piece Blank) break
            y = y + 1
        }
        y = kingRow - 1
        while (y >= 1) {
            if (white && (this[kingCol, y] == Piece B_Rook || this[kingCol, y] == Piece B_Queen)) return true
            if (!white && (this[kingCol, y] == Piece W_Rook || this[kingCol, y] == Piece W_Queen)) return true
            if (this [kingCol, y] != Piece Blank) break
            y = y + 1
        }
        
        // Check by opposite bishop/queen?
        x = kingCol + 1
        y = kingRow + 1
        while (x <= 'H' && y <= 8) {
            if (white && (this[x, y] == Piece B_Bishop || this[x, y] == Piece B_Queen)) return true
            if (!white && (this[x, y] == Piece W_Bishop || this[x, y] == Piece W_Queen)) return true
            (x, y) = (x + 1, y + 1)
        }
        x = kingCol + 1
        y = kingRow - 1
        while (x <= 'H' && y >= 1) {
            if (white && (this[x, y] == Piece B_Bishop || this[x, y] == Piece B_Queen)) return true
            if (!white && (this[x, y] == Piece W_Bishop || this[x, y] == Piece W_Queen)) return true
            (x, y) = (x + 1, y - 1)
        }
        x = kingCol - 1
        y = kingRow - 1
        while (x >= 'A' && y >= 1) {
            if (white && (this[x, y] == Piece B_Bishop || this[x, y] == Piece B_Queen)) return true
            if (!white && (this[x, y] == Piece W_Bishop || this[x, y] == Piece W_Queen)) return true
            (x, y) = (x - 1, y - 1)
        }
        x = kingCol - 1
        y = kingRow + 1
        while (x >= 'A' && y <= 8) {
            if (white && (this[x, y] == Piece B_Bishop || this[x, y] == Piece B_Queen)) return true
            if (!white && (this[x, y] == Piece W_Bishop || this[x, y] == Piece W_Queen)) return true
            (x, y) = (x - 1, y + 1)
        }
        
        // Check by opposite knight?
        if ((x - 1 >= 'A' && y - 2 >= 1) && ((white && this[x - 1 , y - 2] == Piece B_Knight) || (!white && this[x - 1, y - 2] == Piece W_Knight))) return true
        if ((x + 1 <= 'H' && y - 2 >= 1) && ((white && this[x + 1 , y - 2] == Piece B_Knight) || (!white && this[x + 1, y - 2] == Piece W_Knight))) return true
        if ((x - 1 >= 'A' && y + 2 <= 8) && ((white && this[x - 1 , y + 2] == Piece B_Knight) || (!white && this[x - 1, y + 2] == Piece W_Knight))) return true
        if ((x + 1 <= 'H' && y + 2 <= 8) && ((white && this[x + 1 , y + 2] == Piece B_Knight) || (!white && this[x + 1, y + 2] == Piece W_Knight))) return true
        if ((x - 2 >= 'A' && y - 1 >= 1) && ((white && this[x - 2 , y - 1] == Piece B_Knight) || (!white && this[x - 2, y - 1] == Piece W_Knight))) return true
        if ((x + 2 <= 'H' && y - 1 >= 1) && ((white && this[x + 2 , y - 1] == Piece B_Knight) || (!white && this[x + 2, y - 1] == Piece W_Knight))) return true
        if ((x - 2 >= 'A' && y + 1 <= 8) && ((white && this[x - 2 , y + 1] == Piece B_Knight) || (!white && this[x - 2, y + 1] == Piece W_Knight))) return true
        if ((x + 2 <= 'H' && y + 1 <= 8) && ((white && this[x + 2 , y + 1] == Piece B_Knight) || (!white && this[x + 2, y + 1] == Piece W_Knight))) return true
        
        
        // Check by opposite king? (To avoid king stepping in to check)
        for (_col in -1 .. 2)
            for (_row in -1 .. 2) {
                col := kingCol + _col
                row := kingRow + _row
                if (col >= 'A' && col <= 'H' && row >= 1 && row <= 8) {
                    if ((white && this[col, row] == Piece B_King) || (!white && this[col, row] == Piece W_King))
                        return true
                }
            }
        
        return false
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