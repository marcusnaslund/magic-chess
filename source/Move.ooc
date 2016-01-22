use base

Move: class {
    colFrom, colTo: Char
    rowFrom, rowTo: Int
    
    init: func (=colFrom, =rowFrom, =colTo, =rowTo)
    
    toText: func -> Text {
        result := TextBuilder new()
        result append(Text new(colFrom))
        result append(Text new(rowFrom toString()))
        result append(t"->")
        result append(Text new(colTo))
        result append(Text new(rowTo toString()))
        result join(t"")
    }
}