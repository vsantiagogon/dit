import collections
import matplotlib.pyplot as plt
import networkx  as nx

#plot of the size of the GCC in a random network by average degree

gcc_list=[]
num_nodes =  200
#diagram of the size of the GCC as a function of p
for j in range(0,70):   #seventy points, each time i increase the probability (and therefore the average degree = p*(n-1) ,  n is the number of nodes)
	G = nx.gnp_random_graph(num_nodes, 0.0003*j)
	
	#Connected compoments
	CC = sorted(nx.connected_components(G), key = len, reverse=True) #sort by len, the first element is the giant component
	gcc = len(CC[0])/float(len(G.nodes()))
	gcc_list.append(gcc)  #create a list of the sizes of the GCC


fig, ax = plt.subplots()
plt.title("Sizr of GCC component")
plt.ylabel("Size %")
plt.xlabel("p")
#plot x=degree . y = size of giant connected component
plt.plot([d*0.0003*(num_nodes-1) for d in range(0,70)],gcc_list)

plt.show()  #show all the figures

