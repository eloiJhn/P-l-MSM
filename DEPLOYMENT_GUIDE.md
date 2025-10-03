# 📱 Guide de Déploiement App Store - Pèlerinage MSM

## ✅ État Actuel de l'Application

### Vérifications Complètes Effectuées

#### 1. **Code Quality** ✅
- ✅ Toutes les déprécations `withOpacity()` corrigées → `withValues(alpha:)`
- ✅ Imports inutilisés nettoyés
- ✅ Cache d'images optimisé (pas de rechargement)
- ✅ Transitions entre pages optimisées (200ms fade)
- ⚠️ 9 warnings mineurs (variables non utilisées - non bloquant)

#### 2. **Configuration iOS** ✅
- ✅ Info.plist configuré avec :
  - Nom d'affichage: "Pèlerinage MSM"
  - Langue: Français (fr)
  - Orientation: Portrait uniquement
  - Encryption export compliance: Non (pas de cryptage)
  - Privacy tracking: Description ajoutée

#### 3. **Performances** ✅
- ✅ Précache de toutes les images au démarrage
- ✅ Optimisation des assets
- ✅ Gestion du dark mode
- ✅ Cache Hive pour favoris et thème

#### 4. **Sécurité** ✅
- ✅ Pas de collecte de données
- ✅ Stockage local uniquement (Hive)
- ✅ Pas d'API externes
- ✅ Conforme RGPD

---

## 🚀 ÉTAPES DE DÉPLOIEMENT MANUEL

### PHASE 1: Préparation du Compte Apple Developer

#### 1.1 Créer un Compte Apple Developer
1. Aller sur https://developer.apple.com
2. S'inscrire au **Apple Developer Program** (99€/an)
3. Attendre la validation du compte (24-48h)

#### 1.2 Créer un App Store Connect Account
1. Aller sur https://appstoreconnect.apple.com
2. Se connecter avec votre Apple ID
3. Accepter les accords

---

### PHASE 2: Configuration de l'Application dans App Store Connect

#### 2.1 Créer une Nouvelle App
1. Dans App Store Connect → **Mes Apps** → **+** (Nouvelle app)
2. Remplir les informations :
   - **Plateformes** : iOS
   - **Nom** : `Pèlerinage Mont Saint-Michel` (ou votre choix)
   - **Langue principale** : Français (France)
   - **Bundle ID** : À créer (voir étape suivante)
   - **SKU** : `pelerinage-msm-2025` (identifiant unique)
   - **Accès** : Accès total

#### 2.2 Créer le Bundle ID
1. Aller sur https://developer.apple.com/account/resources/identifiers/list
2. Cliquer sur **+** pour créer un nouveau Bundle ID
3. Sélectionner **App IDs** → **Continue**
4. Choisir **App** → **Continue**
5. Remplir :
   - **Description** : `Pèlerinage Mont Saint-Michel`
   - **Bundle ID** : `com.votreorg.pelerinage-msm` (ou `fr.pelerinage.msm`)
   - **Capabilities** : Aucune nécessaire pour cette app
6. Cliquer sur **Continue** puis **Register**

#### 2.3 Mettre à Jour le Bundle ID dans le Projet
**Vous devez le faire manuellement :**

1. Ouvrir Xcode :
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Dans Xcode :
   - Sélectionner **Runner** dans le navigateur de projet (à gauche)
   - Onglet **Signing & Capabilities**
   - **Team** : Sélectionner votre équipe Apple Developer
   - **Bundle Identifier** : Entrer `com.votreorg.pelerinage-msm` (le même que créé)
   - Cocher **Automatically manage signing**

#### 2.4 Configurer les Métadonnées dans App Store Connect

1. **Informations de l'App** :
   - **Catégorie principale** : Voyages
   - **Catégorie secondaire** : Style de vie (optionnel)
   - **Classification du contenu** : 4+ ans
   - **Langue supplémentaire** : Anglais (optionnel)

