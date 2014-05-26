#!/usr/bin/perl -w
use utf8 ;

# Simple script to convert csv to html
# For input/outpus examples, see below.


print STDOUT "<html><body>\n";

while (<>) 
{
	chomp ;
	#      1a     2b       3c    4d      5e      6f    7g    8h       9i    10j       11k    12l       13m     14n      15o     16p      
	my ($lemma, $lemma2, $POS, $trans, $trans2, $var, $CG,  $syn, $ex1, $extrans1, $ex2, $extrans2, $ex3, $extrans3, $ex4, $extrans4) = split /\t/ ;
	print STDOUT "  <p>\n";
	print STDOUT "  <div style=\"margin-left:1.1em;text-indent:-1.1em\"><b>$lemma2 $POS $CG</b>\n";
	print STDOUT "    <i>$POS</i>\n";
	print STDOUT "     ▸ $trans $trans2\n";
	if ($var == '[а-я]+' ) {
	print STDOUT ";     ($var)\n";
	}
	print STDOUT "     <b><i>$CG</i></b> \n";
	print STDOUT "     (<i>$syn</i>) \n";
	print STDOUT "     <b>$ex1</b> $extrans1\n";
	print STDOUT "     <b>$ex2</b> $extrans2, \n";
	print STDOUT "     <b>$ex3</b> $extrans3, \n";
	print STDOUT "     <b>$ex4</b> $extrans4\n";
	print STDOUT "  </div>\n";
	print STDOUT "  </p>\n";
}

s/ ; \(\)//g;

print STDOUT "</body></html>\n";

#     1	По-русски (böjd)
#     2	По-русски (grundform)
#     3	(ordklass)
#     4	Са̄мас (böjd)
#     5	Са̄мас (grundform)
#     6	(varianter)
#     7	Stadieväxling
#     8	Ссылка (länk)
#     9	Пример на русском 1 (exempel Ru 1)
#    10	Пример са̄мас 1 (exempel Sa 1)
#    11	Пример на русском 2 (exempel Ru 2)
#    12	Пример са̄мас 2 (exempel Sa 2)
#    13	Пример на русском 3 (exempel Ru 3)
#    14	Пример са̄мас 3 (exempel Sa 3)
#    15	Пример на русском 4 (exempel Ru 4)
#    16	Пример са̄мас 4 (exempel Sa 4)

# Example input:
#
# се̄ййп_N_ANIMAL_хвост длинный, длинный хвост
# кӣдтжэва_N_ANIMAL, LIVING-PLACE_животное домашнее, домашнее животное
# оа̄к_N_ANIMAL_лосиха


#Target output:
#
#  <entry>
#    <lemma>на̄ввьт</lemma>
#    <pos class="N"/>
#    <translations>
#      <tr xml:lang="rus">животное домашнее</tr>
#      <tr xml:lang="rus">домашнее животное</tr>
#    </translations>
#    <semantics>
#      <sem class="ANIMAL"/>
#      <sem class="LIVING-PLACE"/>
#    </semantics>
#    <sources>
#      <book name="l1"/>
#    </sources>
#  </entry>
