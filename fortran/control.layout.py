"""
Layout of the overlay CONTROL (sub-overlay of FORTR*) for ../tools/ovsplit.py.
Address order; M = module cut from the disassembly, C = common block.
References to the root are made symbolic with the layout of ROOT.
"""
M, C, L = 'M', 'C', 'L'
BASE = 0o35064                  # address of the overlay header
END = 0o51764
ROOT = 'fortr'
LAYOUT = [
    (0o35074, M, 'G35074'),
    (0o40152, M, 'G40152'),
    (0o41005, M, 'G41005'),
    (0o41101, M, 'G41101'),
    (0o41174, M, 'G41174'),
    (0o42540, M, 'G42540'),
    (0o44472, M, 'G44472'),
    (0o44753, M, 'G44753'),
    (0o44763, M, 'G44763'),
    (0o44766, M, 'G44766'),
    (0o45015, M, 'G45015'),
    (0o45033, C, 'D45033'),     # work cells shared by the statement routines
    (0o45163, M, 'G45163'),
    (0o46060, M, 'G46060'),
    (0o46107, M, 'G46107'),
    (0o47004, M, 'G47004'),
    (0o47017, C, 'D47017'),     # tables of G46107
    (0o50207, M, 'G50207'),
    (0o50234, C, 'D50234'),     # work cells and stacks
    (0o50501, M, 'G50501'),
    (0o50510, M, 'G50510'),
    (0o50517, M, 'G50517'),
    (0o50531, M, 'G50531'),
    (0o50610, M, 'G50610'),
    (0o50635, M, 'G50635'),
    (0o50655, M, 'G50655'),
    (0o50674, M, 'G50674'),
    (0o50741, M, 'G50741'),
]
# The names are given: from the error messages a module issues (see the
# `C NNNNN:` comments in the .asm), its literals and its debugging prints.
# Modules left with their addresses have not been identified.
RENAME = {
    'G35074': 'CONTROL',    # executable statements: DO, GO TO, ASSIGN, CALL,
                            # ENTRY, FORMAT labels; a vector of 15 jumps first
    'G41005': 'ASSIGNST',   # arithmetic assignment (error 2207)
    'G41101': 'IFSTMT',     # IF: branch points, logical IF (4101, 4102)
    'G41174': 'ARITHEXP',   # arithmetic expressions (2201-2207, 2210)
    'G42540': 'OPERAND',    # operands: subscripts, function references,
                            # the table of intrinsic functions (5040-5053)
    'G44472': 'FUNCREF',    # function name and argument list (2201, 2202)
    'G44753': 'PUTOP',      # one item to PUTAWAY
    'G44763': 'ERRJUMP',    # jumps to ERRPRINT and ERRPRIN2
    'G44766': 'ASFTRACE',   # debugging print "BEGIN-ASF" / "END-ASF"
    'G45163': 'LOGEXPR',    # logical and relational expressions (4103-4114)
    'G46060': 'IFLTRACE',   # debugging print "BEGIN IFLOGI" / "END IFLOGI"
    'G47004': 'TABTRACE',   # debugging print of a table
    'G50207': 'PROSIG',     # debugging print, prints its own name
}
LOW = '../lowmap.txt'          # resident monitor names
BASES = {0o41174: 7,             # ARITHEXP: уиа ARITHEXP+6(М7), see arithexp.dtr
         0o42540: 7,             # OPERAND: уиа OPERAND+2(М7), see operand.dtr
         0o44472: 7}             # FUNCREF (with G44647, G44661): уиа FUNCREF+5(М7), see funcref.dtr
# the tables after TABTRACE belong to G46107
OWNER = {0o47017: 0o46107}
ERRCALLS = [0o44763, 0o44765]    # jumps to ERRPRINT and ERRPRIN2 (and those of the root)
