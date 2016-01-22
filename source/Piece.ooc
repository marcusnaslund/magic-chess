Piece: enum {
    Blank
    W_Pawn
    B_Pawn
    W_Rook
    B_Rook
    W_Knight
    B_Knight
    W_Bishop
    B_Bishop
    W_Queen
    B_Queen
    W_King
    B_King
    
    isWhite: func -> Bool {
        this == Piece W_Pawn || this == W_Rook || this == W_Knight || this == W_Bishop || this == W_Queen || this == W_King
    }
    isBlack: func -> Bool {
        !this isWhite() && this != Piece Blank
    }
}
