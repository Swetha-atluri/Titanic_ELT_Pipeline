
from pathlib import Path
import subprocess
import sys
import os

from dotenv import load_dotenv

folder = Path(__file__).parent
sql_folder = folder / "sql"

load_dotenv(folder / ".env")

def run_pipeline():
    print("Starting Titanic ELT Pipeline...")

    # Step 1: Extract and load raw data
    subprocess.run(
        [sys.executable, str(folder / "extract_load.py")],
        check=True,
        cwd=folder
    )

    # Step 2: Execute SQL files in order
    sql_files = [
        "01_staging.sql",
        "02_transform.sql",
        "03_analytics.sql",
        "04_data_quality.sql"
    ]

    for filename in sql_files:
        sql_path = sql_folder / filename

        if not sql_path.exists():
            print(f"FAIL: {filename} not found")
            sys.exit(1)

        print(f"Running {filename}...", end=" ")

        result = subprocess.run(
            [
                "mysql",
                "--host=" + os.getenv("DB_HOST", "localhost"),
                "--port=" + os.getenv("DB_PORT", "3306"),
                "--user=" + os.getenv("DB_USER", "root"),
                "--password=" + os.getenv("DB_PASSWORD", ""),
                os.getenv("DB_NAME", "titanic_db")
            ],
            input=sql_path.read_text(encoding="utf-8"),
            text=True,
            capture_output=True,
            cwd=folder
        )

        if result.returncode != 0:
            print("FAIL")
            print(result.stderr)
            sys.exit(1)

        print("PASS")

    print("ELT pipeline execution completed.")

if __name__ == "__main__":
    run_pipeline()
