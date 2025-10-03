# Guide de Déploiement Android - Pèlerinage MSM

## ✅ Configuration Automatique Déjà Effectuée

Les éléments suivants ont été configurés automatiquement :

- ✅ Permissions Android (notifications, internet, boot)
- ✅ Configuration Gradle (compilation, minification, ProGuard)
- ✅ Métadonnées de l'application
- ✅ Application ID : `com.pelerinage.msm`
- ✅ Version : 1.0.0 (versionCode: 1)
- ✅ Icône de l'application configurée
- ✅ Core library desugaring activé

## 📋 Actions Manuelles Requises

### 1. Créer la Clé de Signature (Keystore)

Cette clé sera utilisée pour signer votre application en production.

**⚠️ IMPORTANT : Gardez cette clé en lieu sûr ! Si vous la perdez, vous ne pourrez plus mettre à jour votre application sur le Play Store.**

```bash
cd ~/Documents/projets\ perso/Pélerinage/P-l-MSM/android

keytool -genkey -v -keystore pelerinage-msm.jks -keyalg RSA -keysize 2048 -validity 10000 -alias pelerinage-msm
```

**Informations à fournir :**
- Mot de passe du keystore (mémorisez-le !)
- Mot de passe de la clé (peut être le même)
- Nom et prénom
- Unité organisationnelle : Pèlerinage MSM
- Organisation : Votre organisation
- Ville : Votre ville
- État/Province
- Code pays : FR

### 2. Créer le Fichier key.properties

Créez le fichier `android/key.properties` avec le contenu suivant :

```properties
storePassword=VOTRE_MOT_DE_PASSE_KEYSTORE
keyPassword=VOTRE_MOT_DE_PASSE_CLE
keyAlias=pelerinage-msm
storeFile=pelerinage-msm.jks
```

**⚠️ ATTENTION : Ne commitez JAMAIS ce fichier sur Git ! Il contient vos mots de passe.**

### 3. Sécuriser les Fichiers Sensibles

Vérifiez que le fichier `.gitignore` contient bien :

```gitignore
**/android/key.properties
**/android/*.jks
**/android/*.keystore
```

### 4. Builder l'Application pour Production

#### Option A : Build APK (pour distribution directe)

```bash
cd ~/Documents/projets\ perso/Pélerinage/P-l-MSM
flutter build apk --release
```

L'APK sera généré dans : `build/app/outputs/flutter-apk/app-release.apk`

#### Option B : Build AAB (pour Google Play Store - RECOMMANDÉ)

```bash
cd ~/Documents/projets\ perso/Pélerinage/P-l-MSM
flutter build appbundle --release
```

L'AAB sera généré dans : `build/app/outputs/bundle/release/app-release.aab`

**💡 AAB vs APK :**
- **AAB (Android App Bundle)** : Format recommandé par Google, génère des APKs optimisés par appareil, taille réduite
- **APK** : Distribution directe, plus simple mais plus lourd

### 5. Tester le Build Release

Avant de publier, testez le build release :

```bash
# Installer l'APK sur un appareil connecté
flutter install --release

# Ou directement avec adb
adb install build/app/outputs/flutter-apk/app-release.apk
```

### 6. Préparer pour le Google Play Store

#### Créer un Compte Développeur Google Play

