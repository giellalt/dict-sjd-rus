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
  <xsl:variable name="outputDir" select="'output_kt2gt'"/>
  <xsl:variable name="debug" select="true()"/>

  <xsl:variable name="tab" select="'&#x9;'"/>
  <xsl:variable name="nl" select="'&#xa;'"/>
  <xsl:variable name="xxx" select="'textbf'"/>
  <xsl:variable name="cbl" select="'{'"/>
  <xsl:variable name="cbr" select="'}'"/>
  <xsl:variable name="bsl" select="'\'"/>

  <!-- get input files -->
  <!-- These paths have to be adjusted accordingly -->
  <xsl:param name="file" select="'../inc/kurutch/kurutch1985_1-1000.xml'"/>
  <xsl:variable name="file_name" select="substring-before((tokenize($file, '/'))[last()], '.xml')"/>
  
  <xsl:template match="/" name="main">
    <xsl:choose>
      <xsl:when test="doc-available($file)">
	<xsl:variable name="file_out" as="element()">
	  <r xml:lang="sjd">
	    <xsl:for-each select="doc($file)/r/E">
	      <xsl:if test="$debug">
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
					      or ends-with($current_l, 'тэнне')) then 'adv' else
					      if (ends-with($current_l, 'ант')
					      or ends-with($current_l, 'мушш')
					      or ends-with($current_l, 'егк')
					      or ends-with($current_l, 'эгк')
					      or ends-with($current_l, 'ӭгк')
					      or ends-with($current_l, 'енч')
					      or ends-with($current_l, 'энч')
					      or ends-with($current_l, 'ӭнч')
					      or ends-with($current_l, 'вудт')
					      or ends-with($current_l, 'хэсс')) then 'n' else
					      if (ends-with($current_l, 'хэмь')
					      or ends-with($current_l, 'есь')
					      or ends-with($current_l, 'ай')) then 'a' else
					      if (ends-with($current_l, 'ювве')
					      or ends-with($current_l, 'увве')
					      or ends-with($current_l, 'увне')
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
					      or ends-with($current_l, 'ювне')) then 'v' else 'xxx'"/>
