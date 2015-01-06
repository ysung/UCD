__author__ = 'SUNG'

import re
import csv
import numpy as np
#from sklearn.manifold import MDS, Isomap, LocallyLinearEmbedding
#from sklearn.decomposition import PCA, KernelPCA, RandomizedPCA
import operator
from sklearn.feature_selection import SelectPercentile, f_classif
import copy as co
import pylab as pl
import knn
from sklearn.metrics import silhouette_score
from sklearn.cross_validation import*
from sklearn.grid_search import GridSearchCV
from sklearn.svm import SVC
from sklearn import metrics, neighbors
import matplotlib.pyplot as plt

##################### Training Data Selection ##########################
def load_data(name,pattern):
    data=[]
    with open(name, 'rU') as f:
        reader = csv.reader(f)
        for row in reader:
            if re.search(pattern, row[0]) is None:
                pass
            else:
                data.append(row)
        f.close
    data = np.asarray(data)
    scores = data[:,-1]
    teams = data[:,2]
    #training_set = np.delete(data, np.s_[0:6], 1)  # delete first to third row of data
    training = np.delete(np.asarray(data), (0,1,2,3,4,5,7,8,10,11,21), 1)  # delete first to third row of data
    training = np.asarray([map(float, row) for row in training])
    return data, training, scores, teams

##################### Test Data Selection #############################

def load_test(name):
    data=[]
    with open(name, 'rU') as f:
        reader = csv.reader(f)
        for row in reader:
            if re.search("\*", row[0]) is None:
                pass
            else:
                data.append(row)
        f.close
    data = np.asarray(data)
    scores = data[:,-1]
    teams = data[:,0]
    #training_set = np.delete(data, np.s_[0:6], 1)  # delete first to third row of data
    testing = np.delete(np.asarray(data), (0,1,2,3,4,6,7,9,10,20), 1)  # delete first to third row of data
    testing = np.asarray([map(float, row) for row in testing])
    testing = testing/int(data[1,1])
    test_set = []
    test = []
    for i in range(len(testing)):
        for j in range(len(testing)):
            if j==i:
                test.append(testing[i]-testing[j])
            else:
                test.append(testing[i]-testing[j])
                #test_set.append(test)
        #test_set = np.asmatrix(test_set)
    test=np.asarray(test)
    return data, test, scores, teams

######################### Team Selection #############################
def s_team_data(options, pattern, data_set, label_set, vs_teams):
    new_data=[]
    new_labels=[]
    if options == "team":
        for z in range(len(vs_teams)):
            if re.search(pattern, vs_teams[z,0]) is None:
                pass
            else:
                new_data += [data_set[z]]
                new_labels += [label_set[z]]
    elif options == "match":
        for z in range(len(vs_teams)):
            if re.search(pattern, vs_teams[z,0]+vs_teams[z,1]) is None:
                pass
            else:
                new_data+=[data_set[z]]
                new_labels += [label_set[z]]
    else:
        print "wrong parameter"
    return np.array(new_data), np.array(new_labels)

##########################Score Selection #############################
def score_sel(training, scores, digit):
    t_set= []
    labels= []
    for row in range(1, len(training),2):
        #print row
        #tmp=map(operator.sub, training_set[count], training_set[count-1])# if data_type is list
        if np.abs(int(scores[row])-int(scores[row-1])) <= digit:
            t_set.append(training[row-1] - training[row])
            t_set.append(training[row] - training[row-1])
            if int(scores[row])-int(scores[row-1]) >= 1:
                labels.extend([0, 1])
            else:
                labels.extend([1, 0])
        else:
            pass
    return np.asarray(labels), np.asarray(t_set)

########################### Main ########################################
data, training, scores, teams = load_data("NBA.csv","2009 Playoffs")
t_data, testing, t_scores, t_teams = load_test("2009_2010_NBA_Team.csv")
# new_data, new_labels = s_team_data('match', 'BostonLA Lakers', t_set, labels, vs_teams)
##################### Translate score to label ########################
t_set = co.copy(training) # training data
labels = co.copy(scores) # win=1 lose=-1
vs_teams = []
for row in range(1, len(training),2):
    #print row
    #tmp=map(operator.sub, training_set[count], training_set[count-1])# if data_type is list
    t_set[row-1] = training[row-1] - training[row]
    t_set[row] = training[row] - training[row-1]
    vs_teams += [[teams[row-1], teams[row]],[teams[row], teams[row-1]]]
    if int(scores[row])-int(scores[row-1]) >= 1:
        labels[row]=1
        labels[row-1]=0
    else:
        labels[row]=0
        labels[row-1]=1
labels = np.asarray(map(int, labels))
vs_teams=np.array(vs_teams)

######################grid for SVM#####################################

X = co.copy(t_set)
Y = co.copy(labels)
C_range = 2.0 ** np.arange(14, 19)
gamma_range = 2.0 ** np.arange(-15, -10)
#np.hstack ((2.0 ** np.arange(-13, -9), 2.0 ** np.arange(6, 12)))
param_grid = dict(gamma=gamma_range, C=C_range)
cv = StratifiedKFold(y=Y, n_folds=3)
grid = GridSearchCV(SVC(cache_size=1000), param_grid=param_grid, cv=cv)
grid.fit(X, Y)
print("The best classifier is: ", grid.best_estimator_)

