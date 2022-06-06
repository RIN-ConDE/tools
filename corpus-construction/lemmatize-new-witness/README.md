# Lemmatising new tokens

This folder contains a chain of scripts for each step of the inital lemmatisation process of the [ConDÉ corpus](https://github.com/RIN-ConDE/editions), from a tokenised TEI-XML file to the synchronisation of lemmas and part-of-speach information produced by Analog, with said TEI-XML file.

The aim is, therefore, to transform the `<w>` elements from this:
```xml
<w>La</w>
<w>Coutume</w>
<w>de</w>
<w>Normandie</w>
```
...to this:
```xml
<w lemma="LE" pos="Da" n="1">La</w>
<w lemma="COUTUME" pos="Nc" n="2">Coutume</w>
<w lemma="DE" pos="S" n="3">de</w>
<w lemma="NORMANDIE" pos="Np" n="4">Normandie</w>
```

The current scripts are written for the ConDÉ project TEI schema, and are not meant to be universally applied to any TEI-XML file. However, being under a Creative Commons BY-NC 4.0 license, they may be forked and modified to suit your own needs, provided you respect these conditions:
```txt
Sharing and modification of the file is authorized, but you must give appropriate credit, provide a link to the license, and indicate if changes were made.  You may not use the material for commercial purposes. No further restrictions must be placed on the file.
```

Please also note that these files may later be modified to optimise and chain the process correctly. After this work, the "corpus-construction" folder may be organised differently.

### Included files by step number

* `NV_1_*` -> Script to number all `<w>` tokens within a TEI-XML file.
* `NV_2_*` -> Scripts to extract the contents of the `<w>` tokens into a CSV table. This is the file which will be given to the lemmatiser Analog.
* `NV_3_*` -> Script to convert the table resulting from the automatic analysis by Analog, which has one column by available part-of-speach, into an XML-compatible format which can be implemented as attribute values.
* `NV_4_*` to `NV_8_*` -> Scripts allowing to resolve some hesitations on Analog's part. Each has a different target and takes advantage of its previous counterparts. They must be run in the order of their numbers to be most effective.
* `NV_9_*` -> Script integrating the lemma and part-of-speach information obtained through the previous steps to the TEI-XML file given to the `NV_2_*` script used.