2. **Informations de Version** :
   - **Nom** : `Pèlerinage Mont Saint-Michel`
   - **Sous-titre** : `Votre guide spirituel 2025`
   - **Description** :
   ```
   Application officielle du pèlerinage des jeunes au Mont Saint-Michel.

   Découvrez :
   • Programme complet jour par jour
   • Chants du pèlerinage avec paroles
   • Méditations pour la traversée de la baie
   • Prières dédiées à Saint Michel
   • Mode sombre pour la lecture nocturne
   • Favoris pour retrouver vos chants préférés

   Une application simple et intuitive pour vivre pleinement votre expérience spirituelle au Mont Saint-Michel.

   Cette application ne collecte aucune donnée personnelle.
   ```

3. **Mots-clés** (max 100 caractères) :
   ```
   pèlerinage,mont saint michel,chants,prières,méditation,spirituel,jeunes
   ```

4. **URL de support** : Votre site web ou email de contact
   Exemple: `mailto:contact@pelerinage-msm.fr`

5. **URL marketing** : (optionnel) Site web du pèlerinage

---

### PHASE 3: Captures d'Écran (OBLIGATOIRE)

#### 3.1 Tailles Requises par Apple
Vous devez fournir des captures d'écran pour **au moins** :
- **iPhone 6.9"** (iPhone 16 Pro Max) : 1320 x 2868 pixels
- **iPhone 6.7"** (iPhone 15 Pro Max) : 1290 x 2796 pixels

#### 3.2 Générer les Captures d'Écran
**Option 1 - Utiliser un iPhone réel :**
1. Lancer l'app sur votre iPhone
2. Prendre des captures (bouton Power + Volume Haut)
3. Transférer sur Mac via AirDrop

**Option 2 - Utiliser le Simulateur iOS :**
```bash
# Lancer le simulateur iPhone 16 Pro Max
open -a Simulator
# Dans le simulateur : Device → iPhone 16 Pro Max

# Lancer l'app
flutter run

# Prendre des captures : Cmd + S
# Les fichiers seront sur le Bureau
```

#### 3.3 Captures Recommandées (5 maximum)
1. **Page d'accueil** (Bienvenue au pèlerinage)
2. **Liste des chants** (avec fonction recherche)
3. **Détail d'un chant** (paroles)
4. **Programme** (agenda jour par jour)
5. **Méditations** (avec mode sombre)

#### 3.4 Upload des Captures
1. Dans App Store Connect → **Média**
2. Faire glisser les captures dans les emplacements correspondants
3. Ajouter des **textes descriptifs** optionnels sur les captures

---

### PHASE 4: Icône de l'Application

#### 4.1 Vérifier l'Icône Actuelle
L'icône est déjà configurée dans `pubspec.yaml` :
```yaml
flutter_launcher_icons:
  android: "launcher_icon"
  ios: true
  image_path: "assets/images/Logo MSM Transparent.png"
```

#### 4.2 Générer les Icônes iOS
```bash
flutter pub run flutter_launcher_icons
```

#### 4.3 Vérifier dans Xcode
1. Ouvrir `ios/Runner.xcworkspace`
2. Naviguer vers **Runner → Assets.xcassets → AppIcon**
3. Vérifier que toutes les tailles sont remplies

---

### PHASE 5: Build et Upload de l'Application

#### 5.1 Nettoyer le Projet
```bash
cd "/Users/eloijahan/Documents/projets perso/Pélerinage/P-l-MSM"
flutter clean
flutter pub get
```

#### 5.2 Build en Mode Release
```bash
flutter build ios --release
```

⚠️ **Si erreurs de signature :**
- Ouvrir `ios/Runner.xcworkspace` dans Xcode
- Vérifier **Signing & Capabilities**
- S'assurer que votre Team est sélectionnée

#### 5.3 Archiver dans Xcode
1. Ouvrir Xcode :
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Dans Xcode :
   - Menu **Product** → **Scheme** → Sélectionner **Runner**
   - Menu **Product** → **Destination** → Sélectionner **Any iOS Device (arm64)**
   - Menu **Product** → **Archive**

