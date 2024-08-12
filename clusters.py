# Required installs - put each of these starting with pip in the terminal. 
#pip install prince 
#pip install matplotlib 
#pip install kmodes

# Required imports
import numpy as np
import pandas as pd

# Set pandas display options  
pd.set_option('display.max_columns', None)  
pd.set_option('display.max_rows', None)  
pd.set_option('display.max_colwidth', None)  # Set to None for unlimited column width  

# Other imports

import matplotlib.pyplot as plt
import matplotlib.patches as patches
import matplotlib.cm as cm
import matplotlib.colors as colors

from sklearn.cluster import KMeans
from kmodes import kmodes

from sklearn.decomposition import PCA
import prince

import warnings
warnings.filterwarnings("ignore")

# Path to your data - should be a small data set ideally no more than 15 columns. 
train_data = pd.read_csv(r'C:\Users\acollins056\OneDrive - PwC\Documents\BP\BP_shortened.csv')  
#print(train_data)  # Double check that your data uploads as you expect 

feat_df = train_data.iloc[:,2:-1]
feat_df.fillna(0, inplace = True)
feat_names = feat_df.columns
print(feat_df.head()) 

# Calculating feature correlation
corr_feat_df = feat_df.corr()
corr_feat_mtx = corr_feat_df.to_numpy()

# Plotting the correlation matrix  
plt.figure(figsize=(12, 10))  
plt.imshow(corr_feat_mtx, interpolation='nearest', cmap=cm.viridis)  
plt.colorbar()  
plt.title('Feature correlation')  
  
# Adding labels for every row and column  
num_features = len(feat_names)  
ticks = np.arange(num_features)  # Create an array of tick positions for every feature  
tick_labels = feat_names  # Use all feature names as labels  
  
plt.xticks(ticks, tick_labels, rotation=90)  
plt.yticks(ticks, tick_labels)  
  
plt.tight_layout()  
plt.show()  

################### Really not to sure how to interpret what happens below here ##################
# Determine optimun number of clusters for kmeans
wcss = [] # WCSS (Within-Cluster Sum of Square) i.e. the sum of the square distance between points in a cluster and the cluster centroid.
max_num_clusters = 15
for i in range(1, max_num_clusters):
    kmeans = KMeans(n_clusters=i, init='k-means++', max_iter=300, n_init=10, random_state=0)
    kmeans.fit(corr_feat_mtx)
    wcss.append(kmeans.inertia_)
    
plt.plot(range(1, max_num_clusters), wcss)
plt.title('Elbow Method')
plt.xlabel('Number of clusters')
plt.ylabel('WCSS - Within-Cluster Sum of Square')
plt.show()

# Using kmeans to cluster the features based on their correlation
n_clusters_kmeans = 2
kmeans = KMeans(n_clusters = n_clusters_kmeans, init = 'k-means++', max_iter = 3000, n_init = 10, random_state = 0)
corr_feat_labels = kmeans.fit_predict(corr_feat_mtx)


#####################################

# Assuming feat_names and corr_feat_labels are already defined  
corr_feat_clust_df = pd.DataFrame({'feature': feat_names, 'cluster': corr_feat_labels})  
corr_feat_clust_df['feat_list'] = corr_feat_clust_df.groupby("cluster")['feature'].transform(lambda x: ', '.join(x))  
corr_feat_clust_df = corr_feat_clust_df.groupby(["cluster", "feat_list"]).size().reset_index(name='feat_count')  
print(corr_feat_clust_df)  

corr_node_dist = kmeans.transform(corr_feat_df)  
corr_clust_dist = np.c_[feat_names, np.round(corr_node_dist.min(axis=1), 3), np.round(corr_node_dist.min(axis=1) / np.max(corr_node_dist.min(axis=1)), 3), corr_feat_labels]  
corr_clust_dist_df = pd.DataFrame(corr_clust_dist, columns=['feature', 'dist_corr', 'dist_corr_norm', 'cluster_corr'])  
print(corr_clust_dist_df)  

def clustering_corr_matrix(corrMatrix, clustered_features):  
    npm = corrMatrix.to_numpy()  
    npm_zero = np.zeros((len(npm), len(npm)))  
    n = 0  
    for i in clustered_features:  
        m = 0  
        for j in clustered_features:  
            npm_zero[n, m] = npm[i, j]  
            m += 1  
        n += 1  
    return npm_zero  

import matplotlib.patches as patches  
  
def plot_clustered_matrix(clust_mtx, feat_clust_list):  
    plt.figure(figsize=(10, 8))  
    fig, ax = plt.subplots(1)  
    im = ax.imshow(clust_mtx, interpolation='nearest', cmap=cm.viridis)  
      
    corner = 0  
    for s in feat_clust_list:  
        rect = patches.Rectangle((corner, corner), s, s, linewidth=2, edgecolor='r', facecolor='none')  
        ax.add_patch(rect)  
        corner += s  
      
    fig.colorbar(im)  
    plt.title('Clustered Feature by Correlation')  
    plt.show()      
from sklearn.decomposition import PCA  
  
 
  
# Scatter plot of the different centroids along with observations once clustered  
def plotting_scatter(n_clusters, centroids, labels_mtx, title):  
    # Size and alpha values   
    obsv_lw, obsv_alp = 2, .9  
    cntr_lw, cntr_apl = 20, .55  
      
    # Generating cluster names for the legend and colors  
    target_names = ['k'+str(i) for i in range(n_clusters)]  
    colors = cm.rainbow(np.linspace(0, 1, n_clusters))  
      
    # Printing the centroids  
    for color, i, target_name in zip(colors, range(n_clusters), target_names):  
        plt.scatter(centroids[i, 0], centroids[i, 1], color=color, alpha=cntr_apl, s=cntr_lw**2)  
      
    # Printing observation  
    for color, i, target_name in zip(colors, range(n_clusters), target_names):  
        cur_label = labels_mtx[labels_mtx[:, 2] == i]  
        plt.scatter(cur_label[:, 0], cur_label[:, 1], color=color, alpha=obsv_alp, lw=obsv_lw, label=target_name)  
      
    # Adding legend to indicate which color refers to each cluster  
    handles = [plt.Line2D([0], [0], marker='o', color='w', markerfacecolor=color, markersize=10, label=target_name)   
               for color, target_name in zip(colors, target_names)]  
    plt.legend(handles=handles, loc='best', shadow=False, scatterpoints=1)  
      
    plt.title(title)  
    plt.show()  
  
# Visualizing the dispersion of each cluster in "2D"  
pca_2 = PCA(n_components=2)  
corr_pca = pca_2.fit_transform(corr_feat_df)  
corr_centr_pca = pca_2.transform(kmeans.cluster_centers_)  
  
# Concatenating the PCA values with their labels  
corr_labels_mtx = np.c_[corr_pca, corr_feat_labels]  
plotting_scatter(n_clusters_kmeans, corr_centr_pca, corr_labels_mtx, 'PCA of Clustered Features')  
plt.show()  

  
