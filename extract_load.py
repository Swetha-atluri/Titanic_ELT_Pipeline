
import os
import uuid
import pandas as pd
import seaborn as sns

from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.engine import URL

# Load database settings from .env
load_dotenv()

# 1. Extract Titanic dataset
df = sns.load_dataset("titanic")

# 2. Add required metadata
df["load_timestamp"] = pd.Timestamp.now()
df["batch_id"] = str(uuid.uuid4())

# 3. Create MySQL connection
connection_url = URL.create(
    drivername="mysql+pymysql",
    username=os.getenv("DB_USER"),
    password=os.getenv("DB_PASSWORD"),
    host=os.getenv("DB_HOST", "localhost"),
    port=int(os.getenv("DB_PORT", "3306")),
    database=os.getenv("DB_NAME", "titanic_db")
)

engine = create_engine(connection_url)

# 4. Load data into MySQL
try:
    df.to_sql(
        name="raw_titanic",
        con=engine,
        if_exists="replace",
        index=False
    )

    print("Titanic data loaded successfully!")
    print("Total rows:", len(df))
    print("Table name: raw_titanic")

finally:
    engine.dispose()
