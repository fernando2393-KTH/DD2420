'''

This code template belongs to
"
PGM-TUTORIAL: EVALUATION OF THE 
PGMPY MODULE FOR PYTHON ON BAYESIAN PGMS
"

Created: Summer 2017
@author: miker@kth.se

Refer to https://github.com/pgmpy/pgmpy
for the installation of the pgmpy module

See http://pgmpy.org/models.html#module-pgmpy.models.BayesianModel
for examples on fitting data

See http://pgmpy.org/inference.html
for examples on inference

'''

def separator():
    input('Enter to continue')
    print('-'*70, '\n')
    
# Generally used stuff from pgmpy and others:
import math
import random
import numpy as np
import pandas as pd
from pgmpy.inference import VariableElimination
from pgmpy.inference import BeliefPropagation
from pgmpy.models import BayesianModel
from pgmpy.estimators import MaximumLikelihoodEstimator, K2Score

# Specific imports for the tutorial
import pgm_tutorial_data
from pgm_tutorial_data import ratio, get_random_partition

RAW_DATA = pgm_tutorial_data.RAW_DATA
FEATURES = [f for f in RAW_DATA]
DELAY_VAL = ['0','1','>=2','NA']

''' # Task 1 ------------ Setting up and fitting a naive Bayes PGM

data = pd.DataFrame(data=RAW_DATA)
model = BayesianModel([('delay', 'age'), ('delay', 'gender'), ('delay', 'avg_mat'), ('delay', 'avg_cs')])
# age --> 0, avg_cs --> 1, avg_mat --> 2, delay --> 3, gender --> 4

model.fit(data) # Uses the default ML-estimation

STATE_NAMES = model.cpds[0].state_names
print('State names:')
for s in STATE_NAMES:
    print(s, STATE_NAMES[s])

print('')
print(model.cpds[0])

    
separator()


# Task 1.2

print(model.cpds[3])
for i in DELAY_VAL:
    print("Probability for delay = ",i,"\t ",ratio(data, lambda t: t['delay']==i))

'''
# End of Task 1



''' # Task 2 ------------ Probability queries (inference)

data = pd.DataFrame(data=RAW_DATA)
model = BayesianModel([('delay', 'age'),
                       ('delay', 'gender'),
                       ('delay', 'avg_mat'),
                       ('delay', 'avg_cs')])
model.fit(data) # Uses the default ML-estimation

STATE_NAMES = model.cpds[0].state_names
print('State names:')
for s in STATE_NAMES:
    print(s, STATE_NAMES[s])

ve = VariableElimination(model)

"""
q = ve.query(variables = ['delay'], evidence = {'age': '<=20'}, joint=False)
print(q['delay'])
"""
"""
q = ve.query(variables = ['age'], evidence = {'delay': '0'}, joint=False)
print(q['age'])
"""

q = ve.map_query(variables = ['age'], evidence = {'delay': '0'})
print(q)

separator()
'''
# End of Task 2


"""
# Task 3 ------------ Reversed PGM

data = pd.DataFrame(data=RAW_DATA)
model = BayesianModel([('age', 'delay'),
                       ('gender', 'delay'),
                       ('avg_mat', 'delay'),
                       ('avg_cs', 'delay')])
model.fit(data) # Uses the default ML-estimation

STATE_NAMES = model.cpds[0].state_names
print('State names:')
for s in STATE_NAMES:
    print(s, STATE_NAMES[s])

print('')
print(model.cpds[3].get_values().shape)

separator()

delay, age, avgCS, avgMat, gender = model.cpds[3].values.shape
q = model.cpds[3].values
cnt = 0
for d in range(delay):
    for a in range(age):
        for a_c in range(avgCS):
            for a_m in range(avgMat):
                for g in range(gender):
                    if (np.sum(q[d,a,a_c,a_m,g]) == 0):
                        cnt += 1
                        print("Row number:", cnt, '[delay, age, avgCD, avgMat, gender]:', [d,a,a_c,a_m,g])


ve = VariableElimination(model)
q = ve.query(variables = ['delay'], joint=False)
print("Marginalization over delay:\t" + str(q['delay']))

for i in DELAY_VAL:
    print("Probability for delay = ",i,"\t ",ratio(data, lambda t: t['delay']==i))

# End of Task 3
"""


