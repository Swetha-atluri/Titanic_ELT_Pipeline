# Titanic ELT Pipeline

## 📌 Project Overview

The **Titanic ELT Pipeline** is a data engineering project that demonstrates how to extract and load raw data into a MySQL database, transform the data using SQL, and generate analytical insights through SQL views.

The project follows the **ELT (Extract, Load, Transform)** approach, where raw data is loaded into the database before cleaning and transformation take place. The original raw dataset is retained separately from the staging and cleaned tables.

## 🎯 Objectives

- Extract the Titanic dataset using Python.
- Load raw data into MySQL while preserving its original values and missing data.
- Perform data cleaning and transformation using SQL.
- Create analytical views to examine passenger survival patterns.
- Implement data-quality checks to validate the transformed dataset.
- Automate the pipeline execution using Python.

## 🛠️ Technologies Used

- **Python** – Data extraction and pipeline orchestration
- **Pandas** – Dataset handling and loading
- **Seaborn** – Titanic dataset source
- **MySQL** – Data storage, transformation, and analytics
- **SQL** – Data cleaning, aggregation, window functions, and quality checks
- **SQLAlchemy** – Python–MySQL connectivity
- **python-dotenv** – Environment variable management
- **Git and GitHub** – Version control and project hosting

## 🏗️ Project Workflow

1. **Extract and Load:** Retrieve the Titanic dataset and load it into the `raw_titanic` table, including load metadata.
2. **Staging:** Create `stg_titanic` with clearer column names and normalized text values.
3. **Transformation:** Create `clean_passengers` by handling missing values and deriving additional passenger attributes.
4. **Analytics:** Create SQL views to analyze survival rates and identify passengers with the highest fares.
5. **Data Quality:** Store validation results in the `dq_results` table.
6. **Automation:** Use `run_elt.py` to execute the extraction, loading, and SQL scripts in sequence.

## 📊 Data Transformations

The transformation stage is designed to include:

- Filling missing ages using the average age for the same passenger class and sex.
- Filling missing embarkation values using the most frequent value.
- Encoding sex as numeric values.
- Categorizing passengers into Child, Teen, Adult, and Senior age groups.
- Calculating family size and identifying passengers traveling alone.
- Categorizing fares into quartiles: Low, Medium, High, and Premium.

## 📈 Analytical Views

The pipeline creates three analytical views:

- `survival_by_class_sex` – Examines survival rates by passenger class and sex.
- `survival_by_age_group` – Analyzes survival rates across age groups.
- `top_3_fares_by_class` – Identifies the three highest-fare passengers in each passenger class.


## 📁 Project Structure

```text
Titanic_ELT_Pipeline/
│
├── sql/
│   ├── 01_staging.sql
│   ├── 02_transform.sql
│   ├── 03_analytics.sql
│   └── 04_data_quality.sql
│
├── extract_load.py
├── run_elt.py
├── .env
└── README.md
```


## ⚙️ Setup and Execution

### 1. Clone the repository

```bash
git clone <YOUR_GITHUB_REPOSITORY_URL>
cd Titanic_ELT_Pipeline
```

### 2. Create and activate a virtual environment

```bash
python -m venv .venv
```

Windows PowerShell:

```powershell
.\.venv\Scripts\Activate.ps1
```

### 3. Install dependencies

```bash
pip install pandas seaborn sqlalchemy pymysql python-dotenv
```

### 4. Configure database credentials

Create a `.env` file in the project root:

```text
DB_HOST=localhost
DB_PORT=3306
DB_USER=your_mysql_username
DB_PASSWORD=your_mysql_password
DB_NAME=titanic_db
```

Create the `titanic_db` database in MySQL before running the pipeline.

### 5. Run the pipeline

```bash
python run_elt.py
```

The script loads the raw dataset and executes the SQL scripts in sequence. Check the terminal output and the `dq_results` table to verify the execution and data-quality results.

## 🎓 Learning Outcomes

This project demonstrates practical skills in ELT pipeline development, relational database management, SQL-based data transformation, analytical views, data validation, and Python automation.
