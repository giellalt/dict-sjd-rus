This is a tmp dir containing the following files:

00_readme.txt
rus-sjd900.txt Micha's word list in kind of a rich text format
rus-sjd900.xml xml result
sjd-rus900.txt Micha's word list in kind of a rich text format
sjd-rus900.xml xml result
srtf2xml_sjd-rus.xsl script to transform the quasi-rtf into gt_xml

Todo:
 - compare the content of the rus-sjd900.txt/sjd-rus900.txt files with the content of the
   RuSaDict.xml/SaRuDict.xml (after transforing the later into gt_xml format). __Cip__
 - if needed merge the content of the transformed files pairwise __Cip__
 - check the extra infos from the quasi-rtf format (ask Micha what that means)
  Ex. from sjd-rus900.txt
       \textbf{е̄рркъя, е̄рркъенч} \hspace{0.2cm} старый, древний (прежний) \smallskip\\
  Ex. from rus-sjd900.txt
       \textbf{бабушка} (мать отца или матери) \hspace{0.2cm} оаххка, а̄ка \smallskip\\
       \textbf{бабушка} (старая женщина) \hspace{0.2cm} а̄кэнч, а̄ка \smallskip\\
       \textbf{барабан} (шаманский) \hspace{0.2cm} барабан \smallskip\\ 
 - add pos to both sjd and rus
 - add graphic variants

NB: If it IS the case that rus-sjd is just the inverse of sjd-rus, one should work only with
    one file!!!






