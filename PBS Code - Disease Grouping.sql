alter table pbs_code_to_disease_condition_mapping
add column DISEASE_GROUP varchar(500);

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Tobacco use disorders' 
where lower(DISEASE_CONDITION) like '%cease%smoking%'
or (lower(DISEASE_CONDITION) like '%Completion of short-term, sole PBS-subsidised, therapy as an aid to achieving abstinence in a patient who has previously been issued with an authority prescription for this drug and who is enrolled in a comprehensive support and counselling program%')
or (lower(DISEASE_CONDITION) like '%Continuation of short-term sole PBS-subsidised therapy as an aid to achieving abstinence in a patient who has previously been issued with an authority prescription for this drug and who is enrolled in a comprehensive support and counselling program%');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Dermatophyte infection' 
where lower(DISEASE_condition) like '%Dermatophyte infection%' and lower(DISEASE_condition) not like '%mycos%s%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Menopause symptoms' 
where lower(DISEASE_CONDITION) like '%Post-menopausal symptoms%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Corticosteroids' 
where lower(DISEASE_CONDITION) like '%Patients on long-term treatment with corticosteroids%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'High dose regimen' 
where lower(DISEASE_CONDITION) like '%high dose regimen%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'In-vitro fertilisation' 
where lower(DISEASE_CONDITION) like '%in-vitro fertilisation%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Calcium malabsorption' 
where lower(DISEASE_CONDITION) like '%calcium malabsorption%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Peroxisomal biogenesis disorders' 
where lower(DISEASE_CONDITION) like '%Peroxisomal biogenesis disorders%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Protein metabolism' 
where lower(DISEASE_CONDITION) like '%protein metabolism%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Pulmonary embolism' 
where lower(DISEASE_CONDITION) like '%Pulmonary embolism%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Pyruvate dehydrogenase deficiency' 
where lower(DISEASE_CONDITION) like '%dehydrogenase%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Legs syndrome' 
where lower(DISEASE_CONDITION) like '%legs syndrome%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Gastrectomy'
where lower(DISEASE_CONDITION) like '%gastrectomy%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Large bowel surgery' 
where (lower(DISEASE_CONDITION) like '%Prophylaxis%' and lower(DISEASE_CONDITION) like '%bowel%') or
	  (lower(DISEASE_CONDITION) like '%Prophylaxis to prevent infection%' and lower(restriction_indication_full_text) like '%bowel%');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hyperprolactinaemia' 
