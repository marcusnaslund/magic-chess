import Board, Play

//TODO: This class will be used for actually playing chess

Game: class {
    position: Board
    whiteIsHuman: Bool
    blackIsHuman: Bool
    whiteToPlay: Bool
    
    init: func (=position, =whiteToPlay, =whiteIsHuman, =blackIsHuman)
    
    free: override func {
        this position free()
        super()
    }    
    start: func {
        //TODO: Run game loop
    }    
}