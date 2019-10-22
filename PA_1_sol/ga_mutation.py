#Ahmed Ahmed
#Trevor Glassey
#Konstantin Dimitrov

import random

#Bases = ['A', 'T', 'C', 'G']

def mutate(seq, m_type = 'M'):
        loc1 = random.randint(0, len(seq)-1)
        loc2 = random.randint(0, len(seq)-1)
        mut = seq
        if m_type == 'M':  # this now swaps and is the only valid mutation. Every other mutation breaks the TSP rules
            swap = seq[loc1]
            while loc1 == loc2:
                loc2 = random.randint(0, len(seq)-1)
            mut[loc1] = mut[loc2]
            mut[loc2] = swap
#        elif m_type == 'N':
#            stops = [i for i in range(len(seq)) if seq.startswith('AG', i)]
#            to_mod = random.randint(0, len(stops)-1)
#            mut = seq[:stops[to_mod]] + 'TAG' + seq[stops[to_mod]:]
#        elif m_type == 'I' :
#            mut = seq[:loc] + Bases[random.randint(0,3)] + seq[loc:]
#        elif m_type == 'D':
#            mut = seq[:loc] + seq[loc+1:]
#        elif m_type == 'U':
#            mut = seq[:loc] + seq[loc:loc+num_copy] + seq[loc:]
#        elif m_type == 'R':
#            mut = seq[:loc] + seq[loc:loc+num_copy] * num_copy + seq[loc:]
        return mut