where lower(DISEASE_CONDITION) like '%hyperprolactinaemia%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Prevention of lactation' 
where lower(DISEASE_CONDITION) like '%lactation%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Stroke' 
where (lower(DISEASE_CONDITION) like '%stroke%' and lower(DISEASE_CONDITION) not like '%spasticity%') or
(lower(DISEASE_CONDITION) like '%Patients established on this drug as a pharmaceutical benefit prior to 1 November 1999%' and drug_name = 'TICLOPIDINE HYDROCHLORIDE');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Pelvic inflammatory disease' 
where lower(DISEASE_CONDITION) like '%Pelvic inflammatory disease%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Panic disorder' 
where lower(DISEASE_CONDITION) like '%panic disorder%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Phenylketonuria' 
where lower(DISEASE_CONDITION) like '%Phenylketonuria%' and lower(DISEASE_CONDITION) not like '%Hyperphenylalaninemia%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Phaeochromocytoma' 
where lower(DISEASE_CONDITION) like '%Phaeochromocytoma%'; 

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Nocturnal enuresis' 
where lower(DISEASE_CONDITION) like '%nocturnal enuresis%'; 

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Cirrhosis' 
where lower(DISEASE_CONDITION) like '%cirrhosis%' and lower(DISEASE_CONDITION) not like '%hepatitis%'; 

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Proctitis' 
where lower(DISEASE_CONDITION) like '%Proctitis%'; 

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Bacterial infection' 
where lower(DISEASE_CONDITION) like 'infection%' or lower(DISEASE_CONDITION) like '%Use initiated in a hospital for infections where vancomycin is an appropriate antibiotic%'
or lower(DISEASE_CONDITION) like '%Atypical mycobacterial infections%' or lower(DISEASE_CONDITION) LIKE '%bacterial enterocolitis%' or lower(DISEASE_CONDITION) LIKE '%gastroenteritis%'
or lower(DISEASE_CONDITION) like '%Bone or joint infection%' or lower(DISEASE_CONDITION) LIKE '%treatment of joint and bone infections, epididymo-orchitis, prostatitis or perichondritis of the pinna%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Constitutional delay of growth or puberty' 
WHERE lower(DISEASE_CONDITION) like '%Constitutional delay of growth or puberty%' or lower(DISEASE_CONDITION) like '%Pubertal induction%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Precocious puberty'
where lower(DISEASE_CONDITION) like '%precocious puberty%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Renal cell carcinoma' 
WHERE lower(DISEASE_CONDITION) like '%Continuing treatment%' and lower(restriction_indication_full_text) like '%Renal cell carcinoma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Spondylitis' 
WHERE (lower(DISEASE_CONDITION) like '%Continuing treatment%' and lower(restriction_indication_full_text) like '%ankylosing spondylitis%') or
(lower(DISEASE_CONDITION) like 'Initial 1%' and restriction_indication_full_text like '%ankylosing spondylitis%') or
(lower(DISEASE_CONDITION) like 'Initial 2%' and restriction_indication_full_text like '%ankylosing spondylitis%') or
(lower(DISEASE_CONDITION) like 'Initial (\'grandfather\' patients)%' and restriction_indication_full_text like '%active ankylosing spondylitis%');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Alzheimer\'s disease' 
WHERE (lower(DISEASE_CONDITION) like '%Continuing treatment%' and lower(restriction_indication_full_text) like '%Alzheimer%') or lower(DISEASE_CONDITION) like '%Alzheimer%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Psoriasis' 
WHERE (lower(DISEASE_CONDITION) like '%Continuing treatment%' and lower(restriction_indication_full_text) like '%psoriasis%')
or (lower(DISEASE_CONDITION) like '%Initial treatment [%' and lower(restriction_indication_full_text) like '%psoriasis%');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Asthma' 
WHERE (lower(DISEASE_CONDITION) like '%Continuing treatment%' and lower(restriction_indication_full_text) like '%asthma%')
or (lower(DISEASE_CONDITION) like '%Patients unable to achieve co-ordinated use of other metered dose inhalers containing this drug%');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Coronary artery disease' 
where lower(DISEASE_CONDITION) like '%Coronary artery disease%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Cows\' milk anaphylaxis' 
where lower(DISEASE_CONDITION) like '%cow%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Corneal grafts' 
where lower(DISEASE_CONDITION) like '%Corneal grafts%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Pancreatic neuroendocrine tumour (pNET)' 
where lower(DISEASE_CONDITION) like '%pancreatic neuroendocrine tumour (pNET)%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Transplant rejection' 
where lower(DISEASE_CONDITION) like '%rejection%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Cardiac transplant' 
where lower(DISEASE_CONDITION) like '%cardiac transplant%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Chronic kidney disease' 
where lower(DISEASE_CONDITION) like '%chronic kidney disease%ipth%' or lower(DISEASE_CONDITION) LIKE '%hyperphosphataemia%' or lower(DISEASE_CONDITION) like '%ADPKD%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hidradenitis suppurativa' 
where lower(DISEASE_CONDITION) like '%hidradenitis suppurativa%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Cryopyrin associated periodic syndromes (CAPS)' 
where lower(DISEASE_CONDITION) like '%Cryopyrin%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Mobilisation of haematopoietic stem cells' 
where lower(DISEASE_CONDITION) like '%Mobilisation of haematopoietic stem cells%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Acidaemia' 
where lower(DISEASE_CONDITION) like '%acidaemia%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Major depressive disorders' 
where lower(DISEASE_CONDITION) like '%Major depressive disorders%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Meningococcal disease' 
where lower(DISEASE_CONDITION) like '%Meningococcal%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Maple syrup urine disease' 
where lower(DISEASE_CONDITION) like '%Maple syrup urine disease%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Megacolon' 
where lower(DISEASE_CONDITION) like '%Megacolon%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Mesothelioma' 
where lower(DISEASE_CONDITION) like '%Mesothelioma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Myoclonus' 
where lower(DISEASE_CONDITION) like '%Myoclonus%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Micropenis' 
where lower(DISEASE_CONDITION) like '%Micropenis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Pressure injury' 
where lower(DISEASE_CONDITION) like '%pressure injury%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'LH deficiency' 
where lower(DISEASE_CONDITION) like '%Stimulation of follicular development%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Chronic obstructive pulmonary disease (COPD)' 
where lower(DISEASE_CONDITION) like '%Chronic obstructive pulmonary disease (COPD)%' or lower(DISEASE_CONDITION) like 'Chronic obstructive pulmonary disease%' or lower(DISEASE_CONDITION) like '%Bronchiectasis%' or lower(DISEASE_CONDITION) like '%Bronchospasm%' or lower(DISEASE_CONDITION) like '%bronchitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Sporotrichosis' 
where lower(DISEASE_CONDITION) like '%sporotrichosis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Splenectomy' 
where lower(DISEASE_CONDITION) like '%Splenectom%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Spinal muscular atrophy (SMA)' 
where lower(DISEASE_CONDITION) like '%spinal muscular atrophy%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Oral laxative' 
where lower(DISEASE_CONDITION) like '%oral laxative%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Menorrhagia' 
where lower(DISEASE_CONDITION) like '%menorrhagia%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hyperhidrosis' 
where lower(DISEASE_CONDITION) like '%hyperhidrosis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Lipoatrophy' 
where lower(DISEASE_CONDITION) like '%lipoatrophy%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Urticaria' 
where lower(DISEASE_CONDITION) like '%Severe chronic spontaneous urticaria%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Wegeners granulomatosis' 
where lower(DISEASE_CONDITION) like '%polyangiitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Eye infection' 
where lower(DISEASE_CONDITION) like '%eye infection%' or (drug_name like '%TOBRAMYCIN%' and lower(DISEASE_CONDITION) like '%infection%') or lower(DISEASE_CONDITION) like '%ocular infection%' or lower(DISEASE_CONDITION) like '%ophthalmic surgery%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Basal cell carcinoma' 
where lower(DISEASE_CONDITION) like '%basal cell carcinoma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Merkel Cell Carcinoma' 
where lower(DISEASE_CONDITION) like '%Merkel Cell Carcinoma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Disorders of keratinisation' 
where lower(DISEASE_CONDITION) like '%disorders of keratinisation%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Dermatitis' 
where lower(DISEASE_CONDITION) like '%dermatitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Thrombocytopenia' 
where lower(DISEASE_CONDITION) like '%thrombocytopenia%' or 
(DISEASE_CONDITION like '%Continuing therapy%' and restriction_indication_full_text like '%thrombocytopenic purpura%') or
(lower(DISEASE_CONDITION) like 'Initial (grandfather patients)%' and restriction_indication_full_text like '%thrombocytopenia%') or
(lower(DISEASE_CONDITION) like 'Initial (new patients%' and restriction_indication_full_text like '%thrombocytopenia%');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Rhinorrhoea' 
where lower(DISEASE_CONDITION) like '%rhinorrhoea%' or lower(DISEASE_CONDITION) like '%rhinitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Strongyloidiasis' 
where lower(DISEASE_CONDITION) like '%Strongyloidiasis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Paget disease of bone' 
where lower(DISEASE_CONDITION) like '%Paget disease%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Angina' 
where lower(DISEASE_CONDITION) like '%For a patient who is unable to take a solid dose form of atenolol%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'For patients requiring doses greater than 20 mg per week' 
where lower(DISEASE_CONDITION) like '%for patients requiring doses greater than 20 mg per week%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Actinic keratoses (skin)' 
where lower(DISEASE_CONDITION) like '%actinic keratoses%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Miscellaneous' 
where lower(DISEASE_CONDITION) like '%long-term nursing care%' and lower(DISEASE_CONDITION) not like '%benzodiazepine%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Benzodiazepine dependent' 
where lower(DISEASE_CONDITION) like '%long-term nursing care%' and lower(DISEASE_CONDITION) like '%benzodiazepine%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'GP Management Plan' 
where lower(DISEASE_CONDITION) like '%For use in patients who are receiving treatment under a GP Management Plan or Team Care Arrangements where Medicare benefits were or are payable for the preparation of the Plan or coordination of the Arrangements%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Functional carcinoid tumour' 
where lower(DISEASE_CONDITION) like '%Functional carcinoid tumour%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hormone deficiency' 
where lower(DISEASE_CONDITION) like '%severe growth hormone deficiency%' or lower(DISEASE_CONDITION) like '%gonadotrophins%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Miscellaneous' 
where lower(DISEASE_CONDITION) like '%glucose%monitoring%' or lower(DISEASE_CONDITION) like '%For treatment of a patient identifying as Aboriginal or Torres Strait Islander%' or lower(DISEASE_CONDITION) like '%for use in a hospital%' or lower(DISEASE_CONDITION) like '%for use with surgical appliances%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Paraplegic / Quadriplegic' 
where lower(DISEASE_CONDITION) like '%paraplegic%' or lower(DISEASE_CONDITION) like '%quadriplegict%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Organ or tissue transplant' 
where lower(DISEASE_CONDITION) like '%organ or tissue transplant%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Skin infections' 
where lower(DISEASE_CONDITION) like '%skin%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Lipid-lowering drugs' 
where lower(DISEASE_CONDITION) like '%For use in patients who meet the criteria set out in the General Statement for Lipid-Lowering Drugs%'
or lower(DISEASE_CONDITION) like '%Patients eligible for PBS-subsidised lipid-lowering medication%'
or lower(DISEASE_CONDITION) like '%For use in patients that meet the criteria set out in the General Statement for Lipid-Lowering Drugs%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Chronic wounds' 
where lower(DISEASE_CONDITION) like '%wound%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Insulin therapy' 
where lower(DISEASE_CONDITION) like '%insulin%therapy%' or lower(DISEASE_CONDITION) like '%therapy%insulin%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Angioplasty' 
where lower(DISEASE_CONDITION) like '%angioplasty%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Colostomy / Ileostomy' 
where lower(DISEASE_CONDITION) like '%colostomy%' or lower(DISEASE_CONDITION) like '%ileostomy%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Insomnia' 
where lower(DISEASE_CONDITION) like '%insomnia%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Non-functional gastroenteropancreatic neuroendocrine tumour (GEP-NET)' 
where lower(DISEASE_CONDITION) like '%Non-functional gastroenteropancreatic neuroendocrine tumour (GEP-NET)%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Staph infections' 
where lower(DISEASE_CONDITION) like '%staphylococcus aureus%' or lower(DISEASE_CONDITION) like '%staphylococcal infection%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Necrobiosis lipoidica (Skin condition)' 
where lower(DISEASE_CONDITION) like '%necrobiosis lipoidica%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Tobacco use disorders' 
where lower(DISEASE_CONDITION) like '%nicotine%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Nephrotic syndrome' 
where lower(DISEASE_CONDITION) like '%nephrotic%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Cataplexy' 
where lower(DISEASE_CONDITION) like '%cataplexy%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Narcolepsy' 
where lower(DISEASE_CONDITION) like '%narcolepsy%' and lower(DISEASE_CONDITION) not like '%cataplexy%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Short stature' 
where lower(DISEASE_CONDITION) like '%short stature%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hypoglycaemia' 
where lower(DISEASE_CONDITION) like '%hypoglycaemia%' and lower(DISEASE_CONDITION) not like '%stature%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Astrocytoma' 
where lower(DISEASE_CONDITION) like '%astrocytoma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hypothyroidism' 
where lower(DISEASE_CONDITION) like '%hypothyroid%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Intestinal failure' 
where lower(DISEASE_CONDITION) like '%intestinal malabsorption%' or lower(DISEASE_CONDITION) like '%intestinal failure%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Mucositis' 
where lower(DISEASE_CONDITION) like '%mucositis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Mucositis' 
where lower(DISEASE_CONDITION) like '%mucositis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Acute allergic reaction with anaphylaxis' 
where lower(DISEASE_CONDITION) like '%acute allergic reaction% with anaphylaxis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Antidote to folic acid antagonists'
where lower(DISEASE_CONDITION) like '%antidote to folic acid antagonists%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Ulcer'
WHERE lower(DISEASE_CONDITION) like '%adverse effects occurring with all of the base-priced drugs%'
and lower(drug_name) = 'RANITIDINE HYDROCHLORIDE';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hypertension'
WHERE lower(DISEASE_CONDITION) like '%adverse effects occurring with all of the base-priced drugs%'
and lower(drug_name) in ('CANDESARTAN CILEXETIL', 'eprosartan', 'EPROSARTAN MESYLATE', 'NIFEDIPINE', 'OLMESARTAN MEDOXOMIL', 'TELMISARTAN');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Alcohol dependence' 
where lower(DISEASE_CONDITION) like '%alcohol dependence%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Assisted Reproductive Technology' 
where lower(DISEASE_CONDITION) like '%Assisted Reproductive Technology%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Atypical haemolytic uraemic syndrome (aHUS)'
where lower(DISEASE_CONDITION) like '%aHUS%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Melanoma'
where lower(DISEASE_CONDITION) like '%melanoma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Respiratory tract infections'
where lower(DISEASE_CONDITION) like '%respiratory tract infection%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Urothelial toxicity'
where lower(DISEASE_CONDITION) like '%Urothelial toxicity%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Tumour of bone'
where lower(DISEASE_CONDITION) like '%tumour of bone%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Gastrointestinal stromal tumour'
where lower(DISEASE_CONDITION) like '%Gastrointestinal stromal tumour%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Adenocarcinoma of the pancreas'
where lower(DISEASE_CONDITION) like '%adenocarcinoma of the pancreas%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Lichen'
where lower(DISEASE_CONDITION) like '%lichen%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Oesophageal candidiasis'
where lower(DISEASE_CONDITION) like '%oesophageal candidiasis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Genital candidiasis'
where lower(DISEASE_CONDITION) like '%genital candidiasis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Vasoactive intestinal peptide secreting tumour'
where lower(disease_condition) like '%vasoactive intestinal peptide secreting tumour%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Dry eye syndrome'
where lower(disease_condition) like '%dry eye syndrome%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Neutropenia'
where lower(DISEASE_CONDITION) like '%neutropenia%' and lower(DISEASE_CONDITION) not like '%cancer%' and lower(DISEASE_CONDITION) not like '%hodgkin%' and lower(DISEASE_CONDITION) not like '%leukaemia%' and lower(DISEASE_CONDITION) not like '%myeloma%' and lower(DISEASE_CONDITION) not like '%carcinoma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Dynamic equinus foot deformity'
where lower(disease_condition) like '%dynamic equinus foot deformity%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Sarcoma'
where lower(disease_condition) like '%sarcoma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hepatic encephalopathy'
where lower(disease_condition) like '%encephalopathy%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hepatic coma'
where lower(DISEASE_CONDITION) like '%Hepatic coma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hypertension'
where (lower(DISEASE_CONDITION) like '%hypertension%' and lower(DISEASE_CONDITION) like '%patients unable to take a solid dose form of an ace inhibitor%' and lower(DISEASE_CONDITION) not like '%ocular hypertension%' and lower(DISEASE_CONDITION) not like '%pulmonary%hypertension%' and lower(DISEASE_CONDITION) not like '%cholesterol%')
or (lower(DISEASE_CONDITION) like '%Patients receiving this drug as a pharmaceutical benefit%' and drug_name = 'CARVEDILOL')
or (lower(DISEASE_CONDITION) like '%Patients hypersensitive to other oral diuretics%')
or (lower(DISEASE_CONDITION) like '%Transfer to a base-priced drug would cause patient confusion resulting in problems with compliance%' and drug_name != 'RANITIDINE HYDROCHLORIDE')
or (lower(DISEASE_CONDITION) like '%Patients unable to take a solid dose form of an ACE inhibitor%' and drug_name = 'captopril');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hypertension'
where (lower(DISEASE_CONDITION) like '%pulmonary%hypertension%' and lower(DISEASE_CONDITION) not like '%cholesterol%') or
(lower(DISEASE_CONDITION) like '%Continuing treatment%' and lower(restriction_indication_full_text) like '%Pulmonary%Hypertension%') or
(lower(DISEASE_CONDITION) like 'Initial (change or re-commencement for%' and lower(restriction_indication_full_text) like '%Pulmonary%Hypertension%') or
(lower(DISEASE_CONDITION) like 'Initial (grandfather patients)%' and restriction_indication_full_text like '%pulmonary hypertension%') or
(lower(DISEASE_CONDITION) like 'Initial (new adult patients)%' and restriction_indication_full_text like '%pulmonary hypertension%') or
(lower(DISEASE_CONDITION) like 'Initial (new patients%' and restriction_indication_full_text like '%pulmonary%hypertension%');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Androgenisation'
where lower(DISEASE_CONDITION) like '%androgenisation%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Acne'
where lower(DISEASE_CONDITION) like '%acne%' and lower(DISEASE_CONDITION) not like '%androgenisation%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Cardiac Arrhythmias'
where lower(DISEASE_CONDITION) like '%cardiac arrhythmias%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Schizophrenia'
where lower(DISEASE_CONDITION) like '%Schizophrenia%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Septicaemia'
where lower(DISEASE_CONDITION) like '%Septicaemia%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Schistosomiasis'
where lower(DISEASE_CONDITION) like '%Schistosomiasis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Vitamin deficiencies'
where lower(DISEASE_CONDITION) like '%vitamin%b12%' or lower(DISEASE_CONDITION) like '%vitamin and mineral intake is insufficient%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Obsessive-compulsive disorder'
where lower(DISEASE_CONDITION) like '%Obsessive-compulsive disorder%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Obesity'
where lower(DISEASE_CONDITION) like 'Obesity%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Osteomyelitis'
where lower(DISEASE_CONDITION) like '%Osteomyelitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Onchocerciasis'
where lower(DISEASE_CONDITION) like '%Onchocerciasis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Urea cycle disorders'
where lower(DISEASE_CONDITION) like '%Urea cycle disorders%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Uveitis'
where lower(DISEASE_CONDITION) like '%Uveitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Infection due to susceptible organism requiring liquid formulation'
where lower(DISEASE_CONDITION) like '%Infection%liquid formulation%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Pseudomonas aeruginosa infection'
where lower(DISEASE_CONDITION) like '%Pseudomonas aeruginosa%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Neuropathic pain'
where lower(DISEASE_CONDITION) like '%neuropathic pain%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'To reduce drive in sexual deviations in males'
where lower(DISEASE_CONDITION) like '%To reduce drive in sexual deviations in males%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Pneumonia'
where lower(DISEASE_CONDITION) like '%pneumonia%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Mycosis'
where lower(DISEASE_CONDITION) like '%mycos%s%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Mycobacterium avium complex infections'
where lower(DISEASE_CONDITION) like '%Mycobacterium avium complex infection%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Candida infections'
where lower(DISEASE_CONDITION) like '%Candida infections%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Spasmodic torticollis'
where lower(DISEASE_CONDITION) like '%Spasmodic torticollis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Solar keratosis'
where lower(DISEASE_CONDITION) like '%Solar%keratosis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Cholesterol'
where lower(DISEASE_CONDITION) like '%cholesterol%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Opiate dependence'
where lower(DISEASE_CONDITION) like '%opiate dependence%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Oropharyngeal candidiasis'
where lower(DISEASE_CONDITION) like '%oropharyngeal candidiasis%' or lower(DISEASE_CONDITION) like '%oral candidiasis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Chronic suppurative otitis media'
where lower(DISEASE_CONDITION) like '%Chronic suppurative otitis media%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Tyrosinaemia'
where lower(DISEASE_CONDITION) like '%Tyrosinaemia%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Cervicitis'
where lower(DISEASE_CONDITION) like '%cervicitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Urethritis'
where lower(DISEASE_CONDITION) like '%urethritis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Trachoma'
where lower(DISEASE_CONDITION) like 'Trachoma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Termination of an intra-uterine pregnancy'
where lower(DISEASE_CONDITION) like '%Termination of an intra-uterine pregnancy%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Tinea pedis'
where lower(DISEASE_CONDITION) like '%Tinea pedis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Thiamine deficiency'
where lower(DISEASE_CONDITION) like '%Thiamine deficiency%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Constipation / Malignant Neoplasia'
where lower(DISEASE_CONDITION) like '%malignant neoplasia%' and lower(DISEASE_CONDITION) like '%constipation%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Severe disbaling pain / Malignant Neoplasia'
where lower(DISEASE_CONDITION) like '%malignant neoplasia%' and lower(DISEASE_CONDITION) like '%pain%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Malignant neoplasia'
where lower(DISEASE_CONDITION) like '%Terminal malignant neoplasia%' or lower(DISEASE_CONDITION) like '%Malignant neoplasia (late stage)%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Anxiety'
where lower(DISEASE_CONDITION) like '%Terminal disease%' and drug_name = 'BROMAZEPAM';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Insomnia'
where lower(DISEASE_CONDITION) like '%Terminal disease%' and drug_name = 'FLUNITRAZEPAM';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Bowel syndrome'
where lower(DISEASE_CONDITION) like '%Terminal disease%' and drug_name = 'hyoscine butylbromide';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Constipation'
where lower(DISEASE_CONDITION) like '%Terminal disease%' and drug_name in ('MACROGOL 3350', 'STERCULIA with FRANGULA BARK', 'BISACODYL');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Laxative'
where lower(DISEASE_CONDITION) like '%Terminal disease%' and drug_name = 'SORBITOL with SODIUM CITRATE and SODIUM LAURYL SULFOACETATE';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Tapeworm infestation'
where lower(DISEASE_CONDITION) like '%Tapeworm infestation%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Lupus erythematosus, chronic discoid'
where lower(DISEASE_CONDITION) like '%Lupus erythematosus%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hyperlipoproteinaemia'
where lower(DISEASE_CONDITION) like '%Long chain fatty acid oxidation disorders%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Articular infiltration'
where lower(DISEASE_CONDITION) like '%infiltration%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Leprosy'
where lower(DISEASE_CONDITION) like '%Leprosy%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Wounds'
where lower(DISEASE_CONDITION) like '%wounds%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Lupus nephritis'
where lower(DISEASE_CONDITION) like '%lupus nephritis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Whipworm infestation'
where lower(DISEASE_CONDITION) like '%Whipworm infestation%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Breast disease'
where lower(DISEASE_CONDITION) like '%breast disease%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Behavioural disturbances'
where lower(DISEASE_CONDITION) like '%Behavioural disturbances%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Vernal kerato-conjunctivitis'
where lower(DISEASE_CONDITION) like '%Vernal kerato-conjunctivitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Vitreomacular traction syndrome'
where lower(DISEASE_CONDITION) like '%Vitreomacular traction syndrome%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Zollinger-Ellison syndrome'
where lower(DISEASE_CONDITION) like '%Zollinger-Ellison%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Ketogenic diet'
where lower(DISEASE_CONDITION) like '%Ketogenic diet%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Keloid'
where lower(DISEASE_CONDITION) like '%Keloid%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Scabies'
where lower(DISEASE_CONDITION) like '%scabies%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Homozygous sitosterolaemia'
where lower(DISEASE_CONDITION) like '%Homozygous sitosterolaemia%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Heterotopic ossification'
where lower(DISEASE_CONDITION) like '%Heterotopic ossification%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Haemophilus influenzae'
where lower(DISEASE_CONDITION) like '%Haemophilus influenzae%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hookworm infestation'
where lower(DISEASE_CONDITION) like '%Hookworm infestation%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Myelofibrosis'
where lower(DISEASE_CONDITION) like '%myelofibrosis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Homocystinuria'
where lower(DISEASE_CONDITION) like '%Homocystinuria%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Haemodialysis'
where lower(DISEASE_CONDITION) like 'Haemodialysis';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hyperkinetic extrapyramidal disorders'
where lower(DISEASE_CONDITION) like '%Hyperkinetic extrapyramidal disorders%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hyperlipoproteinaemia'
where lower(DISEASE_CONDITION) like '%Hyperlipoproteinaemia%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hyperphenylalaninemia'
where lower(DISEASE_CONDITION) like '%Hyperphenylalanin%'

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hydatid disease'
where lower(DISEASE_CONDITION) like '%Hydatid disease%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hypsarrhythmia and/or infantile spasms'
where lower(DISEASE_CONDITION) like '%Hypsarrhythmia and/or infantile spasms%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hypothalamic-pituitary disease'
where lower(DISEASE_CONDITION) like '%Hypothalamic-pituitary%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Rickets'
where lower(DISEASE_CONDITION) like '%rickets%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hypomagnesaemia'
where lower(DISEASE_CONDITION) like '%Hypomagnesaemia%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hypercalcaemia'
where lower(DISEASE_CONDITION) like '%calcaemia%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Gyrate atrophy of the choroid and retina'
where lower(DISEASE_CONDITION) like '%Gyrate atrophy of the choroid and retina%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Growth retardation'
where lower(DISEASE_CONDITION) like '%growth retardation%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Subfoveal choroidal neovascularisation (CNV)'
where lower(DISEASE_CONDITION) like '%Subfoveal choroidal neovascularisation%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Histoplasmosis'
where lower(DISEASE_CONDITION) like '%histoplasmosis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Aspergillosis'
where lower(DISEASE_CONDITION) like '%aspergillosis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Dietary management'
where lower(DISEASE_CONDITION) like '%dietary%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Therapy with metformin and/or a sulfonylurea'
where lower(DISEASE_CONDITION) like '%metformin%sulfonylurea ';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Drug interactions'
where lower(DISEASE_CONDITION) like 'Drug interactions%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Dynamic equinus foot deformity'
where lower(DISEASE_CONDITION) like '%Dynamic equinus foot deformity%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Glucose transport defect'
where lower(DISEASE_CONDITION) like '%Glucose%transport%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Glycogen storage disease'
where lower(DISEASE_CONDITION) like '%Glycogen storage disease%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Gram-positive coccal infections'
where lower(DISEASE_CONDITION) like '%Gram-positive coccal infection%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Pneumococcal infection'
where lower(DISEASE_CONDITION) like '%pneumococcal infection%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Streptococcal infection'
where lower(DISEASE_CONDITION) like '%streptococcal infection%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Gonorrhoea'
where lower(DISEASE_CONDITION) like '%Gonorrhoea%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Granulomata'
where lower(DISEASE_CONDITION) like '%Granulomata%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Germ cell neoplasms'
where lower(DISEASE_CONDITION) like '%Germ cell neoplasms%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Glioblastoma multiforme'
where lower(DISEASE_CONDITION) like '%glioblastoma%multiforme%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Mycosis'
where lower(DISEASE_CONDITION) like '%Fungal%infection%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Familial hypophosphataemia'
where lower(DISEASE_CONDITION) like '%Familial hypophosphataemia%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Faecal impaction'
where lower(DISEASE_CONDITION) like '%Faecal impaction%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Helicobacter pylori'
where lower(DISEASE_CONDITION) like '%Helicobacter pylori%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Chylous ascites'
where lower(DISEASE_CONDITION) like '%Chylous ascites%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Chylothorax'
where lower(DISEASE_CONDITION) like '%Chylothorax%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Migraine'
where lower(DISEASE_CONDITION) like '%migraine%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Herpes'
where lower(DISEASE_CONDITION) like '%herpes%' and lower(DISEASE_CONDITION) not like '%keratitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Glaucoma'
where lower(disease_condition) like '%ocular%pressure%' and lower(restriction_indication_full_text) like '%glaucoma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Ocular hypertension'
where lower(disease_condition) like '%ocular%pressure%' and lower(restriction_indication_full_text) not like '%glaucoma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Angioedema'
where lower(DISEASE_CONDITION) like '%angio%edema%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Macular oedema'
where lower(DISEASE_CONDITION) like '%macular%oedema%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Epididymo-orchitis'
where lower(DISEASE_CONDITION) like 'Epididymo-orchitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Perichondritis of the pinna' 
where lower(DISEASE_CONDITION) like 'Perichondritis of the pinna ';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Joint and bone infections/Epididymo-orchitis/Prostatitis/Perichondritis of the pinna'
where lower(DISEASE_CONDITION) like '%joint and bone infections, epididymo-orchitis, prostatitis or perichondritis of the pinna%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Chronic iron overload / Disorders of erythropoiesis '
where lower(DISEASE_CONDITION) like '%iron overload%' or lower(DISEASE_CONDITION) like '%erythropoiesis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Enterokinase deficiency'
where lower(DISEASE_CONDITION) like '%Enterokinase deficiency%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Epilepsy'
where lower(DISEASE_CONDITION) like '%epilepsy%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Seizure'
where lower(disease_condition) like '%seizure%' and lower(DISEASE_CONDITION) not like '%epilepsy%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Endocarditis'
where lower(DISEASE_CONDITION) like '%Endocarditis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Eczema'
where lower(DISEASE_CONDITION) like '%Eczema%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Dysmenorrhoea'
where lower(DISEASE_CONDITION) like '%Dysmenorrhoea%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Erectile dysfunction'
where lower(DISEASE_CONDITION) like '%Erectile%dysfunction%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Endophthalmitis'
where lower(DISEASE_CONDITION) like '%Endophthalmitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Diarrhoea'
where lower(DISEASE_CONDITION) like '%Diarrhoea%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Depression'
where lower(DISEASE_CONDITION) like '%Depression%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Cessation of treatment'
where lower(DISEASE_CONDITION) like '%Cessation of treatment%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Chronic gout'
where lower(DISEASE_CONDITION) like '%gout%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Detrusor overactivity'
where lower(DISEASE_CONDITION) like '%Detrusor overactivity%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Chronic granulomatous disease'
where lower(DISEASE_CONDITION) like '%Chronic granulomatous disease%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Infertility'
where lower(DISEASE_CONDITION) like '%infertility%' or lower(DISEASE_CONDITION) like '%Patients who are receiving medical treatment as described in items 13200, 13201, 13202 or 13203 of the Medicare Benefits Schedule%'
or lower(DISEASE_CONDITION) like '%A patient who is receiving treatment as described in items 13200, 13201 or 13202 of the Medicare Benefits Schedule and who: %'
or lower(DISEASE_CONDITION) like '%luteal%support%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Malaria'
where lower(DISEASE_CONDITION) like '%malaria%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Urinary symptons/infection'
where lower(DISEASE_CONDITION) like '%urinary%' and lower(DISEASE_CONDITION) not like '%carcinoma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Carcinoma in situ of the urinary bladder'
where lower(DISEASE_CONDITION) like '%carcinoma%urinary%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Severe pain'
where lower(DISEASE_CONDITION) like '%breakthrough%pain%' or lower(DISEASE_CONDITION) like '%severe%pain%' or lower(DISEASE_CONDITION) like 'Pain ' or lower(DISEASE_CONDITION) like '%acute pain%' or lower(DISEASE_CONDITION) like '%chronic pain%' or lower(DISEASE_CONDITION) like '%For pain where aspirin and/or paracetamol alone are inappropriate or have failed%' or lower(DISEASE_CONDITION) like '%bone pain%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Pulmonary fibrosis'
where lower(DISEASE_CONDITION) like '%Pulmonary fibrosis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Cystic fibrosis'
where (lower(DISEASE_CONDITION) like '%Cystic fibrosis%' and lower(DISEASE_CONDITION) not like '%Fat malabsorption%' and lower(DISEASE_CONDITION) not like '%Pseudomonas aeruginosa infection%') or
(lower(DISEASE_CONDITION) like 'Grandfather%' and restriction_indication_full_text like '%cystic fibrosis%');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Pseudomonas aeruginosa infection'
WHERE lower(DISEASE_CONDITION) like '%Pseudomonas aeruginosa infection%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Endometriosis'
WHERE lower(DISEASE_CONDITION) like '%Endometriosis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Venous thromboembolism'
WHERE lower(DISEASE_CONDITION) like '%Deep vein thrombosis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Cataplexy'
WHERE lower(DISEASE_CONDITION) like '%Cataplexy%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hypogonadism'
WHERE lower(DISEASE_CONDITION) like '%hypogonadism%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Cryptococcal meningitis'
WHERE lower(DISEASE_CONDITION) like '%Cryptococcal meningitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Chronic arthropathies'
WHERE lower(DISEASE_CONDITION) like '%Chronic arthropathies%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hyperlipoproteinaemia'
WHERE lower(DISEASE_CONDITION) like '%Fat malabsorption%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Crohn disease'
WHERE lower(DISEASE_CONDITION) like '%crohn%' or 
(lower(DISEASE_CONDITION) like 'Initial 1%' and restriction_indication_full_text like '%Crohn%') or
(lower(DISEASE_CONDITION) like 'Initial 2%' and restriction_indication_full_text like '%Crohn%') or
(lower(DISEASE_CONDITION) like 'Initial 3%' and restriction_indication_full_text like '%Crohn%');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Cellulitis'
WHERE lower(DISEASE_CONDITION) like '%Cellulitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Corticosteroid-responsive dermatoses'
WHERE lower(DISEASE_CONDITION) like '%Corticosteroid%responsive dermatoses%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Contraception'
WHERE lower(DISEASE_CONDITION) like '%Contraception%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Cervicitis'
WHERE lower(DISEASE_CONDITION) like '%Cervicitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Bordetella pertussis'
WHERE lower(DISEASE_CONDITION) like '%Bordetella pertussis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Attention deficit hyperactivity disorder'
WHERE lower(DISEASE_CONDITION) like '%Attention%deficit hyperactivity disorder%'
or (lower(DISEASE_CONDITION) like '%Continuing sole PBS-subsidised treatment where the patient has previously been issued with an authority prescription for this drug%');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Psoriasis'
WHERE lower(DISEASE_CONDITION) like '%psoriasis%' or lower(restriction_indication_full_text) like '%re-treatment%psoriasis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Benzodiazepine dependence'
WHERE lower(DISEASE_CONDITION) like '%Benzodiazepine%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Ovarian related'
WHERE lower(DISEASE_CONDITION) like '%ovarian%' and lower(DISEASE_CONDITION) not like '%cancer%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Congenital abnormalities'
WHERE lower(DISEASE_CONDITION) like '%congenital%' AND lower(DISEASE_CONDITION) NOT like '%neutropenia%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Acute Coronary Syndrome'
WHERE lower(DISEASE_CONDITION) like '%myocardial%' or lower(DISEASE_CONDITION) LIKE '%heart%' or lower(disease_condition) like '%unstable angina%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Anaemia'
WHERE lower(DISEASE_CONDITION) like '%Anaemia%' or (lower(DISEASE_CONDITION) like '%Patients receiving this drug as a pharmaceutical benefit%' and drug_name = 'nandrolone decanoate');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Anaerobic infection'
WHERE lower(DISEASE_CONDITION) like '%Anaerobic infection%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Sepsis'
WHERE lower(DISEASE_CONDITION) like '%sepsis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Alopecia areata'
WHERE lower(DISEASE_CONDITION) like '%Alopecia areata%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Ablation of thyroid remnant tissue'
WHERE lower(DISEASE_CONDITION) like '%Ablation of thyroid remnant tissue%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hypoparathyroidism'
WHERE lower(DISEASE_CONDITION) LIKE '%Hypoparathyroidism%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hypothyroidism '
WHERE lower(DISEASE_CONDITION) LIKE '%Hypothyroidism%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Percutaneous coronary intervention'
WHERE lower(DISEASE_CONDITION) LIKE '%percutaneous%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Glutaric aciduria'
WHERE lower(DISEASE_CONDITION) LIKE '%glutaric aciduria%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Oesophageal'
WHERE lower(DISEASE_CONDITION) LIKE '%oesophag%' AND lower(DISEASE_CONDITION) NOT LIKE '%cancer%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Venous thromboembolism'
WHERE lower(DISEASE_CONDITION) LIKE '%venous thromboembolism%' or lower(DISEASE_CONDITION) like '%venous thromboembolic events%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Short stature'
WHERE lower(DISEASE_CONDITION) LIKE '%short stature%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hyperkinetic extrapyramidal disorders'
WHERE lower(DISEASE_CONDITION) LIKE '%Hyperkinetic%';

