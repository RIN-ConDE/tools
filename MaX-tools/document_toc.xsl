<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="2.0" exclude-result-prefixes="tei xsl">
	<xsl:template match="/">
		<div id="document-toc">
			<xsl:apply-templates/>
		</div>
	</xsl:template>
	<xsl:template match="h2">
		<xsl:text> </xsl:text>
		<h2>
			<xsl:apply-templates/>
		</h2>
	</xsl:template>
	<xsl:template match="h3">
		<h3>
			<xsl:apply-templates/>
		</h3>
	</xsl:template>
	<xsl:template match="h4">
			<h4 class="parttitle"><b><xsl:apply-templates/></b></h4>
	</xsl:template>

	
	<!-- MP
		La query produit des listes dans des listes, mais elle indique
	aussi le niveau de profondeur de chaque <div> trouvée.
	En fonction de cet @type, on choisit la mise en forme de chaque
	élément. -->
	<xsl:template match="li">
		<xsl:variable name="href"><xsl:value-of select="a/@data-href"/></xsl:variable>
		<xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="@type='chapter' and not(child::ul)">
				<details class="hover">
					<xsl:apply-templates/>
				</details>
			</xsl:when>
			<xsl:when test="@type='chapter'">
				<details class="hover">
					<xsl:apply-templates/>
				</details>
			</xsl:when>
			<xsl:otherwise>
				<li id="{@id}">
					<xsl:apply-templates/>
				</li>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- MP
		Les fichiers TEI ont 3 niveaux de div ('part' > 'chapter' > 'section') et elles sont nombreuses, donc je voulais que le dernier
	niveau soit déroulable. Donc, si le niveau de div concerné est un "chapter", elle devient un bouton controlant l'affichage ou non
	des "section" contenues dans le chapitre, de manière à n'avoir jamais plus qu'un chapitre déroulé à la fois.
	-->
	<xsl:template match="a">
		<xsl:variable name="href">
			<xsl:value-of select="@data-href"/>
		</xsl:variable>
		<xsl:choose>
			<xsl:when test="self::a[parent::li[@type='chapter']]">
				<summary href="{$href}">
					<xsl:apply-templates/><xsl:text>  	
