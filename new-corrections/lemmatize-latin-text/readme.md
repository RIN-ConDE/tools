# Comment lemmatiser les textes latins

### 1 - Vérifications d'équipe
* S'assurer qu'on est le⋅a seul⋅e à travailler sur ce fichier, qu'on travaille sur la version la plus récente ([branche ameliorations du corpus](https://github.com/RIN-ConDE/editions/tree/ameliorations)) et que personne n'a de modifications à ajouter.
* Informer tout le monde qu'on s'apprête à travailler sur un témoin et qu'on doit être le⋅a seul⋅e à le modifier pendant ce temps.
* Git clone/pull sur la branche ameliorations du corpus.

### 2 - Marquer les emplacements du texte latin
* Il faut **manuellement repérer** tous les fragments latins. Certains sont déjà marqués (dans le Rouillé, les notes latines étaient clairement distinctes et ont été marquées avec un `att.xml:lang="la"`, mais il peut y avoir des fragments latins dans le texte français non repérés) mais la plupart ne le sont pas.
* On peut s'aider des informations de lemmatisation quand un `//w/att.pos='Xe'`.
* Si le fragment est une note entière ou un paragraphe entier, ou correspond entièrement à un élément structurel déjà présent, il faut ajouter un attribut `att.xml:lang="la"` à cet élément structurel.
* Si le fragment ne correspond pas exactement à un tel élément structurel, il faut ajouter un élément `<seg>` avec un attribut `att.xml:lang="la"`.

### 3 - Revoir la tokenisation
* Une fois tous les mots bien retokénisés, il faut refaire la numérotation de tous les tokens. Pour cela, on utilise le script `re-id_tokens.ipynb` sur Jupyter Notebook.

### 4 - Lemmatisation etc
* À décider : le jeu d'étiquettes utilisé. Il devra être déclaré dans le `/TEI/teiHeader/encodingDesc` en français et en anglais.
* Si on lemmatise à la main, cela se fait sur le modèle des autres témoins : un attribut lemma pour le lemme, un attribut pos pour les catégories grammaticales.
* Si on le souhaite, on peut faire une lemmatisation automatique.
* Le script `extraction_tokens.ipynb` permet de sortir les mots-formes et leurs numéros en tableau CSV.
* Le script `resync_tokens.ipynb` permet de donner aux tokens du XML les POS et lemmes déduits par le lemmatiseur. Attention à ce que les mots soient tous bien alignés avec leurs numéros et que rien ne soit décalé. Ce script est fait pour produire un fichier séparé en sortie, pour pouvoir faire les vérifications sans toucher au fichier d'origine. Donc si les modifications conviennent, on peut remplacer l'élément `<text>` de l'ancien par celui du nouveau.

### 5 - Déclarer les modifications
* Il faut ajouter un élément `/TEI/revisionDesc/listChanges/change` (cf [doc. TEI](https://www.tei-c.org/release/doc/tei-p5-doc/en/html/HD.html#HD6)) dans chaque fichier modifié pour décrire les changements opérés.
* Il faut se déclarer comme contributeurice : si on est déjà déclaré dans un `/TEI/teiHeader/fileDesc/editionStmt/respStmt/resp`, il faut mettre à jour les textes français/anglais décrivant nos rôles. Sinon, on se crée un élément `<resp>` à cet endroit sur le modèle des personnes déjà déclarées.

### 6 - Mettre la nouvelle version du fichier sur GitHub
* Si vous maîtrisez Git, vous pouvez faire un git push *sur la branche ameliorations*.
* Sinon, contactez l'équipe du projet pour que le nouveau fichier soit vérifié et changé.