3. Attendre la fin de l'archivage (2-5 minutes)

#### 5.4 Upload vers App Store Connect
1. Quand l'archive apparaît, cliquer sur **Distribute App**
2. Sélectionner **App Store Connect** → **Next**
3. Sélectionner **Upload** → **Next**
4. **Automatiquement gérer la signature** → **Next**
5. Vérifier les informations → **Upload**
6. Attendre la fin de l'upload (5-15 minutes)

---

### PHASE 6: Soumission pour Review

#### 6.1 Attendre le Traitement
1. Retourner dans App Store Connect
2. Aller dans **TestFlight** (onglet en haut)
3. Attendre que le build apparaisse (10-30 minutes)
4. Le statut passera de "Processing" à "Ready to Submit"

#### 6.2 Configurer la Version pour Review
1. Retourner dans **Mes Apps** → Votre app
2. Onglet **Distribution** → **iOS App**
3. Cliquer sur **+** près de "Préparer pour soumission"
4. Sélectionner le build que vous venez d'uploader

#### 6.3 Remplir les Informations de Review
1. **Informations de contact** :
   - Nom, Téléphone, Email

2. **Informations de connexion** (si app nécessite login) :
   - Pas nécessaire pour cette app → Cocher "Connexion requise : Non"

3. **Notes pour l'équipe de review** :
   ```
   Application de pèlerinage religieux au Mont Saint-Michel.
   Contenu entièrement hors ligne, pas de compte utilisateur nécessaire.
   Aucune collecte de données personnelles.

   Pour tester toutes les fonctionnalités :
   - Parcourir les onglets : Accueil, Programme, Chants, Méditations
   - Ajouter un chant en favori (icône cœur)
   - Tester le mode sombre (bouton en haut à droite de l'accueil)
   ```

4. **Classification de contenu** :
   - Remplir le questionnaire (répondre "Non" à tout sauf "Contenu religieux" → "Peu fréquent")

5. **Informations de copyright** :
   ```
   © 2025 Pèlerinage Mont Saint-Michel
   ```

6. **Coordonnées** :
   - Email de contact visible publiquement

#### 6.4 Prix et Disponibilité
1. **Prix** : Gratuit
2. **Disponibilité** :
   - Tous les pays OU seulement France
   - Date de sortie : Dès approbation

#### 6.5 Soumettre
1. Vérifier que tout est rempli (✅ verts partout)
2. Cliquer sur **Soumettre pour review**
3. Confirmer

---

### PHASE 7: Attendre la Review Apple

#### 7.1 Délais
- **Temps moyen** : 24-48 heures
- **Maximum** : 5-7 jours
- Vous recevrez des emails à chaque étape

#### 7.2 Statuts Possibles
1. **En attente de review** (Waiting for Review)
2. **En review** (In Review) - 24-48h généralement
3. **Accepté** (Ready for Sale) ✅
4. **Rejeté** (Rejected) ⚠️ - Voir raisons et corriger

#### 7.3 Si Rejeté
Apple vous donnera les raisons précises. Corrections communes :
- Captures d'écran manquantes
- Informations de contact invalides
- Contenu non conforme
- Problème de performance

Corriger puis **Resoumettre** depuis App Store Connect.

---

## 📋 CHECKLIST FINALE AVANT SOUMISSION

### Informations Requises
- [ ] Compte Apple Developer actif (99€/an)
- [ ] Bundle ID créé et configuré dans Xcode
- [ ] Captures d'écran (min. 2 tailles d'iPhone)
- [ ] Icône d'application générée
- [ ] Description et mots-clés rédigés
- [ ] URL de support (email ou site web)
- [ ] Build archivé et uploadé
- [ ] Informations de contact remplies
- [ ] Classification de contenu complétée
- [ ] Prix configuré (Gratuit)

