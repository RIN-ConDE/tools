declare function local:get_docs_with_mentions($refdId){
    (: MP :
    On liste tous les documents contenant une mention de l'auteur courant.
    On renvoie une liste des témoins trouvés. Chaque <li> de témoin
    contient une autre liste construite par la fonction local:make_mention_list(),
    dont le premier élément sera le lien vers la document-toc du témoin courant. :)
    for $doc in collection("conde")[descendant::*:ref[@corresp=$refdId]]
    let $bibl := $doc//*:sourceDesc/*:bibl[@xml:id='temoin']
    let $date := if($bibl/*:date/@when) then($bibl/*:date/@when) else($bibl/*:date/@notBefore)
    let $datetext := if($bibl/*:date/@when) then($bibl/*:date/@when) else($bibl/*:date/text())
    let $editor := if($doc//*:titleStmt/*:editor) then(" (ed. "||string-join(($doc//*:titleStmt/*:editor),", ")||")") else()
    let $author := if($doc//*:titleStmt/*:author) then($doc//*:titleStmt/*:author/text()) else("anonyme")
    let $mentions := if(count($doc//*:ref[@corresp=$refdId]) = 1) then(" : 1 mention") else(concat(" : ",count($doc//*:ref[@corresp=$refdId])," mentions"))
    order by $date
    return <details><summary class='hover'>{"("||$datetext||") "||$author}{if($editor) then($editor) else()}{$mentions}</summary><ul><li><a target="_blank" rel="noopener noreferrer" href="{document-uri($doc)}" class="buttonlink">Sommaire de {$author}</a></li>{local:make_mention_list($doc, $refdId)}</ul></details>
};


declare function local:make_mention_list($doc, $refdId){
  (: MP :
  On fait la liste de toutes les mentions de la personne courante dans le témoin
  courant. On renvoie pour chaque un élément de liste avec l'identifiant de
  la section parente dans l'@href et le lien pour le retour au texte dans un <a>.
  La fonction renvoie toute la liste d'un coup.
  :)
  for $mention in $doc//*:ref
  where $mention/@corresp = $refdId
  let $parentId := $mention/ancestor::*:div[not(child::*:div)]/@xml:id
  let $parentName := if(contains(data($parentId), 'front')) then(concat('Matière liminaire, ',substring-after(data($parentId),'frontMatter-'))) else(if(contains(data($parentId), 'back')) then(concat('Appendices, ',substring-after(data($parentId),'backMatter-'))) else(concat('Corps du texte, ',substring-after(data($parentId),'alpha-'))))
  let $mentionNb := count($mention/preceding-sibling::*:ref[@corresp=$refdId]) +1
  let $wordNbs := if(count($mention/*:w)=1) then(data($mention/*:w/@n)) else(concat(data($mention/*:w[1]/@n), '-',data($mention/*:w[position()=last()]/@n)))
  return <li type="partname" href="{$parentId}">{$parentName} — <a target="_blank" rel="noopener noreferrer" href="{document-uri($doc)||'/'||$parentId||'.html#'||$wordNbs}">{$mentionNb||'e mention'}</a></li>
};


(: MP :
Query principale.
:)
<index type="personnes">{
  (: On fait la liste de chaque identifiant de notices bibliographiques différent dans le corpus.:)
  for $persId in distinct-values(collection("conde")//*:sourceDesc//*:listPerson//*:person/@xml:id)
  (: On ne garde que ceux qui sont effectivement référencés dans le corpus.:)
  where collection("conde")//*:ref[@corresp = concat("#",$persId)]
  let $refdId := concat('#', $persId)
  
  (: On va chercher la première notice de la personne courante et on extrait ses éventuelles dates. :)
  let $person := subsequence(collection("conde")//*:sourceDesc//*:listPerson//*:person[@xml:id=$persId],1,1)
  let $notice := if($person/@sameAs) then(data($person/@sameAs)) else('')
  let $birth := if($person//*:birth) then($person//*:birth/text()) else('')
  let $death := if($person//*:death) then($person//*:death/text()) else('')
  let $dates := if($birth != '') then(concat($birth, ' — ', $death)) else('')
  
  (: On va chercher les différentes formes possibles du nom enregistrées (français/anglais et/ou latin) individuellement.:)
  let $persFRENGname := if($person/*:persName[@xml:lang='fr']) then(string-join($person/*:persName[@xml:lang='fr']//text(),", ")) else(
    if($person/*:persName[@xml:lang='eng']) then(string-join($person/*:persName[@xml:lang='eng']//text(),", ")) else(''))
  let $persLATname := if($person/*:persName[@xml:lang='la']) then(string-join($person/*:persName[@xml:lang='la']//text(),", ")) else('')
  
  (: On combine les noms français/anglais et latin sans espace pour trier alphabétiquement.:)
  let $fullName := concat(replace(replace($persFRENGname, "\s", ""),"é","e"), replace(replace($persLATname, "\s", ""),"é","e"))
  let $initial := upper-case(substring($fullName,1,1))
  order by lower-case($fullName)
  
  (: On met en forme, selon quel(s) nom(s) est/sont présent(s). Puis on appelle la fonction
  local:get_docs_with_mentions() pour commencer la liste des mentions de la personne courante
  dans le corpus. :)
  return <details type="{$initial}" id="{$persId}"><summary class="hover"><span type="freng">{if($persFRENGname!='') then($persFRENGname) else()}</span>{if($dates != '' and $persFRENGname != '') then(concat(" [",$dates,"] ")) else()}{if ($persFRENGname!='' and $persLATname!='') then(', (')}{if ($persLATname!='') then (<span type="lat">{$persLATname}</span>) else()}{if ($persFRENGname!='' and $persLATname!='') then(')') else()}{if($persLATname !='' and $persFRENGname = '' and $dates!='') then(concat(' [',$dates,"] ")) else()}</summary><hr/>{if($notice != '') then(<a target="_blank" rel="noopener noreferrer" href="{$notice}">Notice d'autorité</a>) else()}{local:get_docs_with_mentions($refdId)}</details>
}</index>