UPDATE pbs_code_to_disease_condition_mapping 
SET DISEASE_GROUP = 'Hyperlipoproteinaemia'
WHERE lower(DISEASE_CONDITION) LIKE '%hyperlipoproteinaemia%';

UPDATE pbs_code_to_disease_condition_mapping 
SET DISEASE_GROUP = 'Hyperprolactinaemia'
WHERE lower(DISEASE_CONDITION) LIKE '%hyperprolactinaemia%';

UPDATE pbs_code_to_disease_condition_mapping 
SET DISEASE_GROUP = 'Attention deficit hyperactivity disorder'
WHERE lower(DISEASE_CONDITION) LIKE '%attention%deficit%hyperactivity%disorder%';

UPDATE pbs_code_to_disease_condition_mapping 
SET DISEASE_GROUP = 'Hypertension'
WHERE lower(DISEASE_CONDITION) LIKE '%hypertension%' AND lower(DISEASE_CONDITION) not LIKE '%cholesterol%';

UPDATE pbs_code_to_disease_condition_mapping 
SET DISEASE_GROUP = 'Hyperhidrosis'
WHERE lower(DISEASE_CONDITION) LIKE '%hyperhidrosis%';

UPDATE pbs_code_to_disease_condition_mapping 
SET DISEASE_GROUP = 'Myeloma'
WHERE lower(DISEASE_CONDITION) LIKE '%myeloma%' or lower(DISEASE_CONDITION) like '%bortezomib%';

