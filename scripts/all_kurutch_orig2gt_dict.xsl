<?xml version="1.0"?>
<!--+
    | Usage: java net.sf.saxon.Transform -it main THIS_FILE PARAM_NAME=PARAM_VALUE*
    | NB: Now, a name for the output file is needed!
    | @cip's command: _sax scripts/all_kurutch_orig2gt_dict.xsl > kurutsch_interim.xml
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
  
  <xsl:function name="local:substring-after-if-contains" as="xs:string?">
    <xsl:param name="arg" as="xs:string?"/> 
    <xsl:param name="delim" as="xs:string"/> 
    <xsl:sequence select=" 
			  if (contains($arg,$delim))
			  then substring-after($arg,$delim)
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
  <xsl:variable name="outDir" select="'out_kt2gt'"/>
  <xsl:variable name="debug" select="true()"/>

  <xsl:variable name="tab" select="'&#x9;'"/>
  <xsl:variable name="nl" select="'&#xa;'"/>
  <xsl:variable name="xxx" select="'textbf'"/>
  <xsl:variable name="cbl" select="'{'"/>
  <xsl:variable name="cbr" select="'}'"/>
  <xsl:variable name="bsl" select="'\'"/>
  <!-- helper for kurutsch inflection class -->
  <xsl:variable name="class" select="'IIIV'"/>
  <xsl:variable name="ablaut" select="'1234'"/>
  <xsl:variable name="grad" select="'*'"/>


  <!-- get input dir -->
  <!-- These paths have to be adjusted accordingly -->
  <xsl:param name="inDir" select="'../inc/kurutch'"/>
  <!--   <xsl:variable name="file_name" select="substring-before((tokenize($file, '/'))[last()], '.xml')"/> -->
  
  <xsl:template match="/" name="main">
    
    <xsl:variable name="e_link_ot" as="element()">
      <lot_entries>
	<xsl:attribute name="ot_counter">
	  <xsl:value-of select="count(collection(concat($inDir, '?select=*.xml'))/r/E[T/LINK/@TYPE ='OT'])"/>
	</xsl:attribute>
	<xsl:for-each select="collection(concat($inDir, '?select=*.xml'))/r/E[T/LINK/@TYPE ='OT']">
	  <e>
	    <xsl:copy-of select="./@*"/>
	    <xsl:attribute name="link_ot">
	      <xsl:value-of select="count(./T/LINK[./@TYPE ='OT'])"/>
	    </xsl:attribute>
	    <xsl:attribute name="link_sm">
	      <xsl:value-of select="count(./T/LINK[./@TYPE ='SM'])"/>
	    </xsl:attribute>
	    
	    <!-- quick, grep-friendly test: not only for 'non-programmers' -->
	    
	    <xsl:message terminate="no">
	      <xsl:value-of select="concat('.......................................................', $nl)"/>
	      <xsl:value-of select="concat('OT entry kur_ID: ', ./@kur_ID, ' LINK counter ', count(./T), $nl)"/>
	      <xsl:value-of select="'.......................................................'"/>
	    </xsl:message>

	    <merge_target t_count="{count(./T)}">
	      <xsl:for-each select="./T">
		<xsl:if test="$debug">
		  <xsl:call-template name="check_merge_target">
		    <xsl:with-param name="theLink" select="./LINK"/>
		  </xsl:call-template>
		</xsl:if>
	      </xsl:for-each>
	    </merge_target>
	    
	    <xsl:if test="not($debug)">
	      <xsl:call-template name="flatten_node">
		<xsl:with-param name="theNode" select="."/>
		<xsl:with-param name="theTag" select="'ot'"/>
	      </xsl:call-template>
	    </xsl:if>

	    <!-- <xsl:copy-of select="./*"/> -->
	    <!-- don't copy, lower-case it for the moment -->
	    <!-- I keep this just for debugging purposes -->

	    <xsl:for-each select="./*">
	      <xsl:call-template name="lower-case_node">
		<xsl:with-param name="theNode" select="."/>
	      </xsl:call-template>
	    </xsl:for-each>
	  </e>
	</xsl:for-each>
      </lot_entries>
    </xsl:variable>
    
    <xsl:variable name="e_link_sm" as="element()">
      <lsm_entries>
	<xsl:attribute name="sm_counter">
	  <xsl:value-of select="count(collection(concat($inDir, '?select=*.xml'))/r/E[T/LINK/@TYPE ='SM'])"/>
	</xsl:attribute>
	<xsl:for-each select="collection(concat($inDir, '?select=*.xml'))/r/E[T/LINK/@TYPE ='SM']">
	  <E>
	    <xsl:copy-of select="./@*"/>
	    <xsl:attribute name="link_sm">
	      <xsl:value-of select="count(./T/LINK[./@TYPE ='SM'])"/>
	    </xsl:attribute>
	    <xsl:attribute name="link_ot">
	      <xsl:value-of select="count(./T/LINK[./@TYPE ='OT'])"/>
	    </xsl:attribute>
	    
	    <!-- quick, grep-friendly test: not only for 'non-programmers' -->
	    <xsl:if test="$debug">
	      <xsl:call-template name="flatten_node">
		<xsl:with-param name="theNode" select="."/>
		<xsl:with-param name="theTag" select="'sm'"/>
	      </xsl:call-template>
	    </xsl:if>
	    
	    <xsl:copy-of select="./*"/>
	  </E>
	</xsl:for-each>
      </lsm_entries>
    </xsl:variable>
    
    <r xml:lang="sjd">
      <!-- number of entries without any LINK element -->
      <xsl:attribute name="no-link_e">
	<xsl:value-of select="count(collection(concat($inDir, '?select=*.xml'))/r/E[not(T/LINK/@TYPE ='OT')][not(T/LINK/@TYPE ='SM')])"/>
      </xsl:attribute>
      
      <!-- number of entries with LINK OT -->
      <xsl:attribute name="ot_e">
	<xsl:value-of select="count(collection(concat($inDir, '?select=*.xml'))/r/E[T/LINK/@TYPE ='OT'])"/>
      </xsl:attribute>
      
      <!-- number of entries with LINK SM -->
      <xsl:attribute name="sm_e">
	<xsl:value-of select="count(collection(concat($inDir, '?select=*.xml'))/r/E[T/LINK/@TYPE ='SM'])"/>
      </xsl:attribute>
      
      <xsl:for-each select="collection(concat($inDir, '?select=*.xml'))/r/E[not(T/LINK/@TYPE ='OT')][not(T/LINK/@TYPE ='SM')]">
	<xsl:if test="true()">
	  <xsl:message terminate="no">
	    <xsl:value-of select="concat('-----------------------------------------', $nl)"/>
	    <xsl:value-of select="concat('entry kur_ID: ', ./@kur_ID, $nl)"/>
	    <xsl:value-of select="'-----------------------------------------'"/>
	  </xsl:message>
	</xsl:if>
	<e>
	  <xsl:copy-of select="./@*"/>
	  <xsl:if test="not(./@kur_ID)">
	    <!-- some default before merging -->
	    <xsl:attribute name="kur_ID">
	      <xsl:value-of select="'xxx'"/>
	    </xsl:attribute>
	  </xsl:if>
	  <xsl:variable name="current_l" select="lower-case(./L)"/>
	  <lg>
	    <l>
	      <xsl:variable name="current_pos">
		<xsl:if test="./POS and not(./POS = '')">
		  <xsl:value-of select="./POS"/>
		</xsl:if>
		<xsl:if test="not(./POS) or (./POS = '')">
		  <xsl:value-of select="if (ends-with($current_l, 'ельт') 
					or ends-with($current_l, 'эльт')
					or ends-with($current_l, 'ӭльт')
					or ends-with($current_l, 'енне')
					or ends-with($current_l, 'алт')
					or ends-with($current_l, 'ханна')
					or ends-with($current_l, 'энне')) then 'adv' else
					if (ends-with($current_l, 'мушш')
					or ends-with($current_l, 'мусс')
					or ends-with($current_l, 'пе̄лль')
					or ends-with($current_l, 'егк')
					or ends-with($current_l, 'эгк')
					or ends-with($current_l, 'ӭгк')
					or ends-with($current_l, 'енч')
					or ends-with($current_l, 'энч')
					or ends-with($current_l, 'ӭнч')
					or ends-with($current_l, 'вудт')
					or ends-with($current_l, 'хэсс')) then 'n' else
					if (ends-with($current_l, 'хэмь')
					or ends-with($current_l, 'ай')) then 'a' else
					if (ends-with($current_l, 'юввэ')
					or ends-with($current_l, 'уввэ')
					or ends-with($current_l, 'увнэ')
					or ends-with($current_l, 'енне')
					or ends-with($current_l, 'эллэ')
					or ends-with($current_l, 'элнэ')
					or ends-with($current_l, 'южнэ')
					or ends-with($current_l, 'южсэ')
					or ends-with($current_l, 'ужнэ')
					or ends-with($current_l, 'ужсэ')
					or ends-with($current_l, 'яһтӭ')
					or ends-with($current_l, 'юшшэ')
					or ends-with($current_l, 'аһтӭ')
					or ends-with($current_l, 'ушшэ')
					or ends-with($current_l, 'эннтэ')
					or ends-with($current_l, 'еннтэ')
					or ends-with($current_l, 'эдтэ')
					or ends-with($current_l, 'eдтэ')
					or ends-with($current_l, 'ънэ')
					or ends-with($current_l, 'ъе')
					or ends-with($current_l, 'ассьтэ')
					or ends-with($current_l, 'ювнэ')) then 'v' else
					if ((./DER[(./@type = 'STRAD_K') 
					or (./@type = 'PONUD_K')])
					or (./T/RE = '___UNPERS___') 
					or (./T/TAM)
					or contains(., '*')) then 'v' else
					if (contains(., '_GENDER') 
					or contains(., '_NUMBER')
					or (./STEM)) then 'n' else
					'xxx'"/>
		  
		</xsl:if>
	      </xsl:variable>
	      
	      <xsl:attribute name="pos">
		<xsl:value-of select="$current_pos"/>
	      </xsl:attribute>
	      <xsl:value-of select="$current_l"/>
	    </l>

	    <xsl:variable name="ot_result">
	      <xsl:call-template name="check_merge_ot_source">
		<xsl:with-param name="theEntry" select="."/>
	      </xsl:call-template>
	    </xsl:variable>
	    
	    <!-- this is to prepare the merging -->
	    <xsl:if test="$debug">
	      <xsl:copy-of select="$ot_result"/>
	    </xsl:if>
	    
	    <!-- a pos-test for verbs is needed here to account for the specification from the kurutsch-todo file -->

	    <xsl:if test="not(normalize-space(./STEM/text()) = '') or not(normalize-space(./CLASS/text()) = '')">
	      <infl>
		<xsl:if test="normalize-space(./STEM/text()) = ''">
		  <only_ot_kur_stem>
		    <xsl:attribute name="kur_ID">
		      <xsl:value-of select="$ot_result/ot_kur_stem/source/@kur_ID"/>
		    </xsl:attribute>
		    <xsl:value-of select="$ot_result/ot_kur_stem/source"/>
		  </only_ot_kur_stem>
		</xsl:if>
		<xsl:if test="not(normalize-space(./STEM/text()) = '')">
		  <xsl:if test="$ot_result/ot_kur_stem/source">
		    
		    <xsl:if test="$ot_result/ot_kur_stem/source = lower-case(normalize-space(./STEM/text()))">
		      <kur_stem case="nom" number="pl">
			<xsl:attribute name="kur_ID">
			  <xsl:value-of select="$ot_result/ot_kur_stem/source/@kur_ID"/>
			</xsl:attribute>
			<xsl:value-of select="lower-case(normalize-space(./STEM/text()))"/>
		      </kur_stem>
		    </xsl:if>
		    
		    <xsl:if test="not($ot_result/ot_kur_stem/source = lower-case(normalize-space(./STEM/text())))">
		      <ot_kur_stem case="nom" number="pl">
			<xsl:attribute name="kur_ID">
			  <xsl:value-of select="$ot_result/ot_kur_stem/source/@kur_ID"/>
			</xsl:attribute>
			<xsl:value-of select="lower-case(normalize-space(./STEM/text()))"/>
		      </ot_kur_stem>
		      <kur_stem kur_ID="xxx_conflict_xxx" case="nom" number="pl">
			<xsl:value-of select="lower-case(normalize-space(./STEM/text()))"/>
		      </kur_stem>
		    </xsl:if>
		  </xsl:if>
		  
		  <xsl:if test="not($ot_result/ot_kur_stem/source)">
		    <kur_stem kur_ID="xxx" case="nom" number="pl">
		      <xsl:value-of select="lower-case(normalize-space(./STEM/text()))"/>
		    </kur_stem>
		  </xsl:if>
		  
		</xsl:if>
		<xsl:if test="not(normalize-space(./CLASS/text()) = '')">
		  <!-- mark not found value with '_x_' -->
		  <xsl:variable name="cls" select="normalize-space(./CLASS/text())"/>
		  <kur_infl>
		    <xsl:attribute name="class">
		      <xsl:if test="contains($cls, ',')">
			<xsl:value-of select="local:substring-before-if-contains(substring-before($cls, ','), $grad)"/>
		      </xsl:if>
		      <xsl:if test="not(contains($cls, ','))">
			<xsl:value-of select="if (contains($class, $cls)) then $cls else '_x_'"/>
		      </xsl:if>
		    </xsl:attribute>
		    <xsl:attribute name="ablaut">
		      <xsl:if test="contains($cls, ',')">
			<xsl:value-of select="local:substring-before-if-contains(substring-after($cls, ','), $grad)"/>
		      </xsl:if>
		      <xsl:if test="not(contains($cls, ','))">
			<xsl:value-of select="if (contains($ablaut, $cls)) then $cls else '_x_'"/>
		      </xsl:if>
		    </xsl:attribute>
		    <xsl:attribute name="special">
		      <xsl:value-of select="if (contains($cls, $grad)) then $grad else '_x_'"/>
		    </xsl:attribute>
		  </kur_infl>
		</xsl:if>
	      </infl>
	    </xsl:if>
	  </lg>
	  
	  <xsl:if test="./*[(local-name() = 'DER') or (local-name() = 'COMPARE')]">
	    <pointers>
	      <xsl:for-each select="./*[(local-name() = 'DER') or (local-name() = 'COMPARE')]">
		<xsl:element name="{lower-case(local-name(.))}">
		  <xsl:copy-of select="./@*"/>
		  <xsl:copy-of select="normalize-space(lower-case(.))"/>
		</xsl:element>
	      </xsl:for-each>
	    </pointers>
	  </xsl:if>
	  
	  <xsl:for-each select="./T">
	    <mg>
	      <!-- marking Kurutch meaning groups
		   explicitly. Who knows when this would be needed?
	      -->
	      <!-- km means "source of mg is Kurutch"; km="g"
		   means "Kurutch entry has only one meaning";
		   km="g1" means "Kurutch entry has more than
		   one meaning and this is the first one"; etc.
	      -->
	      <xsl:if test="not(./@tnumber)">
		<xsl:attribute name="km">
		  <xsl:value-of select="'g'"/>
		</xsl:attribute>
	      </xsl:if>
	      <xsl:if test="./@tnumber">
		<xsl:attribute name="km">
		  <xsl:value-of select="concat('g', ./@tnumber)"/>
		</xsl:attribute>
	      </xsl:if>
	      
	      <!-- as agreed with Michael, semantic types, re and tam have as scope the whole mg -->
	      <!-- which is more understandable: meaning = semantics -->
	      <semantics>
		<stype>
		  <xsl:value-of select="if (child::*/local-name() = 'SEM') then lower-case(child::SEM) else 'xxx'"/>
		</stype>
	      </semantics>
	      
	      <xsl:for-each select="./*[not(local-name() = 'SEM')][not(local-name() = 'LINK')]">
		<xsl:element name="{lower-case(local-name(.))}">
		  <xsl:copy-of select="./@*"/>
		  <xsl:copy-of select="normalize-space(lower-case(.))"/>
		</xsl:element>
	      </xsl:for-each>
	      
	      <!-- T is empty -->
	      <xsl:if test="count(./node()) = 0">
		<tg>
		  <t>
		    <!-- this should be checked -->
		    <xsl:value-of select="'xxx___xxx'"/>
		  </t>
		</tg>
	      </xsl:if>
	      
	      <!-- T has only one child of type element -->
	      <xsl:if test="(count(child::*) = 1) and not(child::text())">
		<!-- which is LINK: take it! -->
		<tg>
		  <xsl:if test="child::*/local-name() = 'LINK'">
		    <t>
		      <xsl:attribute name="link_type">
			<xsl:value-of select="if (./LINK/@type) then ./LINK/@type
					      else if (./LINK/@TYPE) then ./LINK/@TYPE
					      else 'xxx'"/>
		      </xsl:attribute>
		      <xsl:value-of select="normalize-space(./LINK)"/>
		    </t>
		  </xsl:if>
		  <!-- else ... just for the sake of robustness --> 
		  <xsl:if test="not(child::*/local-name() = 'LINK')">
		    <t unknown_elem="xxx"/>
		    <xsl:copy-of select="child::*"/>
		  </xsl:if>
		</tg>
	      </xsl:if>
	      
	      <!-- T has some text node as child -->
	      <xsl:if test="child::text()">
		
		<xsl:if test="not($debug)">
		  <xsl:variable name="pattern">
		    <xsl:for-each select="./node()">
		      <xsl:if test="self::text()">
			<xsl:value-of select="concat('txtX', count(tokenize(normalize-space(self::text()), ';')))"/>
		      </xsl:if>
		      <xsl:if test="self::*">
			<xsl:value-of select="lower-case(local-name(.))"/>
		      </xsl:if>
		      <xsl:if test="not(position() = last())">
			<xsl:value-of select="'_'"/>
		      </xsl:if>
		    </xsl:for-each>
		  </xsl:variable>
		  <todo>
		    <xsl:attribute name="stamp">
		      <xsl:value-of select="$pattern"/>
		    </xsl:attribute>
		    
		    <xsl:for-each select="./node()">
		      <node>
			<xsl:if test="self::text()">
			  <xsl:attribute name="ntype">
			    <xsl:value-of select="'txt'"/>
			  </xsl:attribute>
			  <xsl:copy-of select="normalize-space(.)"/>
			</xsl:if>
			<xsl:if test="self::*">
			  <xsl:attribute name="ntype">
			    <xsl:value-of select="lower-case(local-name(.))"/>
			  </xsl:attribute>
			  <xsl:copy-of select="normalize-space(lower-case(.))"/>
			</xsl:if>
		      </node>
		    </xsl:for-each>
		  </todo>
		</xsl:if>
		
		<xsl:for-each select="child::text()">
		  <!-- here: to refine it wrt. LINK-elements mixed T-elements -->
		  <xsl:for-each select="tokenize(., ';')">
		    <tg>
		      <xsl:for-each select="tokenize(., ',')">
			<!-- processing brackets -->
			<!-- 			      <xsl:if test="contains(., '(')"> -->
			<!-- 				<xsl:variable name="bracket" select=""/> -->
			<!-- 			      </xsl:if> -->
			
			<t>
			  <xsl:value-of select="normalize-space(.)"/>
			</t>
		      </xsl:for-each>
		    </tg>
		  </xsl:for-each>
		</xsl:for-each>
	      </xsl:if>
	      
	      <xsl:if test="following-sibling::X">
		<xsl:variable name="exs">
		  <ex_group>
		    <xsl:for-each select="following-sibling::node()[generate-id(preceding-sibling::T[1])=
					  generate-id(current())][not(local-name() = 'T')]">
		      
		      <!-- 		    <xsl:for-each select="following-sibling::*[generate-id(preceding-sibling::T[1])= -->
		      <!-- 					  generate-id(current())][starts-with(local-name(), 'X')]"> -->
		      
		      
		      <xsl:if test="self::*">
			<xsl:element name="{lower-case(local-name(.))}">
			  <xsl:copy-of select="./@*"/>
			  <xsl:copy-of select="normalize-space(lower-case(.))"/>
			</xsl:element>
		      </xsl:if>
		      
		      <xsl:if test="self::text()">
			<idiom_boundary>
			  <xsl:value-of select="normalize-space(.)"/>
			</idiom_boundary>
		      </xsl:if>
		    </xsl:for-each>
		  </ex_group>
		</xsl:variable>
		
		<xsl:if test="$exs/ex_group/idiom_boundary">
		  <xsl:for-each select="$exs/ex_group/idiom_boundary/preceding-sibling::x">
		    <xg>
		      <xsl:attribute name="type">
			<xsl:if test="ends-with(. , '!') or ends-with(., '?')">
			  <xsl:value-of select="'sentence'"/>
			</xsl:if>
			<xsl:if test="not(ends-with(. , '!') or ends-with(., '?'))">
			  <xsl:value-of select="'xxx'"/>
			</xsl:if>
		      </xsl:attribute>
		      <xsl:copy-of select="."/>
		      <xsl:copy-of select="following-sibling::xt[1]"/>
		    </xg>
		  </xsl:for-each>
		  
		  <xsl:for-each select="$exs/ex_group/idiom_boundary/following-sibling::x">
		    <xg type="idiom">
		      <xsl:copy-of select="."/>
		      <xsl:copy-of select="following-sibling::xt[1]"/>
		    </xg>
		  </xsl:for-each>
		</xsl:if>
		
		<xsl:if test="not($exs/ex_group/idiom_boundary)">
		  <xsl:for-each select="$exs/ex_group/x">
		    <xg>
		      <xsl:attribute name="type">
			<xsl:if test="ends-with(. , '!') or ends-with(., '?')">
			  <xsl:value-of select="'sentence'"/>
			</xsl:if>
			<xsl:if test="not(ends-with(. , '!') or ends-with(., '?'))">
			  <xsl:value-of select="'xxx'"/>
			</xsl:if>
		      </xsl:attribute>
		      <xsl:copy-of select="."/>
		      <xsl:copy-of select="following-sibling::xt[1]"/>
		    </xg>
		  </xsl:for-each>
		</xsl:if>
		
	      </xsl:if>
	      
	    </mg>
	  </xsl:for-each>
	</e>
      </xsl:for-each>
      <xsl:copy-of select="$e_link_ot"/>
      <xsl:copy-of select="$e_link_sm"/>
    </r>
    
  </xsl:template>
  
  <xsl:template name="flatten_node">
    <xsl:param name="theNode"/>
    <xsl:param name="theTag"/>
    <xsl:variable name="pattern">
      <xsl:for-each select="$theNode/node()">
	<xsl:variable name="node_content">
	  <xsl:value-of select="normalize-space(.)"/>
	</xsl:variable>
	<xsl:if test="not($node_content = '')">
	  <xsl:if test="self::text() and not(normalize-space(text()) = '')">
	    <xsl:value-of select="'txt'"/>
	  </xsl:if>
	  <xsl:if test="self::*">
	    <xsl:value-of select="lower-case(local-name(.))"/>
	  </xsl:if>
	  <xsl:if test="not(position() = last())">
	    <xsl:value-of select="'_'"/>
	  </xsl:if>
	</xsl:if>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:element name="{concat($theTag, '_test')}">
      <xsl:attribute name="stamp">
	<xsl:value-of select="$pattern"/>
      </xsl:attribute>
      <xsl:for-each select="$theNode/node()">

	<xsl:variable name="c_node">
	  <node>
	    <xsl:if test="self::text() and not(normalize-space(text()) = '')">
	      <xsl:attribute name="ntype">
		<xsl:value-of select="'txt'"/>
	      </xsl:attribute>
	      <xsl:copy-of select="normalize-space(.)"/>
	    </xsl:if>
	    <xsl:if test="self::*">
	      <xsl:attribute name="ntype">
		<xsl:value-of select="lower-case(local-name(.))"/>
	      </xsl:attribute>
	      <xsl:copy-of select="normalize-space(lower-case(.))"/>
	    </xsl:if>
	  </node>
	</xsl:variable>
	<xsl:if test="not(count($c_node/node/node()) = 0)">
	  <xsl:copy-of select="$c_node"/>
	</xsl:if>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

  
  <xsl:template name="check_merge_target">
    <xsl:param name="theLink"/>
    
    <xsl:for-each select="collection(concat($inDir, '?select=*.xml'))/r/E[not(T/LINK/@TYPE ='OT')][not(T/LINK/@TYPE ='SM')]/L">
      <xsl:if test="lower-case(.) = lower-case($theLink)">
	
	<xsl:variable name="kid">
	  <xsl:value-of select="if (../@kur_id and not(../@kur_ID = '')) then ../@kur_ID else 'xxx'"/>
	</xsl:variable>
	
	<target kur_ID="{$kid}">
	  <xsl:value-of select="lower-case(.)"/>
	</target>
      </xsl:if>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="check_merge_ot_source">
    <xsl:param name="theEntry"/>
    
    <xsl:variable name="result">
      <ot_kur_stem>
	<xsl:for-each select="collection(concat($inDir, '?select=*.xml'))/r/E[T/LINK/@TYPE ='OT']">
	  <xsl:for-each select="./T[./LINK/@TYPE ='OT']">
	    
	    <xsl:if test="lower-case(./LINK[./@TYPE ='OT']) = lower-case($theEntry/L/text())">
	      
	      
	      <xsl:if test="true()">
		<xsl:message terminate="no">
		  <xsl:value-of select="concat('*****@@@@@***** check merge ot source in  target:', $nl)"/>
		  <xsl:value-of select="concat('target: ', lower-case($theEntry/L/text()), 'source: ', lower-case(./LINK[./@TYPE ='OT']),$nl)"/>
		  <xsl:value-of select="'*****@@@@@*****'"/>
		</xsl:message>
	      </xsl:if>
	      
	      <xsl:variable name="kid">
		<xsl:value-of select="if (../@kur_ID and not(../@kur_ID = '')) then ../@kur_ID else '_x_x_x_'"/>
	      </xsl:variable>
	      
	      <source kur_ID="{$kid}">
		<xsl:value-of select="lower-case(../L)"/>
	      </source>
	      
	      <link_target_test>
		<xsl:value-of select="lower-case(./LINK[./@TYPE ='OT'])"/>
	      </link_target_test>

	    </xsl:if>
	  </xsl:for-each>
	</xsl:for-each>
      </ot_kur_stem>
    </xsl:variable>
    
    <!--     <xsl:if test="normalize-space($result) = ''"> -->
    <!--       <empty_out_kur_stem/> -->
    <!--     </xsl:if> -->
    
    <xsl:if test="not(normalize-space($result) = '')">
      <xsl:copy-of select="$result"/>
    </xsl:if>
    
  </xsl:template>
  

  <xsl:template name="lower-case_node">
    <xsl:param name="theNode"/>

    <xsl:element name="{lower-case(local-name($theNode))}">
      <xsl:for-each select="$theNode/@*">
	<xsl:attribute name="{lower-case(local-name(.))}">
	  <xsl:value-of select="."/>
	</xsl:attribute>
      </xsl:for-each>

      <xsl:if test="not($theNode/*)">
	<xsl:value-of select="lower-case(./text())"/>
      </xsl:if>
      
      <xsl:for-each select="$theNode/*">
	<xsl:call-template name="lower-case_node">
	  <xsl:with-param name="theNode" select="."/>
	</xsl:call-template>
      </xsl:for-each>
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
