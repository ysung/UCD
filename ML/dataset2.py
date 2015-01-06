from PIL import Image
import os
import numpy
from sklearn.decomposition import PCA, KernelPCA, RandomizedPCA
from sklearn.manifold import MDS, Isomap, LocallyLinearEmbedding
from sklearn.metrics import euclidean_distances
from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
import plot as m_plot
import re
import pylab as pl
from sklearn.metrics import silhouette_score

image_shape = (64, 60)

path = "Images/"
listing = os.listdir(path)

# read pixels from 624 faces (64*60), construct a 624*3080 matrix
def all_data(listing):
    faces = []
    labels = []
    for z in range(len(listing)):
        pat ="(\w+)_(\w+)_(\w+)_(\w+)_" #regular expression pattern
        match = re.search(pat,listing[z])
        labels.append(list(match.groups()))
        im = Image.open(path + listing[z]) #read image
        pix = im.load()
        data = []
        for i in range(image_shape[0]):
            for j in range(image_shape[1]):
                data.append(pix[i, j])
        faces.append(data)
    return numpy.asarray(faces), numpy.asarray(labels)

def specific_data(pattern, listing):
    faces = []
    labels = []
    for z in range(len(listing)):
        if re.search(pattern,listing[z]) is None:
            pass
        else:
            #print listing
            pat ="(\w+)_(\w+)_(\w+)_(\w+)_" #regular expression pattern
            match = re.search(pat,listing[z])
            labels.append(list(match.groups()))
            im = Image.open(path + listing[z]) #read image
            pix = im.load()
            data = []
            for i in range(image_shape[0]):
                for j in range(image_shape[1]):
                    data.append(pix[i, j])
            faces.append(data)
    return numpy.asarray(faces), numpy.asarray(labels)

def ei_faces(ei):
    c=131
    for i in range(len(ei)):
        f=numpy.reshape(ei[i],(-1,60))
        plt.subplot(c)
        plt.imshow(f.T, cmap = pl.cm.hot)
        c+=1
    plt.show()

#plot people
def p2D3D(X,labels):
    p_colors=m_plot.features(labels[:,0])
    m_plot.plot3D(X,p_colors)
    m_plot.plot2D(X,p_colors)
    '''
    #plot side
    p_colors=m_plot.features_2(labels[:,1])
    m_plot.plot3D(X,p_colors)
    m_plot.plot2D(X,p_colors)

    #plot emotion
    p_colors=m_plot.features_2(labels[:,2])
    m_plot.plot3D(X,p_colors)
    m_plot.plot2D(X,p_colors)

    #plot sunglasses
    p_colors=m_plot.features_2(labels[:,3])
    m_plot.plot3D(X,p_colors)
    m_plot.plot2D(X,p_colors)
    '''

faces, labels = specific_data("straight\w+open", listing)
n_samples, n_features = faces.shape

# global centering
faces_centered = faces - faces.mean(axis=0)

# local centering
# faces_centered -= faces_centered.mean(axis=1).reshape(n_samples, -1)

print("Dataset consists of %d faces" % n_samples)

'''
#Kernel PCA
kpca = KernelPCA(n_components=3, kernel='poly', gamma=1e-6, degree=1, coef0=100)
V  = kpca.fit_transform(faces_centered)
s_score = silhouette_score(V,labels[:,0],metric="euclidean")
#print s_score


#Random PCA
rpca = RandomizedPCA(n_components=3)
W  = rpca.fit_transform(faces_centered)
project_W = rpca.components_
s_score = silhouette_score(W,labels[:,0],metric="euclidean")
#print s_score

#PCA
pca = PCA(n_components=3)
X = pca.fit_transform(faces_centered)
project_X = pca.components_
s_score = silhouette_score(X,labels[:,0],metric="euclidean")
#print s_score

#show eigen faces
#ei_faces(project_V)
ei_faces(project_W)
ei_faces(project_X)
'''


#Isomap

def ISO(i,faces_centered,labels):
    s_3=[]
    for y in range(1,i):
        iso = Isomap(n_neighbors=y, n_components=3)
        Y = iso.fit_transform(faces_centered)
        s_score3=silhouette_score(Y,labels,metric="euclidean")
        s_3 += [[s_score3, y]]
        #print s_3for i in range(1,78):
        #print max(s_3)
    return Y, numpy.asarray(s_3)

def LLE(i,faces_centered,labels):
    s_4=[]
    for y in range(5,i):

        lle = LocallyLinearEmbedding (n_neighbors=y, n_components=3, eigen_solver='auto',
                               method='standard')
        Z = lle.fit_transform(faces_centered)
        s_score4=silhouette_score(Z,labels,metric="euclidean")
        #print i
        s_4 += [[s_score4, y]]
        #print s_score4
        #print max(s_4)
    return Z, numpy.asarray(s_4)

fig = plt.figure()
ax = fig.add_subplot(111)
Y, s_3=ISO(20,faces_centered,labels[:,0])
Z, s_4=LLE(20,faces_centered,labels[:,0])
print s_3, s_4
ax.plot(s_3[:,1], s_3[:,0], c='r', label='ISOMAP')#, edgecolors='none')
ax.plot(s_4[:,1], s_4[:,0],label='LLE')#, edgecolors='none')
ax.legend()
ax.set_xlabel('neighbors')
ax.set_ylabel('Silhouett escore')
#plt.show()
#print Y,Z




'''
p2D3D(Y,labels)
p2D3D(Z,labels)
Y, s_score3=ISO(4,faces_centered,labels[:,0])
Z, s_score4=LLE(13,faces_centered,labels[:,0])
p2D3D(Y,labels)
p2D3D(Z,labels)

# p2D3D(W,labels)
#p2D3D(X,labels)
# p2D3D(Y,labels)
# p2D3D(Z,labels)


# similarities = euclidean_distances(faces_centered)
yy = MDS(n_components=3).fit_transform(similarities)














##############

#print 'PCA - SVD used'
#U, S, V = numpy.linalg.svd(faces_centered)
##U[:,:3]*S[:3]==X_r!!!
#print V[:3]==pca.components_ #projection vector
#


#
# ax.legendx
# ax.set_xlim3d(0, np.min(len(test)))
# ax.set_ylim3d(np.min(train+test)*0.9, np.max(train+test))
# ax.set_zlim3d(0, 2)


#plt.savefig("test_output.png",dpi=500,format="png")


# kpca = KernelPCA(kernel="rbf", fit_inverse_transform=True, gamma=10)
# X_kpca = kpca.fit_transform(X)
# X_back = kpca.inverse_transform(X_kpca)
# pca = PCA()
# X_pca = pca.fit_transform(X)
#
# def randrange(n, vmin, vmax):
#     return (vmax-vmin)*np.random.rand(n) + vmin
#
# fig = plt.figure()
# ax = fig.add_subplot(111, projection='3d')
# n = 100
# for c, m, zl, zh in [('r', 'o', -50, -25), ('b', '^', -30, -5)]:
#     xs = randrange(n, 23, 32)
#     ys = randrange(n, 0, 100)
#     zs = randrange(n, zl, zh)
#     ax.scatter(xs, ys, zs, c=c, marker=m)
#
# ax.set_xlabel('X Label')
# ax.set_ylabel('Y Label')
# ax.set_zlabel('Z Label')
#
# plt.show()
'''