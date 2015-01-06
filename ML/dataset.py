__author__ = 'SUNG'

import re
import csv
import numpy as np
import operator
import copy as co
from sklearn import cross_validation, metrics, svm, neighbors

def load_data(name):
    data=[]
    target=[]
    with open(name, 'rU') as f:
        reader = csv.reader(f)
        for row in reader:
            target.append(row.pop())
            data.append(row)
    label=data[0]
    del data[0]
    del target[0]
    f.close

    training_set = np.delete(data, np.s_[0:6], 1)  # delete first to third row of data
    training_set = np.delete(training_set, np.s_[1:3], 1)  # delete first to third row of data
    training_set = np.delete(training_set, np.s_[2:4], 1)  # delete first to third row of data
    training_set = [map(float, row) for row in training_set]
    #print training_set[0],"\n",training_set[1],"\n"

    new_t_set=co.copy(training_set)
    new_t_tar=co.copy(target)

    count=0
    for row in data:
        #print count
        if count%2==0:
            pass
        else:
            tmp=map(operator.sub, training_set[count], training_set[count-1])
            new_t_set[count-1]=map(operator.sub, training_set[count-1], training_set[count])
            new_t_set[count]=tmp
            if int(new_t_tar[count])-int(new_t_tar[count-1]) >= 1:
                new_t_tar[count]=1
                new_t_tar[count-1]=0
            else:
                new_t_tar[count]=0
                new_t_tar[count-1]=1
        count+=1

    new_t_tar=np.array(new_t_tar)
    new_t_set=np.array(new_t_set)

    return new_t_set,new_t_tar
    #print target
    #print new_t_tar
    # new_t_tar=np.array(new_t_tar)
    # new_t_set=np.array(new_t_set)


    # print training_set[0],"\n",training_set[1],"\n"
    # print new_t_set[0],"\n",map(operator.sub, training_set[0], training_set[1]),"\n\n"
    # print new_t_set[1],"\n",map(operator.sub, training_set[1], training_set[0])
    #map(operator.sub, training_set[0], training_set[1])
    #map(float.__sub__, training_set[0], training_set[1])