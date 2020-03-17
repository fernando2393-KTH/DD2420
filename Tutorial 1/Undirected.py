# THIS CODE HAS TO BE RUN ON PYTHON 2
# Otherwise, you will get wrong results

from pgmpy.models import MarkovModel
from pgmpy.factors.discrete import DiscreteFactor
from pgmpy.inference import BeliefPropagation
import numpy as np

# Construct a graph
PGM = MarkovModel()
PGM.add_nodes_from(['w1', 'w2', 'w3'])
PGM.add_edges_from([('w1', 'w2'), ('w2', 'w3')])
tr_matrix = np.array([1,2,3,10,1,3,3,5,2]).reshape(3, 3).T.reshape(-1)
phi = [DiscreteFactor(edge, [3, 3], tr_matrix) for edge in PGM.edges()]
PGM.add_factors(*phi)

# Calculate partition funtion
Z= PGM.get_partition_function()
print('The partition function is:', Z)

# Calibrate the click
belief_propagation = BeliefPropagation(PGM)
belief_propagation.calibrate()

# Output calibration result, which you should get
query=belief_propagation.query(variables=["w2"],joint=False)
print('After calibration you should get the following mu(S):',query["w2"]*Z)

# Get marginal distribution over third word
query=belief_propagation.query(variables=['w3'],joint=False)#, evidence = {'w2':0})
print ('Marginal distribution over the third word is:\n',query["w3"])

#Get conditional distribution over third word
query=belief_propagation.query(variables=['w3'], evidence = {'w1':0},joint=False) # 0 stays for "noun"
print('Conditional distribution over the third word, given that the first word is noun is:\n', query["w3"])
    
