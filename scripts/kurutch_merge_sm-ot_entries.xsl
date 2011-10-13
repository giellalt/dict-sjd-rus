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
  <xsl:variable name="outputDir" select="'merge-test_output'"/>
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


  <!-- get input files -->
  <!-- These paths have to be adjusted accordingly -->
  <xsl:param name="file" select="'../rule2_merging_test.xml'"/>
  <xsl:variable name="file_name" select="substring-before((tokenize($file, '/'))[last()], '.xml')"/>
  
  <xsl:template match="/" name="main">
    <xsl:choose>
      <xsl:when test="doc-available($file)">
	<xsl:variable name="file_out" as="element()">
	  <r xml:lang="sjd">
	    
	    <!-- 	    <xsl:variable name="noKID_e" as="element()"> -->
	    <!-- 	      <e_noKID> -->
	    <!-- 		<xsl:copy-of select="doc($file)/r/e"/> -->
	    <!-- 	      </e_noKID> -->
	    <!-- 	    </xsl:variable> -->
	    
	    
	    <!-- to refine here: all entries that have no pointers to -->
<!-- 	    <xsl:for-each select="doc($file)/r/e[not(T/LINK/@TYPE ='OT')][not(T/LINK/@TYPE ='SM')]"> -->
<!-- 	      <xsl:if test="true()"> -->
<!-- 		<xsl:message terminate="no"> -->
<!-- 		  <xsl:value-of select="concat('.................................', $nl)"/> -->
<!-- 		  <xsl:value-of select="concat('entry kur_ID: ', ./@kur_ID, $nl)"/> -->
<!-- 		  <xsl:value-of select="'.................................'"/> -->
<!-- 		</xsl:message> -->
<!-- 	      </xsl:if> -->

<!-- 	      <xsl:copy-of select="."/> -->

<!-- 	    </xsl:for-each> -->

	    <xsl:for-each select="doc($file)/r/lsm_entries/e">
	      <xsl:if test="true()">
		<xsl:message terminate="no">
		  <xsl:value-of select="concat('-----------------------------------------', $nl)"/>
		  <xsl:value-of select="concat('entry kur_ID: ', ./@kur_ID, $nl)"/>
		  <xsl:value-of select="'-----------------------------------------'"/>
		</xsl:message>
	      </xsl:if>
	      <xsl:variable name="c_lemma" select="./l"/>
	      <e>
		<xsl:copy-of select="./@*"/>
		<lg>
		  <xsl:copy-of select="doc($file)/r/e/lg[./l = $c_lemma]/*"/>
		  <der type="SM">
		    <xsl:value-of select="./t/link[./@type = 'SM']"/>
		  </der>
		</lg>
		<xsl:copy-of select="doc($file)/r/e[./lg/l = $c_lemma]/mg"/>
	      </e>
	    </xsl:for-each>
	  </r>
	</xsl:variable>
	
	<xsl:result-document href="{$outputDir}/out_{$file_name}.{$e}">
	  <xsl:copy-of select="$file_out"/>
	</xsl:result-document>
	
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>Cannot locate: </xsl:text><xsl:value-of select="$file"/><xsl:text>&#xa;</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="flatten_node">
    <xsl:param name="theNode"/>
    <xsl:param name="theTag"/>
    <xsl:variable name="pattern">
      <xsl:for-each select="$theNode/node()">
	<xsl:if test="self::text()">
	  <xsl:value-of select="'txt'"/>
	</xsl:if>
	<xsl:if test="self::*">
	  <xsl:value-of select="lower-case(local-name(.))"/>
	</xsl:if>
	<xsl:if test="not(position() = last())">
	  <xsl:value-of select="'_'"/>
	</xsl:if>
      </xsl:for-each>
    </xsl:variable>
    
    <xsl:element name="{concat($theTag, '_test')}">
      <xsl:attribute name="stamp">
	<xsl:value-of select="$pattern"/>
      </xsl:attribute>
      <xsl:for-each select="$theNode/node()">
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
    </xsl:element>
  </xsl:template>

</xsl:stylesheet>
