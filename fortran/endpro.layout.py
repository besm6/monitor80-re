"""
Layout of the overlay ENDPRO (sub-overlay of FORTR*) for ../tools/ovsplit.py.
Address order; M = module cut from the disassembly. References to the root
are made symbolic with the layout of ROOT.
"""
M, C, L = 'M', 'C', 'L'
BASE = 0o35064                  # address of the overlay header
END = 0o37051
ROOT = 'fortr'
LAYOUT = [
    (0o35074, M, 'ENDPRO'),     # code, its routines 36344-36501 and data
    (0o36642, M, 'G36642'),
    (0o36673, M, 'G36673'),
]
# The names are given, the original ones are not known.
RENAME = {
    'G36642': 'IDXERR',     # "ERROR: INDEX VARIABLE IN IFLIST IS NOT
                            # CORRESPONDENT TO INDEX VARIABLE IN IVLIST AND
                            # VICE VERSA", then stop
    'G36673': 'ENDDUMP',    # debugging print of the root tables by their
                            # names: IFLIST, IVLIST, DIMENLIS, LGINVAR,
                            # SWITCH, INDEXCT, DIM2RE, UPI1CNT, PARAMCNT
}
LOW = '../lowmap.txt'          # resident monitor names
BASES = {0o35074: 7}            # ENDPRO: уиа ENDPRO(М7), see endpro.dtr
