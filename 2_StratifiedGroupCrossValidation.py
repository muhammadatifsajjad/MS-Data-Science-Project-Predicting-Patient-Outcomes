"""
 Credits: 
     Code adapted from https://www.kaggle.com/jakubwasikowski/stratified-group-k-fold-cross-validation
 
 Description:
     Splits train data into 80% (training) and 20% (testing)
     Performs k-fold cross-valiation on 80% training data
     Class balance is preserved across each set
     Multiple rows of same MASTERPATIENTID always belong to the same set within each fold
"""

import os
import random
import pandas as pd
import numpy as np
from sklearn import preprocessing
from sklearn.model_selection import GroupKFold
from collections import Counter, defaultdict

os.chdir(r'C:\\FINAL')

# -----------------------------------------------------------------------------
# 						   CODE FOR STRATIFIED GROUP K-FOLD
# -----------------------------------------------------------------------------

def stratified_group_k_fold(X, y, groups, k, seed=None):
    labels_num = np.max(y) + 1
    y_counts_per_group = defaultdict(lambda: np.zeros(labels_num))
    y_distr = Counter()
    for label, g in zip(y, groups):
        y_counts_per_group[g][label] += 1
        y_distr[label] += 1

    y_counts_per_fold = defaultdict(lambda: np.zeros(labels_num))
    groups_per_fold = defaultdict(set)

    def eval_y_counts_per_fold(y_counts, fold):
        y_counts_per_fold[fold] += y_counts
        std_per_label = []
        for label in range(labels_num):
            label_std = np.std([y_counts_per_fold[i][label] / y_distr[label] for i in range(k)])
            std_per_label.append(label_std)
        y_counts_per_fold[fold] -= y_counts
        return np.mean(std_per_label)
    
    groups_and_y_counts = list(y_counts_per_group.items())
    random.Random(seed).shuffle(groups_and_y_counts)

    for g, y_counts in sorted(groups_and_y_counts, key=lambda x: -np.std(x[1])):
        best_fold = None
        min_eval = None
        for i in range(k):
            fold_eval = eval_y_counts_per_fold(y_counts, i)
            if min_eval is None or fold_eval < min_eval:
                min_eval = fold_eval
                best_fold = i
        y_counts_per_fold[best_fold] += y_counts
        groups_per_fold[best_fold].add(g)

    all_groups = set(groups)
    for i in range(k):
        train_groups = all_groups - groups_per_fold[i]
        test_groups = groups_per_fold[i]

        train_indices = [i for i, g in enumerate(groups) if g in train_groups]
        test_indices = [i for i, g in enumerate(groups) if g in test_groups]

        yield train_indices, test_indices

def get_distribution(y_vals):
        y_distr = Counter(y_vals)
        y_vals_sum = sum(y_distr.values())
        return [f'{y_distr[i] / y_vals_sum:.2%}' for i in range(np.max(y_vals) + 1)]
        
# -----------------------------------------------------------------------------
# 						   STEP 0 - SET VARIABLES
# -----------------------------------------------------------------------------

# File location for train data set
train_file_path = 'full_train.csv'

# Specify the number of folds to be created
nfolds = 5 

# Define target label column to predict
target_column = 'TARGET_LABEL' 

# -----------------------------------------------------------------------------
# 						STEP 1 - READ TRAIN DATA SET 
# -----------------------------------------------------------------------------

# Read train dataset
train_full_x = pd.read_csv(train_file_path)

"""
test_ind = pd.read_csv('test_ind.csv')
test_ind = test_ind['IND'].values.tolist()
train_ind = pd.read_csv('train_ind.csv')
train_ind = train_ind['IND'].values.tolist()
"""

# -----------------------------------------------------------------------------
# 		            STEP 3 - CREATE TRAIN / TEST SPLIT
# ----------------------------------------------------------------------------
# GroupKFold on 'MASTERPATIENTID' ensures that multiple rows of same MASTERPATIENTID  
# with different disease labels are all added to the same set within each fold
train_full_y = train_full_x[target_column]
train_full_x.drop(target_column, axis=1, inplace=True)
le = preprocessing.LabelEncoder()
le.fit(train_full_x['MASTERPATIENTID'])
groups = le.transform(train_full_x['MASTERPATIENTID'])

