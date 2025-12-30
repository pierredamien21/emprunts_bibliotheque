from pydantic import BaseModel, EmailStr
from datetime import date
from typing import Optional


# ============================
# TYPE MEMBRE
# ============================
class TypeMembreBase(BaseModel):
    nom_type: str
    duree_max_emprunt: int
    nb_max_emprunt: int

class TypeMembreCreate(TypeMembreBase):
    pass

class TypeMembreRead(TypeMembreBase):
    id_type_membre: int

    class Config:
        from_attributes = True


# ============================
# MEMBRE
# ============================
class MembreBase(BaseModel):
    nom: str
    prenom: str
    email: EmailStr
    telephone: Optional[str] = None
    adresse: Optional[str] = None
    id_type_membre: int

class MembreCreate(MembreBase):
    pass

class MembreRead(MembreBase):
    id_membre: int
    date_inscription: date

    class Config:
        from_attributes = True


# ============================
# BIBLIOTÉCAIRE
# ============================
class BibliotecaireBase(BaseModel):
    nom: str
    prenom: str
    email: EmailStr
    telephone: Optional[str] = None

class BibliotecaireCreate(BibliotecaireBase):
    pass

class BibliotecaireRead(BibliotecaireBase):
    id_bibliotecaire: int

    class Config:
        from_attributes = True


# ============================
# CATEGORIE
# ============================
class CategorieBase(BaseModel):
    nom_categorie: str

class CategorieCreate(CategorieBase):
    pass

class CategorieRead(CategorieBase):
    id_categorie: int

    class Config:
        from_attributes = True


# ============================
# LIVRE
# ============================
class LivreBase(BaseModel):
    titre: str
    auteur: str
    annee_publication: Optional[int] = None
    id_categorie: int

class LivreCreate(LivreBase):
    pass

class LivreRead(LivreBase):
    id_livre: int

    class Config:
        from_attributes = True


# ============================
# EXEMPLAIRE
# ============================
class ExemplaireBase(BaseModel):
    code_barre: str
    etat: str
    id_livre: int

class ExemplaireCreate(ExemplaireBase):
    pass

class ExemplaireRead(ExemplaireBase):
    id_exemplaire: int

    class Config:
        from_attributes = True


# ============================
# EMPRUNT
# ============================
class EmpruntBase(BaseModel):
    id_membre: int
    id_exemplaire: int
    id_bibliotecaire: int
    date_retour_prevue: date

class EmpruntCreate(EmpruntBase):
    pass

class EmpruntRead(EmpruntBase):
    id_emprunt: int
    date_emprunt: date
    date_retour_effective: Optional[date]
    statut: str

    class Config:
        from_attributes = True


# ============================
# RESERVATION
# ============================
class ReservationBase(BaseModel):
    id_membre: int
    id_exemplaire: int
    id_bibliotecaire: int
    statut: str
    priorite: int

class ReservationCreate(ReservationBase):
    pass

class ReservationRead(ReservationBase):
    id_reservation: int
    date_reservation: date

    class Config:
        from_attributes = True


# ============================
# SANCTION
# ============================
class SanctionBase(BaseModel):
    id_membre: int
    id_bibliotecaire: int
    type_sanction: str
    montant: float
    statut: str

class SanctionCreate(SanctionBase):
    pass

class SanctionRead(SanctionBase):
    id_sanction: int
    date_sanction: date

    class Config:
        from_attributes = True
