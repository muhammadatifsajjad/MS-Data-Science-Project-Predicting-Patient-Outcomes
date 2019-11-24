import os
import datetime
import numpy as np
import pandas as pd
import lightgbm as lgb
import xgboost as xgb
from sklearn import tree
from sklearn import preprocessing
from sklearn.feature_selection import VarianceThreshold
from sklearn.svm import LinearSVC, SVC
from sklearn.ensemble import RandomForestClassifier
from sklearn.linear_model import RidgeClassifier, LogisticRegression
from sklearn.metrics import f1_score, accuracy_score

os.chdir(r'C:\\FINAL')

# -----------------------------------------------------------------------------
# DEFINE CV DATASETS, TARGET COLUMN, FILTER UNNECESSARY FEATURES, 
# AND SPECIFY HOW TO OPTIMISE THE EVALUATION METIRUC
# -----------------------------------------------------------------------------
"""
 Specify what type of features to include prefixed with '|' symbol
 Possible values are: 'DIS_', 'MED_', 'ATC3_', 'ATC4_', 'ATC5_', 'DISLAG_', 
                       'MEDLAG_', 'ATC3LAG_', 'ATC4LAG_', 'ATC5LAG_'
"""
# Define target label column to predict
target_column = 'TARGET_LABEL' 

# Specify what features to keep
feature_type = '|DIS_|ATC4_'
feature_regex = '^' + target_column + '|MASTERPATIENTID' + feature_type

print('Read Data Start', datetime.datetime.now())
# Read k-folds data and keep only the above specified features
data = {}
i=0
for fold_ind in range(0,5):
    data[i] = pd.read_csv('dev'+str(fold_ind)+'.csv')
    data[i] = data[i].filter(regex=feature_regex, axis=1)
    
    data[i+1] = pd.read_csv('val'+str(fold_ind)+'.csv')
    data[i+1] = data[i+1].filter(regex=feature_regex, axis=1)
    
    if(i==0):
        # Remove features having zero variance
        train = pd.concat([data[0], data[1]], axis=0)
        selector = VarianceThreshold(0.01)
        train.drop(['MASTERPATIENTID','TARGET_LABEL'], axis=1, inplace=True)
        selector.fit(train)
        keep_columns = list(train.columns[selector.get_support(indices=True)])
        keep_columns.append('MASTERPATIENTID')
        keep_columns.append('TARGET_LABEL')    
        
        del train

    data[i]   = data[i][keep_columns]
    data[i+1] = data[i+1][keep_columns]
        
    print(fold_ind, ' completed')
    i += 2
print('Read Data End', datetime.datetime.now())

pd.DataFrame(keep_columns).to_csv('FeatureSelectedColumns.csv', index=False)
# Add header
 
# Change data type of all columns except 'MASTERPATIENTID' to int
for i in data.keys():
    mpid = data[i]['MASTERPATIENTID']
    data[i].drop('MASTERPATIENTID', axis=1, inplace=True)
    data[i] = data[i].astype('int')
    data[i].insert(0, 'MASTERPATIENTID', mpid)
      
# Get total distinct classes in target label column
num_classes = pd.concat([data[0][target_column], data[1][target_column]]).nunique()

# Should the evaluation metric be maximised or minimised?
is_maximised = True

# -----------------------------------------------------------------------------
# 					DEFINE CUSTOM EVALUATION FUNCTIONS
# -----------------------------------------------------------------------------
    
######## Define custom evaluation function to calucalte cross-validation F1 micro score 
# For XGBoost
def f1_micro_score_xgb(y_pred, dvalid):
    y_true = list(dvalid.get_label())  
    score = f1_score(y_true, y_pred, average='micro')  
    return 'f1_micro_score', score
   
# For LightGBM
def f1_micro_score_lgb(y_pred, dvalid):
    y_true = list(dvalid.get_label())

    y_pred = y_pred.reshape(num_classes, -1)
    y_pred = y_pred.argmax(axis = 0)
           
    score = f1_score(y_true, y_pred, average='micro')  
    return 'f1_micro_score', score, is_maximised

######## Define custom evaluation function to calucalte cross-validation F1 weighted score 
# For XGBoost
def f1_weighted_score_xgb(y_pred, dvalid):
    y_true = list(dvalid.get_label())  
    score = f1_score(y_true, y_pred, average='weighted')  
    return 'f1_weighted_score', score
   
