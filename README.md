# 🌱 EcoSnap — Application mobile écoresponsable

**EcoSnap** est une application mobile hybride (Flutter + Django) qui permet aux utilisateurs de :
- Scanner des déchets pour savoir s’ils sont recyclables
- Lire du contenu écologique (Feed)
- Recevoir des rappels réguliers via notifications push
- Suivre l’historique de leurs scans
- Utiliser une IA pour la classification des déchets
- Interagir via une API REST ou GraphQL

---

## ⚙️ Technologies utilisées

| Composant        | Stack                          |
|------------------|--------------------------------|
| Mobile           | Flutter + Dart                 |
| Backend API      | Django + GraphQL         |
| Authentification | JWT (`simplejwt`)              |
| IA               | TensorFlow / PyTorch + Celery  |
| Notifications    | Firebase Cloud Messaging (FCM) |
| Tâches async     | Celery + Redis + Celery Beat   |
| DB               | PostgreSQL (via Docker)        |
| Conteneurisation | Docker + Docker Compose        |

---

## 📲 Fonctionnalités détaillées

### 🔐 Authentification (JWT)
- Enregistrement (`POST /api/register/`) et login (`POST /api/token/`)
- Utilisation de `djangorestframework-simplejwt`
- Vérification de session expirée, refresh token (`/api/token/refresh/`)
- Modèle `AppUser` personnalisé (AUTH_USER_MODEL)
- Permissions sécurisées via `IsAuthenticated`

### 🧠 Scan IA des déchets
- Upload d’image depuis Flutter
- Traitement asynchrone via tâche Celery : `run_classifier_task(scan_id)`
- Prédiction IA de :
  - `category`: plastique, papier, métal...
  - `is_recyclable`: booléen
- Modèle d’IA entraîné sur dataset Kaggle (CNN TensorFlow)
- REST: `POST /api/scan/upload/`

### 📰 Feed écologique
- Vue publique : consulter des articles environnementaux
- Vue privée : créer/modifier/supprimer un article (REST & DRF)
- Champs : titre, description, image (upload)
- REST:
  - `GET /api/feed/`
  - `POST /api/feed/`
  - `PUT/DELETE /api/feed/{id}/`

### 🔔 Notifications Push
- Firebase Cloud Messaging (FCM)
- Stockage du `fcm_token` à la connexion dans le modèle `Device`
- Notification automatique toutes les 5min via Celery Beat
- Contenu dynamique : suggestion de scan ou lecture
- Backend : `send_reminder_notifications()`

### 🔄 API GraphQL
- Endpoint : `/graphql/` 
- Requêtes sécurisées : `info.context.user` requis
- Query : `allScans`, `myScans`
- Mutation : `createScan`, `likeFeed`

---

## 🔁 Tâches Celery

### `run_classifier_task(scan_id)`
- Prétraitement image 
- Chargement modèle entraîné
- Prédiction catégorie
- Mise à jour du modèle `Scan`

### `send_reminder_notifications()`
- Récupère tous les tokens FCM (via modèle `Device`)
- Envoie une requête HTTP à l’API FCM
- Message : « Scannez un objet ! » 

---

## 🛠️ Installation locale

### Prérequis :
- Docker & Docker Compose
- Compte Firebase + Server Key
- Fichier `.env` :
```
SECRET_KEY=...
DEBUG=True
DATABASE_URL=postgres://postgres:postgres@db:5432/eco
REDIS_URL=redis://redis:6379/0
FIREBASE_SERVER_KEY=...
```
### Lancer le projet :
```bash
docker-compose up --build
# Terminal 1
celery -A ecosnap_backend worker -l info
# Terminal 2
celery -A ecosnap_backend beat -l info
```

---

## ✅ Tests et validation

| Fonction                     | Méthode testée                 | Résultat attendu                          |
|-----------------------------|--------------------------------|-------------------------------------------|
| Enregistrement utilisateur   | POST /api/register/            | 201 CREATED avec user_id                  |
| Authentification JWT         | POST /api/token/               | Token JWT `access` et `refresh`           |
| Scan IA                      | POST /api/scan/upload/         | Scan ajouté, task IA déclenchée           |
| Lecture Feed                 | GET /api/feed/                 | Liste des articles                        |
| Notification Push            | Automatique via Celery         | Notification reçue toutes les 5 minutes   |
| GraphQL                      | allScans, createScan           | Données retournées avec user auth         |

---

## 📁 Structure projet (Django)

```
├── ecosnap_backend/
│   ├── settings.py
│   ├── urls.py
│   ├── schema.py (GraphQL)
│   └── celery.py
├── users/
│   ├── models.py (AppUser)
│   └── views.py (auth/register)
├── scans/
│   ├── models.py (Scan, Device)
│   ├── tasks.py (IA + notifications)
│   ├── views.py
│   └── serializers.py
├── feeds/
│   ├── models.py (Feed)
│   ├── serializers.py
│   └── views.py
└── media/
    └── feed_images/
```

---

## 📦 Contenu Flutter

- Page d’accueil (Feed + articles)
- Page Scan (Upload image + affichage résultat)
- Notifications intégrées (FCM)
- Authentification persistante avec JWT
- GoRouter pour navigation moderne

---

## 📊 Données et Intelligence Artificielle

- Dataset : [Garbage Classification Dataset – Kaggle](https://www.kaggle.com/datasets/asdasdasasdas/garbage-classification)
- Modèle : CNN entraîné avec Keras / TensorFlow
- Évaluation : Accuracy > 85%
- Déploiement : modèle chargé dynamiquement dans tâche Celery

---
