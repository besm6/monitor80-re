"""
Layout of the root overlay FORTR* for ../tools/ovsplit.py (see its docstring).
Address order; M = module cut from the disassembly, L = module taken from the
permanent library, C = common block.
"""
M, C, L = 'M', 'C', 'L'
BASE = 0o1760                   # address of the overlay header
END = 0o35064
LAYOUT = [
    (0o01770, M, 'FORTR'),      # becomes FORTR* in the Madlen text
    (0o01773, C, 'D01773'),
    (0o01775, M, 'G01775'),
    (0o02144, C, 'D02144'),
    (0o02412, M, 'G02412'),
    (0o03740, C, 'D03740'),
    (0o04275, M, 'G04275'),
    (0o04407, M, 'G04407'),
    (0o06407, M, 'G06407'),
    (0o06410, M, 'G06410'),
    (0o06463, M, 'G06463'),
    (0o06466, C, 'D06466'),
    (0o06636, C, 'D06636'),
    (0o07427, C, 'D07427'),
    (0o10170, C, 'D10170'),
    (0o23440, C, 'D23440'),
    (0o32477, C, 'D32477'),
    (0o33143, C, 'D33143'),
    (0o33503, M, 'G33503'),
    (0o33515, C, 'D33515'),
    (0o33551, M, 'G33551'),
    (0o33553, M, 'G33553'),
    (0o33612, M, 'G33612'),
    (0o33740, M, 'G33740'),
    (0o33744, L, 'G33744'),     # DUBLPREC
    (0o34176, L, 'G34176'),     # C*PO*I
    (0o34243, M, 'G34243'),
    (0o34251, M, 'G34251'),
    (0o34265, M, 'G34265'),
    (0o34320, M, 'G34320'),
    (0o34606, M, 'G34606'),
    (0o34621, C, 'D34621'),
    (0o34736, L, 'G34736'),     # DATAPR
    (0o34756, C, 'D34756'),
    (0o34757, C, 'D34757'),
    (0o34762, C, 'D34762'),
    (0o34766, M, 'G34766'),
    (0o34767, C, 'D34767'),
    (0o34772, M, 'G34772'),
    (0o35023, M, 'G35023'),
    (0o35024, L, 'G35024'),     # SDEC*
]
# BEMSH labels are at most 6 characters, so real names appear only in Madlen
RENAME = {'FORTR': 'FORTR*', 'G34772': 'OCTTODEC', 'G35023': 'SDEC'}
# Names given from what the routines do (callers, externals, literals);
# PUTAWAY is the routine's own name, printed by its debugging trace.
RENAME.update({
    'G01775': 'FTNMAIN',    # driver: banner, phases CBDPR/CONTROL/ENDPRO/GLINK via LOADCALL
    'G02412': 'SCANSTMT',   # reads a statement, recognises keywords and constants
    'G04275': 'SYMOUT',     # end of unit: passes names of the symbol table to PUTAWAY
    # the generator, 04407-06406: one module with internal subroutines and the
    # table of run-time names (I*AD*I ...); its base register M7 holds 04407
    'G04407': 'PUTAWAY',
    'G06407': 'WRDECL',     # buffered writer, first list (**DECLIST**/**OUTLIST**)
    'G06410': 'WROUT',      # buffered writer, second list
    'G06411': 'WRLIST',     # common body of the two writers
    'G06463': 'ERRCODE',    # error with a code
    'G33503': 'BANNER',     # prints "ФОРТРАН /16.07.73/" and the date
    'G33551': 'GETCARD',    # READ*
    'G33553': 'ADDTEXT',    # finds or appends a text in a pool
    'G33612': 'LISTCARD',   # prints the source line to the listing
    'G33740': 'ERRVEC',     # jumps into ERRPRINT
    'G34243': 'PUTNAME',    # name item -> PUTAWAY
    'G34251': 'PUTSYMB',    # symbol table entry -> PUTAWAY
    'G34265': 'DBGPRINT',   # debugging output, by flags
    'G34266': 'DBGDUMP',
    'G34267': 'DBGHOOK',
    'G34766': 'DBGSTUB',
    'G34320': 'ERRPRINT',   # "ОШИБКА НОМЕР ... В ОПЕРАТОРЕ, СЛЕДУЮЩЕМ ЗА МЕТКОЙ"
    'G34322': 'ERRPRIN2',
    'G34606': 'DECTEXT',    # number -> decimal text (SDEC)
})
# L items are taken from the permanent library: module name and its entries
LIB = {
    0o33744: ('DUBLPREC', {0o1: 'D*AD*D', 0o104: 'D*MU*D', 0o116: 'D*DI*D',
                           0o134: 'D*SU*D', 0o165: 'D*COMP', 0o167: 'D*LN*D',
                           0o173: 'D*LO*D', 0o175: 'D*ST*D'}),
    0o34176: ('D*PO*I', {}),    # C*PO*I has the same code
    0o34736: ('DATAPR', {0o1: 'DATAPR*'}),
    0o35024: ('SDEC*', {}),
}
LOW = '../lowmap.txt'          # resident monitor names
# ERRVEC, ERRPRINT, ERRPRIN2, ERRCODE and 05403 (inside PUTAWAY) take an error number
ERRCALLS = [0o33740, 0o34320, 0o34322, 0o06463, 0o05403]
# 03477: error number 5003, kept in a cell and passed to ERRVEC later
NUMBERS = [0o03477]
BASES = {0o04407: 7}            # PUTAWAY: уиа PUTAWAY(М7), see putaway.dtr
