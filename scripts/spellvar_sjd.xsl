<?xml version="1.0"?>
<!--+
    | Usage: java net.sf.saxon.Transform -it main THIS_FILE PARAM_NAME=PARAM_VALUE*
    +-->

<xsl:stylesheet version="2.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:local="nightbar"
		exclude-result-prefixes="xs local">

  <xsl:strip-space elements="*"/>
  <xsl:output method="xml"
	      omit-xml-declaration="no"
	      indent="yes"/>

  <xsl:function name="local:substring-before-if-contains" as="xs:string?">
    <xsl:param name="arg" as="xs:string?"/> 
    <xsl:param name="delim" as="xs:string"/> 
    
    <xsl:sequence select=" 
			  if (contains($arg,$delim))
			  then substring-before($arg,$delim)
			  else $arg
			  "/>
  </xsl:function>
  
  <xsl:function name="local:value-intersect" as="xs:anyAtomicType*">
    <xsl:param name="arg1" as="xs:anyAtomicType*"/> 
    <xsl:param name="arg2" as="xs:anyAtomicType*"/> 
    
    <xsl:sequence select=" 
			  distinct-values($arg1[.=$arg2])
			  "/>
  </xsl:function>

  <xsl:function name="local:value-except" as="xs:anyAtomicType*">
    <xsl:param name="arg1" as="xs:anyAtomicType*"/> 
    <xsl:param name="arg2" as="xs:anyAtomicType*"/> 
    
    <xsl:sequence select=" 
			  distinct-values($arg1[not(.=$arg2)])
			  "/>
  </xsl:function>
  
  <xsl:variable name="e" select="'xml'"/>
  <xsl:variable name="outputDir" select="'output'"/>
  <xsl:variable name="outFile" select="'sjd_spelling'"/>

  <xsl:variable name="tab" select="'&#x9;'"/>
  <xsl:variable name="nl" select="'&#xa;'"/>
  <xsl:variable name="xxx" select="'textbf'"/>
  <xsl:variable name="cbl" select="'{'"/>
  <xsl:variable name="cbr" select="'}'"/>
  <xsl:variable name="bsl" select="'\'"/>

  <!-- get input files -->
  <!-- These paths have to be adjusted accordingly -->
  <xsl:param name="file" select="'gogo'"/>
  
  <xsl:template match="/" name="main">
    
    <xsl:choose>
      <xsl:when test="doc-available($file)">

	<xsl:variable name="file_out" as="element()">
	  <r>
	    <xsl:copy-of select="doc($file)/r/@*"/>
	    <xsl:for-each select="doc($file)/r/e">
	      <e>
		<xsl:copy-of select="./@*"/>
		<lg>
		  <xsl:copy-of select="./lg/l"/>
		  <xsl:copy-of select="./lg/graph_var"/>
		  <xsl:variable name="gVar">
		    <var>
		      <xsl:call-template name="kur2aaa">
			<xsl:with-param name="lemma" select="normalize-space(./lg/l)"/>
		      </xsl:call-template>
		    </var>
		  </xsl:variable>
		  
		  <xsl:if test="not($gVar/var = '')">
		    <graph_var src="aaa">
		      <xsl:value-of select="$gVar"/>
		    </graph_var>
		  </xsl:if>
		</lg>
		<xsl:copy-of select="./mg"/>
	      </e>
	    </xsl:for-each>
	  </r>
	</xsl:variable>

	<xsl:result-document href="{$outputDir}/{$outFile}.{$e}">
	  <xsl:copy-of select="$file_out"/>
	</xsl:result-document>
	
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>Cannot locate: </xsl:text><xsl:value-of select="$file"/><xsl:text>&#xa;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="kur2aaa">
    <xsl:param name="lemma"/>

<!--
    <rules>
REGELN FÜR UMWANDLUNG DER GRAPHISCHEN VARIANTEN KUR (Kuruč 1985) __: AAA (=A.Antonovas Orthographie)
Beachte Reihenfolge!
1) stimmloses /j/
1a) jj_# __: хxь_# (=Buchstabenkombination jj im Wortauslaut wird ersetzt durch Buchstabenkombination хxь)
1b) j_# __: xь_# (=Buchstabe j im Wortauslaut wird ersetzt durch Buchstabenkombination хь)
1c) jj_C __: xь (=Buchstabenkombination jj vor einem der Buchstaben к, п, т, ц, ч wird ersetzt durch Buchstabenkombination xь)
1c) j_C __: й (=Buchstabe j vor einem der Buchstaben к, п, т, ц, ч wird ersetzt durch Buchstabenkombination xь)