UPDATE pbs_code_to_disease_condition_mapping 
SET DISEASE_GROUP = 'Cardiac stent insertion'
WHERE lower(DISEASE_CONDITION) LIKE '% stent %';

UPDATE pbs_code_to_disease_condition_mapping 
SET DISEASE_GROUP = 'Blepharospasm'
WHERE lower(DISEASE_CONDITION) LIKE '%blepharospasm%';

UPDATE pbs_code_to_disease_condition_mapping 
SET DISEASE_GROUP = 'Bipolar disorder'
WHERE lower(DISEASE_CONDITION) LIKE '%bipolar%' AND lower(DISEASE_CONDITION) NOT LIKE '%mania%';

UPDATE pbs_code_to_disease_condition_mapping 
SET DISEASE_GROUP = 'Anxiety'
WHERE lower(DISEASE_CONDITION) LIKE '%anxiety%' or lower(DISEASE_CONDITION) like '%phobic%';

UPDATE pbs_code_to_disease_condition_mapping 
SET DISEASE_GROUP = 'Mastocytosis with eosinophilia'
WHERE lower(DISEASE_CONDITION) LIKE '%mastocytosis with eosinophilia%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Biliary atresia'
WHERE lower(DISEASE_CONDITION) LIKE '%biliary atresia%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Carcinoma of cervix'
WHERE lower(DISEASE_CONDITION) LIKE '%carcinoma of cervix%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Prostatitis'
WHERE lower(DISEASE_CONDITION) LIKE 'prostatitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Prostatic hyperplasia'
WHERE lower(DISEASE_CONDITION) LIKE '%prostatic hyperplasia%'; 

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Bone metastases'
WHERE lower(DISEASE_CONDITION) LIKE '%bone metastases%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Prostatic carcinoma'
WHERE (lower(DISEASE_CONDITION) LIKE '%prostatic carcinoma%' OR lower(DISEASE_CONDITION) LIKE '%carcinoma%prostate%');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Bone marrow transplantation'
WHERE lower(DISEASE_CONDITION) LIKE '%bone marrow%' AND lower(DISEASE_CONDITION) NOT LIKE '%cytomegalovirus%' AND lower(DISEASE_CONDITION) NOT LIKE '%congenital neutropenia%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Mobilisation of peripheral blood progenitor cells'
WHERE lower(DISEASE_CONDITION) LIKE '%blood progenitor cell%' AND lower(DISEASE_CONDITION) NOT LIKE '%bone marrow%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Sclerosis'
WHERE lower(DISEASE_CONDITION) LIKE '%sclerosis%' AND lower(DISEASE_CONDITION) NOT LIKE '%chronic spasticity%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Spasticity'
where lower(disease_condition) like '%spasticity%' and lower(disease_condition) not like '%dynamic equinus foot deformity%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Ano-genital warts'
WHERE lower(DISEASE_CONDITION) LIKE '%ano-genital warts%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Nephrotic Syndrome'
WHERE lower(DISEASE_CONDITION) LIKE '%nephrotic syndrome%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Cytomegalovirus (CMV) infection'
WHERE lower(DISEASE_CONDITION) LIKE '%cmv%' or lower(DISEASE_CONDITION) like '%Cytomegalovirus%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Renal'
WHERE lower(DISEASE_CONDITION) not LIKE '%short stature%' and lower(DISEASE_CONDITION) LIKE '% renal %' AND lower(DISEASE_CONDITION) NOT LIKE '%rcc%' AND lower(DISEASE_CONDITION) NOT LIKE '%nephrotic syndrome%' AND lower(DISEASE_CONDITION) NOT LIKE '%anaemia%' AND lower(DISEASE_CONDITION) NOT LIKE '%cmv%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Ulcerative colitis'
WHERE lower(DISEASE_CONDITION) LIKE '%ulcerative colitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Pseudomembranous colitis'
WHERE lower(DISEASE_CONDITION) LIKE '%pseudomembranous colitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Keratitis'
WHERE lower(DISEASE_CONDITION) LIKE '%keratitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Atopic dermatitis'
WHERE lower(DISEASE_CONDITION) LIKE '%atopic dermatitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Androgen'
WHERE lower(DISEASE_CONDITION) LIKE '%androgen%' AND lower(DISEASE_CONDITION) NOT LIKE '%prostatic carcinoma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hepatitis C'
WHERE lower(DISEASE_CONDITION) LIKE '%hepatitis c%' or lower(DISEASE_CONDITION) like '%non-pegylated or pegylated%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hepatitis B'
WHERE lower(DISEASE_CONDITION) LIKE '%hepatitis b%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Analgesia / Fever'
WHERE lower(DISEASE_CONDITION) LIKE '%analgesia%fever%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Renal cell carcinoma (RCC)'
WHERE lower(DISEASE_CONDITION) LIKE '%renal cell carcinoma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Cancer'
WHERE (lower(DISEASE_CONDITION) LIKE '%cancer%' OR lower(DISEASE_CONDITION) LIKE '%ifosfamide%' or lower(DISEASE_CONDITION) like '%administration of fluorouracil%')
AND lower(DISEASE_CONDITION) NOT LIKE '%colorectal cancer%'
AND lower(DISEASE_CONDITION) NOT LIKE '%lung cancer%'
AND lower(DISEASE_CONDITION) NOT LIKE '%breast cancer%'
AND lower(DISEASE_CONDITION) NOT LIKE '%ovarian cancer%'
AND lower(DISEASE_CONDITION) NOT LIKE '%lymphoid cancer%'
AND lower(DISEASE_CONDITION) NOT LIKE '%thyroid cancer%'
AND lower(DISEASE_CONDITION) NOT LIKE '%prostate cancer%'
AND lower(DISEASE_CONDITION) NOT LIKE '%liver cancer%'
AND lower(DISEASE_CONDITION) NOT LIKE '%urothelial cancer%'
AND lower(DISEASE_CONDITION) NOT LIKE '%colon cancer%'
AND lower(DISEASE_CONDITION) NOT LIKE '%peritoneal cancer%'
AND lower(DISEASE_CONDITION) NOT LIKE '%bladder cancer%'
AND lower(DISEASE_CONDITION) NOT LIKE '%gastric cancer%'
AND lower(DISEASE_CONDITION) NOT LIKE '%cell cancer of the larynx, oropharynx or hypopharynx%'
AND lower(DISEASE_CONDITION) NOT LIKE '%renal cell carcinoma%'
AND lower(DISEASE_CONDITION) NOT LIKE '%tube cancer%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Fallopean tube cance / Tubal cancer'
WHERE lower(DISEASE_CONDITION) LIKE '%tube cancer%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Cell cancer of the larynx, oropharynx or hypopharynx'
WHERE lower(DISEASE_CONDITION) LIKE '%cell cancer of the larynx, oropharynx or hypopharynx%' or lower(DISEASE_CONDITION) like '%cell carcinoma of the oral cavity%larynx%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Gastric Cancer'
WHERE lower(DISEASE_CONDITION) LIKE '%gastric cancer%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Bladder Cancer'
WHERE lower(DISEASE_CONDITION) LIKE '%bladder cancer%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Peritoneal Cancer'
WHERE lower(DISEASE_CONDITION) LIKE '%peritoneal cancer%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Colon Cancer'
WHERE lower(DISEASE_CONDITION) LIKE '%colon cancer%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Urothelial Cancer'
WHERE lower(DISEASE_CONDITION) LIKE '%urothelial cancer%' or lower(DISEASE_CONDITION) like '%urothelial carcinoma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Liver Cancer'
WHERE lower(DISEASE_CONDITION) LIKE '%liver cancer%' or lower(DISEASE_CONDITION) like '%hepatocellular carcinoma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Prostate Cancer'
WHERE lower(DISEASE_CONDITION) LIKE '%prostate cancer%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Thyroid Cancer'
WHERE lower(DISEASE_CONDITION) LIKE '%thyroid cancer%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Lymphoid Cancer'
WHERE lower(DISEASE_CONDITION) LIKE '%lymphoid cancer%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Ovarian Cancer'
WHERE lower(DISEASE_CONDITION) LIKE '%ovarian cancer%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Colorectal Cancer'
WHERE lower(DISEASE_CONDITION) LIKE '%colorectal cancer%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Lung Cancer'
WHERE lower(DISEASE_CONDITION) LIKE '%lung cancer%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Angina'
WHERE lower(DISEASE_CONDITION) LIKE '%angina%' 
AND lower(DISEASE_CONDITION) NOT LIKE '%acute coronary syndrome%'
AND lower(DISEASE_CONDITION) NOT LIKE '%myocardial infarction%'
AND lower(DISEASE_CONDITION) NOT LIKE '%unstable angina%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Myocardial infarction'
WHERE lower(DISEASE_CONDITION) LIKE '%myocardial infarction%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Parkinson disease'
WHERE lower(DISEASE_CONDITION) LIKE '%parkinson%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Spondylitis'
WHERE lower(DISEASE_CONDITION) LIKE '%spondylitis%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Acromegaly'
WHERE lower(DISEASE_CONDITION) LIKE '%acromegaly%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Lactose intolerance'
WHERE lower(DISEASE_CONDITION) LIKE '%lactose intolerance%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Mania'
WHERE lower(DISEASE_CONDITION) LIKE '%mania%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Lymphoma'
WHERE lower(DISEASE_CONDITION) LIKE '%lymphoma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Neuroblastoma'
WHERE lower(DISEASE_CONDITION) LIKE '%neuroblastoma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Sarcoma'
WHERE lower(DISEASE_CONDITION) LIKE '%sarcoma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Leukaemia'
WHERE lower(disease_condition) like '%Leukaemia%' or (lower(DISEASE_CONDITION) like '%Continuing treatment%' and lower(restriction_indication_full_text) like '%Leukaemia%');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Myelodysplastic or myeloproliferative disorder' 
where lower(DISEASE_CONDITION) like '%Myelodysplastic%' or lower(DISEASE_CONDITION) like '%Myeloproliferative%' or lower(DISEASE_CONDITION) like 'Initial PBS-subsidised treatment of a patient with:%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Hodgkin'
WHERE lower(DISEASE_CONDITION) LIKE '%hodgkin%' AND lower(DISEASE_CONDITION) NOT LIKE '%non-hodgkin%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Breast cancer'
WHERE lower(DISEASE_CONDITION) LIKE '%breast cancer%' and lower(DISEASE_CONDITION) NOT LIKE '%Bone metastases%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'CNS tumour'
WHERE lower(DISEASE_CONDITION) LIKE '%cns tumour%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Germ cell tumour'
WHERE lower(DISEASE_CONDITION) LIKE '%germ cell tumour%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Ulcer'
WHERE lower(DISEASE_CONDITION) LIKE '%ulcer%'
or (lower(DISEASE_CONDITION) like '%Transfer to a base-priced drug would cause patient confusion resulting in problems with compliance%' and drug_name = 'RANITIDINE HYDROCHLORIDE');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'HIV'
WHERE lower(DISEASE_CONDITION) LIKE '%hiv%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Osteoporosis'
WHERE lower(DISEASE_CONDITION) LIKE '%osteoporosis%' or lower(DISEASE_CONDITION) like '%Preservation of bone mineral density%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Arthritis'
WHERE lower(DISEASE_CONDITION) LIKE '%arthritis%' or 
(lower(DISEASE_CONDITION) like '%Continuing treatment%' and lower(restriction_indication_full_text) like '%arthritis%') or 
(lower(DISEASE_CONDITION) like 'Initial 1%' and restriction_indication_full_text like '%arthritis%') or
(lower(DISEASE_CONDITION) like 'Initial 2%' and restriction_indication_full_text like '%arthritis%') or
(lower(DISEASE_CONDITION) like 'Initial 3%' and restriction_indication_full_text like '%arthritis%') or
(lower(DISEASE_CONDITION) like '%Persistent Pain%' and restriction_indication_full_text like '%osteoarthritis%') or
(lower(DISEASE_CONDITION) like '%Patients requiring doses greater than 20 mg per week%' and drug_name = 'methotrexate');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Asthma'
WHERE lower(DISEASE_CONDITION) LIKE '%asthma%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Constipation'
WHERE lower(DISEASE_CONDITION) LIKE '%constipation%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Colicky pain'
WHERE lower(DISEASE_CONDITION) LIKE '%colicky pain%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Nausea'
WHERE lower(DISEASE_CONDITION) LIKE '%nausea%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Dry mouth'
WHERE lower(DISEASE_CONDITION) LIKE '%dry mouth%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Painful mouth'
WHERE lower(DISEASE_CONDITION) LIKE '%painful mouth%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Terminal illness'
WHERE lower(DISEASE_CONDITION) LIKE '%palliative%' 
AND lower(DISEASE_CONDITION) NOT LIKE '%nausea%'
AND lower(DISEASE_CONDITION) NOT LIKE '%constipation%'
AND lower(DISEASE_CONDITION) NOT LIKE '%colicky%'
AND lower(DISEASE_CONDITION) NOT LIKE '%insomnia%'
AND lower(DISEASE_CONDITION) NOT LIKE '%dry mouth%'
AND lower(DISEASE_CONDITION) NOT LIKE '%painful mouth%'
AND lower(DISEASE_CONDITION) NOT LIKE '%epilepsy%'
AND lower(DISEASE_CONDITION) NOT LIKE '%anxiety%'
AND lower(DISEASE_CONDITION) NOT LIKE '%cancer%'
AND lower(DISEASE_CONDITION) NOT LIKE '%fever%'
AND lower(DISEASE_CONDITION) NOT LIKE '%severe%pain%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Diabetes'
WHERE lower(DISEASE_CONDITION) LIKE '%diabetes%';

