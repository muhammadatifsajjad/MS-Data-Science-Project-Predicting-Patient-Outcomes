----------------------------------------- PBS DATA ----------------------------------

In addition to the data provided by NostraData, the solution uses Medicine to Disease Condition Mapping data from the PBS website. To contsruct this table, following needs to be done:

(1) Download PBS data text files from https://www.pbs.gov.au/info/publication/schedule/archive. For the purposes of this project, all the files from 1st Jan 2011 to 1st May 2019 were downloaded.
(2) Import the Talend ETL solution "PBS Extract - Talend Job.zip" in Talend Open Studio for Big Data.
(3) Modify the source to point to the folder where the downloaded files are present.
(4) Modify the MySQL database connection to point to the current database.
(5) Run the "PBS" job which will load the 'drug', 'Linkextract', and 'RestrictionExtract' files into three separate tables.
(6) Run "Product-Disease - PBS.sql" script to create 'pbs_code_to_condition_mapping' table.
(7) Run "PBS Code - Disease Grouping.sql" script to classify disease conditions into more general broad categories.

---------------------------------- SUPERVISED LEARNING ----------------------------------

To build and run complete solution for implemented supervised learning algorithms following scripts need to be executed in order:
	0_Snowflake_ETL.py
	1_GenerateDatasetForSupervisedClassification.py
	2_StratifiedGroupCrossValidation.py
	3_RunSupervisedClassificationOnKFolds.py
	4_RunSupervisedClassificationOnTrainTest.py
	bi-LSTM_Model.ipynb

Below is a brief description of each of the scripts:

0_Snowflake_ETL.py:
Runs "ND_Snowflake_ETL.sql" SQL script against the snowflake database and creates following patient history tables from the base tables:

nd_patient_history_distinct_diseases_final 		------- Patient history of first occurrence of diseases
nd_patient_history_distinct_medicines_final 	------- Patient medicine history keeping only the first occurrence of each medicine for each patient
nd_patient_history_distinct_atclevel3code_final ------- Patient medicine history according to ATC3 keeping only the first occurrence of each ATC3 code for each patient
nd_patient_history_distinct_atclevel4code_final ------- Patient medicine history according to ATC4 keeping only the first occurrence of each ATC4 code for each patient
nd_patient_history_distinct_atclevel5code_final ------- Patient medicine history according to ATC4 keeping only the first occurrence of each ATC5 code for each patient
nd_patient_history_distinct_batchid_final 		------- Patient medicine history according to NostraData assigned BatchID keeping only the first occurrence of each BatchID for each patient

The script utilizes the following base tables:

PPO.FACTSCRIPT 			     		 ------- Provided by NostraData
PPO.DIMPRODUCTMASTER 		     	 ------- Provided by NostraData
PPO.ISRD 			     			 ------- Provided by NostraData
PPO.PBSCODETODISEASECONDITIONMAPPING ------- Disease to medicine mapping data from PBS website

1_GenerateDatasetForSupervisedClassification.py:
Reads the generated patient history tables (constructed in '0_Snowflake_ETL.py' script) from a MySQL database and builds data set for the disease prediction task as follows:
	(a) One record is generated for each patient.
	(b) "Target Label" to predict is the last occurrence of disease of each patient according to DispensedCalendarDate.
	(c) Features are one-hot encoding of different feature types (medicines, disease, atc3, atc4, atc5). 
	    'feature_type' variable can be used to configure what type of features are to be used to generate the one-hot dummy variables in the dataset. Possible values are: 
	    'disease', 'medicine', 'atclevel3code', 'atclevel4code', 'atclevel5code', 'days_lag_disease', 'days_lag_medicine', 'days_lag_atclevel3code', 'days_lag_atclevel4code', 'days_lag_atclevel5code'
	    "days_lag_***" feature means after how many days from the previous medicine/disease/atc3/atc/4/atc5 was the next one taken.
	(d) Only those records of patients are kept in the dataset which have a frequently occuring disease in their 'target label' as follows:
		 (i) Determine the top 50 diseases according to the count of number of patients who have that disease in the 'target label'.
		(ii) Only keep those records where patients have one of these top 50 diseases in their 'target label'.

2_StratifiedGroupCrossValidation.py:
     (a) Splits the data set genearted from '1_GenerateDatasetForSupervisedClassification.py' script into 80% train and 20% test data sets.
     (b) Performs k-fold cross-valiation on 80% training data.
     (c) Class balance of the target label is preserved across each set.
     (d) Multiple rows of same MASTERPATIENTID always belong to the same fold.

3_RunSupervisedClassificationOnKFolds.py:
This script is used to do parameter tuning and feature selection by evaluation different models' predictive performance using genearted k-folds in '2_StratifiedGroupCrossValidation.py' script as follows:
     (a) Does k-fold cross-validation using multiple machine learning algorithms (Logistic Regression, RisgeRegression, LightGBM, DecisionTrees, RandomForests).
     (b) Uses f1 weighted score to evaluate model's performance.
     (c) Performs CV in two ways:
		 (i) Predict all the 50 target disease labels together.
		(ii) Disease specific models for predicting top 3 diseases one by one.
     (d)  Uses a configurable 'feature_type' variable to specify what type of features to include. Possible values are: 
		'DIS_', 'MED_', 'ATC3_', 'ATC4_', 'ATC5_', 'DISLAG_', 'MEDLAG_', 'ATC3LAG_', 'ATC4LAG_', 'ATC5LAG_'

4_RunSupervisedClassificationOnTrainTest.py:
This script uses 80% train and 20% test data sets generated in '2_StratifiedGroupCrossValidation.py' script to get the final evaluation score. Complete 80% train data set is used to do the final model training and 20% test data set is used to make the prediction and calucalte 'Accuracy', 'Evaluation', and 'Recall' evaluation metrics.

bi-LSTM_Model.ipynb:
This standalone python notebook runs Long Short-Term Memory (LSTM) deep-learning based approcah to make prediction.

Miscellaenous Notes:
(1) Working directory is being explicitly set within the scripts which will need to be modified to point to the correct directory from where the code will be executed and intermediate files will be saved.
(2) Database connection strings need to be set in '0_Snowflake_ETL.py' and '1_GenerateDatasetForSupervisedClassification.py' scripts.
(3) Scripts generate several files to store intermediate results.

---------------------------------- UNSUPERVISED LEARNING ----------------------------------

To build and run complete solution for implemented unsupervised learning algorithms following scripts need to be executed:
	diseaseRule.ipynb				  ------- Runs association rules on diseases
	medicineRule.ipynb  			  ------- Runs association rules on medicines
	CPT_SequencePrediction.zip folder ------- Contains code to run Compact Prediction Trees
