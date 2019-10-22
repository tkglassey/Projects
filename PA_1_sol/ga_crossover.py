#Ahmed Ahmed
#Trevor Glassey
#Konstantin Dimitrov

import random

#BASE_PAIRS = {'A' : 'T', 'T':'A', 'C':'G','G':'C'}


# this pretty much never works. Can't figure out a good complement strategy.
def complementary_strand(seq):
    return [seq[int(x)-1] for x in seq]


def crossover(seq):
    comp = complementary_strand(seq)
    loc = random.randint(0, len(seq)-1)
    crossLen = random.randint(0, len(seq[loc:])-1)
    crossRes = seq[:loc] + comp[loc:loc+crossLen] + seq[loc+crossLen:]
    return crossRes