### Vérifications Techniques
- [ ] App build réussie en mode release
- [ ] Aucune erreur dans Xcode
- [ ] Signature automatique activée
- [ ] Version dans `pubspec.yaml` : `1.0.0+1`
- [ ] Toutes les images chargent correctement
- [ ] Mode sombre fonctionne
- [ ] Transitions fluides entre pages
- [ ] Favoris persistent après redémarrage

---

## 🔧 COMMANDES UTILES

### Vérifier la Version Actuelle
```bash
grep "^version:" pubspec.yaml
# Résultat attendu: version: 1.0.0+1
```

### Incrementer la Version (pour mise à jour future)
```bash
# Version 1.0.0+1 → 1.0.1+2
# Modifier manuellement dans pubspec.yaml
```

### Nettoyer et Rebuild Complet
```bash
flutter clean
flutter pub get
cd ios && pod install && cd ..
flutter build ios --release
```

### Vérifier l'App avec l'Analyseur
```bash
flutter analyze
```

### Tester en Mode Release sur Simulateur
```bash
flutter run --release
```

---

## ⚠️ POINTS D'ATTENTION APPLE

### Raisons Fréquentes de Rejet
1. **Métadonnées manquantes ou incorrectes**
   - ✅ Solution : Vérifier tous les champs obligatoires

2. **Captures d'écran non conformes**
   - ✅ Solution : Fournir toutes les tailles requises

3. **App crashe au lancement**
   - ✅ Solution : Tester en mode release avant soumission

4. **Permissions non justifiées**
   - ✅ Notre app : Aucune permission → Pas de problème

5. **Contenu offensant**
   - ✅ Notre app : Contenu religieux approprié → Pas de problème

### Guidelines Importantes
- ✅ Pas de publicité → Conforme
- ✅ Pas d'achats intégrés → Conforme
- ✅ Pas de tracking → Conforme (Privacy manifest respectée)
- ✅ App fonctionnelle hors ligne → Excellent point

---

## 🎯 APRÈS L'APPROBATION

### Quand l'App est Approuvée
1. Vous recevrez un email "App Approved"
2. L'app sera **automatiquement publiée** (ou à la date choisie)
3. Elle apparaîtra sur l'App Store dans les 24h

### Promouvoir l'App
1. **Lien App Store** : Disponible dans App Store Connect
2. **QR Code** : Généré automatiquement dans App Store Connect
3. **Marketing** : Partager le lien avec les pèlerins

### Mises à Jour Futures
Pour publier une mise à jour :
1. Incrémenter la version dans `pubspec.yaml`
   ```yaml
   version: 1.0.1+2  # ou 1.1.0+2 pour nouvelles fonctionnalités
   ```
2. Faire un nouveau build et archive
3. Upload vers App Store Connect
4. Soumettre pour review

---

## 📞 SUPPORT

### Problèmes Techniques
- **Flutter** : https://docs.flutter.dev
- **Xcode** : https://developer.apple.com/documentation

### Problèmes App Store
- **Support Apple** : https://developer.apple.com/support
- **Guidelines** : https://developer.apple.com/app-store/review/guidelines/

### Contact Direct Apple
- Dans App Store Connect → **Aide** → **Contacter Apple**

---

## ✨ RÉSUMÉ DES OPTIMISATIONS EFFECTUÉES

### Performance
- ✅ Cache d'images pré-chargé (pas de rechargement)
- ✅ Transitions optimisées (200ms fade)
- ✅ Stockage local Hive (rapide)

### Qualité du Code
- ✅ Toutes déprécations corrigées
- ✅ Analyse Flutter : 0 erreurs, 9 warnings mineurs
- ✅ Imports nettoyés

### UX
- ✅ Mode sombre complet
- ✅ Navigation fluide
- ✅ Favoris persistants
- ✅ Interface intuitive

### Conformité App Store
- ✅ Info.plist configuré
- ✅ Privacy policy respectée
- ✅ Orientation portrait uniquement
- ✅ Nom français correct

---

**Bon déploiement ! 🚀**

*Guide créé le $(date +%Y-%m-%d)*
*Version de l'app: 1.0.0+1*
