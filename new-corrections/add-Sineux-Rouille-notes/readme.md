# Quelles étapes reste-t-il pour ajouter les notes manuscrites du Rouillé de Pierre Sineux au XML ?
### 1 - Vérifications codicologiques
* S'agit-il bien exactement de la même édition ?
* **Si oui**, pas besoin de se poser de questions, les notes pourront aller dans le même fichier et on peut ajouter dans `//bibl[att.xml:id='temoin']/att.corresp` une espace puis le lien vers la notice du scd d'UniCaen. **Sinon**, vérifier si le texte imprimé auquel se réfèrent les notes est identique à notre version éditée. Si c'est le cas, on peut procéder pareil. Si les changements sont minimes, on peut procéder comme pour Morisse avec des `<quote>` pour préciser le texte exact en début de note.
* **Autrement** : Si ce n'est pas la même édition exactement et que le texte diffère, on devra procéder comme pour le Morisse : un fichier à part, et on transcrit aussi le texte référé (à quelle échelle ? à décider).
* **Déterminer les différentes mains** et potentiellement créer un identifiant pour chaque (quitte à écrire "hand1" etc) pour différencier les notes. Il faudra aussi déclarer ces mains (cf plus loin).

### 2 - Terminer la transcription
* Si la collection a un problème sur Transkribus, les données actuelles sont inclues dans ce dossier au format Transkribus. Il faudra redonner à Transkribus ce dossier.
* Terminer la transcription sur Transkribus.
* Vérifier les lignes et leur ordre, enlever toutes les lignes inutiles, refaire les identifiants (onglet Layout, bouton "Assign unique IDs to all elements according to their current sorting".

### 3 - Exporter la transcription
* "Export document" (barre du haut)
* Dans la fenêtre d'export, prenez l'onglet "Client export" tout en haut, choisissez un chemin local pour l'export et un nom pour le dossier qui sera créé.
* Colonne de gauche ("choose export formats") : cochez *uniquement* `TEI`.
* Colonne du milieu ("Export options") : cochez `Zone per region`, `Zone per line`, `Use bounding box coordinates` et `Line tags (<l>...</l>)`.
* Ok.

### 4 - Convertir la sortie TEI-Transkribus en TEI-ConDÉ.
[À suivre.]