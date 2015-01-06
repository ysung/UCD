from mpl_toolkits.mplot3d import Axes3D
import matplotlib.pyplot as plt
colors=['DeepPink', 'Gold', 'Blue', 'BlueViolet', 'Brown', 'BurlyWood',
        'DarkMagenta','Chartreuse', 'Chocolate', 'Coral', 'CornflowerBlue',
        'DarkGreen', 'Crimson', 'Cyan', 'DarkBlue', 'DarkCyan', 'DarkGoldenRod',
        'Black', 'DarkGrey', 'DarkSlateBlue']
colors2=['Yellow','Blue' , 'Red', 'Green']

def features(labels):
    p_colors=[]
    for i in range(len(labels)):
        if i==0:
            c=0
            p_colors.append(colors[c])
        else:
            if labels[i]==labels[i-1]:
                p_colors.append(colors[c])
            elif labels[i]!=labels[i-1]:
                c+=1
                p_colors.append(colors[c])
    return p_colors

def features_2(labels):
    p_colors=[]
    f_type = list(set(labels))
    for i in range(len(labels)):
        for j in range (len(f_type)):
            if labels[i]==f_type[j]:
                p_colors.append(colors2[j])
            else:
                pass
    return p_colors




# plot by 3D graph
def plot3D(X_r,p_colors):
    fig = plt.figure()
    ax = fig.add_subplot(111, projection='3d')
    ax.scatter(X_r[:,0], X_r[:,1], X_r[:,2], c=p_colors, marker='o', edgecolors='none')
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax.set_zlabel('Z')
    return plt.show()

# plot by 2D graph XY,XZ,YX,YZ,ZX,ZY
def plot2D(X_r,p_colors):
    # plot by people 2D
    fig = plt.figure()
    ax = fig.add_subplot(332)
    ax.scatter(X_r[:,0], X_r[:,1], c=p_colors, marker='o', edgecolors='none')
    ax.set_xlabel('X')
    ax.set_ylabel('Y')
    ax = fig.add_subplot(333)
    ax.scatter(X_r[:,0], X_r[:,2], c=p_colors, marker='o', edgecolors='none')
    ax.set_xlabel('X')
    ax.set_ylabel('Z')
    ax = fig.add_subplot(334)
    ax.scatter(X_r[:,1], X_r[:,0], c=p_colors, marker='o', edgecolors='none')
    ax.set_xlabel('Y')
    ax.set_ylabel('X')
    ax = fig.add_subplot(336)
    ax.scatter(X_r[:,1], X_r[:,2], c=p_colors, marker='o', edgecolors='none')
    ax.set_xlabel('Y')
    ax.set_ylabel('Z')
    ax = fig.add_subplot(337)
    ax.scatter(X_r[:,2], X_r[:,0], c=p_colors, marker='o', edgecolors='none')
    ax.set_xlabel('Z')
    ax.set_ylabel('X')
    ax = fig.add_subplot(338)
    ax.scatter(X_r[:,2], X_r[:,1], c=p_colors, marker='o', edgecolors='none')
    ax.set_xlabel('Z')
    ax.set_ylabel('X')
    return plt.show()