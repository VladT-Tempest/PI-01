from fastapi import APIRouter
from config.db import conn
from models.consulta import consultas
from models.driversCSV import drivers 
from schemas.consulta import Consulta

consulta = APIRouter()

#     Año con más carreras     
query1 = 'SELECT year, COUNT(year) AS Total_Carreras \
    FROM RacesCSV \
    GROUP BY year \
    ORDER BY Total_Carreras DESC \
    LIMIT 1'

# Piloto con mayor cantidad de primeros puestos
query2 = 'SELECT d.driverid, d.name, d.surname ,COUNT(d.driverid) AS C_Ganadas, \
    r.position \
    FROM driversCSV AS d \
    INNER JOIN  resultsCSV AS r ON d.driverid = r.driverid \
    WHERE r.position = 1 \
    GROUP BY d.driverid \
    ORDER BY C_Ganadas DESC \
    LIMIT 1'

#  Nombre del circuito más corrido 
query3 = 'SELECT r.circuitId, COUNT(r.circuitId) AS Veces_Corridas, \
        c.name, c.location, c.country \
        FROM RacesCSV AS r \
        INNER JOIN circuitidCSV as c ON r.circuitId = c.circuitid \
        GROUP BY r.circuitId \
        ORDER BY Veces_Corridas DESC \
        LIMIT 1'


@consulta.get("/consulta1")
def get_drivers():
    return conn.execute(query1).fetchall()


@consulta.get("/consulta2")
def get_drivers():
    return conn.execute(query2).fetchall()

@consulta.get("/consulta3")
def get_drivers():
    return conn.execute(query3).fetchall()

@consulta.post("/consultas")
def create_consulta(consulta: Consulta):
    print(consulta)
    return 'Hello, world'