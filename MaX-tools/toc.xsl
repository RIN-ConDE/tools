<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" version="1.0" exclude-result-prefixes="tei xsl">
	<xsl:param name="baseuri"/>
	<xsl:param name="project"/>
	
	
	<xsl:template match="/">
		<div class="row">
			<div class="col-md-12 col-lg-10">
				<div id="toc">
					<xsl:apply-templates/>
				</div>
			</div>
		</div>
	</xsl:template>
	

	<!--MP : Structuration de la page avec titre et explications.-->
	<xsl:template match="div[@class='wrapperDiv']">
		<div class="wrapperDiv">
			<h2 class="pageTitle">Accès aux textes</h2>
			<hr/>
			<div>
				<p class="mention">Via cette page, vous pouvez accéder au sommaire de chaque témoin et lire le texte chapitre par chapitre, ou section par section.</p>
			</div>
			<hr/>
			<xsl:apply-templates/>
			<div>
				<hr/><p class="mention">La base de données en XML-TEI est disponible au téléchargement selon la licence Creative Commons, sur <a class="lien_externe" target="_blank" rel="noopener noreferrer" href="https://github.com/RIN-ConDE/editions">notre dépot GitHub</a>. Nous y mettons également à votre disposition une version des textes compatible avec le logiciel <a class="lien_externe" href="http://textometrie.ens-lyon.fr/?lang=en">TXM</a>. Des fichiers PDF texte sont également prévus pour la lecture simple.</p>
			</div>
		</div>
	</xsl:template>
	
	<xsl:template match="tei:note"/>
	
	<xsl:template match="li">
		<li>
			<xsl:choose>
				<xsl:when test="@data-dir='true'">
					<xsl:value-of select="./text()"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:variable name="href">
						<xsl:value-of select="replace(@data-href,'xml','html')"/>
					</xsl:variable>
					<a href="{$href}">
						<xsl:apply-templates/>
					</a>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="./ul"/>
		</li>
	</xsl:template>
	<xsl:template match="ul">
		<ul>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>
	<xsl:template match="tei:title">
		<span>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
	<xsl:template match="tei:hi">
		<span>
			<xsl:attribute name="class">
				<xsl:value-of select="@rend"/>
			</xsl:attribute>
			<xsl:apply-templates/>
		</span>
	</xsl:template>
</xsl:stylesheet>