&#8212; </xsl:text>
					<a href="{$href}"><button>Lire tout le chapitre.</button></a>
				</summary>
			</xsl:when>
			<xsl:otherwise>
				<a href="{$href}">
					<xsl:apply-templates/>
				</a>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>	
	<!-- MP
		Pour la meme raison, puisque le chapitre est à présent un bouton, j'ai rajouté un élément de liste au-dessus des sections, avec
	les memes @id et @href que l'élément original de liste du chapitre, pour permettre si besoin l'affichage du chapitre entier.
	-->
	<xsl:template match="div[@type]"/>


	<xsl:template match="ul[ancestor::div[not(@type)]]">
		<xsl:variable name="href"><xsl:value-of select="parent::li/a/@data-href"/></xsl:variable>
		<xsl:variable name="id"><xsl:value-of select="parent::li/@id"/></xsl:variable>
		<xsl:choose>
			<xsl:when test="child::ul">
				<xsl:apply-templates/>
			</xsl:when>
			<xsl:when test="parent::li[@type='chapter']">
					<ol>
						<xsl:apply-templates/>
					</ol>
			</xsl:when>
			<xsl:when test="not(parent::li[@type='chapter']) and not(child::li)">
				<ul>
					<xsl:apply-templates/>
				</ul>
			</xsl:when>
			<xsl:when test="not(child::*)"/>
			<xsl:otherwise>
				<ul>
					<xsl:apply-templates/>
				</ul>
				<hr/>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>

	<!-- MP
		Ici, c'est la structuration du sommaire : on fait une TOC en trois parties.
		
		- S'il y a un /TEI/text/front, la transformation produit une première
		<div> avec son contenu, sinon la <div> n'est pas produite.
		- Au milieu, il y aura toujours une <div> avec le contenu du /TEI/text/body.
		- S'il y a un /TEI/text/back, on produit une dernière <div> pour son contenu.
		
		C'est possible parce que j'ai basé ma query sur tous les petits-enfants de /TEI/text
		et que j'ai exporté le parent front/body/back dans l'@type.
	 -->

	<xsl:template match="div[@type='maindiv']">
		<xsl:if test="div[@type='front']">
			<h3 class="parttitle">Matière liminaire</h3>
			<div class="sommaire">
				<ul>
					<xsl:for-each select="div[@type='front']">
					<xsl:variable name="href"><xsl:value-of select="@data-href"/></xsl:variable>
						<xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
						<xsl:variable name="title"><xsl:apply-templates select="child::h4"/></xsl:variable>
						<ul>
							<li id="{$id}" type="section"><a href="{$href}"><xsl:value-of select="$title"/></a></li>
						</ul>
					</xsl:for-each>
					<hr/>
				</ul>
			</div>
		</xsl:if>
		<h3 class="parttitle">Corps du texte</h3>
		<div class="sommaire">
			<xsl:apply-templates/>
		</div>
		<xsl:if test="div[@type='back']">
			<h3 class="parttitle">Annexes</h3>
			<div class="sommaire">
				<ul>
					<xsl:for-each select="div[@type='back']">
						<xsl:variable name="href"><xsl:value-of select="@data-href"/></xsl:variable>
						<xsl:variable name="id"><xsl:value-of select="@id"/></xsl:variable>
						<xsl:variable name="title"><xsl:value-of select="child::h4"/></xsl:variable>
						<ul>
							<li id="{$id}" type="section"><a href="{$href}"><xsl:value-of select="$title"/></a></li>
						</ul>
					</xsl:for-each>
				</ul>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- les éléments TEI -->
	<xsl:template match="tei:note[@type!='notice']"/>
	<xsl:template match="tei:rdg"/>
	<xsl:template match="tei:pb"/>
	<xsl:template match="tei:lb"/>
	<xsl:template match="tei:fw"/>		
	<xsl:template match="tei:catchwords"/>		
	<xsl:template match="tei:name">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="tei:head">
		<xsl:apply-templates/>
		<xsl:text> </xsl:text>
	</xsl:template>
	<xsl:template match="tei:add">
		<xsl:text> </xsl:text>
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="tei:app">
		<xsl:apply-templates/>
	</xsl:template>

	<xsl:template match="tei:lem">
		<xsl:apply-templates/>
	</xsl:template>
	<xsl:template match="tei:hi">
	 <span>
		 <xsl:attribute name="class">
			 <xsl:value-of select="@rend"/>
		 </xsl:attribute>
		 <xsl:apply-templates/>
	 </span>
	</xsl:template>
	

    <xsl:template match="tei:w[@join='left']">
    	<xsl:value-of select="node()"/>
    	<xsl:text> </xsl:text>
    </xsl:template>
        
    <!-- OVP: je fais ça un peu comme un boucher mais c’est un bon départ.
    MP : J'ajoute juste les tirets -.-->
    <xsl:template match="tei:w[not(@join='left')]">
        <xsl:variable name="nextW" select="following-sibling::tei:w[1]/@lemma"/>
        <xsl:value-of select="."/>
        <xsl:choose>
        	<!-- les cas avec une espace insécable -->
        	<xsl:when test="$nextW=';' or $nextW=':' or $nextW='?' or $nextW='!'">
            	<xsl:text>&#160;</xsl:text>
            </xsl:when>
            <!-- les cas sans espaces -->
        	<xsl:when test="$nextW=',' or $nextW='.' or $nextW='’' or $nextW='-' or @lemma='’' or @lemma='-'"/>           	
            <!-- sinon une espace simple -->          	
            <xsl:otherwise>
            	<xsl:text> </xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
	
</xsl:stylesheet>
