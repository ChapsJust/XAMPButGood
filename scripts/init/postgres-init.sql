-- =============================================================================
-- PostgreSQL - Script d'initialisation
-- =============================================================================
-- Ce script s'exécute automatiquement au premier démarrage du container
-- Pour réexécuter: supprimer le volume et redémarrer
-- =============================================================================

-- Extension UUID (utile pour .NET)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Extension pour recherche full-text
CREATE EXTENSION IF NOT EXISTS "pg_trgm";

-- -----------------------------------------------------------------------------
-- Schéma d'exemple (optionnel - à personnaliser)
-- -----------------------------------------------------------------------------

-- Table d'exemple Users
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) NOT NULL UNIQUE,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    is_active BOOLEAN DEFAULT true
);

-- Index pour performances
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);

-- Table d'exemple pour audit/logs
CREATE TABLE IF NOT EXISTS audit_log (
    id BIGSERIAL PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    record_id UUID NOT NULL,
    action VARCHAR(20) NOT NULL, -- INSERT, UPDATE, DELETE
    old_data JSONB,
    new_data JSONB,
    user_id UUID,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Index sur audit_log
CREATE INDEX IF NOT EXISTS idx_audit_log_table ON audit_log(table_name);
CREATE INDEX IF NOT EXISTS idx_audit_log_record ON audit_log(record_id);
CREATE INDEX IF NOT EXISTS idx_audit_log_created ON audit_log(created_at);

-- -----------------------------------------------------------------------------
-- Fonction pour mise à jour automatique de updated_at
-- -----------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Trigger sur la table users
DROP TRIGGER IF EXISTS update_users_updated_at ON users;
CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- -----------------------------------------------------------------------------
-- Données de test (optionnel)
-- -----------------------------------------------------------------------------
INSERT INTO users (email, username, password_hash) 
VALUES 
    ('admin@example.com', 'admin', 'hash_placeholder'),
    ('user@example.com', 'testuser', 'hash_placeholder')
ON CONFLICT (email) DO NOTHING;

-- Message de confirmation
DO $$
BEGIN
    RAISE NOTICE '✓ PostgreSQL initialisé avec succès!';
END $$;
