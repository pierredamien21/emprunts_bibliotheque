from sqlalchemy import (
    Column, Integer, String, Date, ForeignKey
)
from sqlalchemy.orm import relationship
from datetime import date
from sqlalchemy import (
    Column, Integer, String, Date, ForeignKey
)
from sqlalchemy.orm import relationship
from datetime import date
import sys
from pathlib import Path

# Ajoute le répertoire ORM au chemin Python
sys.path.insert(0, str(Path(__file__).parent.parent))

from database import Base


# ============================
# TYPE_MEMBRE
# ============================
class TypeMembre(Base):
    __tablename__ = "type_membre"

    id_type_membre = Column(Integer, primary_key=True)
    nom_type = Column(String(50), unique=True, nullable=False)
    duree_max_emprunt = Column(Integer, nullable=False)
    nb_max_emprunt = Column(Integer, nullable=False)

    membres = relationship("Membre", back_populates="type_membre")


# ============================
# MEMBRE
# ============================
class Membre(Base):
    __tablename__ = "membre"

    id_membre = Column(Integer, primary_key=True)
    nom = Column(String(100), nullable=False)
    prenom = Column(String(100), nullable=False)
    email = Column(String(150), unique=True, nullable=False)
    telephone = Column(String(20))
    adresse = Column(String)
    date_inscription = Column(Date, default=date.today)

    id_type_membre = Column(
        Integer,
        ForeignKey("type_membre.id_type_membre"),
        nullable=False
    )

    type_membre = relationship("TypeMembre", back_populates="membres")
    emprunts = relationship("Emprunt", back_populates="membre")
    reservations = relationship("Reservation", back_populates="membre")
    sanctions = relationship("Sanction", back_populates="membre")


# ============================
# BIBLIOTECAIRE
# ============================
class Bibliotecaire(Base):
    __tablename__ = "bibliotecaire"

    id_bibliotecaire = Column(Integer, primary_key=True)
    nom = Column(String(100), nullable=False)
    prenom = Column(String(100), nullable=False)
    email = Column(String(150), unique=True, nullable=False)
    telephone = Column(String(20))

    emprunts = relationship("Emprunt", back_populates="bibliotecaire")
    reservations = relationship("Reservation", back_populates="bibliotecaire")
    sanctions = relationship("Sanction", back_populates="bibliotecaire")


# ============================
# CATEGORIE
# ============================
class Categorie(Base):
    __tablename__ = "categorie"

    id_categorie = Column(Integer, primary_key=True)
    nom_categorie = Column(String(100), unique=True, nullable=False)

    livres = relationship("Livre", back_populates="categorie")


# ============================
# LIVRE
# ============================
class Livre(Base):
    __tablename__ = "livre"

    id_livre = Column(Integer, primary_key=True)
    titre = Column(String(255), nullable=False)
    auteur = Column(String(255), nullable=False)
    annee_publication = Column(Integer)

    id_categorie = Column(
        Integer,
        ForeignKey("categorie.id_categorie"),
        nullable=False
    )

    categorie = relationship("Categorie", back_populates="livres")
    exemplaires = relationship("Exemplaire", back_populates="livre")


# ============================
# EXEMPLAIRE
# ============================
class Exemplaire(Base):
    __tablename__ = "exemplaire"

    id_exemplaire = Column(Integer, primary_key=True)
    code_barre = Column(String(100), unique=True, nullable=False)
    etat = Column(String(20), nullable=False)

    id_livre = Column(
        Integer,
        ForeignKey("livre.id_livre"),
        nullable=False
    )

    livre = relationship("Livre", back_populates="exemplaires")
    emprunts = relationship("Emprunt", back_populates="exemplaire")
    reservations = relationship("Reservation", back_populates="exemplaire")


# ============================
# EMPRUNT
# ============================
class Emprunt(Base):
    __tablename__ = "emprunt"

    id_emprunt = Column(Integer, primary_key=True)
    date_emprunt = Column(Date, default=date.today, nullable=False)
    date_retour_prevue = Column(Date, nullable=False)
    date_retour_effective = Column(Date)
    statut = Column(String(20), nullable=False)

    id_membre = Column(
        Integer,
        ForeignKey("membre.id_membre"),
        nullable=False
    )
    id_exemplaire = Column(
        Integer,
        ForeignKey("exemplaire.id_exemplaire"),
        nullable=False
    )
    id_bibliotecaire = Column(
        Integer,
        ForeignKey("bibliotecaire.id_bibliotecaire"),
        nullable=False
    )

    membre = relationship("Membre", back_populates="emprunts")
    exemplaire = relationship("Exemplaire", back_populates="emprunts")
    bibliotecaire = relationship("Bibliotecaire", back_populates="emprunts")


# ============================
# RESERVATION
# ============================
class Reservation(Base):
    __tablename__ = "reservation"

    id_reservation = Column(Integer, primary_key=True)
    date_reservation = Column(Date, default=date.today, nullable=False)
    statut = Column(String(20), nullable=False)
    priorite = Column(Integer, nullable=False)

    id_membre = Column(
        Integer,
        ForeignKey("membre.id_membre"),
        nullable=False
    )
    id_exemplaire = Column(
        Integer,
        ForeignKey("exemplaire.id_exemplaire"),
        nullable=False
    )
    id_bibliotecaire = Column(
        Integer,
        ForeignKey("bibliotecaire.id_bibliotecaire"),
        nullable=False
    )

    membre = relationship("Membre", back_populates="reservations")
    exemplaire = relationship("Exemplaire", back_populates="reservations")
    bibliotecaire = relationship("Bibliotecaire", back_populates="reservations")


# ============================
# SANCTION
# ============================
class Sanction(Base):
    __tablename__ = "sanction"

    id_sanction = Column(Integer, primary_key=True)
    type_sanction = Column(String(20), nullable=False)
    montant = Column(Integer, nullable=False)
    date_sanction = Column(Date, default=date.today, nullable=False)
    statut = Column(String(20), nullable=False)

    id_membre = Column(
        Integer,
        ForeignKey("membre.id_membre"),
        nullable=False
    )
    id_bibliotecaire = Column(
        Integer,
        ForeignKey("bibliotecaire.id_bibliotecaire"),
        nullable=False
    )

    membre = relationship("Membre", back_populates="sanctions")
    bibliotecaire = relationship("Bibliotecaire", back_populates="sanctions")