"""# Task 4 ------------ Comparing accuracy of PGM models

from scipy.stats import entropy

data = pd.DataFrame(data=RAW_DATA)

model1 = BayesianModel([('delay', 'age'),
                        ('delay', 'gender'),
                        ('delay', 'avg_mat'),
                        ('delay', 'avg_cs')])

model2 = BayesianModel([('age', 'delay'),
                        ('gender', 'delay'),
                        ('avg_mat', 'delay'),
                        ('avg_cs', 'delay')])

models = [model1, model2]

[m.fit(data) for m in models]  # ML-fit

STATE_NAMES = model2.cpds[3].state_names
print('\nState names:')
for s in STATE_NAMES:
    print(s, STATE_NAMES[s])

S = STATE_NAMES

VARIABLES = list(S.keys())
print("..................")
def random_query(variables, target):
    # Helper function, generates random evidence query
    n = random.randrange(1, len(variables) + 1)
    evidence = {v: random.choice(S[v]) for v in random.sample(variables, n)}
    if target in evidence: del evidence[target]
    return (target, evidence)

queries = []
for target in ['delay', 'age']:
    variables = [v for v in VARIABLES if v != target]
    queries.extend([random_query(variables, target) for _ in range(200)])

divs = []
for v, e in queries:
    # Relative frequencies, compared below
    rf = [ratio(RAW_DATA, lambda t: t[v] == s,
                lambda t: all(t[k] == w for k, w in e.items())) \
            for s in S[v]]

    print(len(divs), '-' * 20)
    print('rf: ', rf)

    div = [(v, e), rf]
    for m in models:
        ve = VariableElimination(m)
        q = ve.query(variables=[v], evidence=e, show_progress=False)
        div.extend([q.values, entropy(q.values, rf)])
        print('PGM:', q.values, ', Divergence:', div[-1])
    divs.append(div)

divs2 = [r for r in divs if math.isfinite(r[3]) and math.isfinite(r[5])]
# What is the meaning of what is printed below?
for n in range(1,5):
    print('\n N =', n)
    print([len([r for r in divs2 if len(r[0][1]) == n]), 
            len([r for r in divs2 if len(r[0][1]) == n and r[3] < r[5]]), # % M1 wins 
            len([r for r in divs2 if len(r[0][1]) == n and r[3] > r[5]]), # % M2 wins 
            len([r for r in divs if len(r[0][1]) == n and \
                not (math.isfinite(r[3]) and math.isfinite(r[5]))]), # number of infinities 
            sum(r[3] for r in divs2 if len(r[0][1]) == n), # sum for M1
            sum(r[5] for r in divs2 if len(r[0][1]) == n)]) # sum for M2

# The following is required for working with same data in next task:
import pickle
f = open('data.pickle', 'wb')
pickle.dump(divs2, f)
f.close()

separator()


# End of Task 4
"""



