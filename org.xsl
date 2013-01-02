<?xml version="1.0" encoding="utf-8"?> 
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:db="http://docbook.org/ns/docbook"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                exclude-result-prefixes="db xlink"
                version="1.0">

    <xsl:output method="xml" omit-xml-declaration="yes" encoding="utf-8" />
    <xsl:strip-space elements="db:article db:section" />
    <xsl:template match="/db:article/db:title" />
    <xsl:template match="/db:article/db:info" />
    
    <xsl:template match="//db:section/db:title">
        <xsl:text>&#xA;</xsl:text>
        <h2><xsl:value-of select="." /></h2>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>


    <xsl:template match="//db:spoiler/text()">
        <xsl:value-of select="normalize-space(.)" />
    </xsl:template>

    <xsl:template match="db:link">
        <a href="{@xlink:href}"><xsl:value-of select="." /></a>
    </xsl:template>

    <xsl:template match="db:spoiler">
        <xsl:element name="{name()}">
            <xsl:copy-of select="@*" />
            <xsl:apply-templates />
        </xsl:element>
    </xsl:template>

    <xsl:template match="db:cut">
        <habracut />
    </xsl:template>

    <xsl:template match="db:programlisting">
        <source lang="lisp">
            <xsl:value-of select="." />
        </source>
    </xsl:template>
</xsl:stylesheet>
