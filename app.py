from fastapi import FastAPI
from routes.consultas import consulta 

app = FastAPI()

app.include_router(consulta)

