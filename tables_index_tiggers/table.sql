-- ================================
-- 1. TYPE_MEMBRE
-- ================================
CREATE TABLE type_membre (
    id_type_membre SERIAL PRIMARY KEY,
    nom_type VARCHAR(50) NOT NULL UNIQUE,
    duree_max_emprunt INT NOT NULL CHECK (duree_max_emprunt > 0),
    nb_max_emprunt INT NOT NULL CHECK (nb_max_emprunt >= 0)
);

-- ================================
-- 2. MEMBRE
-- ================================
CREATE TABLE membre (
    id_membre SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telephone VARCHAR(20),
    adresse TEXT,
    date_inscription DATE NOT NULL DEFAULT CURRENT_DATE,
    id_type_membre INT NOT NULL,

    CONSTRAINT fk_membre_type
        FOREIGN KEY (id_type_membre)
        REFERENCES type_membre(id_type_membre)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ================================
-- 3. BIBLIOTECAIRE
-- ================================
CREATE TABLE bibliotecaire (
    id_bibliotecaire SERIAL PRIMARY KEY,
    nom VARCHAR(100) NOT NULL,
    prenom VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    telephone VARCHAR(20)
);

-- ================================
-- 4. CATEGORIE
-- ================================
CREATE TABLE categorie (
    id_categorie SERIAL PRIMARY KEY,
    nom_categorie VARCHAR(100) NOT NULL UNIQUE
);

-- ================================
-- 5. LIVRE
-- ================================
CREATE TABLE livre (
    id_livre SERIAL PRIMARY KEY,
    titre VARCHAR(255) NOT NULL,
    auteur VARCHAR(255) NOT NULL,
    annee_publication INT CHECK (annee_publication > 0),
    id_categorie INT NOT NULL,

    CONSTRAINT fk_livre_categorie
        FOREIGN KEY (id_categorie)
        REFERENCES categorie(id_categorie)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

-- ================================
-- 6. EXEMPLAIRE
-- ================================
CREATE TABLE exemplaire (
    id_exemplaire SERIAL PRIMARY KEY,
    id_livre INT NOT NULL,
    code_barre VARCHAR(100) NOT NULL UNIQUE,
    etat VARCHAR(20) NOT NULL
        CHECK (etat IN ('Disponible', 'Emprunté', 'Réservé', 'Abîmé')),

    CONSTRAINT fk_exemplaire_livre
        FOREIGN KEY (id_livre)
        REFERENCES livre(id_livre)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- ================================
-- 7. EMPRUNT
-- ================================
CREATE TABLE emprunt (
    id_emprunt SERIAL PRIMARY KEY,
    id_membre INT NOT NULL,
    id_exemplaire INT NOT NULL,
    id_bibliotecaire INT NOT NULL,
    date_emprunt DATE NOT NULL DEFAULT CURRENT_DATE,
    date_retour_prevue DATE NOT NULL,
    date_retour_effective DATE,
    statut VARCHAR(20) NOT NULL
        CHECK (statut IN ('En cours', 'Terminé', 'Retard')),

    CONSTRAINT fk_emprunt_membre
        FOREIGN KEY (id_membre)
        REFERENCES membre(id_membre),

    CONSTRAINT fk_emprunt_exemplaire
        FOREIGN KEY (id_exemplaire)
        REFERENCES exemplaire(id_exemplaire),

    CONSTRAINT fk_emprunt_bibliotecaire
        FOREIGN KEY (id_bibliotecaire)
        REFERENCES bibliotecaire(id_bibliotecaire)
);

-- ================================
-- 8. RESERVATION
-- ================================
CREATE TABLE reservation (
    id_reservation SERIAL PRIMARY KEY,
    id_membre INT NOT NULL,
    id_exemplaire INT NOT NULL,
    id_bibliotecaire INT NOT NULL,
    date_reservation DATE NOT NULL DEFAULT CURRENT_DATE,
    statut VARCHAR(20) NOT NULL
        CHECK (statut IN ('En attente', 'Confirmée', 'Annulée')),
    priorite INT NOT NULL CHECK (priorite > 0),

    CONSTRAINT fk_reservation_membre
        FOREIGN KEY (id_membre)
        REFERENCES membre(id_membre),

    CONSTRAINT fk_reservation_exemplaire
        FOREIGN KEY (id_exemplaire)
        REFERENCES exemplaire(id_exemplaire),

    CONSTRAINT fk_reservation_bibliotecaire
        FOREIGN KEY (id_bibliotecaire)
        REFERENCES bibliotecaire(id_bibliotecaire)
);

-- ================================
-- 9. SANCTION
-- ================================
CREATE TABLE sanction (
    id_sanction SERIAL PRIMARY KEY,
    id_membre INT NOT NULL,
    id_bibliotecaire INT NOT NULL,
    type_sanction VARCHAR(20) NOT NULL
        CHECK (type_sanction IN ('Retard', 'Perte', 'Dommage')),
    montant NUMERIC(10,2) NOT NULL CHECK (montant >= 0),
    date_sanction DATE NOT NULL DEFAULT CURRENT_DATE,
    statut VARCHAR(20) NOT NULL
        CHECK (statut IN ('Payée', 'Non payée')),

    CONSTRAINT fk_sanction_membre
        FOREIGN KEY (id_membre)
        REFERENCES membre(id_membre),

    CONSTRAINT fk_sanction_bibliotecaire
        FOREIGN KEY (id_bibliotecaire)
        REFERENCES bibliotecaire(id_bibliotecaire)
);
