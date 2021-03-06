import trainingset
import numpy
from sklearn import neighbors
from sklearn import cross_validation, metrics, svm


def do_knn():
    k_folds = 10
    data, labels = trainingset.load_data()                              # Load data
    cv = cross_validation.KFold(len(labels), n_folds=k_folds, shuffle=True)  # Do 10-fold cross validation with shuffling
    #classifier = neighbors.KNeighborsClassifier(n_neighbors=1)          # K nearest neighbor classifier
    #classifier = neighbors.KNeighborsClassifier(n_neighbors=5)          # K nearest neighbor classifier
    #classifier = neighbors.KNeighborsClassifier(n_neighbors=20)         # K nearest neighbor classifier
    classifier = svm.SVC(kernel='linear')                               # SVM classifier with linear kernel
    #classifier = svm.SVC(kernel='rbf',  gamma=0.0005)                    # SVM classifier with rbf kernel
    #classifier = svm.SVC(kernel='poly',degree=3)                                 # SVM classifier with poly kernel
    #classifier = svm.SVC(C=0.001, kernel='sigmoid')                      # SVM classifier with sigmoid kernel
    confusion_matrices = [0]
    for train_cv, test_cv in cv:
        data_train, labels_train = data[train_cv], labels[train_cv]     # Set training set
        data_test, labels_test = data[test_cv], labels[test_cv]         # Set testing set
        expected = labels_test
        predicted = classifier.fit(data_train, labels_train).predict(data_test)
        report = metrics.classification_report(expected, predicted)
        confusion_matrix = metrics.confusion_matrix(expected, predicted)
        print "Confusion matrix for classifier %s:\n%s\n" % (classifier, confusion_matrix)
        print "Classification report:\n%s" % report
        confusion_matrices += confusion_matrix

    match = ([0] * k_folds)
    miss = ([0] * k_folds)
    for i in range(len(confusion_matrices)):
        for j in range(len(confusion_matrices[i])):
            if j==i:
                match[j]=confusion_matrices[i][j]
            else:
                miss[j]+=confusion_matrices[i][j]

    precision = ([0] * k_folds)
    for k in range(len(match)):
        precision[k] = float(float(match[k])/float(match[k]+miss[k]))
    average_precision = float(float(sum(match))/float(sum(match)+sum(miss)))

    print "Final confusion matrix for %d times:\n%s\n" % (k_folds, confusion_matrices)
    print "Final precision\n"
    for ii in range(len(precision)):
        print "%d\t%f" % (ii, precision[ii])
    print "\nFinal average precision is %f" % average_precision

do_knn()