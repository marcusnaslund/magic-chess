use base
use magic-chess

main: func (argc: Int, argv: CString*) {
    board := Board new~default()
    //board toText() println()
    play := Play new(board, false)
    
    steps := 0
    while (steps < 10) {
        play evaluate(3)
        play toText() println()
        
        for (i in 0 .. play moves count) {
            moves := play moves[i]
            moves toText() print()
            t", " print()
        }
        
        t"\nBest move:" print()
        play moves[play bestMoveIndex] toText() println()
        
        play = play nexts[play bestMoveIndex]
        
        steps = steps + 1
    }
}
