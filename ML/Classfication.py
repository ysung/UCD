__author__ = 'SUNG'

from sklearn import neighbors
from sklearn import cross_validation, metrics, svm


def classification(k,c,new_t_set,new_t_tar):
    classifier = svm.SVC(kernel='rbf',  gamma=k, C=c)                    # SVM classifier with rbf kernel
    confusion_matrices = [0]
    #for train_cv, test_cv in cv:
    data_train, labels_train = new_t_set[train_cv], new_t_tar[train_cv]     # Set training set
    data_test, labels_test = new_t_set[test_cv], new_t_tar[test_cv]         # Set testing set
    expected = labels_test
    predicted = classifier.fit(data_train, labels_train).predict(data_test)
    report = metrics.classification_report(expected, predicted)
    confusion_matrix = metrics.confusion_matrix(expected, predicted)
    #print "Confusion matrix for classifier %s:\n%s\n" % (classifier, confusion_matrix)
    #print "Classification report:\n%s" % report
    confusion_matrices += confusion_matrix

    match = ([0] * 2)
    miss = ([0] * 2)
    for i in range(len(confusion_matrices)):
        for j in range(len(confusion_matrices[i])):
            if j==i:
                match[j]=confusion_matrices[i][j]
            else:
                miss[j]+=confusion_matrices[i][j]

    # print "MMMMM",match
    # print "SHIT",miss
    precision = ([0] * 2)
    for k in range(len(match)):
        precision[k] = float(float(match[k])/float(match[k]+miss[k]))
    average_precision = float(float(sum(match))/float(sum(match)+sum(miss)))

    #print "Final confusion matrix for %d times:\n%s\n" % (k_folds, confusion_matrices)
    #print "Final precision\n"
    #for ii in range(len(precision)):
    #    print "%d\t%f" % (ii, precision[ii])
    print "Final average precision is %f" % average_precision