<!-- further PoS tagging possible thru elements
<DER type="STRAD_K">
<DER type="PONUD_K">
which occur only with verbs
-->
					      			
		      </xsl:if>
		    </xsl:variable>
		    
		    <xsl:attribute name="pos">
		      <xsl:value-of select="$current_pos"/>
		    </xsl:attribute>
		    <xsl:value-of select="$current_l"/>
		  </l>
		  <xsl:if test="not(normalize-space(./STEM/text()) = '')">
		    <stem>
		      <xsl:value-of select="normalize-space(./STEM/text())"/>
		    </stem>
		  </xsl:if>
		  <xsl:if test="not(normalize-space(./CLASS/text()) = '')">
		    <class>
		      <xsl:value-of select="normalize-space(./CLASS/text())"/>
		    </class>
		  </xsl:if>
		</lg>
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

		    <!-- as agreed with Michael, semantic types have as scope the whole mg -->
		    <!-- which is more understandable: meaning = semantics -->
		    <semantics>
		      <stype>
			<xsl:value-of select="if (child::*/local-name() = 'SEM') then lower-case(child::SEM) else 'xxx'"/>
		      </stype>
		    </semantics>
		    
		    <!-- T is empty -->
		    <xsl:if test="count(./node()) = 0">
		      <tg>
			<t>
			  <!-- this should be checked -->
			  <xsl:value-of select="'xxx___xxx'"/>
			</t>
		      </tg>
		    </xsl:if>
		    
		    <!-- T has only one child -->
		    <xsl:if test="count(./node()) = 1">
		      <!-- child of type text: normal case -->
		      <xsl:if test="child::text()">
			<!-- but has no real translation, just a pointer to some other entry in the dict -->
			<xsl:if test="child::text() = 'xxx'">
			  <tg>
			    <!-- gogo -->
			    <t>

			      <xsl:if test="not($debug)">
				<xsl:message terminate="no">
				  <xsl:value-of select="concat('T_xxx_T: ', $current_l, $nl)"/>
				  <xsl:value-of select="'%%%%%%%%%%%%%%%%'"/>
				</xsl:message>
				
				<xsl:attribute name="bare_pointers">
				  <xsl:value-of select="count(preceding-sibling::COMPARE) + count(preceding-sibling::DER)"/>
				</xsl:attribute>
			      </xsl:if>
			      
			      <xsl:if test="preceding-sibling::COMPARE">
				<xsl:attribute name="link_type">
				  <xsl:value-of select="'COMPARE'"/>
				</xsl:attribute>
				<xsl:value-of select="normalize-space(preceding-sibling::COMPARE)"/>
			      </xsl:if>
			      <xsl:if test="preceding-sibling::DER">
				<xsl:attribute name="link_type">
				  <xsl:value-of select="'DERIVAT'"/>
				</xsl:attribute>
				<xsl:attribute name="link_sub_type">
				  <xsl:value-of select="preceding-sibling::DER/@type"/>
				</xsl:attribute>
				<xsl:value-of select="normalize-space(preceding-sibling::DER)"/>
			      </xsl:if>
			      <xsl:if test="not(preceding-sibling::COMPARE) and not(preceding-sibling::DER)">
				<xsl:attribute name="link_type">
				  <xsl:value-of select="'xxx_empty-link_xxx'"/>
				</xsl:attribute>
				<xsl:value-of select="'xxx_empty-t_xxx'"/>
			      </xsl:if>
			    </t>
			  </tg>
			</xsl:if>
			<xsl:if test="not(child::text() = 'xxx')">
			  <xsl:if test="preceding-sibling::COMPARE">
			    <todo type="underspecification">
			      <xsl:attribute name="link_type">
				<xsl:value-of select="'COMPARE'"/>
			      </xsl:attribute>
			      <xsl:value-of select="normalize-space(preceding-sibling::COMPARE)"/>
			    </todo>
			  </xsl:if>
			  <xsl:if test="preceding-sibling::DER">
			    <todo type="underspecification">
			      <xsl:attribute name="link_type">
				<xsl:value-of select="'DERIVAT'"/>
			      </xsl:attribute>
			      <xsl:attribute name="link_sub_type">
				<xsl:value-of select="preceding-sibling::DER/@type"/>
			      </xsl:attribute>
			      <xsl:value-of select="normalize-space(preceding-sibling::DER)"/>
			    </todo>
			  </xsl:if>
			  <xsl:for-each select="tokenize(normalize-space(child::text()), ';')">
			    <tg>
			      <xsl:for-each select="tokenize(., ',')">
				<t>
				  <xsl:value-of select="normalize-space(.)"/>
				</t>
			      </xsl:for-each>
			    </tg>
			  </xsl:for-each>
			</xsl:if>
		      </xsl:if>
		      
		      <!-- child of type element -->
		      <xsl:if test="child::*">
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
			  
			  <!-- Wer sich einmal mit heisser Suppe 
			       verbrannt hat, pustet auch in
			       Yoghourt. -->
			  <xsl:if test="not(child::*/local-name() = 'LINK')">
			    <t unknown_elem="xxx"/>
			    <xsl:copy-of select="child::*"/>
			  </xsl:if>
			</tg>
		      </xsl:if>
		    </xsl:if>
		    
		    <!-- T has more than one child: mixed content -->
		    <xsl:if test="count(./node()) &gt; 1">
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

		      <xsl:if test="$debug">
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

		      <done>
			<xsl:attribute name="stamp">
			  <xsl:value-of select="$pattern"/>
			</xsl:attribute>

			<xsl:call-template name="processMixedMG">
			  <xsl:with-param name="theMG" select="."/>
			</xsl:call-template>
			

		      </done>


