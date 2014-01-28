#!/usr/bin/perl -w
use utf8 ;

# Simple script to convert csv to xml
# For input/outpus examples, see below.


print STDOUT "<root>\n";

while (<>) 
{
	chomp ;
	my ($lemma, $rest) = split /\t/ ;
	print STDOUT "  <n v=\"$lemma\">\n";
	print STDOUT "    <w v=\"$lemma\">\n";
	print STDOUT "     <l>$lemma<s n=\"=\"/></l>\n";
	print STDOUT "     <r>$rest</r>\n";
	print STDOUT "    </w>\n";
	print STDOUT "  </n>\n";
}



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
