import csv
import matplotlib.pyplot as plt


def drawWritings(dataList):
    fig = plt.figure(1)
#    for data in dataList:
    for i in range(0, len(dataList)):
        data = dataList[i]
        xs = data[0:14:2]
        ys = data[1:15:2]
        #xs.append (data[0])
       # ys.append (data[1])
#        print xs
#        print ys
        subFig = fig.add_subplot(10, 10, i)
        subFig.plot(xs, ys)
        subFig.axes.get_xaxis().set_visible(False)
        subFig.axes.get_yaxis().set_visible(False)
    plt.show()


csvFile = open('pendigits-orig.csv', 'rb')
csvReader = csv.reader(csvFile, delimiter=',')

# convert into a list of hand writings (each handwriting is a list of x, y coordinates. And the last element is the number written)
data = []

for row in csvReader:
    formatRow = [int(x) for x in row]
    data.append(formatRow)


# pick a number and filter out all others
filteredData = [x for x in data if x[16]==0]


# draw data
drawWritings(filteredData[0:100])