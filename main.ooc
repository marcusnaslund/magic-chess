use base
use magic-chess

main: func (argc: Int, argv: CString*) {
    board := Board new~default()
    //board toText() println()
    whiteToPlay := true
    play := Play new(board, whiteToPlay)
    
    steps := 0
    while (steps < 100) {
        play evaluate(2)
        play toText() println()
        
        for (i in 0 .. play moves count) {
            moves := play moves[i]
            moves toText() print()
            t", " print()
        }
        
        t"\nBest move:" print()
        play moves[play bestMoveIndex] toText() println()
        
        next := play nexts[play bestMoveIndex] board copy()
        
        play free()
        whiteToPlay = !whiteToPlay
        play = Play new(next, whiteToPlay)
        
        steps = steps + 1
    }
}
