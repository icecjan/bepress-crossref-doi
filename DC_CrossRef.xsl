<?xml version="1.0" encoding="UTF-8"?>
<!-- ======================================================== -->
<!--    This stylesheet transforms OAI XML data to CrossRef XML. 
        It can be used to register DOIs with CrossRef in batches.
        
        Base URL for AJTE
        http://ro.ecu.edu.au/do/oai/?metadataPrefix=document-export&verb=ListRecords&set=publication:ajte
        
        To obtain XML data for a particular issue only, append URL with volume and issue number, e.g.
        http://ro.ecu.edu.au/do/oai/?metadataPrefix=document-export&verb=ListRecords&set=publication:ajte/vol38/iss7/
        
        Save as .xml document.
        
        You must remove "xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/   http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd" 
        from top row (after "<OAI-PMH ") in your XML document for this stylesheet to work.
        
        Transformer SAXON HE 9.5.0.2
        
        Created by Janice Chan 01 July 2013, Edith Cowan University
-->
<!-- ======================================================== -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    version="1.0">
        
<xsl:output method="xml" 
            indent="yes" 
            encoding="UTF-8"/>  
        
<xsl:template match="/">
        
<doi_batch version="4.3.0" xmlns="http://www.crossref.org/schema/4.3.0"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
        xsi:schemaLocation="http://www.crossref.org/schema/4.3.0 http://www.crossref.org/schema/deposit/crossref4.3.0.xsd">
        
        <xsl:variable name="date" select="adjust-date-to-timezone(current-date(), ())"/>
        <xsl:variable name="time" select="adjust-time-to-timezone(current-time(), ())"/>
        <xsl:variable name="tempdatetime" select="concat($date,'',$time)"/>
        <xsl:variable name="datetime" select="translate($tempdatetime,':-.','')"/>
        
        <head>
        <doi_batch_id>
                <xsl:value-of select="$datetime"/>
        </doi_batch_id>        
            <timestamp>
                    <xsl:value-of select="$datetime"/>
            </timestamp>
        <depositor>
            <!--Enter your name-->
                <name>your name</name>
                <!--Enter your email address here-->
                <email_address>your@email.address</email_address>
        </depositor>
        <!--Enter institution-->
        <registrant>Your institution name</registrant>
    </head>
        <body>
                <journal>
                        <journal_metadata>
                            <!--Enter journal title, abbrev title, and ISSN-->
                                <full_title>full title</full_title>
                                <abbrev_title>Abrev. Title.</abbrev_title>
                                <issn media_type="electronic">Enter ISSN</issn>
                        </journal_metadata>   
                
                <journal_issue>
                        <publication_date media_type="online">
                                <xsl:variable name="datestr">
                                        <xsl:value-of select="OAI-PMH/ListRecords/record[1]/metadata/document-export/documents/document/publication-date"/>
                                </xsl:variable>
                                <month>
                                        <xsl:value-of select="substring($datestr, 6, 2)"/>
                                </month>
                                <day>
                                        <xsl:value-of select="substring($datestr, 9, 2)"/>
                                </day>
                                <year>
                                        <xsl:value-of select="substring($datestr, 1, 4)"/>
                                </year>
                        </publication_date>
                        <!-- pick up string with vol and iss number -->
                        <xsl:variable name="voliss">
                                <xsl:value-of select="OAI-PMH/request/@set"/>
                        </xsl:variable>
                        <!-- get string after 'vol' -->
                        <xsl:variable name="vol_trim">
                                <xsl:value-of select="substring-after($voliss, 'vol')"/>
                        </xsl:variable>
                        <!-- get string after 'iss' -->
                        <xsl:variable name="iss_trim">
                                <xsl:value-of select="substring-after($voliss, 'iss')"/>
                        </xsl:variable>
                        <journal_volume>
                                <volume>
                                        <!-- get string before '/' -->
                                        <xsl:value-of select="substring-before($vol_trim, '/')" />
                                </volume>
                        </journal_volume>
                        <issue>
                                <!-- get string before '/' -->
                                <xsl:value-of select="substring-before($iss_trim, '/')" />
                        </issue>
                </journal_issue>
                <!-- ============== -->
                <xsl:for-each select="OAI-PMH/ListRecords/record/metadata/document-export/documents/document">
                <journal_article publication_type="full_text">
                        <titles>
                                <title>
                                        <xsl:value-of select="title"/>
                                </title>
                        </titles>
                        
                        <contributors>
                                <xsl:for-each select="authors/author">
                                <xsl:if test="position()=1">
                                <person_name sequence="first" contributor_role="author">
                                        <given_name>
                                                <xsl:variable name="given_names">
                                                        <xsl:choose>
                                                                <xsl:when test="mname != ''">
                                                                        <xsl:value-of select="concat(fname, ' ', mname)"/>
                                                                </xsl:when>
                                                                <xsl:otherwise>
                                                                        <xsl:value-of select="fname"/>
                                                                </xsl:otherwise>
                                                        </xsl:choose>
                                                </xsl:variable>
                                                <xsl:value-of select="$given_names"/>
                                        </given_name>
                                        <surname>
                                                <xsl:value-of select="lname"/>
                                        </surname>
                                        <affiliation>
                                                <xsl:choose>
                                                        <xsl:when test="institution!=''">
                                                                <xsl:value-of select="institution"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                None
                                                        </xsl:otherwise>
                                                </xsl:choose> 
                                        </affiliation>
                                </person_name>
                                </xsl:if>
                                <xsl:if test="position()>1">
                                <person_name sequence="additional" contributor_role="author">
                                        <given_name>
                                                <xsl:variable name="given_names">
                                                <xsl:choose>
                                                        <xsl:when test="mname > 0">
                                                                <xsl:value-of select="concat(fname, ' ', mname)"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                <xsl:value-of select="fname"/>
                                                        </xsl:otherwise>
                                                </xsl:choose>
                                                </xsl:variable>
                                                <xsl:value-of select="$given_names"/>
                                        </given_name>
                                        <surname>
                                                <xsl:value-of select="lname"/>
                                        </surname>
                                        <affiliation>
                                                <xsl:choose>
                                                        <xsl:when test="institution!=''">
                                                                <xsl:value-of select="institution"/>
                                                        </xsl:when>
                                                        <xsl:otherwise>
                                                                None
                                                        </xsl:otherwise>
                                                </xsl:choose> 
                                        </affiliation>
                                </person_name>        
                                </xsl:if> 
                                </xsl:for-each>
                        </contributors>
                        <publication_date media_type="online">
                                <xsl:variable name="datestr">
                                        <xsl:value-of select="publication-date"/>
                                </xsl:variable>
                                <month>
                                        <xsl:value-of select="substring($datestr, 6, 2)"/>
                                </month>
                                <day>
                                        <xsl:value-of select="substring($datestr, 9, 2)"/>
                                </day>
                                <year>
                                        <xsl:value-of select="substring($datestr, 1, 4)"/>
                                </year>
                        </publication_date>
                        <doi_data>
                                <doi>
                                        <xsl:value-of select="fields/field[@name='doi']"/>
                                </doi>
                                <resource>
                                        <xsl:value-of select="coverpage-url" />
                                </resource>
                        </doi_data>
                </journal_article>
                
                
                </xsl:for-each>
                </journal>
        </body>
</doi_batch>    
</xsl:template>
</xsl:stylesheet>
