// =============================================================================
// MongoDB - Script d'initialisation
// =============================================================================
// Ce script s'exécute automatiquement au premier démarrage du container
// Pour réexécuter: supprimer le volume et redémarrer
// =============================================================================

// Utiliser la base de données définie dans .env
const dbName = process.env.MONGO_INITDB_DATABASE || 'devdb';
db = db.getSiblingDB(dbName);

// -----------------------------------------------------------------------------
// Création d'un utilisateur applicatif (bonne pratique: ne pas utiliser root)
// -----------------------------------------------------------------------------
db.createUser({
    user: 'appuser',
    pwd: 'apppass123!',
    roles: [
        { role: 'readWrite', db: dbName },
        { role: 'dbAdmin', db: dbName }
    ]
});

// -----------------------------------------------------------------------------
// Collections d'exemple avec validation de schéma
// -----------------------------------------------------------------------------

// Collection Users avec validation
db.createCollection('users', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: ['email', 'username', 'createdAt'],
            properties: {
                email: {
                    bsonType: 'string',
                    pattern: '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$',
                    description: 'Email valide requis'
                },
                username: {
                    bsonType: 'string',
                    minLength: 3,
                    maxLength: 50,
                    description: 'Username entre 3 et 50 caractères'
                },
                profile: {
                    bsonType: 'object',
                    properties: {
                        firstName: { bsonType: 'string' },
                        lastName: { bsonType: 'string' },
                        avatar: { bsonType: 'string' }
                    }
                },
                isActive: {
                    bsonType: 'bool'
                },
                createdAt: {
                    bsonType: 'date'
                },
                updatedAt: {
                    bsonType: 'date'
                }
            }
        }
    },
    validationLevel: 'moderate',
    validationAction: 'warn'
});

// Collection Sessions (pour cache de sessions avec Redis backup)
db.createCollection('sessions', {
    validator: {
        $jsonSchema: {
            bsonType: 'object',
            required: ['userId', 'token', 'expiresAt'],
            properties: {
                userId: { bsonType: 'objectId' },
                token: { bsonType: 'string' },
                expiresAt: { bsonType: 'date' },
                metadata: { bsonType: 'object' }
            }
        }
    }
});

// Collection Logs (time-series pour performances)
db.createCollection('logs', {
    timeseries: {
        timeField: 'timestamp',
        metaField: 'metadata',
        granularity: 'seconds'
    },
    expireAfterSeconds: 604800 // 7 jours
});

// -----------------------------------------------------------------------------
// Index pour performances
// -----------------------------------------------------------------------------

// Index uniques
db.users.createIndex({ email: 1 }, { unique: true });
db.users.createIndex({ username: 1 }, { unique: true });

// Index de recherche
db.users.createIndex({ 'profile.firstName': 1, 'profile.lastName': 1 });
db.users.createIndex({ createdAt: -1 });

// Index TTL pour sessions (expire automatiquement)
db.sessions.createIndex({ expiresAt: 1 }, { expireAfterSeconds: 0 });

// -----------------------------------------------------------------------------
// Données de test
// -----------------------------------------------------------------------------
db.users.insertMany([
    {
        email: 'admin@example.com',
        username: 'admin',
        profile: {
            firstName: 'Admin',
            lastName: 'User'
        },
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
    },
    {
        email: 'test@example.com',
        username: 'testuser',
        profile: {
            firstName: 'Test',
            lastName: 'User'
        },
        isActive: true,
        createdAt: new Date(),
        updatedAt: new Date()
    }
]);

print('✓ MongoDB initialisé avec succès!');
print(`  - Base de données: ${dbName}`);
print('  - Collections: users, sessions, logs');
print('  - Utilisateur applicatif: appuser');