------------------------------- SECOND PASS ---------------------------------------------------------
UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Thyroid related' 
where lower(disease_group) like '%thyroid%' and lower(disease_group) not like '%cancer%';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Bowel syndrome'
where lower(DISEASE_GROUP) like '%Terminal illness%' and drug_name = 'hyoscine butylbromide';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Constipation'
where lower(DISEASE_GROUP) like '%Terminal illness%' and drug_name in ('MACROGOL 3350', 'STERCULIA with FRANGULA BARK', 'BISACODYL');

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Laxative'
where lower(DISEASE_GROUP) like '%Terminal illness%' and drug_name = 'SORBITOL with SODIUM CITRATE and SODIUM LAURYL SULFOACETATE';

UPDATE pbs_code_to_disease_condition_mapping
SET DISEASE_GROUP = 'Miscellaneous'
where lower(DISEASE_GROUP) like '%Terminal illness%' and drug_name = 'GLYCEROL';

insert into pbs_code_to_disease_condition_mapping(nhs_dispensed_code, disease_group, disease_condition, drug_name)
select distinct nhs_dispensed_code, 'Acute Coronary Syndrome' disease_group, disease_condition, drug_name
from pbs_code_to_disease_condition_mapping
where (lower(DISEASE_CONDITION) like '%Patients receiving this drug as a pharmaceutical benefit%' and drug_name = 'CARVEDILOL');