<!-- 		      <done> -->
<!-- 			<xsl:attribute name="stamp"> -->
<!-- 			  <xsl:value-of select="$pattern"/> -->
<!-- 			</xsl:attribute> -->
<!-- 		      </done> -->

		    </xsl:if>
		    
		    <!-- at the moment, the location for xg is uncertain: to be solved later -->
		    <xsl:if test="../X">
		      <xsl:call-template name="processExGroup">
			<xsl:with-param name="theXStar" select=".."/>
		      </xsl:call-template>
		    </xsl:if>
		    
		  </mg>
		</xsl:for-each>
	      </e>
	    </xsl:for-each>
	  </r>
	</xsl:variable>
	
	<xsl:result-document href="{$outputDir}/{$file_name}.{$e}">
	  <xsl:copy-of select="$file_out"/>
	</xsl:result-document>
	
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>Cannot locate: </xsl:text><xsl:value-of select="$file"/><xsl:text>&#xa;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="processExGroup">
    <xsl:param name="theXStar"/>
    <xsl:variable name="x_a" select="count($theXStar/*[starts-with(local-name(), 'X')])"/>
    <xsl:variable name="x_o" select="count($theXStar/*[local-name() = 'X'])"/>
    <xsl:variable name="x_t" select="count($theXStar/*[local-name() = 'XT'])"/>
    <xsl:variable name="idiom" select="count($theXStar/child::text()[normalize-space(.) = '#'])"/>
    <xg_all>
      <xsl:attribute name="xstar">
	<xsl:value-of select="$x_a"/>
      </xsl:attribute>
      <xsl:attribute name="x">
	<xsl:value-of select="$x_o"/>
      </xsl:attribute>
      <xsl:attribute name="xt">
	<xsl:value-of select="$x_t"/>
      </xsl:attribute>
      <xsl:attribute name="idiom">
	<xsl:value-of select="$idiom"/>
      </xsl:attribute>
      <xsl:for-each select="$theXStar/*[starts-with(local-name(), 'X')]|$theXStar/child::text()[normalize-space(.) = '#']">
	<xsl:variable name="c_content" select="."/>
	<xsl:if test="../child::node()[. = $c_content]/position()">
	  <xsl:variable name="c_pos" select="position()"/>
	  
	  <xelex position="{$c_pos}">
	    <xsl:copy-of select="./@*"/>
	    <xsl:copy-of select="normalize-space(.)"/>
	  </xelex>
	</xsl:if>
	
      </xsl:for-each>

      <xsl:if test="not($debug)">
	<global_pattern>
	  <xsl:for-each select="$theXStar/child::*|$theXStar/child::text()">
	    <g_node position="{position()}">
	      <xsl:copy-of select="."/>
	    </g_node>
	  </xsl:for-each>
	</global_pattern>
      </xsl:if>
	
    </xg_all>
    
    <!-- 			  <xsl:for-each select="../X*"> -->
    <!-- 			    <xg> -->
    
    <!-- 			    </xg> -->
    <!-- 			  </xsl:for-each> -->
  </xsl:template>

  <xsl:template name="processMixedMG">
    <xsl:param name="theMG"/>
    
    <xsl:variable name="tgg">
      <xsl:value-of select="count(tokenize($theMG/child::text(), ';'))"/>
    </xsl:variable>

    <!-- based on the number of semicolons, only one tg -->
    <xsl:if test="$tgg = 1">
      <tg>
	<xsl:for-each select="./*">
	  <xsl:element name="{lower-case(local-name(.))}">
	    <xsl:copy-of select="normalize-space(lower-case(.))"/>
	  </xsl:element>
	</xsl:for-each>
	<xsl:for-each select="tokenize(./text(), ',')">
	  <t>
	    <xsl:value-of select="normalize-space(.)"/>
	  </t>
	</xsl:for-each>
      </tg>
    </xsl:if>
    
    <!-- based on the number of semicolons, more than one tg -->
    <xsl:if test="$tgg &gt; 1">
      <iii>
	<xsl:copy-of select="$theMG"/>
      </iii>
    </xsl:if>

  </xsl:template>
  
</xsl:stylesheet>
