from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from pathlib import Path
import sys

# Ajoute le répertoire ORM au chemin Python
sys.path.insert(0, str(Path(__file__).parent.parent))

from database import get_db
from model.model import TypeMembre

router = APIRouter(prefix="/types-membres", tags=["Types de membres"])

@router.post("/")
def create(data: dict, db: Session = Depends(get_db)):
    obj = TypeMembre(**data)
    db.add(obj)
    db.commit()
    db.refresh(obj)
    return obj

@router.get("/")
def read_all(db: Session = Depends(get_db)):
    return db.query(TypeMembre).all()