import csv, ga_crossover, ga_mutation, random, numpy
from copy import copy

POPULATION_SIZE = 1000
GENERATIONS = 50

def generate_population(amount, genes):
    population = []
    for i in range(amount):
        ind = random.sample(range(genes), genes)
        population.append(ind)
    return population


def calc_distance(seq, distances):  # calculates distance (Assumes sequences given as city indexes)
    distance = 0
    prev = seq[0]
    for x in seq[1:]:
        distance += int(distances[int(prev)][int(x)])
        prev = x
    return distance


def valid(ind):
    return len(ind) == len(set(ind))


def change(ind):
    mut = ind
    rand = random.randint(1,10)
    if rand > 5:
        mut = ga_crossover.crossover(mut)
    if rand % 2 == 1:
        mut = ga_mutation.mutate(mut)
    if valid(mut):
        return mut
    else:
        return change(ind)


def calc_pop_distance(population, distances):
    pop_distances = []
    for x in population:
        pop_distances.append(calc_distance(x, distances))
    return pop_distances


# Using a given threshold, remove all individuals higher than it. Average is suggested as threshold
def calc_fitness(population, pop_distances, threshold):
    survivors = population
    survivor_distances = pop_distances
    top = survivors[0]
    y = 0
    while y < len(survivors):
        if survivor_distances[y] > threshold:
            survivor_distances.remove(survivor_distances[y])
            survivors.remove(survivors[y])
        elif calc_distance(top, distances) > survivor_distances[y]:
            top = survivors[y]
        else:
            y += 1
    return survivors, top


with open('TS_Distances_Between_Cities.csv') as csvfile:  # set up the distance array
    readCSV = csv.reader(csvfile, delimiter=',')
    cities = []
    distances = []
    indexes = []
    for row in readCSV:
        city = row[0]

        if city != '':
            cities.append(city)
            distances.append(row[1:])
    population = generate_population(POPULATION_SIZE, len(cities))
    best_candidate = copy(population[0])
    F = open('Trevor_Glassey_GA_TS_Info.txt', 'w')
    for g in range(GENERATIONS):
        F.write('Generation: ' + str(g+1) + '\n')
        F.write('Population Size: ' + str(len(population)) + '\n')
        pop_distances = calc_pop_distance(population, distances)

        average = numpy.mean(pop_distances)
        res = calc_fitness(population, pop_distances, average * 1.0)
        fit_average = numpy.mean(pop_distances)
        F.write('Average fitness score : ' + str(numpy.mean(pop_distances)) + '\n')
        F.write('Median fitness score : ' + str(numpy.median(pop_distances)) + '\n')
        F.write('STD of fitness scores : ' + str(numpy.std(pop_distances)) + '\n')

        population = res[0]

        if calc_distance(res[1], distances) < calc_distance(best_candidate, distances):
            best_candidate = copy(res[1])
        replacements = POPULATION_SIZE - len(population)
        for i in range(replacements):
            population.append(copy(population[random.randint(0, len(population)-1)]))
        for x in population:
            change(x)
    F.close()
    F = open('Trevor_Glassey_GA_TS_Result.txt', 'w')
    for c in range(len(best_candidate)):
        F.write(str(c) + '. ' + cities[best_candidate[c]] + '\n')
    F.write('Total Distance: ' + str(calc_distance(best_candidate, distances)) + '\n')
    F.close()