2) Präaspiration
2a) һ_Cь_# __: ххь_C_# (=Buchstabe һ vor einem der Buchstaben к, п, т, ц, ч vor dem Buchstaben ь wird ersetzt durch Buchstabenkombination хxь; der Buchstabe ь im Wortauslaut wird gelöscht)
2b) һ_Cҍ_# __: ххь_C_# (=Buchstabe һ vor einem der Buchstaben к, п, т, ц, ч vor dem Buchstaben ҍ wird ersetzt durch Buchstabenkombination хxь; der Buchstabe ҍ im Wortauslaut wird gelöscht)
2c) һ_C_ё __: ххь_C_# (=Buchstabe һ vor einem der Buchstaben к, п, т, ц vor dem Buchstaben ё wird ersetzt durch Buchstabenkombination хxь; der Buchstabe ё> wird zum Buchstaben э)
2d) һ_C_е __: ххь_C_# (=Buchstabe һ vor einem der Buchstaben к, п, т, ц vor dem Buchstaben е wird ersetzt durch Buchstabenkombination хxь; der Buchstabe е wird zum Buchstaben э>)
******* der Rest müsste bei der Reihenfolge egal sein *******
2e) һ_C_я __: ххь_C__ (=Buchstabe һ vor einem der Buchstaben к, п, т, ц vor dem Buchstaben я wird ersetzt durch Buchstabenkombination хxь; der Buchstabe я wird zum Buchstaben а)
2f) һ_C_ӓ __: ххь_C__ (=Buchstabe һ vor einem der Buchstaben к, п, т, ц vor dem Buchstaben ӓ wird ersetzt durch Buchstabenkombination хxь; der Buchstabe ӓ wird zum Buchstaben а)
2g) һ_C_ю __: ххь_C__ (=Buchstabe һ vor einem der Buchstaben к, п, т, ц vor dem Buchstaben ю wird ersetzt durch Buchstabenkombination хxь; der Buchstabe ю wird zum Buchstaben у)
2h) һ_ч __: ххь_ч (=Buchstabe һ vor dem Buchstaben ч wird ersetzt durch Buchstabenkombination хxьч)
2i) һ_C __: ххь_C (=Buchstabe һ vor einem der Buchstaben к, п, т, ц wird ersetzt durch Buchstabenkombination хxь)


REGELN FÜR UMWANDLUNG DER GRAPHISCHEN VARIANTEN KUR (Kuruč 1995) __: AAA (=A.Antonovas Orthographie)
1) stimmloses /ҋ/
1a) ҋҋ_# __: хxь_# (=Buchstabenkombination ҋҋ im Wortauslaut wird ersetzt durch Buchstabenkombination хxь)
1b) ҋ_# __: xь_# (=Buchstabe ҋ im Wortauslaut wird ersetzt durch Buchstabenkombination хь)
1c) ҋҋC __: xь (=Buchstabenkombination ҋҋ+к, п, т, ц, ч wird ersetzt durch Buchstabenkombination xь)
1d) ҋC __: й (=Buchstabenkombination ҋ+к, п, т, ц, ч wird ersetzt durch Buchstabenkombination xь)

2) Präaspiration
2a) '_Cь_# __: ххь_C_# (=Buchstabe ' vor einem der Buchstaben к, п, т, ц, ч vor dem Buchstaben ь wird ersetzt durch Buchstabenkombination хxь; der Buchstabe ь im Wortauslaut wird gelöscht)
2b) '_Cҍ_# __: ххь_C_# (=Buchstabe ' vor einem der Buchstaben к, п, т, ц, ч vor dem Buchstaben ҍ wird ersetzt durch Buchstabenkombination хxь; der Buchstabe ҍ im Wortauslaut wird gelöscht)
2c) '_C_ё __: ххь_C__ (=Buchstabe ' vor einem der Buchstaben к, п, т, ц vor dem Buchstaben ё wird ersetzt durch Buchstabenkombination хxь; der Buchstabe ё wird zum Buchstaben э)
2d) '_C_е __: ххь_C__ (=Buchstabe ' vor einem der Buchstaben к, п, т, ц vor dem Buchstaben е wird ersetzt durch Buchstabenkombination хxь; der Buchstabe е wird zum Buchstaben э)
******* der Rest müsste bei der Reihenfolge egal sein: naja! ******* 
2e) '_C_я __: ххь_C__ (=Buchstabe ' vor einem der Buchstaben к, п, т, ц vor dem Buchstaben я wird ersetzt durch Buchstabenkombination хxь; der Buchstabe я wird zum Buchstaben а)
2f) '_C_ӓ __: ххь_C__ (=Buchstabe ' vor einem der Buchstaben к, п, т, ц vor dem Buchstaben ӓ wird ersetzt durch Buchstabenkombination хxь; der Buchstabe ӓ wird zum Buchstaben а)
2g) '_C_ю __: ххь_C__ (=Buchstabe ' vor einem der Buchstaben к, п, т, ц vor dem Buchstaben ю wird ersetzt durch Buchstabenkombination хxь; der Buchstabe ю wird zum Buchstaben у)
2h) '_ч __: ххь_ч (=Buchstabe ' vor dem Buchstaben ч wird ersetzt durch Buchstabenkombination хxьч)
2i) '_C __: ххь_C (=Buchstabe ' vor einem der Buchstaben к, п, т, ц wird ersetzt durch Buchstabenkombination хxь)

