# Configuration des Fichiers Audio

## 🎵 Lecteur Audio Ajouté !

Un lecteur audio apparaît maintenant dans la page de détail de chaque chant qui a un fichier audio disponible.

**Interface du lecteur :**
- Badge doré "Audio iOS natif" avec icône Apple
- Bouton Play/Pause circulaire (64px)
- Texte "Écouter l'accompagnement" ou "Lecture en cours..."
- Note "Contrôles dans le Control Center iOS"

## 📁 Comment Ajouter des Fichiers Audio

### Option 1 : Fichiers MP3 Existants
Si vous avez déjà des enregistrements :

```bash
# Copiez vos fichiers dans le dossier audio
cp ~/chemin/vers/chant1.mp3 "assets/audio/chant_1.mp3"
cp ~/chemin/vers/chant2.mp3 "assets/audio/chant_2.mp3"
# etc.
```

### Option 2 : Créer des Fichiers de Test avec Synthèse Vocale (macOS)

Pour créer rapidement des fichiers audio de test :

```bash
cd "/Users/eloijahan/Documents/projets perso/Pélerinage/P-l-MSM/assets/audio"

# Chant 1 - Acclamons le Roi du ciel
say -v Thomas "Chant numéro 1. Acclamons le Roi du ciel, que son Nom soit glorifié. Adorons l'Emmanuel, Dieu avec nous à jamais." -o chant_1_temp.aiff
ffmpeg -i chant_1_temp.aiff -acodec libmp3lame -ab 128k chant_1.mp3
rm chant_1_temp.aiff

# Chant 2
say -v Thomas "Chant numéro 2. [Insérez les premières lignes du chant 2]" -o chant_2_temp.aiff
ffmpeg -i chant_2_temp.aiff -acodec libmp3lame -ab 128k chant_2.mp3
rm chant_2_temp.aiff
```

### Option 3 : Fichier Silence (pour test uniquement)

Si vous voulez juste tester que le lecteur fonctionne :

```bash
cd "/Users/eloijahan/Documents/projets perso/Pélerinage/P-l-MSM/assets/audio"

# Créer un fichier silence de 10 secondes
ffmpeg -f lavfi -i anullsrc=r=44100:cl=mono -t 10 -q:a 9 -acodec libmp3lame chant_1.mp3
```

### Option 4 : Enregistrements Piano

Si vous avez un clavier MIDI ou un piano :
1. Enregistrez les mélodies avec GarageBand (gratuit sur Mac)
2. Exportez en MP3
3. Renommez selon le pattern `chant_[ID].mp3`

## ⚙️ Configuration du Service Audio

Le service audio est configuré dans `lib/services/audio_service.dart`.

**Par défaut**, la méthode `hasAudio()` retourne `true` pour les chants 1-10 :

```dart
bool hasAudio(int chantId) {
  return chantId >= 1 && chantId <= 10;
}
```

**Pour modifier :** Ajustez cette méthode selon les chants pour lesquels vous avez des fichiers audio.

Par exemple, si vous n'avez que les chants 1, 2, 3, et 5 :

```dart
bool hasAudio(int chantId) {
  return [1, 2, 3, 5].contains(chantId);
}
```

## 🎨 Interface du Lecteur

Le widget `_AudioPlayerWidget` affiche :

- **Badge "Audio iOS natif"** : Indique aux reviewers Apple que c'est une fonctionnalité native
- **Bouton Play/Pause** : Icône de 64px avec état visuel
- **État de lecture** : "Lecture en cours..." ou "Écouter l'accompagnement"
- **Note Control Center** : Rappelle que l'audio fonctionne en arrière-plan

**Le widget ne s'affiche que si :**
1. Un fichier audio existe dans `assets/audio/chant_[ID].mp3`
2. La méthode `hasAudio(chantId)` retourne `true`

## 📱 Fonctionnalités iOS Natives

L'audio utilise `just_audio` qui offre :

✅ **Background Audio** : Lecture continue même quand l'app est en arrière-plan
✅ **Control Center** : Contrôles dans le Control Center iOS (play/pause/seek)
✅ **Lock Screen** : Affichage des métadonnées sur l'écran de verrouillage
✅ **Interruptions** : Gestion automatique des appels, Siri, etc.
✅ **AirPods** : Support complet des contrôles Bluetooth

Configuration dans `ios/Runner/Info.plist` :
```xml
<key>UIBackgroundModes</key>
<array>
    <string>audio</string>
</array>
```

## 🧪 Test

1. **Ajoutez au moins 1 fichier audio** (ex: `chant_1.mp3`)
2. **Relancez l'app** :
   ```bash
   flutter run
   ```
3. **Ouvrez le chant 1** dans l'app
4. **Vérifiez que le lecteur audio apparaît** avec le badge "Audio iOS natif"
5. **Appuyez sur Play** - l'audio devrait se lancer
6. **Mettez l'app en arrière-plan** - l'audio continue
7. **Ouvrez le Control Center** - les contrôles audio sont visibles

## 📸 Pour Apple Review

Prenez un screenshot du lecteur audio dans la page de détail du chant.
Ce screenshot démontre clairement une fonctionnalité iOS native impossible dans Safari.

## ❓ Dépannage

**Le lecteur n'apparaît pas ?**
- Vérifiez que le fichier existe : `assets/audio/chant_[ID].mp3`
- Vérifiez `hasAudio(chantId)` retourne `true` pour cet ID
- Relancez `flutter pub get` si vous venez d'ajouter des fichiers

**Erreur au clic sur Play ?**
- Vérifiez le nom du fichier (ex: `chant_1.mp3` pas `chant_01.mp3`)
- Vérifiez le format (MP3 recommandé)
- Regardez les logs : `flutter logs`

**L'audio ne continue pas en arrière-plan ?**
- Vérifiez `Info.plist` contient `UIBackgroundModes: ["audio"]`
- Testez sur un iPhone réel (le simulateur peut avoir des limitations)
