"""
Layout of the overlay GLINK (sub-overlay of FORTR*) for ../tools/ovsplit.py.
Address order; M = module cut from the disassembly, L = library module,
C = common block. References to the root are made symbolic with the layout
of ROOT.
"""
M, C, L = 'M', 'C', 'L'
BASE = 0o35064                  # address of the overlay header
END = 0o51104
ROOT = 'fortr'
LAYOUT = [
    (0o35074, M, 'GLINK'),
    (0o37001, C, 'D37001'),     # work cells and the statement record (D37311)
    (0o37324, M, 'G37324'),
    (0o37402, M, 'G37402'),
    (0o37607, M, 'G37607'),
    (0o37622, M, 'G37622'),
    (0o42161, M, 'G42161'),
    (0o44242, M, 'G44242'),
    (0o44562, C, 'D44562'),     # a table of the assembler (data only)
    (0o45027, M, 'G45027'),
    (0o46233, M, 'G46233'),     # SIMFAIL*, not the edition of the 2048 library
    (0o46362, C, 'D46362'),
    (0o47400, L, 'G47400'),
    (0o47435, L, 'G47435'),
    (0o47467, C, 'D47467'),
]
LIB = {
    0o47400: ('ПEP6B81C', {}),
    0o47435: ('OCTTDEC', {}),
}
# Much of GLINK is the Madlen assembler: the same code stands in the overlay
# ASEMBLER (2048, zone 0253), in another order, which fixes the boundaries:
#   42161-44241 = ASEMBLER 23474-25554    44242-44561 = 01775-02314
#   44562-45026 = 23227-23473             45027-46232 = 27000-30150
#   SIMFAIL*, ПEP6B81C, OCTTDEC follow in both; 37622-42160 is an edited
#   version of ASEMBLER 03000-10500.
# The names are given, the original ones are not known.
RENAME = {
    'G37324': 'TABFIND',    # hashed search in a table; G37325 only hashes
    'G37325': 'TABHASH',
    'G37402': 'LISTLINE',   # listing lines and page headers through PRINT8
    'G37507': 'LISTEND',
    'G37607': 'FLDADD',     # adds 1 to a field of a word with wrap-around
    'G37622': 'ASMSTMT',    # the statement processor of the assembler
    'G42161': 'ASMGEN',     # its back end, 27 routines behind a vector:
                            # code and literals, relocation table, object output
    'G44242': 'ASMINIT',
    'G45027': 'ASMPRINT',   # formatted messages (SIMFAIL*, ПEP6B81C, OCTTDEC)
    'G46233': 'SIMFAIL*',
}
# the tables of ASMPRINT after the library modules: 4 words are not zero
OWNER = {0o47467: 0o45027}
# modules that begin with a vector of jumps to their routines
VECTORS = {0o42161: 0o33, 0o45027: 3, 0o46233: 5}
LOW = '../lowmap.txt'          # resident monitor names
