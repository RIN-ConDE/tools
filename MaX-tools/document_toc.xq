import module namespace max.config = 'pddn/max/config' at '../../../rxq/config.xqm';
import module namespace max.alignment = 'pddn/max/alignment' at '../../../rxq/alignment.xqm';
import module namespace max.html = 'pddn/max/html' at '../../../rxq/html.xqm';
(:import module namespace max.tei_toc = 'pddn/max/tei/tei_toc.xqm' at '../../../rxq/tei/tei_toc.xqm';:)

declare variable $baseURI external;
declare variable $dbPath external;
declare variable $project external;
declare variable $doc external;



declare function local:subChapter($chapter, $project, $doc){
	let $subChapters := $chapter/*:div[@*:id]
	return if($chapter/*:div) then(
	<ul>{
		for $subChapter in $chapter/*:div[@*:id]
		let $title := if($subChapter/*:head) then(
			if($subChapter/*:head[2]) then(
				let $title := <head>{$subChapter/*:head[1]/*:w}{$subChapter/*:head[2]/*:w}</head>
				return $title
			)
			else(<head>{if($subChapter/*:head/*:w) then($subChapter/*:head/*:w) else($subChapter/*:head)}</head>)
			)
		else(
			if($subChapter[@subtype='introduction']) then("[Introduction]")
			else(
				if($subChapter[@subtype='coutume']) then("[Coutume de Normandie]")
				else(
					if($subChapter[@subtype='usages-locaux']) then("[Usages locaux]")
					else(
						if($subChapter[@subtype='articles-placitez']) then("[Articles Placités]")
						else(
							if($subChapter[@subtype='editions']) then("[Éditions de textes législatifs]")
							else(if($subChapter[@subtype='salut']) then("[Salut]")
								else("[Sans titre]")
								)
							)
						)
					)
				)
			)
		let $idPointer := $subChapter/@xml:id
		(: MP :
		Si les titres n'ont que des chiffres romains en titre, dans de gros fichiers comme Basnage, 
		ça peut rendre la TOC inutilisable. Donc en plus des titres, s'il y a une citation en début
		de section, j'en convoque les 15 premiers tokens : cette citation est généralement le texte
		commenté dans la section courante, donc ça permet de savoir de quoi on parle dans cette
		section, même sans titre. :)
		let $quoteInTitle := if($subChapter/*:quote/child::*/*:w[16]) then(<quote><w>:</w><w> 	
&#171;&#160;</w>{subsequence($subChapter/*:quote/child::*/*:w, 1, 15)}<w>&#8230;&#160;&#187;</w></quote>) else(if($subChapter/*:quote) then(<quote><w>:</w><w> 	
&#171;&#160;</w>{subsequence($subChapter/*:quote/child::*/*:w, 1, 15)}<w>&#160;&#187;</w></quote>))
		let $type := $subChapter/@type
		return
			<li id="{$idPointer}" type="{$type}">
				<a data-href="{concat(max.config:getBaseURI(), $project, '/', $doc, '/', $idPointer, '.html')}">{
					if($type = "chapter") then($title) else(
						if($subChapter/*:quote) then($title, $quoteInTitle) else($title)
						
						)
					}</a>
				{if($type = "chapter") then(local:subChapter($subChapter, $project, $doc))}
			</li>
		}
	</ul>
	)
};

	
	(: MP :
	Cette partie de la query retourne les grandes parties de la TOC.
	
	La query se base ici sur tous les petits-enfants de /TEI/text, pour
	pouvoir donner accès aussi à la matière liminaire et aux appendices.
	Pour pouvoir les séparer du corps du texte sur la page HTML, la query
	garde trace du parent front/body/back dans l'@type.
	
	Si la partie ne contient pas de titre, la query regarde le @subtype
	(ils sont uniformisés quand c'était possible) pour pouvoir avoir un
	titre par défaut si possible. Sinon, on écrit "[Sans titre]".
	
	On n'appelle la fonction $subChapter que si la partie appartient au
	/TEI/text/body puisque dans le /TEI/text/front et /TEI/text/back,
	les (très) rares sous-parties n'ont pas d'intérêt à être convoquées.
	
	ATTENTION, ne pas enlever la <div> car sinon la query n'est pas
	valide pour MaX. Idem : une seule <div> en racine. :)
	
	<div type="maindiv">{
    	for $chapter in doc(concat($dbPath,'/', $doc))//*:text/*/*
    	let $title := if($chapter/*:docTitle) then("[Page de titre]")
    		else(
    		if($chapter/*:head) then(
    			if($chapter/*:head/*:w) then(<head>{$chapter/*:head/*:w}</head>) else(<head>{$chapter/*:head}</head>)
    			) else(
				if($chapter[@subtype='introduction']) then("[Introduction]")
				else(
					if($chapter[@subtype='coutume']) then("[Coutume de Normandie]")
					else(
						if($chapter[@subtype='usages-locaux']) then("[Usages locaux]")
						else(
							if($chapter[@subtype='articles-placitez']) then("[Articles Placités]")
							else(
								if($chapter[@subtype='editions']) then("[Éditions d'autres textes législatifs]")
								else(if($chapter[@subtype='salut']) then("[Salut]")
									else(if($chapter[@subtype='intention']) then("[Note d'intention]")
										else("[Sans titre]")
										)
									)
								)
							)
						)
					)
				)
			)
    	let $type := if($chapter/ancestor::*:front) then("front") else(
    		if($chapter/ancestor::*:back) then("back") else("body")
    		)
    	let $idPointer := $chapter/@xml:id
    	return if($type="body") then(
    		<div>
            	<h4 class="livre">{$title}</h4>
            	<ul>{local:subChapter($chapter, $project, $doc)}</ul>
        	</div>
        	) else(
    		<div type="{$type}" id="{$idPointer}" data-href="{concat(max.config:getBaseURI(), $project, '/', $doc, '/', $idPointer, '.html')}">
            	<h4>{$title}</h4>
        	</div>
        	)
    }</div>








