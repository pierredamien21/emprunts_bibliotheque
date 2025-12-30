-- =====================================================
-- VUES SQL - TABLEAUX DE BORD
-- Base de données : Bibliothèque
-- =====================================================


-- =====================================================
-- 1. LIVRES / EXEMPLAIRES DISPONIBLES
-- =====================================================

CREATE OR REPLACE VIEW vue_exemplaires_disponibles AS
SELECT
    e.id_exemplaire,
    l.titre,
    l.auteur,
    c.nom_categorie,
    e.code_barre
FROM exemplaire e
JOIN livre l ON e.id_livre = l.id_livre
JOIN categorie c ON l.id_categorie = c.id_categorie
WHERE e.etat = 'Disponible';


-- =====================================================
-- 2. EMPRUNTS EN COURS
-- =====================================================

CREATE OR REPLACE VIEW vue_emprunts_en_cours AS
SELECT
    em.id_emprunt,
    m.nom,
    m.prenom,
    l.titre,
    e.code_barre,
    em.date_emprunt,
    em.date_retour_prevue
FROM emprunt em
JOIN membre m ON em.id_membre = m.id_membre
JOIN exemplaire e ON em.id_exemplaire = e.id_exemplaire
JOIN livre l ON e.id_livre = l.id_livre
WHERE em.statut = 'En cours';


-- =====================================================
-- 3. EMPRUNTS EN RETARD
-- =====================================================

CREATE OR REPLACE VIEW vue_emprunts_retard AS
SELECT
    em.id_emprunt,
    m.nom,
    m.prenom,
    l.titre,
    em.date_retour_prevue,
    CURRENT_DATE - em.date_retour_prevue AS jours_retard
FROM emprunt em
JOIN membre m ON em.id_membre = m.id_membre
JOIN exemplaire e ON em.id_exemplaire = e.id_exemplaire
JOIN livre l ON e.id_livre = l.id_livre
WHERE em.statut = 'Retard';


-- =====================================================
-- 4. HISTORIQUE DES EMPRUNTS
-- =====================================================

CREATE OR REPLACE VIEW vue_historique_emprunts AS
SELECT
    em.id_emprunt,
    m.nom,
    m.prenom,
    l.titre,
    em.date_emprunt,
    em.date_retour_effective,
    em.statut
FROM emprunt em
JOIN membre m ON em.id_membre = m.id_membre
JOIN exemplaire e ON em.id_exemplaire = e.id_exemplaire
JOIN livre l ON e.id_livre = l.id_livre;


-- =====================================================
-- 5. RÉSERVATIONS EN ATTENTE
-- =====================================================

CREATE OR REPLACE VIEW vue_reservations_en_attente AS
SELECT
    r.id_reservation,
    m.nom,
    m.prenom,
    l.titre,
    r.date_reservation,
    r.priorite
FROM reservation r
JOIN membre m ON r.id_membre = m.id_membre
JOIN exemplaire e ON r.id_exemplaire = e.id_exemplaire
JOIN livre l ON e.id_livre = l.id_livre
WHERE r.statut = 'En attente'
ORDER BY r.priorite;


-- =====================================================
-- 6. SANCTIONS NON PAYÉES
-- =====================================================

CREATE OR REPLACE VIEW vue_sanctions_non_payees AS
SELECT
    s.id_sanction,
    m.nom,
    m.prenom,
    s.type_sanction,
    s.montant,
    s.date_sanction
FROM sanction s
JOIN membre m ON s.id_membre = m.id_membre
WHERE s.statut = 'Non payée';


-- =====================================================
-- 7. TABLEAU DE BORD PAR MEMBRE
-- =====================================================

CREATE OR REPLACE VIEW vue_dashboard_membre AS
SELECT
    m.id_membre,
    m.nom,
    m.prenom,
    tm.nom_type,
    COUNT(em.id_emprunt) FILTER (WHERE em.statut = 'En cours') AS emprunts_en_cours,
    COUNT(em.id_emprunt) FILTER (WHERE em.statut = 'Retard') AS emprunts_en_retard,
    COUNT(s.id_sanction) FILTER (WHERE s.statut = 'Non payée') AS sanctions_non_payees
FROM membre m
JOIN type_membre tm ON m.id_type_membre = tm.id_type_membre
LEFT JOIN emprunt em ON em.id_membre = m.id_membre
LEFT JOIN sanction s ON s.id_membre = m.id_membre
GROUP BY m.id_membre, tm.nom_type;
