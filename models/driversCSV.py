from sqlalchemy import Table, Column 
from sqlalchemy.sql.sqltypes import Integer, String, Date
from config.db import meta, engine 

drivers = Table("driversCSV", meta, 
    Column("driverid", Integer, primary_key=True),
    Column("driverRef", String(100)),
    Column("number", String(10)),
    Column("code", String(10)),
    Column("name", String(50)),
    Column("surname", String(50)),
    Column("dob", Date),
    Column("nationality", String(100)),
    Column("url", String(250))
)