insert into pbs_code_to_disease_condition_mapping(nhs_dispensed_code, disease_group, disease_condition, drug_name)
select distinct nhs_dispensed_code, 'Acute Coronary Syndrome' disease_group, disease_condition, drug_name
from pbs_code_to_disease_condition_mapping
where lower(DISEASE_CONDITION) like '%Patients established on this drug as a pharmaceutical benefit prior to 1 November 1999%'
and drug_name = 'TICLOPIDINE HYDROCHLORIDE';

insert into pbs_code_to_disease_condition_mapping(nhs_dispensed_code, disease_group, disease_condition, drug_name)
select distinct nhs_dispensed_code, 'Angina' disease_group, disease_condition, drug_name
from pbs_code_to_disease_condition_mapping
where lower(DISEASE_CONDITION) like '%Transfer to a base-priced drug would cause patient confusion resulting in problems with compliance%' and drug_name = 'NIFEDIPINE';

insert into pbs_code_to_disease_condition_mapping(nhs_dispensed_code, disease_group, disease_condition, drug_name)
select distinct nhs_dispensed_code, 'Hyperparathyroidism' disease_group, disease_condition, drug_name
from pbs_code_to_disease_condition_mapping
where lower(DISEASE_CONDITION) like '%chronic kidney disease%ipth%';

insert into pbs_code_to_disease_condition_mapping(nhs_dispensed_code, disease_group, disease_condition, drug_name)
select distinct nhs_dispensed_code, 'Cholesterol' disease_group, disease_condition, drug_name
from pbs_code_to_disease_condition_mapping
WHERE lower(DISEASE_CONDITION) LIKE '%diabetes%' AND lower(DISEASE_CONDITION) LIKE '%hypercholesterolaemia%';