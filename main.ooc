use base
use magic-chess

main: func (argc: Int, argv: CString*) {
    board := Board new~default()
    //board toText() println()
    play := Play new(board, true)
    play evaluate()
    play toText() println()
    
    for (i in 0 .. play moves count) {
        moves := play moves[i]
        moves toText() println()
    }
    
    
}