1. Allez sur [Google Play Console](https://play.google.com/console)
2. Payez les frais uniques de 25€ (si pas encore fait)
3. Complétez les informations de votre compte

#### Informations Nécessaires pour la Publication

**Screenshots requis :**
- Au moins 2 captures d'écran par type d'appareil
- Résolution recommandée : 1080x1920 (portrait) ou 1920x1080 (paysage)
- Format : PNG ou JPEG

**Icône de l'application (déjà configurée) :**
- 512x512 pixels
- Format : PNG 32-bit
- Déjà présente : `assets/images/Logo MSM Transparent.png`

**Description de l'application :**

```
Titre : Pèlerinage MSM - Mont Saint-Michel

Description courte (80 caractères max) :
Application officielle du pèlerinage des jeunes au Mont Saint-Michel

Description complète (4000 caractères max) :
Accompagnez votre pèlerinage au Mont Saint-Michel avec l'application officielle !

✨ Fonctionnalités :
• 📅 Programme complet du week-end (samedi et dimanche)
• 🎵 Carnet de chants avec paroles complètes
• 🙏 Méditations pour la traversée de la baie
• 📿 Prières auprès de saint Michel
• 🌓 Mode sombre pour économiser la batterie
• ⭐ Système de favoris pour retrouver vos chants préférés

Cette application a été conçue pour vous accompagner spirituellement et pratiquement durant votre pèlerinage. Elle fonctionne entièrement hors ligne une fois téléchargée.

Bon pèlerinage ! 🙏
```

**Catégorie :** Lifestyle ou Books & Reference

**Contenu :** Tout public

**Politique de confidentialité :**
Vous devrez fournir une URL vers votre politique de confidentialité.

#### Étapes de Publication sur le Play Store

1. **Créer une application** dans la Play Console
2. **Remplir la fiche de l'application** :
   - Description
   - Screenshots
   - Icône haute résolution (512x512)
   - Bannière (si souhaitée)
3. **Configuration de la version** :
   - Uploader le fichier AAB (`app-release.aab`)
   - Notes de version : "Version initiale 1.0.0"
4. **Classification du contenu** :
   - Questionnaire à remplir (application religieuse, tout public)
5. **Tarification et distribution** :
   - Gratuit
   - Sélectionner les pays (France au minimum)
6. **Test interne/fermé** (optionnel mais recommandé) :
   - Inviter quelques testeurs
   - Tester pendant quelques jours
7. **Production** :
   - Soumettre pour examen (délai : quelques heures à quelques jours)

## 🔄 Mise à Jour de l'Application

Pour publier une nouvelle version :

1. **Modifier la version dans `pubspec.yaml` :**
   ```yaml
   version: 1.0.1+2  # version+buildNumber
   ```

2. **Modifier la version dans `android/app/build.gradle.kts` :**
   ```kotlin
   versionCode = 2
   versionName = "1.0.1"
   ```

3. **Rebuilder l'application :**
   ```bash
   flutter build appbundle --release
   ```

4. **Uploader sur Play Console** dans l'onglet "Production"

## 🔍 Vérifications Avant Publication

- [ ] L'application fonctionne correctement en mode release
- [ ] Toutes les fonctionnalités sont testées
- [ ] Les assets (images, JSON) sont bien chargés
- [ ] Le mode sombre fonctionne
- [ ] Les notifications fonctionnent
- [ ] L'icône s'affiche correctement
- [ ] Le nom "Pèlerinage MSM" apparaît sous l'icône
- [ ] Les screenshots sont prêts
- [ ] La description est rédigée
- [ ] Le fichier `key.properties` n'est PAS commité sur Git
- [ ] Le keystore `.jks` est sauvegardé en lieu sûr (backup !)

## 📱 Tailles Approximatives

- **AAB :** ~20-30 MB
- **APK :** ~30-40 MB
- **Téléchargement utilisateur :** ~15-25 MB (AAB optimisé)

## 🆘 Résolution de Problèmes

### Erreur de signature

Si vous obtenez une erreur de signature, vérifiez :
- Le fichier `key.properties` existe et contient les bonnes informations
- Le fichier `.jks` est au bon endroit (`android/pelerinage-msm.jks`)
- Les mots de passe sont corrects

### Application qui crash au lancement

- Testez d'abord en mode debug : `flutter run`
- Vérifiez les logs : `adb logcat | grep flutter`
- Assurez-vous que tous les assets sont bien listés dans `pubspec.yaml`

### ProGuard supprime trop de code

Si des fonctionnalités ne marchent plus en release, ajoutez des règles dans `android/app/proguard-rules.pro`

## 📚 Ressources

- [Flutter - Build and release an Android app](https://docs.flutter.dev/deployment/android)
- [Google Play Console](https://play.google.com/console)
- [Android App Signing](https://developer.android.com/studio/publish/app-signing)

---

**✅ Tout est prêt du côté technique ! Il ne vous reste plus qu'à créer le keystore et builder l'application.**
