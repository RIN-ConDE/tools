# Modifying a lemmatised file

This folder contains a chain of scripts for each step of the correction process of the [ConDÉ corpus](https://github.com/RIN-ConDE/editions), from a raw lemmatised TEI-XML file to the synchronisation of corrected lemmas and part-of-speach information, with said TEI-XML file. The present scripts are derived from the [initial lemmatisation scripts](../lemmatize-new-witness). Some functions are completely identical, but have been copied into this folder to better differentiate their different use.

The current scripts are written for the ConDÉ project TEI schema, and are not meant to be universally applied to any TEI-XML file. However, being under a Creative Commons BY-NC 4.0 license, they may be forked and modified to suit your own needs, provided you respect these conditions:
```txt
Sharing and modification of the file is authorized, but you must give appropriate credit, provide a link to the license, and indicate if changes were made.  You may not use the material for commercial purposes. No further restrictions must be placed on the file.
```

Please also note that these files may later be modified to optimise and chain the process correctly. After this work, the "corpus-construction" folder may be organised differently.

### Included files by step number

* `NV_1_*` -> Script to re-number all `<w>` tokens within a TEI-XML file.
* `NV_2_*` -> Script to extract the contents of the `<w>` tokens into a CSV table.
* `NV_3_*` to `NV_6_*` -> Scripts allowing to resolve some hesitations on Analog's part. Each has a different target and takes advantage of its previous counterparts. They must be run in the order of their numbers to be most effective. Running them after some targetted manual corrections was, to us, an excellent way to boost the effectiveness of corrections.
* `NV_9_*` -> Script integrating the lemma and part-of-speach information obtained through the previous steps to the TEI-XML file given to the `NV_2_*` script used.