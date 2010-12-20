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
  <xsl:variable name="debug" select="'true_gogo'"/>

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

	      <xsl:if test="$debug = 'true_gogo'">
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
		         explicitly. who knows when would be needed?
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
		      <xsl:attribute name="kmg">
			<xsl:value-of select="concat('g', ./@tnumber)"/>
		      </xsl:attribute>
		    </xsl:if>
		    
		    <!-- T is empty -->
		    <xsl:if test="count(./node()) = 0">
		      <tg>
			<semantics>
			  <!-- some default as wished -->
			  <sem class="xxx"/>
			</semantics>
			<t>
			  <!-- this should be checked -->
			  <xsl:value-of select="'xxx'"/>
			</t>
			<xsl:if test="../X">
			  <xsl:call-template name="processExGroup">
			    <xsl:with-param name="theXStar" select=".."/>
			  </xsl:call-template>
			</xsl:if>
		      </tg>
		    </xsl:if>
		    
		    <!-- T has only one child -->
		    <xsl:if test="count(./node()) = 1">
		      <!-- child of type text: normal case -->
		      <xsl:if test="child::text()">
			<xsl:for-each select="tokenize(normalize-space(child::text()), ';')">
			  <tg>
			    <semantics>
			      <!-- some default as wished -->
			      <sem class="xxx"/>
			    </semantics>
			    <xsl:for-each select="tokenize(., ',')">
			      <t>
				<xsl:value-of select="normalize-space(.)"/>
			      </t>
			    </xsl:for-each>
			  </tg>
			</xsl:for-each>
			<!-- at the moment, the location for xg is uncertain: to be solved later -->
			<xsl:if test="../X">
			  <xsl:call-template name="processExGroup">
			    <xsl:with-param name="theXStar" select=".."/>
			  </xsl:call-template>
			</xsl:if>
		      </xsl:if>
		      
		      <!-- child of type element -->
		      <xsl:if test="child::*">
			<tg>
			  <semantics>
			    <!-- some default as wished -->
			    <sem class="xxx"/>
			  </semantics>
			  <t>
			    <xsl:attribute name="link_type">
			      <xsl:value-of select="if (./LINK/@type) then ./LINK/@type
						    else if (./LINK/@TYPE) then ./LINK/@TYPE
						    else 'xxx'"/>
			    </xsl:attribute>
			    <xsl:value-of select="normalize-space(./LINK)"/>
			  </t>
			</tg>
		      </xsl:if>
		    </xsl:if>
		    
		    <!-- T has more than one child: mixed content -->
		    <xsl:if test="count(./node()) &gt; 1">
		      <tg>
			<semantics>
			  <!-- some default as wished -->
			  <sem class="xxx"/>
			</semantics>
			<t>
			  <xsl:value-of select="'xxx__processing_mixed_content__xxx'"/>
			</t>
			<xsl:if test="../X">
			  <xsl:call-template name="processExGroup">
			    <xsl:with-param name="theXStar" select=".."/>
			  </xsl:call-template>
			</xsl:if>
		      </tg>
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
    <xg_counter>
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

    </xg_counter>
    
    <!-- 			  <xsl:for-each select="../X*"> -->
    <!-- 			    <xg> -->
    
    <!-- 			    </xg> -->
    <!-- 			  </xsl:for-each> -->
  </xsl:template>
  
</xsl:stylesheet>
