"""
Layout of the overlay CBDPR (sub-overlay of FORTR*) for ../tools/ovsplit.py.
Address order; M = module cut from the disassembly, C = common block.
References to the root are made symbolic with the layout of ROOT.
"""
M, C, L = 'M', 'C', 'L'
BASE = 0o35064                  # address of the overlay header
END = 0o41141
ROOT = 'fortr'
LAYOUT = [
    (0o35074, M, 'CBDPR'),
    (0o35713, C, 'D35713'),
    (0o35730, M, 'G35730'),
    (0o36050, M, 'G36050'),
    (0o36112, M, 'G36112'),
    (0o36212, M, 'G36212'),
    (0o36255, C, 'D36255'),
    (0o36317, M, 'G36317'),
    (0o36336, M, 'G36336'),
    (0o36370, M, 'G36370'),
    (0o36376, M, 'G36376'),
    (0o36402, M, 'G36402'),
    (0o36406, M, 'G36406'),
    (0o40726, M, 'G40726'),
    (0o40735, C, 'D40735'),
    (0o41025, M, 'G41025'),
    (0o41117, M, 'G41117'),
    (0o41140, C, 'D41140'),
]
# Original names: each routine prints its own name through CBTRACE.
# CBTRACE, CBERROR, MKITEM, MKITEM2, CBDUMP, PUTDAT, PUTLABEL, PUTITEM,
# LABTEXT are given names.
RENAME = {
    'G35730': 'CBPROC', 'G36050': 'CBBSS', 'G36112': 'CBCE', 'G36212': 'CBEQU',
    'G36317': 'CDIMSR', 'G36336': 'CFRCH', 'G36406': 'CBPRCZ', 'G37316': 'CBPRDM',
    'G36370': 'CBTRACE',    # prints the name of the routine entered
    'G36376': 'CBERROR',    # -> ERRPRINT
    'G36402': 'MKITEM',     # builds an item for PUTAWAY
    'G37766': 'MKITEM2',
    'G37532': 'CBDUMP',     # debugging print through DBGPRINT
    'G40726': 'PUTDAT',     # item -> PUTAWAY
    'G41025': 'PUTLABEL',   # statement label: decimal text, items to PUTAWAY;
                            # its subroutine PUTITEM (address and code -> PUTAWAY)
                            # at +54 and its data D41115 (used by CBPRCZ) inside
    'G41117': 'LABTEXT',    # label number -> text (SDEC)
}
LOW = '../lowmap.txt'          # resident monitor names
BASES = {0o41025: 7}            # PUTLABEL: уиа PUTLABEL(М7), see putlabel.dtr
ERRCALLS = [0o36376]            # CBERROR (and those of the root)
