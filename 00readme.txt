This directory contains material relevant to Kildin. The original files are in the info directory, while the src directory contains the data in gtdictionary format.

Some infos can be found here:
 
Куруч: Саамско-русский словарь
http://saamruss.narod.ru/

http://en.wikipedia.org/wiki/Windows-1251

==================================
Kildin Saami alphabet (sort order)
==================================
all possible (small) letters of all known alphabets are included
а а̄ ӓ б в г д е е̄ ё ё̄ ж з һ ' и ӣ й ј ҋ к л ӆ м ӎ н ӊ ӈ о о̄ ӧ п р ҏ с т у ӯ ӱ ф x ц ч ш ъ ы ы̄ ӹ ь ҍ э ӭ ю ю̄ я я̄   


====================
Building the dictionary:
====================
Here is the list of the attribute values for the attribute 'meta'
on the e-element in the xml files:

01 - this is the list of sjdoahpa lemmata that kindly have been corrected by native speaker A.A.Antonova via Elli
-orthography is A.A.Antonova's

02 - Michas Liste downloaded from MPI server
-The list from MPI is the basis of dict extention: the infos from the list in pseudo-rtf format should be incorporated gradually.
-orthography is Kuruč's

03 - short word list from Lazer kallsa moajjnas created by Micha, about somewhat more than 100 words
-the Unicode of Latin vs. Cyrillic is not yet checked
-orthography is Kuruč's

04 - short list of animal names and words related to animals collected by Andrey Dubovcev and Micha, somewhat more than 120 words
-please keep the class-attribute and the semantic info, even though it is incomplete and needs better structuring
-both orthographies (where already included in the imported Excel-chart)

05 - first try of restructering the Kurutch-file in GT-xml structure
- so far only very few lemmata (all words starting with д and ф)
- das Element <kur_ID> ist eine ID für jedes Lemma, dass in der Originaldatei enthalten war. Ich möchte es behalten, damit man das Wörterbuch eventuell später zu der Originaldatei zuordnen kann.
-das Element <stem>  zeigt den Stufenwechsel, so wie Kurutch ihn analysiert hat. Das ist in den meisten Fällen richtig. Ich will es erstmal behalten und später sehen, was ich damit machen kann.
-das Element <kur_class> zeigt Kurutchs Analyse der Flexionsklassen. Die ist in vielen Fällen nicht richtig. Aber ich will es erstmal behalten. Ich bin gerade dabei, einen eigene Analyse aller Flexionsklassen aufzuschreiben.
-das Element <LINK> zeigt die Grundform bei abgeleiteten Lemmata
-das Attribute nonceform="*" zeigt, dass dieses Wort einfach nur aus dem Russischen genommen ist. Diese Info ist nicht von Kurutch! Ich habe die Idee dafür aus einem anderen Wörterbuch.
-Es gibt zusätzlich zur alten sjdrus-Struktur eine Example-Gruppe und manchmal auch zusätzliche Kommentare zu den Übersetzungen. Es war mir dabei wichtig, dass ich keine Informationen aus der Originaldatei wegwerfe. Vieles muss aber noch besser strukturiert werden.

=====================
Unicode issues
=====================
always check:
combined vs. precomposed CYRILLIC LETTERS E, I, U WITH DIAERESIS
CYRILLIC SMALL LETTER SHHA (not Latin h)
Cyrillic vowels (not Lation ones)
CYRILLIC SMALL LETTER IO plus MACRON (not e plus diaresis plus macron)

=====================
Notes (MR)
=====================
possible problems in the list 01:
 -too many multi-word-expressions for Kildin head-words (e.g. non-lexicalized нызан олма, вӣллькесь роавас ча̄дзь)?
 -also perhaps too many multi-word-expressions for Russian translations?
 -some Kildin verbs are inconsequently translated with either the Russian perfective or imperfective verb (perhaps, the translation should always include both forms tagged as глаг.несв. and глаг.св. [or the like] respectively?)
 -we have to deal consistently with the meaning groups (in case of multiple translations)

 -some spelling variants could be unified (e.g. та̄ррьмъя : та̄ррмъя, е̄ммьнэ : е̄ммьне), but note that these are inconsistencies (mistakes?) in spelling which have nothing to do with the two competing orthographic variants!
 --MR: seems to be fixed already 
 -some Kildin adjectives are inconsequently translated with either the Russian attributive or predicative adjective (perhaps, the translation should always include both forms tagged as прилаг.опред. and прилаг.сказ. [or the like] respectively?)
 --MR: seems to be fixed already
 –several inflected forms (e.g. plural) occur as new entries (as lemmata on their own)
 --MR: seems to be fixed already
 
 
====================
POS mapping
====================
Preliminary list of PoS used in gtdict_sjdrus in Russian and English
This List will be extended during continuing work
Where should it live finally?
глаг.	verb
мест.	pronoun
нареч.	adverb
послел. postposition
предл.	preposition
прилаг.	adjective
прилаг.опред.	attributive adjective
прилаг.сказ.	predicative adjective
прич.	participle
част.	particle
числ.	numeral
числ.неопрeд. indefinite pronoun
с.	connector
сказ. predicate
собст.	proper noun
сущ.	noun