distrs = [get_distribution(train_full_y)]
index = ['training set']

for fold_ind, (train_ind, test_ind) in enumerate(stratified_group_k_fold(train_full_x, train_full_y, groups, k=5)):
    del groups
    
    # First row gets printed as 0 in csv
    pd.DataFrame(train_ind).to_csv('train_ind.csv', index=False)
    pd.DataFrame(test_ind).to_csv('test_ind.csv', index=False)

    train_x = train_full_x.iloc[train_ind]
    train_y = train_full_y[train_ind]
    train = pd.concat([pd.DataFrame(train_y), train_x], axis=1)

    distrs.append([get_distribution(train_y)])
    index.append(f'train set')
    	
    del train_x, train_y, train_ind
	
    train.to_csv('train.csv', index=False)
	
    del train
	
    test_x = train_full_x.iloc[test_ind]
    test_y = train_full_y[test_ind]
    test = pd.concat([pd.DataFrame(test_y), test_x], axis=1)

    distrs.append(get_distribution(test_y))
    index.append(f'test set')
	
    del test_x, test_y, train_full_x, train_full_y, test_ind
	
    test.to_csv('test.csv', index=False)
    
    del test
   
    break
 
class_distr_train_test = pd.DataFrame(distrs, index=index, columns=[f'Label {l}' for l in range(np.max(train_full_y) + 1)])
class_distr_train_test.to_csv('class_distributions_train_test.csv')

del class_distr_train_test, distrs, index

# -----------------------------------------------------------------------------
# 		   STEP 4 - CREATE DEVELOPMENT / VALIDATION SPLITS
# ----------------------------------------------------------------------------
# GroupKFold on 'MASTERPATIENTID' ensures that multiple rows of same MASTERPATIENTID  
# with different disease labels are all added to the same set within each fold
train_x = pd.read_csv('train.csv')
train_y = train_x[target_column]
train_x.drop(target_column, axis=1, inplace=True)

le = preprocessing.LabelEncoder()
le.fit(train_x['MASTERPATIENTID'])
groups = le.transform(train_x['MASTERPATIENTID'])

distrs = [get_distribution(train_y)]
index = ['training set']

for fold_ind, (dev_ind, val_ind) in enumerate(stratified_group_k_fold(train_x, train_y, groups, k=nfolds)):
    # First row gets printed as 0 in csv
    pd.DataFrame(dev_ind).to_csv('dev_ind'+str(fold_ind)+'.csv', index=False)
    pd.DataFrame(val_ind).to_csv('val_ind'+str(fold_ind)+'.csv', index=False)
    
    dev_x = train_x.iloc[dev_ind]
    dev_y = train_y[dev_ind]
    dev_full = pd.concat([pd.DataFrame(dev_y), dev_x], axis=1)

    print('distrs1...')
    distrs.append(get_distribution(dev_y))
    index.append(f'development set - fold {fold_ind}')
	
    del dev_x, dev_y
	
    dev_full.to_csv('dev'+str(fold_ind)+'.csv', index=False)
	
    del dev_full
	
    val_x = train_x.iloc[val_ind]
    val_y = train_y[val_ind]
    val_full = pd.concat([pd.DataFrame(val_y), val_x], axis=1)

    print('distrs2...')
    distrs.append(get_distribution(val_y))
    index.append(f'validation set - fold {fold_ind}')
    
    del val_x, val_y
    
    val_full.to_csv('val'+str(fold_ind)+'.csv', index=False)
    
    del val_full
	   
class_distr_kfold = pd.DataFrame(distrs, index=index, columns=[f'Label {l}' for l in range(np.max(train_y) + 1)])
class_distr_kfold.to_csv('class_distributions_kfold.csv')