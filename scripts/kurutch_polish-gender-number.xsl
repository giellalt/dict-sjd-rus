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
  <xsl:variable name="outputDir" select="'04_genum_polish_output'"/>
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
  <xsl:param name="file" select="'../src/03_aspect_kurutch1985_sjdrus.xml'"/>
  <xsl:variable name="file_name" select="substring-before((tokenize($file, '/'))[last()], '.xml')"/>
  
  <xsl:template match="/" name="main">
    <xsl:choose>
      <xsl:when test="doc-available($file)">
	<xsl:variable name="file_out" as="element()">
	  <r xml:lang="sjd">
	    <xsl:for-each select="doc($file)/r/e">
	      <!-- copy all entries that don't have flags for gender or number-->
	      <xsl:if test="(every $item in ./mg/tg/t satisfies not(contains($item, '_GENDER') or contains($item, '_NUMBER'))) and 
			    (every $item in ./lg/l satisfies not(contains($item, '_GENDER') or contains($item, '_NUMBER') or
			    contains($item, '_gender') or contains($item, '_number'))) and 
			    (every $item in ./mg/xg/xt satisfies not(contains($item, '_GENDER') or contains($item, '_NUMBER') or
			    contains($item, '_gender') or contains($item, '_number')))">
		<xsl:if test="true()">
		  <xsl:message terminate="no">
		    <xsl:value-of select="concat('.................................', $nl)"/>
		    <xsl:value-of select="concat('entry kur_ID: ', ./@kur_ID, $nl)"/>
		    <xsl:value-of select="'.................................'"/>
		  </xsl:message>
		</xsl:if>
		<xsl:copy-of select="."/>
	      </xsl:if>

	      <xsl:if test="(some $item in ./mg/tg/t satisfies (contains($item, '_GENDER') or contains($item, '_NUMBER'))) or 
			    (some $item in ./lg/l satisfies (contains($item, '_GENDER') or contains($item, '_NUMBER') or 
			    contains($item, '_gender') or contains($item, '_number'))) or 
			    (some $item in ./mg/xg/xt satisfies (contains($item, '_GENDER') or contains($item, '_NUMBER') or 
			    contains($item, '_gender') or contains($item, '_number')))">
		<xsl:if test="true()">
		  <xsl:message terminate="no">
		    <xsl:value-of select="concat('.................................', $nl)"/>
		    <xsl:value-of select="concat('entry kur_ID: ', ./@kur_ID, $nl)"/>
		    <xsl:value-of select="'.................................'"/>
		  </xsl:message>
		</xsl:if>
		<e>
		  <xsl:copy-of select="./@*"/>
		  <lg>
		    <xsl:call-template name="tag2attribute">
		      <xsl:with-param name="theNode" select="./lg/l"/>
		    </xsl:call-template>
		    <xsl:copy-of select="./lg/*[not(./local-name() = 'l')]"/>
		  </lg>
		  <!-- here to implement the gender-number issues: Baustelle -->
		  <xsl:for-each select="./mg">
		    <mg>
		      <xsl:copy-of select="./@*"/>
		      <xsl:copy-of select="./semantics"/>
		      <xsl:copy-of select="./tam"/>
		      <xsl:for-each select="./tg">
			<tg>
			  <xsl:for-each select="./t">
			    <!-- baustelle -->
			    <xsl:call-template name="tag2attribute">
			      <xsl:with-param name="theNode" select="."/>
			    </xsl:call-template>
			  </xsl:for-each>
			</tg>
		      </xsl:for-each>
		      <xsl:for-each select="xg">
			<xg>
			  <xsl:copy-of select="./@*"/>
			  <xsl:copy-of select="./x"/>
			  <xsl:for-each select="xt">
			    <xsl:call-template name="tag2attribute">
			      <xsl:with-param name="theNode" select="."/>
			    </xsl:call-template>
			  </xsl:for-each>
			</xg>
		      </xsl:for-each>
		    </mg>
		  </xsl:for-each>
		</e>
	      </xsl:if>
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

  <xsl:template name="tag2attribute">
    <xsl:param name="theNode"/>

    <xsl:if test="not(contains($theNode, '_GENDER') or contains($theNode, '_NUMBER') or 
		  contains($theNode, '_gender') or contains($theNode, '_number'))">
      <xsl:copy-of select="$theNode"/>
    </xsl:if>
    <xsl:if test="contains($theNode, '_GENDER') or contains($theNode, '_NUMBER') or
		  contains($theNode, '_gender') or contains($theNode, '_number')">
      <xsl:element name="{$theNode/local-name()}">
	<xsl:copy-of select="$theNode/@*"/>
	<xsl:if test="contains($theNode, 'F_GENDER') or contains($theNode, 'f_gender')">
	  <xsl:attribute name="gender">
	    <xsl:value-of select="'f'"/>
	  </xsl:attribute>
	</xsl:if>
	<xsl:if test="contains($theNode, 'M_GENDER') or contains($theNode, 'm_gender')">
	  <xsl:attribute name="gender">
	    <xsl:value-of select="'m'"/>
	  </xsl:attribute>
	</xsl:if>
	<xsl:if test="contains($theNode, 'SG_NUMBER') or contains($theNode, 'sg_number')">
	  <xsl:attribute name="number">
	    <xsl:value-of select="'sg'"/>
	  </xsl:attribute>
	</xsl:if>
	<xsl:if test="contains($theNode, 'PL_NUMBER') or contains($theNode, 'pl_number')">
	  <xsl:attribute name="number">
	    <xsl:value-of select="'pl'"/>
	  </xsl:attribute>
	</xsl:if>
	<xsl:if test="contains($theNode, '_GENDER') or contains($theNode, '_NUMBER')">
	  <xsl:value-of select="normalize-space(
	  		          replace(
			            replace(
			              replace(
			                replace($theNode, 'F_GENDER', ''
			                ), 'M_GENDER', ''
			              ), 'SG_NUMBER', ''
			            ), 'PL_NUMBER', ''
			          )
			        )"/>
	</xsl:if>
	<xsl:if test="contains($theNode, '_gender') or contains($theNode, '_number')">
	  <xsl:value-of select="normalize-space(
	  		          replace(
			            replace(
			              replace(
			                replace($theNode, 'f_gender', ''
			                ), 'm_gender', ''
			              ), 'sg_number', ''
			            ), 'pl_number', ''
			          )
			        )"/>
	</xsl:if>
      </xsl:element>
    </xsl:if>
    
    
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
