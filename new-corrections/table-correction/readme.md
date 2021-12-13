# Correction du texte sur M.O.Excel/L.O.Calc
#### Présentation :
* Pour **faciliter les opérations de correction des textes**, nous avons produit des tableaux permettant de travailer en-dehors du XML. Ces tableaux ont été écrits par un script Python disponible dans ce même dossier (`tableaux_a_modifier.ipynb`) et exécutable via Jupyter Notebook.
* Nos tableaux comportent deux types d'objets, à raison d'un par ligne : a) les **tokens** (mots, ponctuation...) et b) les **sauts de ligne** avec leur att.facs contenant le numéro de facsimilé, pour permettre un retour à l'image en cas de besoin.
* Un tableau comprend nombre de colonnes destinées à faciliter l'utilisation ou typer précisément les corrections effectuées.
* Les tableaux sont au format CSV : vu la quantité de données, les avantages de légèreté du CSV sont primordiaux. Pour ouvrir des fichiers CSV sous Excel, voici [un tutoriel utile](https://www.copytrans.net/support/how-to-open-a-csv-file-in-excel/) Il est également primordial de les enregistrer sous leur format CSV.
* Il existe sur Excel une fonction pour fixer la première ligne, de manière à ce que les noms de colonnes soient visibles en permanence, voici [un tutoriel pour ce faire](https://support.microsoft.com/fr-fr/office/figer-les-volets-pour-verrouiller-la-premi%C3%A8re-ligne-ou-la-premi%C3%A8re-colonne-dans-excel-pour-mac-b8eb717e-9d3e-4354-8c02-d779a4b404b2).

#### Ce que permettent ces tableaux :
* De **séparer** repérage des tokens problématiques et correction à proprement parler en permettant de marquer des tokens comme "à corriger".
* De **garder trace** des tokens déjà traités en les marquant comme "corrigés".
* La correction des **lemmes** (en réécrivant directement dans la colonne "lemme").
* La correction des **POS** (en réécrivant directement dans la colonne "pos").
* De signaler des **tokens mal tokenisés**.
* De **trier** les tokens par forme/lemme/POS/à corriger pour traiter des cas semblables ensemble, puis de remettre tout le tableau dans l'ordre original ensuite (en utilisant la fonction de tri sur Excel ou Calc).

#### Ce que ne permettent pas ces tableaux :
* La correction des **formes mal transcrites**. Dans ce cas, on peut noter les corrections à faire mais ces corrections devront être faites directement dans le XML.
* La **re-tokenisation elle-même** lorsque des tokens sont mal tokenisés : on peut marquer un token comme "à scinder" ou "à fusionner", mais l'action elle-même devra être faite directement dans le XML.
-----------------

#### Les différentes colonnes et comment les utiliser :
###### -> n° de ligne
Cette colonne numérote les éléments en fonction de leur ordre dans le fil du texte, quelle que soit leur numérotation dans le document et quelle que soit leur nature (`<w>` ou `<lb>`). C'est grâce à elle que le document peut être remis dans l'ordre du texte (via la fonction de tri Excel/Calc), après un tri par forme/pos/lemme.

###### -> nature
Cette colonne répertorie la nature de l'élément représenté dans la ligne (`<w>` ou `<lb>`). Elle est destinée à la fois à l'utilisateurice et à la machine pour pouvoir ignorer facilement les lignes de `<lb>` qui par définition ne porteront pas de corrections.

###### -> n°/id
* Si l'élément de cette ligne est un `<w>`, la colonne portera sa numérotation dans le document, afin de permettre l'application automatique des éventuelles corrections enregistrées pour le token.
* Si l'élément de cette ligne est un `<lb>`, la colonne portera son attribut facs. Cette information contient le numéro de la page dont proviennent les tokens suivant le `<lb>`. Ce numéro permet donc à l'utilisateurice, en cas de token mal transcrit, de savoir quelle page regarder pour corriger le token. Attention, le numéro de page correspond à la numérotation des images du témoin par Transkribus, et non au numéro de la page tel qu'imprimé sur l'original.

###### -> forme "diplo"
Colonne pouvant être vide.
Si le token comprend une modernisation/correction d'aucun type (un élément `<choice>`, quels que soient ses enfants), la colonne contiendra du texte, et ce texte sera différent de la colonne suivante. S'il n'y a pas de modernisation/correction, la colonne sera vide.

###### -> forme modernisée
Cette colonne contient le mot-forme, lorsqu'il ne comporte pas de modernisations/corrections, ou bien sa forme corrigée/modernisée lorsqu'il en comporte.

###### -> forme corrigée
Cette colonne sert à enregistrer d'éventuelles corrections sur le mot-forme, indistinctement de la version du mot corrigée. La correction ne sera pas automatiquement appliquée au XML, mais sera transférée en commentaire XML dans le token, charge à l'utilisateurice de modifier le XML. Si le token doit être corrigé et a deux versions ("diplo" et "modernisée"), nous suggérons à l'utilisateurice d'écrire dans la colonne "forme corrigée" d'abord la forme "diplo", même si elle ne change pas, puis une espace, puis la forme "modernisée", même si elle ne change pas. Cela permettra une comparaison visuelle efficace avec le token d'origine à l'intérieur du XML.

###### -> lemme
Cette colonne contient la valeur de l'attribut att.lemma du token. Elle peut être corrigée directement dans cette colonne si besoin.

###### -> pos
Cette colonne contient la valeur de l'attribut att.pos du token. Elle peut être corrigée directement dans cette colonne si besoin.

###### -> à scinder
Cette colonne sert à signaler par un X les tokens mal tokenisés devant être scindés. Ce type de changement ne pouvant être automatiquement appliqués au XML, elle sera transférée en commentaire XML dans le token, charge à l'utilisateurice de modifier le XML.

###### -> à fusionner avec le w n°
Cette colonne sert à signaler les tokens mal tokenisés devant être fusionnés. Ce type de changement ne pouvant être automatiquement appliqués au XML, elle sera transférée en commentaire XML dans le token, charge à l'utilisateurice de modifier le XML.

###### -> à corriger
Cette colonne sert à marquer les tokens identifiés comme à corriger par un X. Les tokens ambigus (avec plusieurs POS possibles) et inconnus du dictionnaire utilisé à la lemmatisation sont d'emblée marqués par le script produisant les tableaux. La colonne peut aussi être marquée manuellement par l'utilisateurice pour fractionner son travail.

###### -> corrigé
Cette colonne sert à marqué un token comme traité par l'utilisateurice. **Il est impératif de bien penser à marquer un X dans sa colonne pour chaque token traité, car sinon les corrections ne seront pas vues par le script de resynchronisation.**

---------------------
#### Que faire lorsqu'on a un tableau à resynchroniser
La synchronisation de vos corrections nécessite l'exécution du script Python `resync-corrections-tableaux.ipynb`. Si vous n'êtes pas à l'aise avec Python, vous pouvez utiliser GitHub pour communiquer avec l'équipe de ConDÉ ou bien écrire un mail à Pierre Larrivée, porteur du projet.
Si vous êtes à l'aise avec Python et Jupyter Notebook, le script vous permet de faire une resynchronisation locale.
Si vous êtes également à l'aise avec le XML, vous pouvez repérer les commentaires contenus dans des éléments `<w>` pour faire les éventuelles retokénisations ou corrections de mots-formes que vous aviez repérées. Vous pourrez ensuite contacter l'équipe ConDÉ sur GitHub ou écrire un mail à Pierre Larrivée pour proposer vos corrections.
