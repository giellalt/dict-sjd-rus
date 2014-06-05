
# Dette skal bli ei makefil for å lage sjdrus.fst, 
# ei fst-fil som tar sme og gjev ei fin-omsetjing.

# Førebels er det berre eit shellscript.

echo ""
echo ""
echo "---------------------------------------------------"
echo "Shellscript to make a transducer of the dictionary."
echo ""
echo "It writes a lexc file to bin, containing the line	 "
echo "LEXICON Root										 "
echo "Thereafter, it picks lemma and first translation	 "
echo "of the dictionary, adds them to this lexc file,	 "
echo "and compiles a transducer bin/sjdrus.fst		 "
echo ""
echo "Usage:"
echo "lookup bin/sjdrus.fst"
echo "---------------------------------------------------"
echo ""
echo ""

echo "LEXICON Root" > bin/sjdrus.lexc
cat src/*_sjdrus.xml | \
grep '^ *<[lt][ >]'  | \
sed 's/LEXICON/LX/g;'| \
sed 's/^ *//g;'      | \
sed 's/<l /™/g;'     | \
tr '\n' '£'          | \
sed 's/£™/€/g;'      | \
tr '€' '\n'          | \
tr '<' '>'           | \
cut -d'>' -f2,6      | \
tr '>' ':'           | \
tr ' ' '_'           | \
sed 's/$/ # ;/g;'    >> bin/sjdrus.lexc        

#xfst -e "read lexc < bin/sjdrus.lexc"

printf "read lexc < bin/sjdrus.lexc \n\
invert net \n\
save stack bin/sjdrus.fst \n\
quit \n" > tmpfile
xfst -utf8 < tmpfile
rm -f tmpfile
