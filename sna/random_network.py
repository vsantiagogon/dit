"""
Generate a random graph
Draw degree histogram with matplotlib.
Add a box to the histogram with some network stats: average degree, size of the giant component, average cluster coefficient
"""
import collections
import matplotlib.pyplot as plt
import networkx as nx

#a function to get the average of a list
def avg(l):   
	return sum(l) / float(len(l))
 
	
G = nx.barabasi_albert_graph(200, 10)  #generate a random graph, 100 nodes, p=0.02 (probabilituy of a link)

degree_sequence=sorted([d for d in dict(G.degree()).values()], reverse=True)  #take the degree of each node and sort them from the highest one

degreeCount=collections.Counter(degree_sequence)  #generate a frequency distribution, a list of pairs (degree,count), telling you for each degree the number of nodes with that degree
deg, cnt = zip(*degreeCount.items())

fig, ax = plt.subplots()		#generate a plot with a figure and an axis object
plt.bar(deg, cnt, width=0.80, color='b')	#draw the histogram

#set some features of the graph
plt.title("Degree Histogram")
plt.ylabel("Count")
plt.xlabel("Degree")
ax.set_xticks([d+0.4 for d in deg])
ax.set_xticklabels(deg)


#Find the Connected compoments
CC = sorted(nx.connected_components(G), key = len, reverse=True) #sort by len, the first element is the giant component
gcc = len(CC[0])/float(len(G.nodes()))   #compute the size of the giant component over the total number of nodes

#culster coefficient
avg_cf = nx.average_clustering(G)

#prepare the textbox
textstr = '<d>=%.2f\nGCC=%.2f\n<cf>=%.2f'%(avg(degree_sequence), 100*gcc, avg_cf)

# these are matplotlib.patch.Patch properties for the label
props = dict(boxstyle='round', facecolor='wheat', alpha=0.5)

# place a text box in upper left in axes coords
ax.text(0.05, 0.95, textstr, transform=ax.transAxes, fontsize=13,
        verticalalignment='top', bbox=props)


# add another picture for the graph of the network
f3 = plt.figure()
pos=nx.spring_layout(G)
nx.draw_networkx_nodes(G, pos, node_size=20)
nx.draw_networkx_edges(G, pos, alpha=0.4)
f3.suptitle('Network Diagram', fontsize=14, fontweight='bold')

plt.show()  #show all the figures
