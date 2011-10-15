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
  <xsl:variable name="outputDir" select="'polish_output'"/>
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
  <xsl:param name="file" select="'../src/sm-unified_kurutch1985_sjdrus.xml'"/>
  <xsl:variable name="file_name" select="substring-before((tokenize($file, '/'))[last()], '.xml')"/>
  
  <xsl:template match="/" name="main">
    <xsl:choose>
      <xsl:when test="doc-available($file)">
	<xsl:variable name="file_out" as="element()">
	  <r xml:lang="sjd">
	    <!-- copy all entries that don't have slashes as aspect separator-->
	    <xsl:for-each select="doc($file)/r/e">


	      <xsl:if test="every $item in ./mg/tg/t satisfies not(contains($item, ' / '))">
		<xsl:if test="true()">
		  <xsl:message terminate="no">
		    <xsl:value-of select="concat('.................................', $nl)"/>
		    <xsl:value-of select="concat('entry kur_ID: ', ./@kur_ID, $nl)"/>
		    <xsl:value-of select="'.................................'"/>
		  </xsl:message>
		</xsl:if>
		<xsl:copy-of select="."/>
	      </xsl:if>

	      <xsl:if test="some $item in ./mg/tg/t satisfies contains($item, ' / ')">
		<xsl:if test="true()">
		  <xsl:message terminate="no">
		    <xsl:value-of select="concat('.................................', $nl)"/>
		    <xsl:value-of select="concat('entry kur_ID: ', ./@kur_ID, $nl)"/>
		    <xsl:value-of select="'.................................'"/>
		  </xsl:message>
		</xsl:if>
		<e>
		  <xsl:copy-of select="./@*"/>
		  <xsl:copy-of select="./lg"/>
		  <!-- here to implement the aspect issue -->
		  <xsl:for-each select="./mg">
		    <mg>
		      <xsl:copy-of select="./@*"/>
		      <xsl:copy-of select="./semantics"/>
		      <xsl:copy-of select="./tam"/>
		      <xsl:for-each select="./tg">
			<tg>
			  <xsl:for-each select="./t">
			    <xsl:if test="not(contains(., ' / '))">
			      <xsl:copy-of select="."/>
			    </xsl:if>
			    <xsl:if test="contains(., ' / ')">
			      <!-- baustelle -->
			      <xsl:variable name="chopped_content" select="tokenize(., ' / ')"/>

			      <xsl:if test="not(count($chopped_content) =2)">
				<xsl:message terminate="yes">
				  <xsl:value-of select="concat('.................................', $nl)"/>
				  <xsl:value-of select="concat('too many separators for aspect in entry kur_ID: ', ./@kur_ID, $nl)"/>
				  <xsl:value-of select="'.................................'"/>
				</xsl:message>
			      </xsl:if>
			      <xsl:variable name="head" select="normalize-space($chopped_content[1])"/>
			      <xsl:variable name="tail" select="normalize-space($chopped_content[2])"/>
			      <t>
				<xsl:if test="not(contains($tail, ' '))">
				  <xsl:attribute name="imperf">
				    <xsl:value-of select="$tail"/>
				  </xsl:attribute>
				  <xsl:value-of select="$head"/>
				</xsl:if>
				<xsl:if test="contains($tail, ' ')">
				  <xsl:attribute name="imperf">
				    <xsl:value-of select="substring-before($tail, ' ')"/>
				  </xsl:attribute>
				  <xsl:value-of select="$head"/>
				  <xsl:value-of select="concat(' ', substring-after($tail, ' '))"/>
				</xsl:if>
			      </t>
			    </xsl:if>
			  </xsl:for-each>
			</tg>
		      </xsl:for-each>
		      <xsl:copy-of select="./xg"/>
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
