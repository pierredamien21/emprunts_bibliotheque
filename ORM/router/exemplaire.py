from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from database import get_db
from model.model import Exemplaire

router = APIRouter(prefix="/exemplaires", tags=["Exemplaires"])

@router.post("/")
def create(data: dict, db: Session = Depends(get_db)):
    obj = Exemplaire(**data)
    db.add(obj); db.commit(); db.refresh(obj)
    return obj

@router.get("/")
def read_all(db: Session = Depends(get_db)):
    return db.query(Exemplaire).all()
