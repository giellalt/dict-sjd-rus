#!/usr/bin/perl -w
use utf8 ;

# Simple script to convert csv to html
# For input/outpus examples, see below.


print STDOUT "<html><body>\n";

while (<>) 
{
	chomp ;
	my ($lemma, $lemma2, $var, $CG, $POS, $trans, $trans2, $syn, $ex1, $extrans1, $ex2, $extrans2, $ex3, $extrans3, $ex4, $extrans4) = split /\t/ ;
	print STDOUT "  <p>\n";
	print STDOUT "  <div style=\"margin-left:1.1em;text-indent:-1.1em\"><b>$lemma $lemma2 $var $CG</b>\n";
	print STDOUT "    <i>$POS</i>\n";
	print STDOUT "     ▸ $trans $trans2;\n";
	print STDOUT "     <b>$syn $ex1</b> $extrans1\n";
	print STDOUT "     <b>$ex2</b> $extrans2\n";
	print STDOUT "     <b>$ex3</b> $extrans3\n";
	print STDOUT "  </div>\n";
	print STDOUT "  </p>\n";
}


print STDOUT "</body></html>\n";


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