# For LightGBM
def f1_weighted_score_lgb(y_pred, dvalid):
    y_true = list(dvalid.get_label()) 

    y_pred = y_pred.reshape(num_classes, -1)
    y_pred = y_pred.argmax(axis = 0)
           
    score = f1_score(y_true, y_pred, average='weighted')  
    return 'f1_weighted_score', score, is_maximised # 3rd return parameter - 'is_higher_better'
  
# -------------------------------------------------------------------------------------------------------------------------------------
# 							PARAMETER TWEAKING
# -------------------------------------------------------------------------------------------------------------------------------------
def param_tweaking_cv(algo, params, param_to_be_tweaked, param_value):              
    # Set parameter to be tweaked
    params[param_to_be_tweaked] = param_value
    
    cv_results = pd.DataFrame(columns=['param_name', 'param_value','algo', 'fold', 
                                       'best_ntree_limit', 'F1_weighted_score', 
                                       'F1_macro_score', 'Accuracy'])       

    j = 0
    for i in range(0, int(len(data.keys()) / 2)):
        x_train = pd.DataFrame(data[j])
        x_valid = pd.DataFrame(data[j+1])
        x_valid_orig = x_valid[['MASTERPATIENTID', target_column]]
        
    	# Separate target variable
        y_train = x_train[target_column].values
        y_valid = x_valid[target_column].values  
        x_train = x_train.drop(['MASTERPATIENTID', target_column], axis=1)
        x_valid = x_valid.drop(['MASTERPATIENTID', target_column], axis=1)   
       
        print('Train and Predict Start:', algo, ';', param_to_be_tweaked, ':', param_value, '; Fold:', i, '; Start Time:', datetime.datetime.now())
        
        best_ntree_limit = 'N/A' 
        
        if algo == 'XGBoost':              
            d_train = xgb.DMatrix(x_train, label=y_train)
            d_valid = xgb.DMatrix(x_valid, label=y_valid)
            watchlist = [(d_train, 'train'), (d_valid, 'valid')]
            xgb_num_rounds = 20000
            model = xgb.train(params, d_train, xgb_num_rounds, watchlist, 
                              maximize=is_maximised, early_stopping_rounds=30, 
                              verbose_eval=10, feval=f1_weighted_score_xgb)		
            y_pred = model.predict(xgb.DMatrix(x_valid), ntree_limit=model.best_ntree_limit)		
            best_ntree_limit = model.best_ntree_limit
            
        if algo == 'LightGBM':                       
            d_train = lgb.Dataset(x_train, label=y_train)
            d_valid = lgb.Dataset(x_valid, label=y_valid, reference=d_train)
            lgb_num_rounds = 20000
            model = lgb.train(params, d_train, lgb_num_rounds, valid_sets=d_valid,
                              feval=f1_weighted_score_lgb, early_stopping_rounds=30,
                              verbose_eval=10)		
            y_pred = model.predict(x_valid, num_iteration=model.best_iteration)
            y_pred = y_pred.argmax(axis = 1)		
            best_ntree_limit = model.best_iteration
            
        if algo == 'RandomForest':
            rf_model = RandomForestClassifier(**params)
            rf_model.fit(x_train, y_train)
            y_pred = rf_model.predict(x_valid) 
    
        if algo == 'DecisionTree':  
            dt_model = tree.DecisionTreeClassifier(**params)            
            dt_model.fit(x_train, y_train)
            y_pred = dt_model.predict(x_valid)        
            
        if algo == 'Ridge':
            ridge_model = RidgeClassifier(**params)
            ridge_model.fit(x_train, y_train)
            y_pred = ridge_model.predict(x_valid) 
			
        if algo == 'LR':
            lasso_model = LogisticRegression(**params)
            lasso_model.fit(x_train, y_train)
            y_pred = lasso_model.predict(x_valid) 
			
        if algo == 'LinearSVC':      	
            linearsvc_model = LinearSVC(**params)
            linearsvc_model.fit(x_train, y_train)
            y_pred = linearsvc_model.predict(x_valid) 
			
        #rbf
        if algo == 'SVC':
            svc_model = SVC(**params)            
            svc_model.fit(x_train, y_train)
            y_pred = svc_model.predict(x_valid) 

        print('Train and Predict End:', algo, ';', param_to_be_tweaked, ':', param_value, '; Fold:', i, '; EndTime:', datetime.datetime.now())
			
        # If a MASTERPATIENTID has multiple disease labels, check if our prediction is 
        # one of them. If yes, classify it as correct prediction.
        x_valid_orig['PREDICTION'] = y_pred
        g = x_valid_orig.groupby(['MASTERPATIENTID'])
        master_patient_id = g.filter(lambda x: len(x) > 1)['MASTERPATIENTID'].unique()    
        for patient in master_patient_id:
            count = x_valid_orig[x_valid_orig.MASTERPATIENTID==patient]['MASTERPATIENTID'].count()
            diseases = list(x_valid_orig[x_valid_orig.MASTERPATIENTID==patient][target_column])
            pred_disease = x_valid_orig[x_valid_orig.MASTERPATIENTID==patient]['PREDICTION'].unique()
            if pred_disease in diseases:
                x_valid_orig.PREDICTION.loc[x_valid_orig.MASTERPATIENTID==patient] = np.repeat(pred_disease, count)
                x_valid_orig.loc[x_valid_orig.MASTERPATIENTID==patient, target_column] = np.repeat(pred_disease, count)
            else:
                x_valid_orig.PREDICTION.loc[x_valid_orig.MASTERPATIENTID==patient] = np.repeat(pred_disease, count)
                x_valid_orig.loc[x_valid_orig.MASTERPATIENTID==patient, target_column] = np.repeat(diseases[0], count)                

        x_valid_orig.to_csv('check_pre_final_y.csv')
        
        y_valid = x_valid_orig.drop_duplicates(keep='first')[target_column]
        y_pred = x_valid_orig.drop_duplicates(keep='first')['PREDICTION']