''' # Task 5 ------------ Checking for overfitting

from scipy.stats import entropy

data = pd.DataFrame(data=RAW_DATA)

model1 = BayesianModel([('delay', 'age'),
                       ('delay', 'gender'),
                       ('delay', 'avg_mat'),
                       ('delay', 'avg_cs')])

model2 = BayesianModel([('age', 'delay'),
                        ('gender', 'delay'),
                        ('avg_mat', 'delay'),
                        ('avg_cs', 'delay')])

models = [model1, model2]

[m.fit(data) for m in models] # ML-fit

STATE_NAMES = model1.cpds[0].state_names
print('\nState names:')
for s in STATE_NAMES:
    print(s, STATE_NAMES[s])

S = STATE_NAMES

# Assumes you pickled data from previous task
import pickle
divs_in = pickle.load(open('data.pickle', 'rb'))

divs = []
k_fold = 5
for k in range(k_fold):
    # Dividing data into 75% training, 25% validation.
    # Change the seed to something of your choice:
    seed = 'your personal random seed string' + str(k)
    raw_data1, raw_data2 = get_random_partition(0.75, seed)
    training_data = pd.DataFrame(data=raw_data1)
    # refit with training data
    [m.remove_cpds(*m.cpds) for m in models] # Gets rid of warnings
    [m.fit(training_data) for m in models]
    for i, div in enumerate(divs_in):
        print(len(divs_in)*k + i,'/', len(divs_in)*k_fold)
        div = div[:] # Make a copy for technical reasons
        try:
            v, e = div[0]
            # Relative frequencies from validation data, compared below
            rf = [ratio(raw_data2, lambda t: t[v]==s,
                        lambda t:all(t[w] == S[w][e[w]] for w in e)) \
                  for s in S[v]]
            for m in models:
                #print('\nModel:', m.edges())
                ve = VariableElimination(m)
                q = ve.query(variables = [v], evidence = e)
                div.append(entropy(rf, q[v].values))
                #print('PGM:', q[v].values, ', Divergence:', div[-1])
            divs.append(div)
        except IndexError:
            print('fail')

# Filter out the failures
divs2 = [d for d in divs if len(d) == 8]

# Modify the following lines according to your needs.
# Perhaps turn it into a loop as well.
n = 1
print([len([r for r in divs2 if len(r[0][1])==n]),
       len([r for r in divs2 if len(r[0][1])==n and r[3] < r[5]]),
       len([r for r in divs2 if len(r[0][1])==n and r[3] > r[5]]),
       len([r for r in divs2 if len(r[0][1])==n and r[-2] < r[-1]]),
       len([r for r in divs2 if len(r[0][1])==n and r[-2] > r[-1]])])

separator()
'''
# End of Task 5


"""
# Task 6 ------------ Finding a better structure

data = pd.DataFrame(data=RAW_DATA)

model1 = BayesianModel([('delay', 'age'),
                       ('delay', 'gender'),
                       ('delay', 'avg_mat'),
                       ('delay', 'avg_cs')])

model2 = BayesianModel([('age', 'delay'),
                        ('gender', 'delay'),
                        ('avg_mat', 'delay'),
                        ('avg_cs', 'delay')])

models = [model1, model2]

[m.fit(data) for m in models] # ML-fit

STATE_NAMES = model1.cpds[0].state_names
print('\nState names:')
for s in STATE_NAMES:
    print(s, STATE_NAMES[s])

# Information for the curious:
# Structure-scores: http://pgmpy.org/estimators.html#structure-score
# K2-score: for instance http://www.lx.it.pt/~asmc/pub/talks/09-TA/ta_pres.pdf
# Additive smoothing and pseudocount: https://en.wikipedia.org/wiki/Additive_smoothing
# Scoring functions: https://www.cs.helsinki.fi/u/bmmalone/probabilistic-models-spring-2014/ScoringFunctions.pdf
k2 = K2Score(data)
print('Structure scores:', [k2.score(m) for m in models])

separator()

print('\n\nExhaustive structure search based on structure scores:')

from pgmpy.estimators import ExhaustiveSearch

# Warning: Doing exhaustive search on a PGM with all 5 variables
# takes more time than you should have to wait. Hence
# re-fit the models to data where some variable(s) has been removed
# for this assignement.
raw_data2 = {'age': data['age'],
             'avg_cs': data['avg_cs'],
             'avg_mat': data['avg_mat'],
             'delay': data['delay'], # Don't comment out this one
             #'gender': data['gender'],
             }

data2 = pd.DataFrame(data=raw_data2)

import time
t0 = time.time()
# Uncomment below to perform exhaustive search
searcher = ExhaustiveSearch(data2, scoring_method=K2Score(data2))
search = searcher.all_scores()
print('time:', time.time() - t0)

# Uncomment for printout:
for score, model in search:
    print("{0}        {1}".format(score, model.edges()))

separator()

print('\nTask 6.5:\n')

from pgmpy.estimators import HillClimbSearch, BicScore

est = HillClimbSearch(data2)
best_model = est.estimate()
sorted(best_model.nodes())
print("Best models are: ",best_model.edges())

est_bicScore = HillClimbSearch(data2, scoring_method=BicScore(data2))
best_model = est_bicScore.estimate()
sorted(best_model.nodes())
print("\n Best models are with bic Score: ",best_model.edges())

separator()


# End of Task 6
"""