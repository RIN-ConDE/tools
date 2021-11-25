# MaX queries and transformations

This directory contains some of the queries and transformations written by Morgane Pica to interrogate the corpus via the project website, which uses [MaX](https://www.unicaen.fr/recherche/mrsh/document_numerique/outils/max), an XML display engine based on [BaseX](https://basex.org/) and developped at the Maison de la Recherche en Sciences Sociales in the University of Caen. Usually, these files work in XQuery-XSLT pairs, wearing the same names and different format suffixes.
They may be used outside of MaX, although the HTML results are fragments and therefore lack HTML root, header or footer. A slight adaptation of the XSLTs or a manual addition will remedy this.
Some of the external variables may also not work as they are originally memorized and returned by MaX.
 #### index_references
 This set produces an index of authors quoted in the books edited by the ConDÉ project. This index records both the names and dates of authors, orders them and sorts them alphabetically. It also records the sections of text containing an actual mention of the person.
 
 #### toc
 This set produces the list of the documents in the ConDÉ corpus and orders them chronologically.
 
 #### document_toc
 This set produces the actual table of contents of one book, based on the fact that it has at least two levels of divisions.