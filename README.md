# bepress-crossref-doi

This project can help repository managers and journal editors using the bepress Digital Commons system to automate DOI generation and crosswalk bepress XML for upload to the CrossRef database.

#DC_CrossRef.xsl

This XSL stylesheet transforms OAI-PMH XML from the bepress Digital Commons platform to CrossRef XML schema. It can be used to register DOIs with CrossRef in batches.

It uses ‘document export’ version of the bepress OAI XML, base URL is http://[your IR URL]/do/oai/?metadataPrefix=document-export&verb=ListRecords&set=publication:[collection label]

To obtain XML data for a particular issue only, append URL with volume and issue number, e.g. http://[your IR URL]/do/oai/?metadataPrefix=document-export&verb=ListRecords&set=publication:[collection label]/vol38/iss7/

You must remove "xsi:schemaLocation="http://www.openarchives.org/OAI/2.0/   http://www.openarchives.org/OAI/2.0/OAI-PMH.xsd" from top row (after "<OAI-PMH ") in your XML document for this stylesheet to work.

A list of constants you need to change before use:

•         Line 49, 51: depositor name and email_address
•         Line 54: Registrant
•         Line 60-62: journal_metadata, full_title, abbrev_title, issn

Here’s a screencast of how to do the transformation in Oxygen http://screencast.com/t/midcn168s

#DOI_Generator.xlsm

This is an Excel spreadsheet that generates unique DOIs. It was developed using VBA in Excel 2010, I haven't tested it in other versions. If you have a different way to structure your DOIs, you may need to tweak the code. 

Type in your institution prefix in B2, journal title abbreviation in C2, then enter the year, vol no., issue no., and the number of articles in this issue to generate a list of unique DOIs for an issue. These can be copied into your batch upload/revise spreadsheet and uploaded via batch revision workflow in the DC repository.
