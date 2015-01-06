import csv
import numpy

def load_data():
    data = []
    labels = []
    file_read = csv.reader(open("pendigits-orig.csv", "rb"), delimiter = "\t")   # Read file
    training_set = list(file_read)                                              # Get matrix
    training_set.pop()
    #random_index = numpy.random.permutation(range(len(training_set)))           # Random index
    for row in training_set:
        #row = training_set[random_index[i]]     # Get random row
        coordinate, label = format_data(row[0]) # Format training set to coordinate and label
        data.append(numpy.array(coordinate))                 # Set Data
        labels.append(numpy.array(label))                    # Set Labels
    return numpy.array(data), numpy.array(labels)

def format_data(row):
    chars = row.replace(",", " ").split()       # Replace comma with space
    ints = [float(char) for char in chars]        # Chars to ints
    label = ints.pop()                          # Last int to label
    #coordinate = [(x,y) for x,y in zip(ints[::2], ints[1::2])]
    coordinate = ints
    return coordinate, label
