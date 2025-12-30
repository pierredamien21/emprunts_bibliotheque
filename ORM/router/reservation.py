from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from pathlib import Path
import sys

# Ajoute le répertoire ORM au chemin Python
sys.path.insert(0, str(Path(__file__).parent.parent))
from database import get_db
from model.model import Reservation
from datetime import date

router = APIRouter(prefix="/reservations", tags=["Réservations"])

@router.post("/")
def create(data: dict, db: Session = Depends(get_db)):
    obj = Reservation(date_reservation=date.today(), **data)
    db.add(obj); db.commit(); db.refresh(obj)
    return obj

@router.get("/en-attente")
def en_attente(db: Session = Depends(get_db)):
    return db.query(Reservation).filter(
        Reservation.statut == "En attente"
    ).all()
