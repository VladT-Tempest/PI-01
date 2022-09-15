from fastapi import FastAPI
from routes.consultas import consulta 

app = FastAPI(
            title = 'PI-01',
            description='API usando FASTAPI y MySQL en Docker',
            openapi_tags=[{
                "name": "consultas",
                "description": "Consultas predefinidas"
            }]
)

app.include_router(consulta)