#        pd.concat(y_valid, y_pred).to_csv('check_final_y.csv')
#Check above
         
        # Calculate evaluation metrics on each fold for the given algorithm
        model_weighted_f1score = f1_score(y_pred, y_valid, average='weighted')  
        model_macro_f1score = f1_score(y_pred, y_valid, average='macro') 
        model_accuracy = accuracy_score(y_pred, y_valid) * 100
    
        cv_results = cv_results.append(pd.DataFrame(
                [[param_to_be_tweaked, param_value, algo, i+1, best_ntree_limit, 
                  model_weighted_f1score, model_macro_f1score, model_accuracy]], 
                columns = ['param_name', 'param_value', 'algo', 'fold', 
                           'best_ntree_limit', 'F1_weighted_score', 'F1_macro_score', 
                           'Accuracy']))     
    
        j = j +2
    
    # Average all folds score
    cv_results = cv_results.append(pd.DataFrame([[param_to_be_tweaked, param_value, 
          algo, 'Avg All Folds', '', 
          np.mean(cv_results[cv_results.algo==algo].F1_weighted_score[0:(int(len(data.keys())/2))]),
          np.mean(cv_results[cv_results.algo==algo].F1_macro_score[0:(int(len(data.keys())/2))]),
          np.mean(cv_results[cv_results.algo==algo].Accuracy[0:(int(len(data.keys())/2))])]],
          columns = ['param_name', 'param_value', 'algo', 'fold', 'best_ntree_limit', 
                     'F1_weighted_score', 'F1_macro_score', 'Accuracy']))
        
    return cv_results    
    
# -------------------------------------------------------------------------------------------------------------------------------------
# 			CALL FUNCTION FOR DIFFERENT PARAMETER VALUES
# -------------------------------------------------------------------------------------------------------------------------------------
xgb_params = {'eta': 0.01, 'max_depth': 8, 'colsample_bytree': 0.7, 
   'subsample': 0.8, 'colsample_bylevel':0.3, 'alpha':2, 'seed': 99, 
   'objective': 'multi:softmax', 'num_class': num_classes} 

lgb_params = {'learning_rate': 0.01, 'max_depth': 8, 'colsample_bytree': 0.7, 
   'subsample' : 0.8, 'objective': 'multiclass', 'num_class': num_classes, 
   'metric': 'None', 'seed': 99}

rf_params = {'max_depth': None, 'min_weight_fraction_leaf': 0.0, 
 'min_samples_leaf': 1, 'min_samples_split':2, 
 'max_leaf_nodes':None, 'random_state': 101}  

dt_params = {'max_depth': None, 'min_weight_fraction_leaf': 0.0, 
 'min_samples_leaf': 1, 'min_samples_split':2, 'max_leaf_nodes':None, 
 'random_state': 101} 

