# cv_flutter_michel

Application mobile Flutter qui présente le CV, la famille et les coordonnées de Michel Civarara.

Dans ce TP2, la connexion est réelle et les membres de la famille sont gérés par une API REST avec une base de données MySQL.

## Vidéo de démonstration

[Télécharger la vidéo de démonstration](https://github.com/michelcivarara-jpg/cv_flutter_michel/raw/main/video/demo.mp4)

[Regarder la vidéo en ligne (Google Drive)](https://drive.google.com/file/d/1GVhGEAE137gnNkDQjS4Oyod8QU5n0uF-/view?usp=sharing)

La vidéo montre : la création de compte, la connexion, la page Accueil, l'ajout, la modification et la suppression d'un membre de la famille, puis la page Contact.

## Fonctionnalités

- **Connexion et création de compte** : l'application envoie l'e-mail et le mot de passe à l'API (`/accounts/login` et `/accounts/register`).
- **Accueil** : photo, nom, formation, expériences, compétences, langues et centres d'intérêt.
- **Famille** : liste, ajout, modification et suppression des membres, enregistrés dans la base de données via l'API (`/famille-membres`).
- **Contact** : téléphone, e-mail, adresse, avec des liens cliquables.
- **Navigation** : barre en bas (BottomNavigationBar) entre les trois pages.

## Utilisation de l'API

L'API utilisée est celle du dépôt https://github.com/espoirbaraka/api-test.

1. Placer l'API dans `C:\xampp\htdocs\api-test` et démarrer Apache et MySQL dans XAMPP.
2. Créer une base de données `api` et importer le fichier `api.sql`.
3. Lancer l'application avec `flutter run -d chrome`.

L'adresse de l'API est définie dans `lib/services/api_service.dart` : `http://localhost/api-test/public`.

## Captures d'écran

### Accueil

![Page d'accueil](screenshots/2_accueil.jpg)

### Contact

![Page contact](screenshots/4_contact.jpg)

Les pages de connexion et de famille, qui ont changé dans ce TP, sont visibles dans la vidéo de démonstration.