import re
Gram = {}
first = {}
follow = {}

with open ("grammar.txt", "r") as myfile:
	string=myfile.read()
Gramarr = string.strip().split("\n")
lis=[] #contains all Non Terminals
print "Initial grammar for first and follow set is:\n"
for i in Gramarr:
	if i == '\t' or i == '':
		continue
	x = i.split(":")
	print(x)
	lhs=x[0].strip()
	lis.append(lhs)
	if(lhs not in Gram):
		Gram[lhs]=[n.split() for n in x[1].split("|")];
	else:
		Gram[lhs].append([n.split() for n in x[1].split("|")])
#print(Gram)
def findFirst(x):
	global first,Gram
	for i in Gram[x]:
		for j in i:
			if(j.islower()):
				findFirst(j)
				#print "first of " + j + " is ",
				#print first[j]
				first[x]=first[x].union(first[j])
				if('e' not in first[j]):
					break;
			else:
				first[x].add(j)
				break;
				
def findFollow():
	global Gram,first,follow
	
	for i in Gram:
		for j in Gram[i]:
			for k in range(len(j)):
				x=k
				if(j[x].islower()):
					while(x+1<len(j)):
						if(j[x+1].islower()):
							follow[j[k]]=follow[j[k]].union(first[j[x+1]]);
							if('e' in first[j[x+1]]):
								follow[j[k]].remove('e')
								x+=1
							else:
								break;
						else:
							if(j[x+1] != 'e'):
								follow[j[k]].add(j[x+1])
								
								break;
							else:
								follow[j[k]]=follow[j[k]].union(follow[i]);
								break;
						
						
					else:
						follow[j[k]]=follow[j[k]].union(follow[i]);
						

for i in Gram:
	first[i]=set([]) #initialise sets for first and follow
	follow[i]=set([])
follow[lis[0]].add("$")
print "\n"
for i in lis:
	findFirst(i) #Call findFirst for every element
for i in lis:
	findFollow(); #Call findFollow for every element
print "**********************************\n"
print "First for the given grammar is:\n"
for i in lis:
	print "First ("+i+") : ",first[i]
	print "\n"
print "**********************************\n"
print "Follow set for the given grammar is:\n"
for i in lis:
	
	print "Follow ("+i+") : ",follow[i] 
	print "\n"
print "**********************************\n"


	


		
	
					
			
		
		




		
