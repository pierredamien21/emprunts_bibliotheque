-- =====================================================
-- GESTION DES ROLES ET PERMISSIONS
-- Base de données : Bibliothèque
-- =====================================================

-- ================================
-- 1. CRÉATION DES RÔLES
-- ================================

-- Administrateur
CREATE ROLE admin_biblio LOGIN PASSWORD 'admin123';

-- Bibliothécaire
CREATE ROLE bibliotecaire_role LOGIN PASSWORD 'biblio123';

-- Application / API
CREATE ROLE api_biblio LOGIN PASSWORD 'api123';

-- Lecteur (lecture seule)
CREATE ROLE lecteur_biblio LOGIN PASSWORD 'lecteur123';


-- ================================
-- 2. SÉCURITÉ : RÉVOCATION PAR DÉFAUT
-- ================================

REVOKE ALL ON ALL TABLES IN SCHEMA public FROM PUBLIC;
REVOKE ALL ON ALL SEQUENCES IN SCHEMA public FROM PUBLIC;


-- ================================
-- 3. PERMISSIONS ADMINISTRATEUR
-- ================================

GRANT ALL PRIVILEGES ON SCHEMA public TO admin_biblio;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin_biblio;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin_biblio;


-- ================================
-- 4. PERMISSIONS BIBLIOTHÉCAIRE
-- ================================

GRANT SELECT, INSERT, UPDATE
ON type_membre, membre, categorie, livre, exemplaire
TO bibliotecaire_role;

GRANT SELECT, INSERT, UPDATE
ON emprunt, reservation, sanction
TO bibliotecaire_role;

GRANT USAGE
ON ALL SEQUENCES IN SCHEMA public
TO bibliotecaire_role;


-- ================================
-- 5. PERMISSIONS APPLICATION / API
-- ================================

GRANT SELECT, INSERT, UPDATE
ON type_membre, membre, categorie, livre, exemplaire,
   emprunt, reservation, sanction
TO api_biblio;

GRANT USAGE
ON ALL SEQUENCES IN SCHEMA public
TO api_biblio;


-- ================================
-- 6. PERMISSIONS LECTEUR (READ ONLY)
-- ================================

GRANT SELECT
ON type_membre, membre, categorie, livre, exemplaire,
   emprunt, reservation, sanction
TO lecteur_biblio;


-- ================================
-- 7. PERMISSIONS PAR DÉFAUT (FUTURES TABLES)
-- ================================

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE ON TABLES TO api_biblio;

ALTER DEFAULT PRIVILEGES IN SCHEMA public
GRANT SELECT, INSERT, UPDATE ON TABLES TO bibliotecaire_role;
