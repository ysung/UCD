def wordBreak(s="asdasd", i=0):
	while i <= len(s) :
		i = i+1
		print(i)
		if i > len(s)+1:
			return(False)
	return(True)

a = wordBreak()
print(a)


