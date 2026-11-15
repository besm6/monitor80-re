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
    (0o04421, C, 'D04421'),
    (0o04424, M, 'G04424'),
    (0o05401, M, 'G05401'),
    (0o05403, M, 'G05403'),
    (0o05405, M, 'G05405'),
    (0o05671, M, 'G05671'),
    (0o05733, M, 'G05733'),
    (0o06000, M, 'G06000'),
    (0o06022, C, 'D06022'),
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
# L items are taken from the permanent library: module name and its entries
LIB = {
    0o33744: ('DUBLPREC', {0o1: 'D*AD*D', 0o104: 'D*MU*D', 0o116: 'D*DI*D',
                           0o134: 'D*SU*D', 0o165: 'D*COMP', 0o167: 'D*LN*D',
                           0o173: 'D*LO*D', 0o175: 'D*ST*D'}),
    0o34176: ('D*PO*I', {}),    # C*PO*I has the same code
    0o34736: ('DATAPR', {0o1: 'DATAPR*'}),
    0o35024: ('SDEC*', {}),
}
