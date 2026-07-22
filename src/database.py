from pathlib import Path
import os

from dotenv import load_dotenv
from sqlalchemy import create_engine
from sqlalchemy.engine import URL


def get_engine():

    # Find the project root
    project_root = Path(__file__).resolve().parent.parent

    # Load the .env file
    load_dotenv(project_root / ".env")

    # Create the database URL
    database_url = URL.create(
        drivername="postgresql+psycopg2",
        username=os.getenv("POSTGRES_USER"),
        password=os.getenv("POSTGRES_PASSWORD"),
        host=os.getenv("POSTGRES_HOST"),
        port=int(os.getenv("POSTGRES_PORT")),
        database=os.getenv("POSTGRES_DATABASE"),
    )

    return create_engine(database_url)