ridge_params = {'alpha': .6, 'copy_X': True, 'fit_intercept': True, 
          'max_iter':100, 'normalize':False, 'random_state': 101, 
          'solver':'auto', 'tol':0.01} 

lr_params = {'random_state': 101, 'solver':'lbfgs', 'multi_class':'multinomial'} 

linearsvc_params = {'random_state': 101, 'multi_class':'ovr'} 

svc_rbf_params = {'kernel': 'rbf', 'max_iter':1000, 'random_state': 101,
 'gamma':0.1, 'decision_function_shape':'ovr', 'tol':0.0001, 'C':1.0} 

################### Predict top 50 target diseases together ###################  

print('LR Overall Start', datetime.datetime.now())
cv_results_out = param_tweaking_cv('LR', lr_params, 'random_state', 101)
print('LR Overall End', datetime.datetime.now())

print('LightGBM Overall Start', datetime.datetime.now())
cv_results_out = cv_results_out.append(param_tweaking_cv('LightGBM', lgb_params, 'learning_rate', 0.05))
print('LightGBM Overall End', datetime.datetime.now())

print('Decision Trees Overall Start', datetime.datetime.now())
cv_results_out = cv_results_out.append(param_tweaking_cv('DecisionTree', dt_params, 'random_state', 101))
print('Decision Trees Overall End', datetime.datetime.now())

print('Ridge Overall Start', datetime.datetime.now())
cv_results_out = cv_results_out.append(param_tweaking_cv('Ridge', ridge_params, 'random_state', 101))
print('Ridge Overall End', datetime.datetime.now())

print('Random Forest Overall Start', datetime.datetime.now())
cv_results_out = cv_results_out.append(param_tweaking_cv('RandomForest', rf_params, 'random_state', 101))
print('Random Forest Overall End', datetime.datetime.now())

cv_results_out.to_csv('cv_results_top50.csv')    

################### Disease specific models for top 3 Target Diseases ###################   
data_7 = {}
for i in data.keys():	
    data_7[i] = data[i].loc[data[i]['TARGET_LABEL'].isin([7])]
    data_7[i].loc[:, 'TARGET_LABEL'] = 1
    data_7[i].drop('DIS_Bacterial infection', axis=1, inplace=True)
    
    data_not = data[i].loc[~data[i]['TARGET_LABEL'].isin([7])]
   # data_not = data_not.loc[data_not['DIS_Bacterial infection'] == 0]
    data_not.drop('DIS_Bacterial infection', axis=1, inplace=True)
    data_not.loc[:, 'TARGET_LABEL'] = 0
    
    data_7[i] = pd.concat([data_7[i], data_not], axis=0)
    data_7[i] = data_7[i].drop_duplicates(subset ="MASTERPATIENTID", keep='first')   
  
data_39 = {}
for i in data.keys():	
    data_39[i] = data[i].loc[data[i]['TARGET_LABEL'].isin([39])]
    data_39[i].loc[:, 'TARGET_LABEL'] = 1
    data_39[i].drop('DIS_Severe pain', axis=1, inplace=True)
    
    data_not = data[i].loc[~data[i]['TARGET_LABEL'].isin([39])]
   # data_not = data_not.loc[data_not['DIS_Severe pain'] == 0]
    data_not.drop('DIS_Severe pain', axis=1, inplace=True)
    data_not.loc[:, 'TARGET_LABEL'] = 0
    
    data_39[i] = pd.concat([data_39[i], data_not], axis=0)
    data_39[i] = data_39[i].drop_duplicates(subset ="MASTERPATIENTID", keep='first')   
  
data_13 = {}
for i in data.keys():	
    data_13[i] = data[i].loc[data[i]['TARGET_LABEL'].isin([13])]
    data_13[i].loc[:, 'TARGET_LABEL'] = 1
    data_13[i].drop('DIS_Corticosteroid-responsive dermatoses', axis=1, inplace=True)
    
    data_not = data[i].loc[~data[i]['TARGET_LABEL'].isin([13])]
  #  data_not = data_not.loc[data_not['DIS_Corticosteroid-responsive dermatoses'] == 0]
    data_not.drop('DIS_Corticosteroid-responsive dermatoses', axis=1, inplace=True)
    data_not.loc[:, 'TARGET_LABEL'] = 0
    
    data_13[i] = pd.concat([data_13[i], data_not], axis=0)
    data_13[i] = data_13[i].drop_duplicates(subset ="MASTERPATIENTID", keep='first')   
  
    