Beachte: 
ҋ und j sind graphische Varianten, in den aktuellen rusa-saru kommt nur ҋ vor, aber diese Regeln können wir auch für spätere Dokumente verwenden
һ und ' (Apostroph) sind graphische Varianten, in den aktuellen rusa-saru kommt nur һ vor, aber diese Regeln können wir auch für spätere Dokumente verwenden
    </rules>
-->

    <graph_variants>
    <!-- left side-->
    <xsl:variable name="r_j.j.END">^(.+)jj$</xsl:variable>
    
    <!-- right side-->
    <xsl:analyze-string select="$lemma" regex="$r_j.j.END">
      <xsl:matching-substring>
	<graph_var src="aaa">
	  <xsl:value-of select="concat(regex-group(1), 'ххь')"/>
	</graph_var>
      </xsl:matching-substring>
      <!--       <xsl:non-matching-substring> -->
      <!-- 	<xsl:value-of select="." /> -->
      <!--       </xsl:non-matching-substring> -->
    </xsl:analyze-string>
    
    <xsl:variable name="r_j.END">^(.+)j$</xsl:variable>
    <xsl:analyze-string select="$lemma" regex="$r_j.END">
      <xsl:matching-substring>
	<graph_var src="aaa">
	  <xsl:value-of select="concat(regex-group(1), 'хь')"/>
	</graph_var>
      </xsl:matching-substring>
    </xsl:analyze-string>
    
    <xsl:variable name="r_j.j.C">^(.*)jj([кптцч].*)$</xsl:variable>
    <xsl:analyze-string select="$lemma" regex="$r_j.j.C">
      <xsl:matching-substring>
	<graph_var src="aaa">
	  <xsl:value-of select="concat(regex-group(1), 'хь', regex-group(2))"/>
	</graph_var>
      </xsl:matching-substring>
    </xsl:analyze-string>
    
    <xsl:variable name="r_j.C">^(.*)j([кптцч].*)$</xsl:variable>
    <xsl:analyze-string select="$lemma" regex="$r_j.C">
      <xsl:matching-substring>
	<graph_var src="aaa">
	  <xsl:value-of select="concat(regex-group(1), 'ххь', regex-group(2))"/>
	</graph_var>
      </xsl:matching-substring>
    </xsl:analyze-string>

    <xsl:variable name="r_SHORT-I-TAIL.SHORT-I-TAIL.END">^(.+)ҋҋ$</xsl:variable>
    <xsl:analyze-string select="$lemma" regex="$r_SHORT-I-TAIL.SHORT-I-TAIL.END">
      <xsl:matching-substring>
	<graph_var src="aaa">
	  <xsl:value-of select="concat(regex-group(1), 'ххь')"/>
	</graph_var>
      </xsl:matching-substring>
    </xsl:analyze-string>
  
    <xsl:variable name="r_SHORT-I-TAIL.END">^(.+)ҋ$</xsl:variable>
    <xsl:analyze-string select="$lemma" regex="$r_SHORT-I-TAIL.END">
      <xsl:matching-substring>
	<graph_var src="aaa">
	  <xsl:value-of select="concat(regex-group(1), 'хь')"/>
	</graph_var>
      </xsl:matching-substring>
    </xsl:analyze-string>

    <xsl:variable name="r_SHORT-I-TAIL.SHORT-I-TAIL.C">^(.*)ҋҋ([кптцч].*)$</xsl:variable>
    <xsl:analyze-string select="$lemma" regex="$r_SHORT-I-TAIL.SHORT-I-TAIL.C">
      <xsl:matching-substring>
	<graph_var src="aaa">
	  <xsl:value-of select="concat(regex-group(1), 'хь', regex-group(2))"/>
	</graph_var>
      </xsl:matching-substring>
    </xsl:analyze-string>

    <xsl:variable name="r_SHORT-I-TAIL.C">^(.*)ҋ([кптцч].*)$</xsl:variable>
    <xsl:analyze-string select="$lemma" regex="$r_SHORT-I-TAIL.C">
      <xsl:matching-substring>
	<graph_var src="aaa">
	  <xsl:value-of select="concat(regex-group(1), 'ххь', regex-group(2))"/>
	</graph_var>
      </xsl:matching-substring>
    </xsl:analyze-string>


