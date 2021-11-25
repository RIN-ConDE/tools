(:Pour créer la liste des fichiers et renvoyer vers document_toc.xq
qui produira le sommaire interne au fichier. Fonctionne avec toc.xsl

NOTE - terminologie en stand-by.
:)

declare variable $baseURI external;
declare variable $dbPath external;
declare variable $project external;


<div class="wrapperDiv">
	<ul>
	{
		for $doc in collection($dbPath)
		let $idPointer := $doc//*:text/@xml:id
		let $bibl := $doc//*:sourceDesc/*:bibl[@xml:id='temoin']
		let $date := if($bibl/*:date/@when) then($bibl/*:date/@when) else($bibl/*:date/@notBefore)
		let $datetext := if($bibl/*:date/@when) then($bibl/*:date/@when) else($bibl/*:date/text())
		let $editor := if($doc//*:titleStmt/*:editor) then(" (ed. "||string-join(($doc//*:titleStmt/*:editor),", ")||")") else()
		let $author := if($doc//*:titleStmt/*:author) then($doc//*:titleStmt/*:author/text()) else("anonyme")
		let $title := $doc//*:titleStmt/*:title
		order by $date
		return
		<li data-href="{concat('sommaire/',tokenize(base-uri($doc),'/')[last()])}" id="doc/{$idPointer}">{$datetext||" — "} <b>{$author}</b> {" — "||$title}{if($editor) then($editor) else()}</li>
	}
	</ul>
</div>