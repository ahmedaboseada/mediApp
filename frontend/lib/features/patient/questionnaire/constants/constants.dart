import 'package:multi_dropdown/multi_dropdown.dart';

class QuestionnaireConstants {
  final List<DropdownItem<String>> allergies = [
    // ---------------- مضادات حيوية ----------------
    DropdownItem(label: 'Penicillin', value: 'Penicillin'),
    DropdownItem(label: 'Amoxicillin', value: 'Amoxicillin'),
    DropdownItem(label: 'Ampicillin', value: 'Ampicillin'),
    DropdownItem(label: 'Cephalexin', value: 'Cephalexin'),
    DropdownItem(label: 'Ceftriaxone', value: 'Ceftriaxone'),
    DropdownItem(label: 'Cefuroxime', value: 'Cefuroxime'),
    DropdownItem(label: 'Sulfamethoxazole', value: 'Sulfamethoxazole'),
    DropdownItem(label: 'Trimethoprim', value: 'Trimethoprim'),
    DropdownItem(label: 'Erythromycin', value: 'Erythromycin'),
    DropdownItem(label: 'Azithromycin', value: 'Azithromycin'),
    DropdownItem(label: 'Clarithromycin', value: 'Clarithromycin'),

    // ---------------- مضادات الالتهاب ومسكنات ----------------
    DropdownItem(label: 'Aspirin', value: 'Aspirin'),
    DropdownItem(label: 'Ibuprofen', value: 'Ibuprofen'),
    DropdownItem(label: 'Naproxen', value: 'Naproxen'),
    DropdownItem(label: 'Ketoprofen', value: 'Ketoprofen'),
    DropdownItem(label: 'Diclofenac', value: 'Diclofenac'),
    DropdownItem(label: 'Celecoxib', value: 'Celecoxib'),

    // ---------------- مسكنات ومخدرات ----------------
    DropdownItem(label: 'Morphine', value: 'Morphine'),
    DropdownItem(label: 'Codeine', value: 'Codeine'),
    DropdownItem(label: 'Tramadol', value: 'Tramadol'),
    DropdownItem(label: 'Fentanyl', value: 'Fentanyl'),

    // ---------------- مضادات الهيستامين ----------------
    DropdownItem(label: 'Cetirizine', value: 'Cetirizine'),
    DropdownItem(label: 'Loratadine', value: 'Loratadine'),
    DropdownItem(label: 'Diphenhydramine', value: 'Diphenhydramine'),
    DropdownItem(label: 'Fexofenadine', value: 'Fexofenadine'),
    DropdownItem(label: 'Chlorpheniramine', value: 'Chlorpheniramine'),

    // ---------------- مضادات الفطريات ----------------
    DropdownItem(label: 'Ketoconazole', value: 'Ketoconazole'),
    DropdownItem(label: 'Terbinafine', value: 'Terbinafine'),
    DropdownItem(label: 'Clotrimazole', value: 'Clotrimazole'),
    DropdownItem(label: 'Fluconazole', value: 'Fluconazole'),

    // ---------------- أدوية هضمية ----------------
    DropdownItem(label: 'Lactulose', value: 'Lactulose'),
    DropdownItem(label: 'Bisacodyl', value: 'Bisacodyl'),
    DropdownItem(label: 'Omeprazole', value: 'Omeprazole'),
    DropdownItem(label: 'Lansoprazole', value: 'Lansoprazole'),
    DropdownItem(label: 'Pantoprazole', value: 'Pantoprazole'),
    DropdownItem(label: 'Ranitidine', value: 'Ranitidine'),

    // ---------------- أدوية القلب وضغط الدم ----------------
    DropdownItem(label: 'Losartan', value: 'Losartan'),
    DropdownItem(label: 'Enalapril', value: 'Enalapril'),
    DropdownItem(label: 'Amlodipine', value: 'Amlodipine'),
    DropdownItem(label: 'Furosemide', value: 'Furosemide'),
    DropdownItem(label: 'Hydrochlorothiazide', value: 'Hydrochlorothiazide'),
    DropdownItem(label: 'Metoprolol', value: 'Metoprolol'),
    DropdownItem(label: 'Propranolol', value: 'Propranolol'),

    // ---------------- فيتامينات ومكملات ----------------
    DropdownItem(label: 'Vitamin B12', value: 'Vitamin B12'),
    DropdownItem(label: 'Vitamin D', value: 'Vitamin D'),
    DropdownItem(label: 'Vitamin C', value: 'Vitamin C'),
    DropdownItem(label: 'Vitamin E', value: 'Vitamin E'),
    DropdownItem(label: 'Iron', value: 'Iron'),
    DropdownItem(label: 'Zinc', value: 'Zinc'),
    DropdownItem(label: 'Calcium', value: 'Calcium'),
    DropdownItem(label: 'Magnesium', value: 'Magnesium'),

    // ---------------- مكونات في الكريمات والمراهم ----------------
    DropdownItem(label: 'Parabens', value: 'Parabens'),
    DropdownItem(label: 'Niacinamide', value: 'Niacinamide'),
    DropdownItem(label: 'Zinc Oxide', value: 'Zinc Oxide'),
    DropdownItem(label: 'Urea', value: 'Urea'),
    DropdownItem(label: 'Salicylic Acid', value: 'Salicylic Acid'),
    DropdownItem(label: 'Retinol', value: 'Retinol'),
    DropdownItem(label: 'Hydroquinone', value: 'Hydroquinone'),
    DropdownItem(label: 'Benzoyl Peroxide', value: 'Benzoyl Peroxide'),

    // ---------------- أطعمة ومكونات شائعة تسبب حساسية ----------------
    DropdownItem(label: 'Peanuts', value: 'Peanuts'),
    DropdownItem(label: 'Tree Nuts', value: 'Tree Nuts'),
    DropdownItem(label: 'Shellfish', value: 'Shellfish'),
    DropdownItem(label: 'Dairy', value: 'Dairy'),
    DropdownItem(label: 'Gluten', value: 'Gluten'),
    DropdownItem(label: 'Soy', value: 'Soy'),
    DropdownItem(label: 'Eggs', value: 'Eggs'),
    DropdownItem(label: 'Wheat', value: 'Wheat'),
    DropdownItem(label: 'Fish', value: 'Fish'),
    DropdownItem(label: 'Sesame', value: 'Sesame'),
    DropdownItem(label: 'Mustard', value: 'Mustard'),
    DropdownItem(label: 'Corn', value: 'Corn'),
    DropdownItem(label: 'Chocolate', value: 'Chocolate'),
    DropdownItem(label: 'Citrus', value: 'Citrus'),
    DropdownItem(label: 'Strawberries', value: 'Strawberries'),

    // ---------------- إضافات شائعة في الأغذية ----------------
    DropdownItem(label: 'Artificial Colors', value: 'Artificial Colors'),
    DropdownItem(label: 'Artificial Flavors', value: 'Artificial Flavors'),
    DropdownItem(label: 'Preservatives', value: 'Preservatives'),
    DropdownItem(label: 'MSG', value: 'MSG'),

    // ---------------- مواد كيميائية منزلية شائعة ----------------
    DropdownItem(label: 'Latex', value: 'Latex'),
    DropdownItem(label: 'Formaldehyde', value: 'Formaldehyde'),
    DropdownItem(label: 'Fragrances', value: 'Fragrances'),
    DropdownItem(label: 'Cleaning Agents', value: 'Cleaning Agents'),
  ];
  final List<DropdownItem<String>> healthConditions = [
    // -------- Chronic Diseases --------
    DropdownItem(label: 'Diabetes', value: 'Diabetes'),
    DropdownItem(label: 'Hypertension', value: 'Hypertension'),
    DropdownItem(label: 'Heart Disease', value: 'Heart Disease'),
    DropdownItem(
      label: 'Coronary Artery Disease',
      value: 'Coronary Artery Disease',
    ),
    DropdownItem(label: 'Heart Failure', value: 'Heart Failure'),
    DropdownItem(label: 'Stroke', value: 'Stroke'),

    // -------- Respiratory --------
    DropdownItem(label: 'Asthma', value: 'Asthma'),
    DropdownItem(label: 'COPD', value: 'COPD'),
    DropdownItem(label: 'Chronic Bronchitis', value: 'Chronic Bronchitis'),
    DropdownItem(label: 'Sleep Apnea', value: 'Sleep Apnea'),

    // -------- Endocrine --------
    DropdownItem(label: 'Hypothyroidism', value: 'Hypothyroidism'),
    DropdownItem(label: 'Hyperthyroidism', value: 'Hyperthyroidism'),
    DropdownItem(label: 'Polycystic Ovary Syndrome (PCOS)', value: 'PCOS'),

    // -------- Neurological --------
    DropdownItem(label: 'Epilepsy', value: 'Epilepsy'),
    DropdownItem(label: 'Migraine', value: 'Migraine'),
    DropdownItem(label: 'Multiple Sclerosis', value: 'Multiple Sclerosis'),
    DropdownItem(label: 'Parkinson’s Disease', value: 'Parkinson’s Disease'),
    DropdownItem(label: 'Alzheimer’s Disease', value: 'Alzheimer’s Disease'),

    // -------- Mental Health --------
    DropdownItem(label: 'Depression', value: 'Depression'),
    DropdownItem(label: 'Anxiety Disorder', value: 'Anxiety Disorder'),
    DropdownItem(label: 'Bipolar Disorder', value: 'Bipolar Disorder'),
    DropdownItem(label: 'PTSD', value: 'PTSD'),
    DropdownItem(label: 'ADHD', value: 'ADHD'),

    // -------- Autoimmune --------
    DropdownItem(label: 'Rheumatoid Arthritis', value: 'Rheumatoid Arthritis'),
    DropdownItem(label: 'Lupus (SLE)', value: 'Lupus'),
    DropdownItem(label: 'Psoriasis', value: 'Psoriasis'),
    DropdownItem(label: 'Celiac Disease', value: 'Celiac Disease'),
    DropdownItem(label: 'Inflammatory Bowel Disease (IBD)', value: 'IBD'),

    // -------- Digestive --------
    DropdownItem(label: 'Gastritis', value: 'Gastritis'),
    DropdownItem(label: 'GERD (Acid Reflux)', value: 'GERD'),
    DropdownItem(label: 'Irritable Bowel Syndrome (IBS)', value: 'IBS'),
    DropdownItem(label: 'Peptic Ulcer', value: 'Peptic Ulcer'),
    DropdownItem(label: 'Crohn’s Disease', value: 'Crohns Disease'),
    DropdownItem(label: 'Ulcerative Colitis', value: 'Ulcerative Colitis'),

    // -------- Kidney & Liver --------
    DropdownItem(
      label: 'Chronic Kidney Disease',
      value: 'Chronic Kidney Disease',
    ),
    DropdownItem(label: 'Kidney Stones', value: 'Kidney Stones'),
    DropdownItem(label: 'Hepatitis B', value: 'Hepatitis B'),
    DropdownItem(label: 'Hepatitis C', value: 'Hepatitis C'),
    DropdownItem(label: 'Liver Cirrhosis', value: 'Liver Cirrhosis'),

    // -------- Blood Disorders --------
    DropdownItem(label: 'Anemia', value: 'Anemia'),
    DropdownItem(label: 'Sickle Cell Disease', value: 'Sickle Cell Disease'),
    DropdownItem(label: 'Thalassemia', value: 'Thalassemia'),
    DropdownItem(label: 'Hemophilia', value: 'Hemophilia'),

    // -------- Hormonal & Reproductive --------
    DropdownItem(label: 'Infertility', value: 'Infertility'),
    DropdownItem(label: 'Endometriosis', value: 'Endometriosis'),
    DropdownItem(label: 'Pregnancy', value: 'Pregnancy'),
    DropdownItem(label: 'Postpartum', value: 'Postpartum'),

    // -------- Infectious Diseases --------
    DropdownItem(label: 'Tuberculosis (TB)', value: 'Tuberculosis'),
    DropdownItem(label: 'HIV/AIDS', value: 'HIV/AIDS'),
    DropdownItem(label: 'COVID-19 (History)', value: 'COVID-19'),

    // -------- Musculoskeletal --------
    DropdownItem(label: 'Osteoarthritis', value: 'Osteoarthritis'),
    DropdownItem(label: 'Osteoporosis', value: 'Osteoporosis'),
    DropdownItem(label: 'Chronic Back Pain', value: 'Chronic Back Pain'),
    DropdownItem(label: 'Fibromyalgia', value: 'Fibromyalgia'),

    // -------- Cancer --------
    DropdownItem(label: 'Cancer (History)', value: 'Cancer History'),
    DropdownItem(label: 'Breast Cancer', value: 'Breast Cancer'),
    DropdownItem(label: 'Colon Cancer', value: 'Colon Cancer'),
    DropdownItem(label: 'Lung Cancer', value: 'Lung Cancer'),

    // -------- Other --------
    DropdownItem(label: 'Obesity', value: 'Obesity'),
    DropdownItem(label: 'Immunodeficiency', value: 'Immunodeficiency'),
    DropdownItem(
      label: 'Chronic Fatigue Syndrome',
      value: 'Chronic Fatigue Syndrome',
    ),
    DropdownItem(label: 'None', value: 'None'),
  ];
  final List<DropdownItem<String>> longTermMedications = [
    // -------- Diabetes --------
    DropdownItem(label: 'Insulin', value: 'Insulin'),
    DropdownItem(label: 'Metformin', value: 'Metformin'),
    DropdownItem(label: 'Gliclazide', value: 'Gliclazide'),
    DropdownItem(label: 'Glimepiride', value: 'Glimepiride'),

    // -------- Hypertension & Heart --------
    DropdownItem(label: 'Amlodipine', value: 'Amlodipine'),
    DropdownItem(label: 'Losartan', value: 'Losartan'),
    DropdownItem(label: 'Enalapril', value: 'Enalapril'),
    DropdownItem(label: 'Valsartan', value: 'Valsartan'),
    DropdownItem(label: 'Bisoprolol', value: 'Bisoprolol'),
    DropdownItem(label: 'Metoprolol', value: 'Metoprolol'),
    DropdownItem(label: 'Hydrochlorothiazide', value: 'Hydrochlorothiazide'),
    DropdownItem(label: 'Furosemide', value: 'Furosemide'),

    // -------- Blood Thinners --------
    DropdownItem(label: 'Aspirin (Low dose)', value: 'Aspirin Low Dose'),
    DropdownItem(label: 'Clopidogrel', value: 'Clopidogrel'),
    DropdownItem(label: 'Warfarin', value: 'Warfarin'),
    DropdownItem(label: 'Apixaban', value: 'Apixaban'),
    DropdownItem(label: 'Rivaroxaban', value: 'Rivaroxaban'),

    // -------- Respiratory --------
    DropdownItem(label: 'Salbutamol Inhaler', value: 'Salbutamol'),
    DropdownItem(label: 'Budesonide Inhaler', value: 'Budesonide'),
    DropdownItem(label: 'Fluticasone', value: 'Fluticasone'),
    DropdownItem(label: 'Montelukast', value: 'Montelukast'),

    // -------- Thyroid --------
    DropdownItem(label: 'Levothyroxine', value: 'Levothyroxine'),
    DropdownItem(label: 'Carbimazole', value: 'Carbimazole'),

    // -------- Gastrointestinal --------
    DropdownItem(label: 'Omeprazole', value: 'Omeprazole'),
    DropdownItem(label: 'Pantoprazole', value: 'Pantoprazole'),
    DropdownItem(label: 'Esomeprazole', value: 'Esomeprazole'),

    // -------- Mental Health --------
    DropdownItem(label: 'Sertraline', value: 'Sertraline'),
    DropdownItem(label: 'Fluoxetine', value: 'Fluoxetine'),
    DropdownItem(label: 'Escitalopram', value: 'Escitalopram'),
    DropdownItem(label: 'Amitriptyline', value: 'Amitriptyline'),
    DropdownItem(label: 'Quetiapine', value: 'Quetiapine'),

    // -------- Neurology --------
    DropdownItem(label: 'Valproate', value: 'Valproate'),
    DropdownItem(label: 'Carbamazepine', value: 'Carbamazepine'),
    DropdownItem(label: 'Levetiracetam', value: 'Levetiracetam'),
    DropdownItem(label: 'Gabapentin', value: 'Gabapentin'),

    // -------- Rheumatology / Autoimmune --------
    DropdownItem(label: 'Methotrexate', value: 'Methotrexate'),
    DropdownItem(label: 'Sulfasalazine', value: 'Sulfasalazine'),
    DropdownItem(label: 'Hydroxychloroquine', value: 'Hydroxychloroquine'),
    DropdownItem(label: 'Prednisolone', value: 'Prednisolone'),

    // -------- Lipid Control --------
    DropdownItem(label: 'Atorvastatin', value: 'Atorvastatin'),
    DropdownItem(label: 'Rosuvastatin', value: 'Rosuvastatin'),
    DropdownItem(label: 'Simvastatin', value: 'Simvastatin'),

    // -------- Hormonal --------
    DropdownItem(label: 'Oral Contraceptive Pills', value: 'OCP'),
    DropdownItem(label: 'Hormone Replacement Therapy (HRT)', value: 'HRT'),

    // -------- Supplements (Long-term use) --------
    DropdownItem(label: 'Vitamin D', value: 'Vitamin D'),
    DropdownItem(label: 'Calcium', value: 'Calcium'),
    DropdownItem(label: 'Iron Supplements', value: 'Iron'),
    DropdownItem(label: 'Vitamin B12', value: 'Vitamin B12'),

    // -------- Other --------
    DropdownItem(label: 'Immunosuppressants', value: 'Immunosuppressants'),
    DropdownItem(label: 'Chemotherapy (Ongoing)', value: 'Chemotherapy'),
    DropdownItem(label: 'Other (Specify)', value: 'Other'),
    DropdownItem(label: 'None', value: 'None'),
  ];
}
