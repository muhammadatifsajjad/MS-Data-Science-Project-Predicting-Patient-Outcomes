# Import data and data preprocessing
import pymysql
import pandas as pd
import json
from sklearn.preprocessing import LabelEncoder
from sklearn.svm import SVC
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score
from sklearn import tree
from sklearn.metrics import f1_score
from sklearn.svm import LinearSVC
from pandas.core.frame import DataFrame
import numpy as np
from sklearn.linear_model import LogisticRegression
def disease_dict(query_data):
    count=0
    disease_set = set()
    disease_dict = {}
    for line in query_data:
        if line[7]==None:
            continue
        else:
            disease_set.add(line[7])
    for item in disease_set:
        count += 1
        disease_dict[item]=count
    return disease_dict

db = pymysql.connect(
    host='127.0.0.1',
    user='root',
    passwd='576820880ly',
    port=3306,
    db='project1',
    charset='utf8')

cur = db.cursor()
cur.execute('select * from nd_patient_history')
res = cur.fetchall()

# with open('disease_dic.json','r', encoding='utf-8') as f:
#     disease_list = json.load(f)

disease_list = disease_dict(res)
# with open('disease_dic.json','w') as f:
#     json.dump(disease_list, f)
# data_new.to_json("no_repeat_patient_history.json")
df = pd.DataFrame(list(res),columns=["MASTERPATIENTID","PATIENTPOSTCODE",'PATIENTGENDERCODE','PATIENTBIRTHDAY','DISPENSECALENDARDATE','DATELAGINDAYS','MEDICINENUMBER','PBSDISEASEGROUP','BATCHID','BRANDNAME','FORMCODE','STRENGTHCODE','TOTALQTYDISPENSED','GENERICINGREDIENTNAME','ATCLEVEL5CODE'])
db.close()

print(df.head())

data = pd.concat([df['MASTERPATIENTID'],
                  df['DISPENSECALENDARDATE'],
                  df['PBSDISEASEGROUP']],
                 axis=1)
# data.shape
# data['PBSDISEASEGROUP'].isnull().value_counts()
# data.dropna(axis=0, subset= ['PBSDISEASEGROUP'], how='any', inplace=True)
# print(data.head())
# data.shape

#replace disease with dictonary
data.replace(disease_list,inplace = True)
# %%
# sort
data_sorted = data.sort_values(
    ['MASTERPATIENTID', 'DISPENSECALENDARDATE'], ascending=[1, 1])
print(data_sorted.head())
# remove duplicate
data_sorted.drop_duplicates(
    subset=[
        'MASTERPATIENTID',
        'PBSDISEASEGROUP'],
    keep='first',
    inplace=True)

new_data = data_sorted.drop(columns=['DISPENSECALENDARDATE'])
#list
data_new = new_data.groupby(['MASTERPATIENTID'])['PBSDISEASEGROUP'].apply(list)
#

#transform data set

transform = data_sorted.drop(columns=['DISPENSECALENDARDATE'])
transform['count1'] = 1

transform.set_index('MASTERPATIENTID',inplace = True)
transform = transform.set_index('PBSDISEASEGROUP',append = True)
transform.head()

transform = pd.Series(transform.values.reshape(len(transform)),index = transform.index)
transform = transform.unstack()
transform.shape
transform = transform.fillna(0)

##deleting the last value y
i=0
for id in data_new.keys():
    transform[data_new[id][-1]][i] = 0.00000
    i+=1

without_zero = transform.ix[~(transform==0).all(axis=1),:]
without_zero.shape

#### adding y value to the dataset


# y dataframe
y_list = []
for id in data_new.keys():
    if len(data_new[id]) == 1:
        continue
    y_list.append(data_new[id][-1])
c={"y" : y_list}
y_result = pd.DataFrame(c)



#### adding y value to the dataset
new_transform = without_zero
new_transform = new_transform.reset_index(drop=True)
new_transform = pd.concat([new_transform,y_result], axis=1)
x = new_transform.iloc[:, :-1]
y = new_transform.iloc[:, -1]


x_train, x_test, y_train, y_test = train_test_split(x, y, test_size=0.2, random_state=42)

#决策树
clf = tree.DecisionTreeClassifier()
clf = clf.fit(x_train, y_train)
y_predict_tree = clf.predict(x_test)
accuracy_score(y_test, y_predict_tree)

# random forest
rnd_clf = RandomForestClassifier()
rnd_clf = rnd_clf.fit(x_train, y_train)
y_predict_rf = rnd_clf.predict(x_test)
accuracy_score(y_test, y_predict_rf)

#linearSVC
clf_linearSVC = LinearSVC(multi_class='ovr')
clf_linearSVC = clf_linearSVC.fit(x_train, y_train)
y_predict_linearSVC = clf_linearSVC.predict(x_test)
accuracy_score(y_test, y_predict_linearSVC)

#rbf
clf_rbf = SVC(C=1, kernel='rbf', gamma=.1)
clf_rbf = clf_rbf.fit(x_train, y_train)
y_predict_clf_rbf = clf_rbf.predict(x_test)
accuracy_score(y_test, y_predict_clf_rbf)

#LR
clf_lr = LogisticRegression(solver='lbfgs',multi_class='multinomial')
clf_lr = clf_lr.fit(x_train, y_train)
y_predict_clf_lr_prob = clf_lr.predict_proba(x_test)
y_predict_clf_lr = clf_lr.predict(x_test)
accuracy_score(y_test, y_predict_clf_lr)

##split data format
#split function
def split_sequence(sequence,n_steps):
    x = []
    for person_record in sequence:
        if len(person_record)<n_steps and len(person_record)>=3:
            x.append(person_record)
        for j in range(len(person_record)):
            end = j + n_steps
            if end > len(person_record):
                break
            seq_x= person_record[j:end]
            x.append(seq_x)
    return x

history_list =[]
for key in data_new.keys():
    history_list.append(data_new[key])
total_length = 0
total_count = 0
for list in history_list:
    total_length+=len(list)
    total_count+=1
#average number of count
total_length/total_count

split_list = split_sequence(history_list,7)
len(split_list)

split_x_list = []
split_y_list = []
for list in split_list:
    split_x_list.append(list[:-1])
    split_y_list.append(list[-1])
split_x_data = DataFrame(split_x_list)
split_y_data = DataFrame(split_y_list)
split_x_data=split_x_data.fillna(0)
for i in range(6):
    split_x_data[i]=split_x_data[i].astype(np.int64)

x_new = split_x_data.iloc[:,:]
y_new = split_y_data.iloc[:, -1]



# #类别变量转化
# for col in x_new:
#     if x_new[col].dtype == 'int64':
#         x_new[col] = LabelEncoder().fit_transform(x_new[col])

x_train_new, x_test_new, y_train_new, y_test_new = train_test_split(x_new, y_new, test_size=0.2, random_state=42)

#决策树
clf = tree.DecisionTreeClassifier()
clf = clf.fit(x_train_new, y_train_new)
y_predict_tree = clf.predict(x_test_new)
accuracy_score(y_test_new, y_predict_tree)
f1_score(y_test_new,y_predict_tree,average='micro')
