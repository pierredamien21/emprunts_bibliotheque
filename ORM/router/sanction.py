from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from pathlib import Path
import sys

# Ajoute le répertoire ORM au chemin Python
sys.path.insert(0, str(Path(__file__).parent.parent))
from database import get_db
from model.model import Sanction
from datetime import date

router = APIRouter(prefix="/sanctions", tags=["Sanctions"])

@router.post("/")
def create(data: dict, db: Session = Depends(get_db)):
    obj = Sanction(date_sanction=date.today(), **data)
    db.add(obj); db.commit(); db.refresh(obj)
    return obj

@router.get("/non-payees")
def non_payees(db: Session = Depends(get_db)):
    return db.query(Sanction).filter(
        Sanction.statut == "Non payée"
    ).all()