<!--
  
    <xsl:variable name="r_APO.C.SOFT-SIGN.END">^(.+)'([кптцч])ь$</xsl:variable>
    <xsl:variable name="r_APO.C.SEMI-SOFT-SIGN.END">^(.+)'([кптцч])ҍ$</xsl:variable>

    <xsl:variable name="r_SHHA.C.SOFT-SIGN.END">^(.+)һ([кптцч])ь$</xsl:variable>
    <xsl:variable name="r_SHHA.C.SEMI-SOFT-SIGN.END">^(.+)һ([кптцч])ҍ$</xsl:variable>

    <xsl:variable name="r_APO.C.IE-DIA">^(.*)'([кптцч])ё(.*)$</xsl:variable>
    <xsl:variable name="r_APO.C.IE">^(.*)'([кптцч])е(.*)$</xsl:variable>

    <xsl:variable name="r_SHHA.C.IE-DIA">^(.*)һ([кптцч])ё(.*)$</xsl:variable>
    <xsl:variable name="r_SHHA.C.IE-DIA">^(.*)һ([кптцч])е(.*)$</xsl:variable>

    <xsl:variable name="r_APO.C.YA">^(.*)'([кптцч])я(.*)$</xsl:variable>
    <xsl:variable name="r_APO.C.A-DIA">^(.*)'([кптцч])ӓ(.*)$</xsl:variable>
    <xsl:variable name="r_APO.C.YU">^(.*)'([кптцч])ю(.*)$</xsl:variable>
    <xsl:variable name="r_APO.CHE">^(.*)'(ч.*)$</xsl:variable>
    <xsl:variable name="r_APO.C">^(.*)'([кптцч])(.*)$</xsl:variable>

    <xsl:variable name="r_SHHA.C.YA">^(.*)һ([кптцч])я(.*)$</xsl:variable>
    <xsl:variable name="r_SHHA.C.A-DIA">^(.*)һ([кптцч])ӓ(.*)$</xsl:variable>
    <xsl:variable name="r_SHHA.C.YU">^(.*)һ([кптцч])ю(.*)$</xsl:variable>
    <xsl:variable name="r_SHHA.CHE">^(.*)һ(ч.*)$</xsl:variable>
    <xsl:variable name="r_SHHA.C">^(.*)һ([кптцч])(.*)$</xsl:variable>
-->
    </graph_variants>
  </xsl:template>
  
  
  
  <xsl:template name="combineIt">
    <xsl:param name="theInput"/>
    
    <xsl:variable name="allSpellings">
      <all>
	<xsl:copy-of select="$theInput/spellings/spv"/>
	<xsl:for-each select="$theInput/spellings/spv">
	  <spv>
	    <xsl:value-of select="translate(., 'æÆ', 'äÄ')"/>
	  </spv>
	</xsl:for-each>
	<xsl:for-each select="$theInput/spellings/spv">
	  <spv>
	    <xsl:value-of select="translate(., 'öÖ', 'øØ')"/>
	  </spv>
	</xsl:for-each>
	<xsl:for-each select="$theInput/spellings/spv">
	  <spv>
	    <xsl:value-of select="translate(., 'æÆöÖ', 'äÄøØ')"/>
	  </spv>
	</xsl:for-each>
      </all>
    </xsl:variable>
    
    <xsl:variable name="uniques" select="distinct-values($allSpellings/all/spv)"/>

    <!--     <out_spell> -->
    <!--       <xsl:copy-of select="$uniques"/> -->
    <!--     </out_spell> -->
    
    <xsl:for-each select="$uniques">
      <spv>
	<xsl:copy-of select="."/>
      </spv>
    </xsl:for-each>

  </xsl:template>
  
</xsl:stylesheet>
