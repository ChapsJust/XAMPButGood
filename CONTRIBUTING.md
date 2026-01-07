# 🤝 Guide de Contribution

Merci de vouloir contribuer à XAMPP-Docker! Ce guide vous aidera à démarrer.

## 📋 Table des matières

- [Code de conduite](#code-de-conduite)
- [Comment contribuer](#comment-contribuer)
- [Structure du projet](#structure-du-projet)
- [Standards de code](#standards-de-code)
- [Processus de Pull Request](#processus-de-pull-request)

---

## Code de conduite

- Soyez respectueux et inclusif
- Acceptez les critiques constructives
- Concentrez-vous sur ce qui est le mieux pour la communauté

---

## Comment contribuer

### 🐛 Signaler un bug

1. Vérifiez que le bug n'a pas déjà été signalé dans les [Issues](../../issues)
2. Créez une nouvelle issue avec:
   - Description claire du problème
   - Étapes pour reproduire
   - Comportement attendu vs actuel
   - Votre environnement (OS, version Docker)

### 💡 Proposer une feature

1. Ouvrez une [Discussion](../../discussions) pour en parler d'abord
2. Si validé, créez une issue avec le label `enhancement`

### 🔧 Soumettre du code

1. Fork le repo
2. Clonez votre fork
3. Créez une branche: `git checkout -b feature/ma-feature`
4. Faites vos modifications
5. Testez localement
6. Committez: `git commit -m "Add: description"`
7. Push: `git push origin feature/ma-feature`
8. Ouvrez une Pull Request

---

## Structure du projet

```
xampp-docker/
├── docker-compose.yml    # Définition des services
├── .env.example          # Template de configuration
├── .env                  # Configuration locale (gitignored)
├── .gitignore
├── README.md             # Documentation principale
├── CONTRIBUTING.md       # Ce fichier
├── LICENSE
└── scripts/              # Scripts utilitaires (future)
    ├── backup.sh
    └── restore.sh
```

---

## Standards de code

### docker-compose.yml

```yaml
# Bon exemple de service
service_name:
  image: image:version-tag      # Toujours spécifier une version
  container_name: dev-service   # Préfixe "dev-"
  restart: unless-stopped       # Redémarrage auto
  environment:
    VAR: ${VAR}                 # Variables depuis .env
  ports:
    - "${PORT:-default}:internal"  # Port configurable avec default
  volumes:
    - named_volume:/path        # Volumes nommés
  networks:
    - dev-network               # Réseau commun
  healthcheck:                  # Toujours un healthcheck
    test: ["CMD", "..."]
    interval: 10s
    timeout: 5s
    retries: 5
  logging:                      # Limiter les logs
    driver: "json-file"
    options:
      max-size: "10m"
      max-file: "3"
```

### Conventions de nommage

- **Containers**: `dev-{service}` (ex: `dev-postgres`)
- **Volumes**: `dev-{service}-data` (ex: `dev-postgres-data`)
- **Variables**: `SERVICE_VARIABLE` (ex: `POSTGRES_USER`)

### Commits

Format: `Type: Description courte`

Types:
- `Add:` Nouvelle fonctionnalité
- `Fix:` Correction de bug
- `Update:` Mise à jour (version, docs, etc.)
- `Remove:` Suppression
- `Refactor:` Refactoring sans changement fonctionnel

Exemples:
```
Add: phpMyAdmin service
Fix: MySQL healthcheck failing on Windows
Update: PostgreSQL to 18.2
```

---

## Processus de Pull Request

### Checklist avant de soumettre

- [ ] J'ai testé mes changements localement
- [ ] J'ai mis à jour la documentation si nécessaire
- [ ] J'ai ajouté les variables nécessaires dans `.env.example`
- [ ] Mon code suit les standards du projet
- [ ] Les healthchecks fonctionnent

### Review

- Au moins 1 review requise
- Les CI checks doivent passer (si configurés)
- Répondez aux commentaires de review

---

## 🎯 Bonnes premières contributions

Cherchez les issues avec le label `good first issue`:
- Améliorer la documentation
- Ajouter des exemples de connection strings
- Traduire le README
- Ajouter des healthchecks manquants

---

## ❓ Questions?

- Ouvrez une [Discussion](../../discussions)
- Ou commentez sur l'issue concernée

Merci de contribuer! 🙏