# Bacterial infection
data = data_7
      
print('LR Overall Start', datetime.datetime.now())
cv_results_out_disease_7 = param_tweaking_cv('LR', lr_params, 'random_state', 101)
print('LR Overall End', datetime.datetime.now())

print('LightGBM Overall Start', datetime.datetime.now())
cv_results_out_disease_7 = cv_results_out_disease_7.append(param_tweaking_cv('LightGBM', lgb_params, 'learning_rate', 0.05))
print('LightGBM Overall End', datetime.datetime.now())

print('Decision Trees Overall Start', datetime.datetime.now())
cv_results_out_disease_7 = cv_results_out_disease_7.append(param_tweaking_cv('DecisionTree', dt_params, 'random_state', 101))
print('Decision Trees Overall End', datetime.datetime.now())

print('Ridge Overall Start', datetime.datetime.now())
cv_results_out_disease_7 = cv_results_out_disease_7.append(param_tweaking_cv('Ridge', ridge_params, 'random_state', 101))
print('Ridge Overall End', datetime.datetime.now())

print('Random Forest Overall Start', datetime.datetime.now())
cv_results_out_disease_7 = cv_results_out_disease_7.append(param_tweaking_cv('RandomForest', rf_params, 'random_state', 101))
print('Random Forest Overall End', datetime.datetime.now())
  
cv_results_out_disease_7.to_csv('cv_results_out_disease_specific_7.csv')  

# Severe pain
data = data_39
      
print('LR Overall Start', datetime.datetime.now())
cv_results_out_disease_39 = param_tweaking_cv('LR', lr_params, 'random_state', 101)
print('LR Overall End', datetime.datetime.now())

print('LightGBM Overall Start', datetime.datetime.now())
cv_results_out_disease_39 = cv_results_out_disease_39.append(param_tweaking_cv('LightGBM', lgb_params, 'learning_rate', 0.05))
print('LightGBM Overall End', datetime.datetime.now())

print('Decision Trees Overall Start', datetime.datetime.now())
cv_results_out_disease_39 = cv_results_out_disease_39.append(param_tweaking_cv('DecisionTree', dt_params, 'random_state', 101))
print('Decision Trees Overall End', datetime.datetime.now())

print('Ridge Overall Start', datetime.datetime.now())
cv_results_out_disease_39 = cv_results_out_disease_39.append(param_tweaking_cv('Ridge', ridge_params, 'random_state', 101))
print('Ridge Overall End', datetime.datetime.now())

print('Random Forest Overall Start', datetime.datetime.now())
cv_results_out_disease_39 = cv_results_out_disease_39.append(param_tweaking_cv('RandomForest', rf_params, 'random_state', 101))
print('Random Forest Overall End', datetime.datetime.now())
  
cv_results_out_disease_39.to_csv('cv_results_out_disease_specific_39.csv')  

# Corticosteroid-responsive dermatoses
data = data_13
      
print('LR Overall Start', datetime.datetime.now())
cv_results_out_disease_13 = param_tweaking_cv('LR', lr_params, 'random_state', 101)
print('LR Overall End', datetime.datetime.now())

print('LightGBM Overall Start', datetime.datetime.now())
cv_results_out_disease_13 = cv_results_out_disease_13.append(param_tweaking_cv('LightGBM', lgb_params, 'learning_rate', 0.05))
print('LightGBM Overall End', datetime.datetime.now())

print('Decision Trees Overall Start', datetime.datetime.now())
cv_results_out_disease_13 = cv_results_out_disease_13.append(param_tweaking_cv('DecisionTree', dt_params, 'random_state', 101))
print('Decision Trees Overall End', datetime.datetime.now())

print('Ridge Overall Start', datetime.datetime.now())
cv_results_out_disease_13 = cv_results_out_disease_13.append(param_tweaking_cv('Ridge', ridge_params, 'random_state', 101))
print('Ridge Overall End', datetime.datetime.now())

print('Random Forest Overall Start', datetime.datetime.now())
cv_results_out_disease_13 = cv_results_out_disease_13.append(param_tweaking_cv('RandomForest', rf_params, 'random_state', 101))
print('Random Forest Overall End', datetime.datetime.now())
  
cv_results_out_disease_13.to_csv('cv_results_out_disease_specific_13.csv')    