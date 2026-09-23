# Simulateur Assurance Vie

Outil d'étude client : leviers assurance vie / PER / manuels (immobilier, SCPI), solution chiffrée,
trois solutions et export Excel. Chaque conseiller a son compte et ne voit que ses propres clients.

- **Version en service** : racine du site (`index.html`)
- **Version de test** : dossier `test/` — on y vérifie une modification avant de la passer en service.
  Elle utilise les mêmes comptes et les mêmes données.

## Fonctionnement
- Site statique hébergé par GitHub Pages ; aucune donnée client dans ce dépôt.
- Données : Supabase (région Paris), table `clients`, cloisonnée par conseiller (Row Level Security).
- `config.js` : adresse du projet Supabase et clé publique (anon).
- `supabase/schema.sql` : schéma à exécuter une fois dans le SQL Editor de Supabase.

## Ajouter un conseiller
Supabase → Authentication → Users → **Invite user** → saisir son email.
Il reçoit un lien, choisit son mot de passe, et arrive sur son espace vide.
(Les inscriptions libres sont désactivées.)

## Réglages Supabase à faire une fois
- Authentication → URL Configuration → **Site URL** = adresse du site (ex. `https://lucasvedep-ai.github.io/vandeputte-lucas-simulateur-av/`)
  et ajouter la même adresse + `test/` dans **Redirect URLs**.