score_dict = grid.grid_scores_
#print score_dict

# We extract just the scores
scores = [x[1] for x in score_dict]
scores = np.array(scores).reshape(len(C_range), len(gamma_range))

# draw heatmap of accuracy as a function of gamma and C
pl.figure(figsize=(8, 6))
pl.subplots_adjust(left=0.05, right=0.95, bottom=0.15, top=0.95)
pl.imshow(scores, interpolation='nearest', cmap=pl.cm.spectral)
pl.xlabel('gamma')
pl.ylabel('C')
pl.colorbar()
pl.xticks(np.arange(len(gamma_range)), gamma_range, rotation=45)
pl.yticks(np.arange(len(C_range)), C_range)

pl.show()


###################### SVM #####################################


clf = SVC(kernel='rbf', C=2**7, gamma=2**-9)
predicted = clf.fit(t_set, labels).predict(testing)
predictmap=np.reshape(predicted,(-1,16))
#print (predictmap.transpose(1, 0) == predictmap).all()

with open('prediction_2006_1.csv', 'wb') as f:
     writer = csv.writer(f)
     writer.writerow(t_teams)
     writer.writerows(predictmap)

a=[0,1,4]
clf = SVC(kernel='rbf', C=2**7, gamma=2**-9)
predicted = clf.fit(t_set[:,a], labels).predict(testing[:,a])
#scores=cross_val_score(clf, t_set, labels, cv=10)
predictmap=np.reshape(predicted,(-1,16))
#print predictmap.T==predictmap
#print (predictmap.transpose(1, 0) == predictmap).all()

with open('prediction_2006_2.csv', 'wb') as f:
    writer = csv.writer(f)
    writer.writerow(t_teams)
    writer.writerows(predictmap)


fig = plt.figure()
ax = fig.add_subplot(111)
X=[2007-2008,2008-2009,2009-2010,2010-2011,2011-2012]
Y_f=[float(10)/15,float(11)/15,float(10)/15,float(11)/15,float(9)/15]
Y_a=[float(8)/15,float(10)/15,float(9)/15,float(7)/15,float(8)/15]
#print s_3, s_4
ax.plot(X, Y_f, c='r', label='F-score + SVM',linewidth = 3)#, edgecolors='none')
ax.plot(X, Y_a,label='SVM',linewidth = 3)#, edgecolors='none')
ax.legend()

ax.set_ylim(0, 1)
#ax.set_xlim(2005,2012)
plt.xticks(X, X )
ax.set_xlabel('Year')
ax.set_ylabel('Accuracy')
plt.show()


########################## CV ########################################

#clf = SVC(kernel='rbf', C=2**11, gamma=2**-11)
#scores=cross_val_score(clf, t_set, labels, cv=10)
#print scores

# plot the scores of the grid
# grid_scores_ contains parameter settings and scores


############################# Fscore ###################################

def Fscore(t_set, labels):

    F=[]
    b=0
    number=len(labels[labels>0])
    for i in range (t_set.shape[1]):
        k1=np.mean(t_set[:,i][labels>0])
        k2=np.mean(t_set[:,i][labels<=0])
        a=(k1-np.mean(t_set))**2+(k2-np.mean(t_set))**2
        for j in range (number):
            b += ((t_set[j,i]-k1)**2+(t_set[j,i]-k2)**2)/(number-1)
        F.append(float(a/b))
    return F



####################   Feature Selection ######################################
###############################################################################
# pl.figure(1)
# pl.clf()
#
# X_indices = np.arange(X.shape[-1])

###############################################################################
# Univariate feature selection with F-test for feature scoring
# We use the default selection functixon: the 10% most significant features
# selector = SelectPercentile(f_classif, percentile=10)
# selector.fit(X, y)
# scores = -np.log10(selector.pvalues_)
# scores /= scores.max()
# pl.bar(X_indices - .45, scores, width=.2,
#        label=r'Univariate score ($-Log(p_{value})$)', color='g')

###############################################################################
# Compare to the weights of an SVM
# clf = SVC(kernel='linear')
# clf.fit(X, y)
#
# svm_weights = (clf.coef_ ** 2).sum(axis=0)
# svm_weights /= svm_weights.max()
#
# pl.bar(X_indices - .25, svm_weights, width=.2, label='SVM weight', color='r')
#
# clf_selected = SVC(kernel='linear')
# clf_selected.fit(selector.transform(X), y)
#
# svm_weights_selected = (clf_selected.coef_ ** 2).sum(axis=0)
# svm_weights_selected /= svm_weights_selected.max()
#
# pl.bar(X_indices[selector.get_support()] - .05, svm_weights_selected, width=.2,
#        label='SVM weights after selection', color='b')
#
#
# pl.title("Comparing feature selection")
# pl.xlabel('Feature number')
# pl.yticks(())
# pl.axis('tight')
# pl.legend(loc='upper right')
# pl.show()


