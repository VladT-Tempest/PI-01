from sqlalchemy import create_engine, MetaData

engine = create_engine('mysql+pymysql://root:mypassword@localhost:3306/racesdb')

meta = MetaData()

conn = engine.connect()