----------------
phrases, e.g.:
mwe._NP: сущ. сущ.
mwe._AP: нареч. прилаг.
mwe._VP: глаг. мест.
mwe._AdP: предл. мест.
----------------


=======================
nonceforms (Russian words for which a !recommended alternative Saami form exists), marked with asterisk like in:
<l src="kur" pos="сущ." nonceform="*">авгусст</l>
But perhaps we should find another convention here?



===========================================================
Orthography issues / Coping with different graphic variants
===========================================================
Value list of the attribute :
kur = Kuruč et al. 1985
aaa = A.A.Antonova

NB: Sjd Oahpa should be changed accordingly wrt. the different
spelling variation, too!

-src="kur" means "according to the orthographic principles of the 1985 dictionary" and concerns mainly the spelling of j and һ (obs! not all words with src="kur" in sjdrus are really listed in the 1985 dictionary)
-<graph_var src="aaa"> means "according to A.A.Antonova's own orthographic principles" and concerns mainly the spelling of йхх and хх (instead of j and һ) but often also other spellings different from both 1985 and (Kert's) 1986 dictionary
-<graph_var src="aaa"> can (hopefully) be derived automatically from src="kur" (see the rules below)
-all derivations aaa --> kur (which cannot be done automatically [because of underspecification]) have therefore by checked manually by Micha
-all entries missing an src="..." attribute have similar spellings in kur and aaa

-----------------
kur -> aaa mapping:
-----------------

REGELN FÜR UMWANDLUNG DER GRAPHISCHEN VARIANTEN KUR (Kuruč 1985) --> AAA (=A.Antonovas Orthographie)
Beachte Reihenfolge!
1) stimmloses /j/
1a) jj_# --> хxь_# (=Buchstabenkombination <jj> im Wortauslaut wird ersetzt durch Buchstabenkombination хxь)
1b) j_# --> xь_# (=Buchstabe <j> im Wortauslaut wird ersetzt durch Buchstabenkombination хь)
1c) jj_C --> xь (=Buchstabenkombination <jj> vor einem der Buchstaben <к, п, т, ц, ч> wird ersetzt durch Buchstabenkombination xь)
1c) j_C --> й (=Buchstabe <j> vor einem der Buchstaben <к, п, т, ц, ч> wird ersetzt durch Buchstabenkombination xь)

2) Präaspiration
2a) һ_Cь_# --> ххь_C_# (=Buchstabe <һ> vor einem der Buchstaben <к, п, т, ц, ч> vor dem Buchstaben <ь> wird ersetzt durch Buchstabenkombination <хxь>; der Buchstabe <ь> im Wortauslaut wird gelöscht)
2b) һ_Cҍ_# --> ххь_C_# (=Buchstabe <һ> vor einem der Buchstaben <к, п, т, ц, ч> vor dem Buchstaben <ҍ> wird ersetzt durch Buchstabenkombination <хxь>; der Buchstabe <ҍ> im Wortauslaut wird gelöscht)
2d) һ_C_ё --> ххь_C__ (=Buchstabe <һ> vor einem der Buchstaben <к, п, т, ц> vor dem Buchstaben <ё> wird ersetzt durch Buchstabenkombination <хxь>; der Buchstabe <ё> wird zum Buchstaben <э>)
2c) һ_C_е --> ххь_C__ (=Buchstabe <һ> vor einem der Buchstaben <к, п, т, ц> vor dem Buchstaben <е> wird ersetzt durch Buchstabenkombination <хxь>; der Buchstabe <е> wird zum Buchstaben <э>)
******* der Rest müsste bei der Reihenfolge egal sein ******* 
2e) һ_C_я --> ххь_C_# (=Buchstabe <һ> vor einem der Buchstaben <к, п, т, ц> vor dem Buchstaben <я> wird ersetzt durch Buchstabenkombination <хxь>; der Buchstabe <я> wird zum Buchstaben <а>)
2f) һ_C_ӓ --> ххь_C_# (=Buchstabe <һ> vor einem der Buchstaben <к, п, т, ц> vor dem Buchstaben <ӓ> wird ersetzt durch Buchstabenkombination <хxь>; der Buchstabe <ӓ> wird zum Buchstaben <а>)
2g) һ_C_ю --> ххь_C_# (=Buchstabe <һ> vor einem der Buchstaben <к, п, т, ц> vor dem Buchstaben <ю> wird ersetzt durch Buchstabenkombination хxь; der Buchstabe <ю> wird zum Buchstaben <у>)
2h) һ_ч --> ххь_ч (=Buchstabe <һ> vor dem Buchstaben <ч> wird ersetzt durch Buchstabenkombination <хxьч>)
2i) һ_C --> ххь_C (=Buchstabe <һ> vor einem der Buchstaben <к, п, т, ц> wird ersetzt durch Buchstabenkombination <хxь>)


