from typing import Optional
from pydantic import BaseModel

class Consulta(BaseModel):
    id: Optional[str]
    name: str  
    email: str
    password: str
