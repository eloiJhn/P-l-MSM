# Déploiement Android — APK gratuit par lien

Objectif: builder l’APK signed (ou fallback debug), le publier automatiquement sur GitHub Pages (lien direct) et, si tag, sur GitHub Releases. 100% gratuit pour repo public.

## Pré-requis
- Créer un dépôt GitHub pour ce projet (racine actuelle). Le code de l’app est dans `pelerinage_msm/`.
- Pousser le code (branch `main`). Les workflows sont dans `.github/workflows/`.
- Activer GitHub Pages: source = « GitHub Actions ».

## (Option recommandé) Générer une clé de signature Release
Cela garantit des mises à jour installables sur les appareils des utilisateurs.

1. Sur votre machine:
   ```bash
   keytool -genkey -v -keystore keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```
2. Base64 du keystore pour secrets GitHub (selon votre OS):
   - macOS (BSD base64):
     ```bash
     base64 -i keystore.jks -o keystore.jks.base64
     # ou
     base64 < keystore.jks > keystore.jks.base64
     # ou
     openssl base64 -in keystore.jks -out keystore.jks.base64
     ```
   - Linux (GNU coreutils):
     ```bash
     base64 keystore.jks > keystore.jks.base64
     ```
   - Windows PowerShell:
     ```powershell
     [Convert]::ToBase64String([IO.File]::ReadAllBytes("keystore.jks")) > keystore.jks.base64
     ```
   - Astuce macOS: copier directement dans le presse-papiers
     ```bash
     pbcopy < keystore.jks.base64
     ```
3. Dans « Settings > Secrets and variables > Actions > New repository secret », ajouter:
   - `ANDROID_KEYSTORE_BASE64` = contenu de `keystore.jks.base64`
   - `ANDROID_KEYSTORE_PASSWORD` = mot de passe du keystore
   - `ANDROID_KEY_ALIAS` = `upload` (ou celui choisi)
   - `ANDROID_KEY_PASSWORD` = mot de passe de la clé

La build utilisera automatiquement `android/key.properties` généré en CI. Sans secrets, la build utilisera la signature debug (OK pour test, pas pour mises à jour stables).

## Lancer une build et obtenir le lien
Deux options:

- Push sur `main`: déclenche build, tests, analyze, puis déploiement GitHub Pages.
  - Lien direct de téléchargement (après 1ère publication):
    `https://<votre_user>.github.io/<repo>/pelerinage_msm.apk`

- Déclenchement manuel (Workflow Dispatch):
  - Aller dans « Actions > Android APK > Run workflow ».
  - Choisir `publish: true` pour mettre à jour GitHub Pages.

## Release taggable (optionnel)
Si vous créez un tag (ex: `v1.0.0`), le workflow ajoute l’APK à la Release du tag. Le lien de la Release est pratique pour archivage; pour un lien stable à partager, préférez GitHub Pages.

## Structure et sorties
- APK build: `pelerinage_msm/build/app/outputs/flutter-apk/app-release.apk`
- Copie publiée: `pelerinage_msm.apk` (nom stable) à la racine de GitHub Pages

## Dépannage
- Assurez-vous que GitHub Pages est activé (source « GitHub Actions »).
- Vérifiez l’onglet « Actions » pour les logs de build.
- En cas d’erreur de signature, validez les 4 secrets et qu’ils correspondent au keystore.
