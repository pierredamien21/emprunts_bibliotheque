-- ================================
-- INDEX SUR LES CLÉS ÉTRANGÈRES
-- ================================

CREATE INDEX idx_membre_type
ON membre (id_type_membre);

CREATE INDEX idx_livre_categorie
ON livre (id_categorie);

CREATE INDEX idx_exemplaire_livre
ON exemplaire (id_livre);

CREATE INDEX idx_emprunt_membre
ON emprunt (id_membre);

CREATE INDEX idx_emprunt_exemplaire
ON emprunt (id_exemplaire);

CREATE INDEX idx_emprunt_bibliotecaire
ON emprunt (id_bibliotecaire);

CREATE INDEX idx_reservation_membre
ON reservation (id_membre);

CREATE INDEX idx_reservation_exemplaire
ON reservation (id_exemplaire);

CREATE INDEX idx_reservation_bibliotecaire
ON reservation (id_bibliotecaire);

CREATE INDEX idx_sanction_membre
ON sanction (id_membre);

CREATE INDEX idx_sanction_bibliotecaire
ON sanction (id_bibliotecaire);

-- ================================
-- INDEX MÉTIER (RECHERCHES FRÉQUENTES)
-- ================================

-- Recherche de livres par titre
CREATE INDEX idx_livre_titre
ON livre (titre);

-- Recherche par auteur
CREATE INDEX idx_livre_auteur
ON livre (auteur);

-- Exemplaires disponibles
CREATE INDEX idx_exemplaire_etat
ON exemplaire (etat);

-- Emprunts en cours / en retard
CREATE INDEX idx_emprunt_statut
ON emprunt (statut);

-- Réservations par statut
CREATE INDEX idx_reservation_statut
ON reservation (statut);

-- Sanctions non payées
CREATE INDEX idx_sanction_statut
ON sanction (statut);

-- ================================
-- INDEX COMPOSÉS (REQUÊTES AVANCÉES)
-- ================================

-- Un membre consulte ses emprunts par statut
CREATE INDEX idx_emprunt_membre_statut
ON emprunt (id_membre, statut);

-- Disponibilité des exemplaires d’un livre
CREATE INDEX idx_exemplaire_livre_etat
ON exemplaire (id_livre, etat);

-- File d’attente des réservations
CREATE INDEX idx_reservation_exemplaire_priorite
ON reservation (id_exemplaire, priorite);
