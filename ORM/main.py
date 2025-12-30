from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from router import (
    type_membre,
    membre,
    bibliotecaire,
    categorie,
    livre,
    exemplaire,
    emprunt,
    reservation,
    sanction
)

app = FastAPI(
    title="API Gestion de Bibliothèque",
    description="API REST pour la gestion des membres, livres, emprunts et sanctions",
    version="1.0.0"
)

# ============================
# CORS (si front plus tard)
# ============================
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # à restreindre en production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ============================
# ROUTERS
# ============================
app.include_router(type_membre)
app.include_router(membre)
app.include_router(bibliotecaire)
app.include_router(categorie)
app.include_router(livre)
app.include_router(exemplaire)
app.include_router(emprunt)
app.include_router(reservation)
app.include_router(sanction)


# ============================
# ROUTE RACINE
# ============================
@app.get("/")
def root():
    return {
        "message": "API Bibliothèque opérationnelle 🚀",
        "docs": "/docs",
        "redoc": "/redoc"
    }
