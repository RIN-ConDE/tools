<xsl:stylesheet version="2.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xmlns:xs="http://www.w3.org/2001/XMLSchema"
  xmlns:xlink="http://www.w3.org/1999/xlink"
  xmlns:xinclude="http://www.w3.org/2001/XInclude"
  xmlns:xhtml="http://www.w3.org/TR/xhtml/strict"
  xmlns:tei="http://www.tei-c.org/ns/1.0"
  xmlns:ead="urn:isbn:1-931666-22-9"
  xmlns:hfp="http://www.w3.org/2001/XMLSchema-hasFacetAndProperty"
  xmlns:max="https://max.unicaen.fr"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="max ead tei xsl xsi xs xlink xinclude xhtml tei hfp">
  <!--pour importer le i18n-->
  <xsl:import href="../../../../ui/xsl/i18n.xsl"/>
  <xsl:output method="xhtml" encoding="utf-8" indent="no"/>
  
<!--  <xsl:preserve-space elements="*:*"/>-->
  
  <!--variables pour le i18n-->
  <xsl:param name="project"/>
  <xsl:param name="locale"/>
  <xsl:param name="key"/>
  
  <!-- Copie des nœuds sans changement. -->
  <xsl:template match="node() | @*">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>
  
  <!-- MP
    Formatage des liens pour le retour au texte.
    - Si le lien est un lien général vers la document-toc (@class='buttonlink')
    on modifie le résultat de la query.
    - Sinon, c'est le lien vers la section d'une occurrence particulière,
    pas besoin de le reprendre.
  -->
  <xsl:template match="//a/@href">
    <xsl:choose>
      <xsl:when test="parent::a/@class='buttonlink'">
        <xsl:attribute name="href">
          <xsl:value-of select="replace(replace(replace(self::node(),'\}/', '}'), 'conde/', 'conde/sommaire/'),'.xml','.html')"/>
        </xsl:attribute>
      </xsl:when>
      <xsl:otherwise>
        <xsl:attribute name="href">
          <xsl:value-of select="self::node()"/>
        </xsl:attribute>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <!-- MP
    Gestions des noms français/anglais.
    J'ai systématiquement ajouté des éléments <span> aux noms
    dans la query pour gérer les informations absentes.
    S'il y a un nom français/anglais (@type='freng'), on enlève le
    <span> et on le remplace par un <strong>.
  -->
  <xsl:template match="span[@type='freng']">
    <xsl:choose>
      <xsl:when test="contains(self::span, text())">
        <strong><xsl:value-of select="replace(self::span,'&#x2028;','')"/></strong>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  
  <!-- MP
    Gestion des noms latins.
    J'ai systématiquement ajouté des éléments <span> aux noms
    dans la query pour gérer les informations absentes.
    S'il y a des noms latins et français, le nom latin ne prend
    qu'un élément <em>.
    S'il y a du latin mais pas du français/anglais, le latin prend un
    <strong> en plus.
    Sinon on peut enlever le <span>.
  -->
  <xsl:template match="span[@type='lat']">
    <xsl:choose>
      <xsl:when test="contains(self::span, text()) and preceding-sibling::span[@type='freng' and text()]">
        <i><xsl:value-of select="replace(self::span,'&#x2028;','')"/></i>
      </xsl:when>
      <xsl:when test="contains(self::span, text()) and preceding-sibling::span[@type='freng' and not(text())]">
        <strong><i><xsl:value-of select="replace(self::span,'&#x2028;','')"/></i></strong>
      </xsl:when>
      <xsl:otherwise/>
    </xsl:choose>
  </xsl:template>
  
  <!-- MP
    Utilisation des identifiants des <div> pour décrire chaque section
    contenant une mention de l'auteur courant.
    La variable $idlist fait une liste en tokenisant l'identifiant sur les -.
    Ensuite, selon l'ancêtre front/body/back de la section, le texte est
    construit autour des différents segments nécessaires de l'identifiant.
  -->
  <xsl:template match="li[@type='partname']">
    <xsl:variable name="idlist" select="tokenize(self::li/@href,'-')"/>
    <li>
    <xsl:choose>
      <xsl:when test="contains(self::li, 'Corps')">
        <xsl:value-of select="substring-before(self::li,',')"/>
        <xsl:text>, partie </xsl:text>
        <xsl:value-of select="subsequence($idlist,4,1)"/>
        <xsl:text>, chapitre </xsl:text>
        <xsl:value-of select="subsequence($idlist,5,1)"/>
        <xsl:text>, section </xsl:text>
        <xsl:value-of select="subsequence($idlist,6)"/>
        <xsl:text>  — </xsl:text>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="substring-before(self::li,',')"/>
        <xsl:text>, section </xsl:text>
        <xsl:value-of select="subsequence($idlist,5,1)"/>
        <xsl:text>  — </xsl:text>
      </xsl:otherwise>
    </xsl:choose>
      <xsl:apply-templates select="self::li/*"/>
    </li>
  </xsl:template>
  
  <!-- MP
    Structuration de la page.
    On ajoute un titre et une explication, puis on fait un groupe
    par initiale (stockée par la query dans l'@type de chaque personne).
    Pour chaque groupe on ajoute l'initiale en titre.
  -->
  <xsl:template match="*:index[@type='personnes']">
    <div class="indexref"><h2 class="pageTitle">Références bibliographiques dans les coutumiers</h2>
      <hr/><p class="mention">Figures d'autorité citées par les auteurs des coutumiers édités par le projet ConDÉ.</p><hr/>
    <xsl:for-each-group select="child::*:details" group-by="replace(@type,'É','E')">
      <h2><xsl:value-of select="@type"/></h2>
      <div type="index">
          <xsl:for-each select="current-group()">
            <details>
              <xsl:apply-templates/>
            </details>
          </xsl:for-each>
      </div>
      <hr/>
    </xsl:for-each-group>
    </div>
  </xsl:template>
  
</xsl:stylesheet>