REGELN FÜR UMWANDLUNG DER GRAPHISCHEN VARIANTEN KUR (Kuruč 1995) --> AAA (=A.Antonovas Orthographie)
1) stimmloses /ҋ/
1a) ҋҋ_# --> хxь_# (=Buchstabenkombination <ҋҋ> im Wortauslaut wird ersetzt durch Buchstabenkombination хxь)
1b) ҋ_# --> xь_# (=Buchstabe <ҋ> im Wortauslaut wird ersetzt durch Buchstabenkombination хь)
1c) ҋҋC --> xь (=Buchstabenkombination <ҋҋ>+<к, п, т, ц, ч> wird ersetzt durch Buchstabenkombination xь)
1d) ҋC --> й (=Buchstabenkombination <ҋ>+<к, п, т, ц, ч> wird ersetzt durch Buchstabenkombination xь)

2) Präaspiration
2a) '_Cь_# --> ххь_C_# (=Buchstabe <'> vor einem der Buchstaben <к, п, т, ц, ч> vor dem Buchstaben <ь> wird ersetzt durch Buchstabenkombination <хxь>; der Buchstabe <ь> im Wortauslaut wird gelöscht)
2b) '_Cҍ_# --> ххь_C_# (=Buchstabe <'> vor einem der Buchstaben <к, п, т, ц, ч> vor dem Buchstaben <ҍ> wird ersetzt durch Buchstabenkombination <хxь>; der Buchstabe <ҍ> im Wortauslaut wird gelöscht)
2d) '_C_ё --> ххь_C__ (=Buchstabe <'> vor einem der Buchstaben <к, п, т, ц> vor dem Buchstaben <ё> wird ersetzt durch Buchstabenkombination <хxь>; der Buchstabe <ё> wird zum Buchstaben <э>)
2c) '_C_е --> ххь_C__ (=Buchstabe <'> vor einem der Buchstaben <к, п, т, ц> vor dem Buchstaben <е> wird ersetzt durch Buchstabenkombination <хxь>; der Buchstabe <е> wird zum Buchstaben <э>)
******* der Rest müsste bei der Reihenfolge egal sein @cip: stimmt nicht ganz!*******  
2e) '_C_я --> ххь_C_# (=Buchstabe <'> vor einem der Buchstaben <к, п, т, ц> vor dem Buchstaben <я> wird ersetzt durch Buchstabenkombination <хxь>; der Buchstabe <я> wird zum Buchstaben <а>)
2f) '_C_ӓ --> ххь_C_# (=Buchstabe <'> vor einem der Buchstaben <к, п, т, ц> vor dem Buchstaben <ӓ> wird ersetzt durch Buchstabenkombination <хxь>; der Buchstabe <ӓ> wird zum Buchstaben <а>)
2g) '_C_ю --> ххь_C_# (=Buchstabe <'> vor einem der Buchstaben <к, п, т, ц> vor dem Buchstaben <ю> wird ersetzt durch Buchstabenkombination <хxь>; der Buchstabe <ю> wird zum Buchstaben <у>)
2h) '_ч --> ххь_ч (=Buchstabe <'> vor dem Buchstaben <ч> wird ersetzt durch Buchstabenkombination <хxьч>)
2i) '_C --> ххь_C (=Buchstabe <'> vor einem der Buchstaben <к, п, т, ц> wird ersetzt durch Buchstabenkombination <хxь>)

Beachte: 
ҋ und j sind graphische Varianten, in den aktuellen rusa-saru kommt nur ҋ vor, aber diese Regeln können wir auch für spätere Dokumente verwenden
һ und ' (Apostroph) sind graphische Varianten, in den aktuellen rusa-saru kommt nur һ vor, aber diese Regeln können wir auch für spätere Dokumente verwenden

-----------------
aaa-> kur mapping:
-----------------
This question is answered now: This mapping is not possible due to underspecification!

-----------------------------
Sorting entries in the files:
-----------------------------
1.
Using the parametrized script from the gtsvn/words/dicts/script (alphabetical sorting of lemmata according to the
alphabet of the language used as parameter):

from the gtsvn/words/dicts/sjdrus/src:
xsltproc --param sortlang 'ru' ../../scripts/sort-dict.xsl sjdrus_mpi.xml > sorted_sjdrus_mpi.xml

@cip added the sorted file for Michal to check the correctnes (sorted using Russian!!!)
@cip: When looking only at the first and the last entries, I got a weird feeling.

2.
sorting by pos (@cip hast to write a small script)

3.
sorting by some other info (meta01, etc.): see 2.!



XML-Securitatea schägt zu: Please correct!
===================================
grep '>=' gtdict_sjdrus.xml 
			<stem>=</stem>
			<stem>=</stem>
			<stem>=</stem>
			<stem>=</stem>
			<stem>=</stem>
			<stem>=</stem>
			<stem>=</stem>
			<stem>=</stem>
			<stem>=</stem>
			<stem>=</stem>
			<stem>=</stem>
			<stem>=</stem>
			<stem>=</stem>
			<stem>=</stem>
			<stem>=</stem>
			<stem>=</stem>
			<kur_flex class="V">=</kur_flex>
			<kur_flex class="V">=</kur_flex>
			<kur_flex class="V">=</kur_flex>
===================================
