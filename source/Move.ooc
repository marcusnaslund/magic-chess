use base

Move: class {
    colFrom, colTo: Char
    rowFrom, rowTo: Int
    
    isValid ::= (this colFrom < 'A' || this colTo < 'A' || this colFrom > 'H' || this colTo > 'H' || this rowFrom < 1 || this rowTo < 1 || this rowFrom > 8 || this rowTo > 8)
    
    init: func (=colFrom, =rowFrom, =colTo, =rowTo)
    
    toText: func -> Text {
        result := TextBuilder new()
        result append(Text new(colFrom))
        result append(Text new(rowFrom toString()))
        result append(t"->")
        result append(Text new(colTo))
        result append(Text new(rowTo toString()))
        text := result join(t"")
        result free()
        text
    }
}