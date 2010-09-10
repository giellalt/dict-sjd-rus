<?xml version="1.0"?>
<!--+
    | Transforms a txt file with two fields - "lemma","part-of-speech"- into a fitswe gtdict xml format
    | NB: An XSLT-2.0-processor is needed!
    | Usage: java -Xmx2024m net.sf.saxon.Transform -it main THIS_SCRIPT file="INPUT-FILE"
    | 
    +-->

<xsl:stylesheet version="2.0"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:fn="fn"
		xmlns:local="nightbar"
		exclude-result-prefixes="xs fn local">
  
  <xsl:strip-space elements="*"/>
  <xsl:output method="xml"
              encoding="UTF-8"
              omit-xml-declaration="no"
              indent="yes"/>


<xsl:function name="local:distinct-deep" as="node()*">
  <xsl:param name="nodes" as="node()*"/> 
 
  <xsl:sequence select=" 
    for $seq in (1 to count($nodes))
    return $nodes[$seq][not(local:is-node-in-sequence-deep-equal(
                          .,$nodes[position() &lt; $seq]))]
 "/>
   
</xsl:function>

<xsl:function name="local:is-node-in-sequence-deep-equal" as="xs:boolean">
  <xsl:param name="node" as="node()?"/> 
  <xsl:param name="seq" as="node()*"/> 
 
  <xsl:sequence select=" 
   some $nodeInSeq in $seq satisfies deep-equal($nodeInSeq,$node)
 "/>
   
</xsl:function>


  <xsl:variable name="e" select="'xml'"/>
  <xsl:variable name="outputDir" select="'xml-out'"/>


  <xsl:variable name="tab" select="'&#x9;'"/>
  <xsl:variable name="nl" select="'&#xa;'"/>
  <xsl:variable name="xxx" select="'textbf'"/>
  <xsl:variable name="cbl" select="'{'"/>
  <xsl:variable name="cbr" select="'}'"/>
  <xsl:variable name="bsl" select="'\'"/>

  <xsl:variable name="regex">^\\textbf\{([^{}]+)\}([^\\]+)\\hspace\{[^{}]+\}([^\\]+)\\.+$</xsl:variable>


  <xsl:param name="file" select="'default.txt'"/>
  
  <xsl:template match="/" name="main">
    
    <xsl:choose>
      <xsl:when test="unparsed-text-available($file)">

	<xsl:variable name="file_name" select="substring-before($file, '.txt')"/>

	<xsl:variable name="source" select="unparsed-text($file)"/>
	<xsl:variable name="lines" select="tokenize($source, '&#xa;')" as="xs:string+"/>
	<xsl:variable name="output">
	  <r>
	    <!-- capture the patterns and their meanings -->
	    <xsl:for-each select="$lines">
	      <xsl:if test=". != ''">

<!-- 		<e> -->
<!-- 		  <xsl:value-of select="."/> -->
<!-- 		</e> -->

		<xsl:analyze-string select="." regex="{$regex}" flags="s">
		  <xsl:matching-substring>
		    <e>
		      <xsl:attribute name="src">
			<xsl:value-of select="$file_name"/>
		      </xsl:attribute>
		      <xsl:variable name="rus" select="concat(regex-group(1), ' ', normalize-space(regex-group(2)))"/>
		      <xsl:variable name="sjd" select="normalize-space(regex-group(3))"/>
		      <lg>
			<l>
			  <xsl:attribute name="pos">
			    <xsl:value-of select="'xxx'"/>
			  </xsl:attribute>
			  <xsl:value-of select="normalize-space($rus)"/>
			</l>
		      </lg>
		      <mg>
			<tg>
			  <xsl:for-each select="tokenize($sjd, ',')">
			    <t pos="xxx">
			      <xsl:value-of select="normalize-space(.)"/>
			    </t>
			  </xsl:for-each>
			</tg>
		      </mg>
		    </e>
		  </xsl:matching-substring>
		  <xsl:non-matching-substring>
		    <xxx><xsl:value-of select="." /></xxx>
		  </xsl:non-matching-substring>
		</xsl:analyze-string>
	      </xsl:if>
	    </xsl:for-each>
	  </r>
	</xsl:variable>

	<!-- output -->
	<xsl:result-document href="{$outputDir}/{$file_name}.{$e}">
	  <xsl:copy-of select="$output"/>
	</xsl:result-document>
	
      </xsl:when>
      <xsl:otherwise>
	<xsl:text>Cannot locate : </xsl:text><xsl:value-of select="concat($file, $nl)"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
</xsl:stylesheet>

