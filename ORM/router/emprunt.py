from fastapi import APIRouter, Depends, HTTPException
from sqlalchemy.orm import Session
from pathlib import Path
import sys

# Ajoute le répertoire ORM au chemin Python
sys.path.insert(0, str(Path(__file__).parent.parent))
from database import get_db
from model.model import Emprunt
from datetime import date

router = APIRouter(prefix="/emprunts", tags=["Emprunts"])

@router.post("/")
def create(data: dict, db: Session = Depends(get_db)):
    obj = Emprunt(date_emprunt=date.today(), **data)
    db.add(obj)
    try:
        db.commit()
    except Exception as e:
        db.rollback()
        raise HTTPException(400, str(e))
    db.refresh(obj)
    return obj

@router.get("/en-cours")
def en_cours(db: Session = Depends(get_db)):
    return db.query(Emprunt).filter(Emprunt.statut == "En cours").all()

@router.put("/{id}/retour")
def retour(id: int, db: Session = Depends(get_db)):
    obj = db.get(Emprunt, id)
    if not obj:
        raise HTTPException(404, "Emprunt introuvable")
    obj.date_retour_effective = date.today()
    db.commit()
    return {"message": "Retour effectué"}
