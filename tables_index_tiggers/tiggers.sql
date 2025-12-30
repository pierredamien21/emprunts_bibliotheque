-- =====================================================
-- TRIGGERS & REGLES METIER
-- Base de données : Bibliothèque
-- =====================================================


-- =====================================================
-- 1. EMPÊCHER PLUSIEURS EMPRUNTS ACTIFS PAR EXEMPLAIRE
-- =====================================================

CREATE OR REPLACE FUNCTION verifier_exemplaire_disponible()
RETURNS TRIGGER AS $$
BEGIN
    IF EXISTS (
        SELECT 1
        FROM emprunt
        WHERE id_exemplaire = NEW.id_exemplaire
          AND statut = 'En cours'
    ) THEN
        RAISE EXCEPTION 'Cet exemplaire est déjà emprunté';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_exemplaire_disponible
BEFORE INSERT ON emprunt
FOR EACH ROW
EXECUTE FUNCTION verifier_exemplaire_disponible();


-- =====================================================
-- 2. LIMITER LE NOMBRE D’EMPRUNTS PAR MEMBRE
-- =====================================================

CREATE OR REPLACE FUNCTION verifier_quota_emprunts()
RETURNS TRIGGER AS $$
DECLARE
    nb_emprunts_actifs INT;
    max_emprunts INT;
BEGIN
    -- Nombre d’emprunts en cours
    SELECT COUNT(*)
    INTO nb_emprunts_actifs
    FROM emprunt
    WHERE id_membre = NEW.id_membre
      AND statut = 'En cours';

    -- Quota autorisé
    SELECT tm.nb_max_emprunt
    INTO max_emprunts
    FROM membre m
    JOIN type_membre tm ON m.id_type_membre = tm.id_type_membre
    WHERE m.id_membre = NEW.id_membre;

    IF nb_emprunts_actifs >= max_emprunts THEN
        RAISE EXCEPTION 'Quota maximal d’emprunts atteint';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_quota_emprunt
BEFORE INSERT ON emprunt
FOR EACH ROW
EXECUTE FUNCTION verifier_quota_emprunts();


-- =====================================================
-- 3. MISE À JOUR AUTOMATIQUE DE L’ÉTAT DE L’EXEMPLAIRE
-- =====================================================

CREATE OR REPLACE FUNCTION maj_etat_exemplaire_emprunt()
RETURNS TRIGGER AS $$
BEGIN
    UPDATE exemplaire
    SET etat = 'Emprunté'
    WHERE id_exemplaire = NEW.id_exemplaire;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_maj_etat_exemplaire_emprunt
AFTER INSERT ON emprunt
FOR EACH ROW
EXECUTE FUNCTION maj_etat_exemplaire_emprunt();


-- =====================================================
-- 4. REMISE À DISPONIBLE AU RETOUR DU LIVRE
-- =====================================================

CREATE OR REPLACE FUNCTION maj_retour_exemplaire()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.date_retour_effective IS NOT NULL THEN
        UPDATE exemplaire
        SET etat = 'Disponible'
        WHERE id_exemplaire = NEW.id_exemplaire;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_retour_exemplaire
AFTER UPDATE ON emprunt
FOR EACH ROW
EXECUTE FUNCTION maj_retour_exemplaire();


-- =====================================================
-- 5. GESTION AUTOMATIQUE DU RETARD
-- =====================================================

CREATE OR REPLACE FUNCTION maj_statut_retard()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.date_retour_effective IS NULL
       AND NEW.date_retour_prevue < CURRENT_DATE THEN
        NEW.statut := 'Retard';
    END IF;

    IF NEW.date_retour_effective IS NOT NULL THEN
        NEW.statut := 'Terminé';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_statut_retard
BEFORE UPDATE ON emprunt
FOR EACH ROW
EXECUTE FUNCTION maj_statut_retard();
