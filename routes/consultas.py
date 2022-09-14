from fastapi import APIRouter
from config.db import conn
from models.consulta import consultas
from schemas.consulta import Consulta

consulta = APIRouter()

@consulta.get("/consultas")
def get_consultas():
    return conn.execute(consultas.select()).fetchall()

@consulta.post("/consultas")
def create_consulta(consulta: Consulta):
    print(consulta)
    return 'Hello, world'