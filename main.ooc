use ooc-base
use magic-chess

main: func (argc: Int, argv: CString*) {
    board := Board new~default()
    board toString() println()
}
