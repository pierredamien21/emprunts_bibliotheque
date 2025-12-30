from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pathlib import Path
import sys

# Ajoute le répertoire ORM au chemin Python
sys.path.insert(0, str(Path(__file__).parent.parent))
from database import get_db
from model.model import Membre

router = APIRouter(prefix="/membres", tags=["Membres"])

@router.post("/")
def create(data: dict, db: Session = Depends(get_db)):
    obj = Membre(**data)
    db.add(obj); db.commit(); db.refresh(obj)
    return obj

@router.get("/")
def read_all(db: Session = Depends(get_db)):
    return db.query(Membre).all()

@router.get("/{id}")
def read(id: int, db: Session = Depends(get_db)):
    obj = db.get(Membre, id)
    if not obj:
        raise HTTPException(404, "Membre introuvable")
    return obj

@router.delete("/{id}")
def delete(id: int, db: Session = Depends(get_db)):
    obj = db.get(Membre, id)
    if not obj:
        raise HTTPException(404, "Membre introuvable")
    db.delete(obj); db.commit()
