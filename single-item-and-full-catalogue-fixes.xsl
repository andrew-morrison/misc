<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:ns2="http://www.w3.org/1999/xlink"
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:ead="urn:isbn:1-931666-22-9"
    xmlns="urn:isbn:1-931666-22-9"
    exclude-result-prefixes="xs ead ns2" 
    version="3.0">
    
    <xsl:output method="xml" encoding="UTF-8" version="1.0" indent="yes"/>
    <xsl:strip-space elements="*"/>
    
    
    <!-- Global variables -->
    <xsl:variable name="isfullcat" as="xs:boolean" select="boolean(/ead:ead/ead:archdesc/ead:dsc/ead:*)"/>
    <xsl:variable name="issingleitem" as="xs:boolean" select="boolean(/ead:ead/ead:archdesc/@level = 'item')"/>
    <xsl:variable name="unicodemap" as="map(xs:string, xs:string)">
        <xsl:map>
            <xsl:map-entry key="'x00C0'" select="'À'"/>
            <xsl:map-entry key="'x00C2'" select="'Â'"/>
            <xsl:map-entry key="'x00C4'" select="'Ä'"/>
            <xsl:map-entry key="'x00C7'" select="'Ç'"/>
            <xsl:map-entry key="'x00C9'" select="'É'"/>
            <xsl:map-entry key="'x00D3'" select="'Ó'"/>
            <xsl:map-entry key="'x00D6'" select="'Ö'"/>
            <xsl:map-entry key="'x00D8'" select="'Ø'"/>
            <xsl:map-entry key="'x00E0'" select="'à'"/>
            <xsl:map-entry key="'x00E1'" select="'á'"/>
            <xsl:map-entry key="'x00E2'" select="'â'"/>
            <xsl:map-entry key="'x00E3'" select="'ã'"/>
            <xsl:map-entry key="'x00E4'" select="'ä'"/>
            <xsl:map-entry key="'x00E6'" select="'æ'"/>
            <xsl:map-entry key="'x00E7'" select="'ç'"/>
            <xsl:map-entry key="'x00E8'" select="'è'"/>
            <xsl:map-entry key="'x00E9'" select="'é'"/>
            <xsl:map-entry key="'x00EA'" select="'ê'"/>
            <xsl:map-entry key="'x00EB'" select="'ë'"/>
            <xsl:map-entry key="'x00ED'" select="'í'"/>
            <xsl:map-entry key="'x00EF'" select="'ï'"/>
            <xsl:map-entry key="'x00F1'" select="'ñ'"/>
            <xsl:map-entry key="'x00F3'" select="'ó'"/>
            <xsl:map-entry key="'x00F4'" select="'ô'"/>
            <xsl:map-entry key="'x00F6'" select="'ö'"/>
            <xsl:map-entry key="'x00F8'" select="'ø'"/>
            <xsl:map-entry key="'x00F9'" select="'ù'"/>
            <xsl:map-entry key="'x00FB'" select="'û'"/>
            <xsl:map-entry key="'x00FC'" select="'ü'"/>
            <xsl:map-entry key="'x0105'" select="'ą'"/>
            <xsl:map-entry key="'x0107'" select="'ć'"/>
            <xsl:map-entry key="'x010C'" select="'Č'"/>
            <xsl:map-entry key="'x010D'" select="'č'"/>
            <xsl:map-entry key="'x011B'" select="'ě'"/>
            <xsl:map-entry key="'x0142'" select="'ł'"/>
            <xsl:map-entry key="'x0159'" select="'ř'"/>
            <xsl:map-entry key="'x015F'" select="'ş'"/>
            <xsl:map-entry key="'x0161'" select="'š'"/>
            <xsl:map-entry key="'x017D'" select="'Ž'"/>
            <xsl:map-entry key="'x017E'" select="'ž'"/>
            <xsl:map-entry key="'x1ef7'" select="'ỷ'"/>
        </xsl:map>
    </xsl:variable>
    
    <!-- Root template -->
    
    <xsl:template match="/">
        <xsl:copy-of select="'&#10;'"/>
        <xsl:apply-templates/>
        <xsl:copy-of select="'&#10;'"/>
    </xsl:template>
    
    
    <!-- The following templates perform the transformations requested -->
    
    <!-- Change 1: Add xlink namespace prefix (does not remove ns2, which seems to be impossible, 
         but the two can co-exist, and the ArchivesSpace EAD importer shouldn't care)-->
    <xsl:template match="ead:ead">
        <xsl:copy>
            <xsl:namespace name="xlink">http://www.w3.org/1999/xlink</xsl:namespace>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    
    <!-- Change 2 for both -->
    
    <xsl:template match="ead:titleproper/ead:num"/>
    
    
    <!-- Change 3 for both -->
    
    <xsl:template match="ead:publicationstmt/ead:publisher | ead:publicationstmt/ead:address"/>
    
    <xsl:template match="ead:publicationstmt[count(*[not(self::ead:publisher or self::ead:address)]) eq 0]"/>
    
    
    <!-- Change 4 for both -->
    
    <xsl:template match="ead:profiledesc/ead:creation"/>
    
    
    <!-- Change 5 for full catalogues (also apply to single items): Delete repository -->
    
    <xsl:template match="ead:archdesc/ead:did/ead:repository"/>
    
    
    <!-- Change 5 for single items, change 6 for full catalogues: Delete heads in certain elements. 
         If the head is the only child, delete the whole thing (otherwise it'd be invalid EAD) -->
    
    <xsl:template match="(ead:abstract|ead:altformavail|ead:arrangement|ead:bioghist|ead:custodhist|ead:scopecontent|ead:accessrestrict|ead:prefercite|ead:acqinfo|ead:bibliography|ead:userestrict|ead:relatedmaterial|ead:separatedmaterial|ead:originalsloc|ead:otherfindaid)/ead:head"/>
    
    <xsl:template match="(ead:abstract|ead:altformavail|ead:arrangement|ead:bioghist|ead:custodhist|ead:scopecontent|ead:accessrestrict|ead:prefercite|ead:acqinfo|ead:bibliography|ead:userestrict|ead:relatedmaterial|ead:separatedmaterial|ead:originalsloc|ead:otherfindaid)[count(child::*[not(self::ead:head)]) eq 0 and string-length(normalize-space(string())) eq 0]"/>
    
    
    <!-- Change 6 for single items, change 7 for full catalogues -->
    
    <xsl:template match="ead:langmaterial/@label"/>
    
    
    <!-- Change 7 and 8 for single items, changes 8 and 9 for full catalogues -->
    
    <xsl:template match="ead:physdesc/@label"/>
    
    
    <!-- Change 10 (was for full catalogues only, now single items too): Ensure extent, physfacet and 
         dimensions are each in their own physdesc parent -->
    
    <xsl:template match="ead:physdesc[count(ead:extent|ead:physfacet|ead:dimensions) gt 1]">
        <xsl:if test="ead:extent">
            <xsl:copy>
                <xsl:apply-templates select="ead:extent"/>
            </xsl:copy>
        </xsl:if>
        <xsl:if test="ead:physfacet">
            <xsl:copy>
                <xsl:apply-templates select="ead:physfacet"/>
            </xsl:copy>
        </xsl:if>
        <xsl:if test="ead:dimensions">
            <xsl:copy>
                <xsl:apply-templates select="ead:dimensions"/>
            </xsl:copy>
        </xsl:if>
        <xsl:if test="*[not(self::ead:extent or self::ead:physfacet or self::ead:dimensions)]">
            <xsl:copy>
                <xsl:apply-templates select="*[not(self::ead:extent or self::ead:physfacet or self::ead:dimensions)]"/>
            </xsl:copy>
        </xsl:if>
    </xsl:template>
    
    
    <!-- Change 9 for single items, change 11 for full catalogues-->
    
    <xsl:template match="ead:title/@render[. = 'italic']"/>
    
    
    <!-- Change 10 for single items, change 12 for full catalogues: Renaming the namespace prefix for XLink attributes-->
    <xsl:template match="ead:extref">
        <xsl:element name="extref" namespace="urn:isbn:1-931666-22-9">
            <xsl:for-each select="@ns2:*">
                <xsl:attribute name="xlink:{ local-name(.) }" select="."/>
            </xsl:for-each>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>
    
    
    <!-- Change 11 for single items, change 13 for full catalogues: Convert physloc to container -->
    
    <xsl:template match="ead:physloc">
        <container altrender="unknown box type" type="box">
            <xsl:attribute name="label">
                <xsl:text>Mixed Materials [</xsl:text>
                <xsl:value-of select="normalize-space(string())"/>
                <xsl:text>]</xsl:text>
            </xsl:attribute>
            <xsl:value-of select="normalize-space(string())"/>
        </container>
    </xsl:template>
    
    
    <!-- Change 14 for full catalogues only: Adjust existing containers
         2020-06-15: Added extra space normalization -->
    
    <xsl:template match="ead:container[$isfullcat]">
        <xsl:choose>
            <xsl:when test="not(@altrender) or not(contains(@label, normalize-space(string())))">
                <xsl:variable name="barcode" as="xs:string" select="normalize-space(replace(@label, '^[^\(]+\(([^\)]+)\).*$', '$1'))"/>
                <xsl:copy>
                    <xsl:attribute name="altrender" select="normalize-space(string())"/>
                    <xsl:attribute name="label">Mixed Materials [<xsl:value-of select="$barcode"/>]</xsl:attribute>
                    <xsl:attribute name="type">box</xsl:attribute>
                    <xsl:value-of select="$barcode"/>
                </xsl:copy>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:choose>
                        <xsl:when test="child::*|comment()|processing-instruction()">
                            <xsl:apply-templates/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(string())"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:copy>
                <xsl:message>Unmodified container|<xsl:copy-of select="."/></xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- Change 12 for single items, change 15 for full catalogues: remove spurious precision in extents -->
    
    <xsl:template match="ead:extent[$issingleitem or ancestor::ead:*[@level][1]/@level = 'file']//text()">
        <xsl:analyze-string select="." regex="(\d+)\.0(\D)">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
                <xsl:value-of select="regex-group(2)"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    
    <!-- Change 16 for full catalogues only: normalize dates -->
    
    <xsl:template match="ead:unitdate[ancestor::ead:*[@level][1]/@level = ('file', 'item') and $isfullcat]">
        <xsl:variable name="datetext" as="xs:string" select="normalize-space(string(.))"/>
        <xsl:choose>
            <xsl:when test="@type = 'inclusive' and @normal">
                <!-- Good dates - do not change -->
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="@type = 'bulk'">
                <!-- Leave bulk dates as-is - they should be paired with inclusive dates -->
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="$datetext = ('n.d.', 'Date not recorded at time of cataloguing')">
                <!-- These are the preferred formats for unknown dates - do not change -->
                <xsl:copy>
                    <xsl:apply-templates select="@*"/>
                    <xsl:apply-templates/>
                </xsl:copy>
            </xsl:when>
            <xsl:when test="$datetext = ('n.d', 'n. d.','n.d.,','nd.', 'ND')">
                <!-- Normalize format variations -->
                <unitdate>n.d.</unitdate>
            </xsl:when>
            <xsl:when test="$datetext = ('Not recorded at time of cataloguing', 'Not recorded at time of catalouging', 'Not recoded at time of cataloguing', 'Date not recorded at time of cataloguing', 'not recorded at time of cataloguing', 'Not recorded at time of cataloging', 'Not recorded at time of cataloguing.', 'Not recorded at time of catalouing', 'No date recorded at time of cataloguing', 'Not recorded a time of cataloguing', 'Not known at time of cataloguing', 'Not recorded at time of cataloguing&gt;', 'No date at time of cataloguing', 'Not recorded at tnime of cataloguing')">
                <!-- Fix typos and slightly different wordings -->
                <unitdate>Date not recorded at time of cataloguing</unitdate>
            </xsl:when>
            <xsl:when test="not(@type = 'inclusive') and @normal">
                <!-- Assume all dates with a normal attribute are good, and 
                     just need to add type attribute of "inclusive" -->
                <unitdate>
                    <xsl:apply-templates select="@*[not(name()='type')]"/>
                    <xsl:attribute name="type" select="'inclusive'"/>
                    <xsl:apply-templates/>
                </unitdate>
            </xsl:when>
            <xsl:when test="matches($datetext, '\d\d/\d\d/\d\d\d\d')">
                <!-- Precise day-dates (last seen in the CPA) -->
                <xsl:variable name="year" as="xs:string" select="tokenize($datetext, '/')[last()]"/>
                <unitdate>
                    <xsl:attribute name="normal" select="concat($year, '/', $year)"/>
                    <xsl:attribute name="type" select="'inclusive'"/>
                    <xsl:apply-templates/>
                </unitdate>
                <xsl:message>Normalized|<xsl:value-of select="/ead:ead/ead:archdesc[1]/ead:did[1]/ead:unitid[1]"/>|<xsl:value-of select="ancestor-or-self::ead:*[@id][1]/@id"/>|<xsl:value-of select="$datetext"/>|<xsl:value-of select="concat($year, '/', $year)"/></xsl:message>
            </xsl:when>
            <xsl:otherwise>
                <!-- Anything else, attempt to normalize the descriptive text in unitdate
                     into YYYY/YYYY format in a normal attribute -->
                <xsl:variable name="convertpartialyearranges" as="xs:string*">
                    <!-- Pass the date text thorugh a series of pattern matching steps to 
                         deal with common date format issues. First, convert year ranges that only 
                         specify the digits that differ (e.g. 1780-5 or 1780-91) into two whole, 
                         four-digit years (e.g. 1780-1785 or 1780-1791) -->
                    <xsl:analyze-string select="$datetext" regex="(\d\d\d\d)([-–])(\d|\d\d)(\D|$)">
                        <xsl:matching-substring>
                            <xsl:variable name="startyear" as="xs:integer" select="regex-group(1) cast as xs:integer"/>
                            <xsl:variable name="endyeardigits" as="xs:integer" select="regex-group(3) cast as xs:integer"/>
                            <xsl:choose>
                                <xsl:when test="$endyeardigits le 9">
                                    <xsl:variable name="endyear" as="xs:decimal" select="(floor($startyear div 10) * 10) + $endyeardigits"/>
                                    <xsl:value-of select="concat($startyear, regex-group(2), $endyear)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:variable name="endyear" as="xs:decimal" select="(floor($startyear div 100) * 100) + $endyeardigits"/>
                                    <xsl:value-of select="concat($startyear, regex-group(2), $endyear)"/>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:value-of select="regex-group(4)"/>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:value-of select="."/>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:variable>
                <!-- Next, look for "Nth century" and convert them into year ranges -->
                <xsl:variable name="centuries2ranges" as="xs:string*">
                    <xsl:choose>
                        <xsl:when test="matches(string-join($convertpartialyearranges, ''), '(earl|mid|late)', 'i')">
                            <!-- Skip this step for "mid 19th cent" or similar -->
                            <xsl:copy-of select="$convertpartialyearranges"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:analyze-string select="string-join($convertpartialyearranges, '')" regex="(\d+)(st|nd|th) [Cc]ent(\D|$)">
                                <xsl:matching-substring>
                                    <xsl:variable name="centurynum" as="xs:integer" select="regex-group(1) cast as xs:integer"/>
                                    <xsl:variable name="startyear" as="xs:integer" select="100 * ($centurynum - 1)"/>
                                    <xsl:variable name="endyear" as="xs:integer" select="$startyear + 99"/>
                                    <xsl:value-of select="concat($startyear, '–', $endyear)"/>
                                </xsl:matching-substring>
                                <xsl:non-matching-substring>
                                    <xsl:value-of select="."/>
                                </xsl:non-matching-substring>
                            </xsl:analyze-string>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!-- Then look for decades, such as "1850s" -->
                <xsl:variable name="decades2ranges" as="xs:string" select="replace(string-join($centuries2ranges, ''), '(\d\d\d)\ds', '$10-$19')"/>
                <!-- Finally, remove the obvious days-of-the-month -->
                <xsl:variable name="noobviousdays" as="xs:string" select="replace($decades2ranges, '(^|\D)\d{1,2} (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)', '')"/>
                <!-- Convert to an array of all the digits, which could potentially be years -->
                <xsl:variable name="potentialyears" as="xs:string*" select="tokenize($noobviousdays, '\D+')[string-length(.) gt 0]"/>
                <xsl:choose>
                    <xsl:when test="count($potentialyears) gt 0 and (every $y in $potentialyears satisfies matches($y, '^\d\d\d\d$')) and not(matches($datetext, '(pre|post|after|since|before)'))">
                        <!-- If text of unitdate contains one or more four-digit strings, assume these are years. 
                             But if there are any other digits, these could be year ranges or months (e.g. "1923-9")
                             so only create a normal attribute if all are four-digit years. -->
                        <unitdate>
                            <xsl:attribute name="normal" select="concat(min($potentialyears), '/', max($potentialyears))"/>
                            <xsl:attribute name="type" select="'inclusive'"/>
                            <xsl:apply-templates/>
                        </unitdate>
                        <xsl:message>Normalized|<xsl:value-of select="/ead:ead/ead:archdesc[1]/ead:did[1]/ead:unitid[1]"/>|<xsl:value-of select="ancestor-or-self::ead:*[@id][1]/@id"/>|<xsl:value-of select="$datetext"/>|<xsl:value-of select="concat(min($potentialyears), '/', max($potentialyears))"/></xsl:message>
                    </xsl:when>
                    <xsl:otherwise>
                        <!-- Anything else, return as-is, and log it for manual fixing -->
                        <xsl:copy>
                            <xsl:apply-templates select="@*"/>
                            <xsl:apply-templates/>
                        </xsl:copy>
                        <xsl:message>Cannot normalize|<xsl:value-of select="/ead:ead/ead:archdesc[1]/ead:did[1]/ead:unitid[1]"/>|<xsl:value-of select="ancestor-or-self::ead:*[@id][1]/@id"/>|<xsl:value-of select="$datetext"/></xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <!-- Change 17 for full catalogues: Pluralize Bodleian Library in prefercite -->
    
    <xsl:template match="ead:prefercite//text()">
        <xsl:analyze-string select="." regex="Bodleian Library">
            <xsl:matching-substring>
                <xsl:text>Bodleian Libraries</xsl:text>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>
    
    
    <!-- Additional changes: fix extra/invalid spaces in attributes
         2020-06-15: Added template to fix spaces inside brackets in existing container labels -->
    
    <xsl:template match="@source[matches(., '\s')]">
        <xsl:attribute name="source" select="replace(., '\s+', '_')"/>
    </xsl:template>
    
    <xsl:template match="ead:container/@label">
        <xsl:attribute name="label">
            <xsl:value-of select="normalize-space(replace(replace(., '\s+([\]\)])', '$1'), '([\[\(])\s+', '$1'))"/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="@*">
        <xsl:copy>
            <xsl:value-of select="normalize-space(.)"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- Everything else is copied to output unchanged -->
    
    <xsl:template match="*">
        <xsl:copy>
            <xsl:apply-templates select="@*"/>
            <xsl:apply-templates/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="comment()|processing-instruction()">
        <xsl:copy/>
    </xsl:template>
    
    
    <!-- Fix broken entity references (everywhere but extent and prefercite, which are matched by 
         templates above, but are unlikely to contain any.) Only works for the codes in $unicodemap,
         anything else will be left unchanged. -->
    
    <xsl:template match="text()">
        <xsl:analyze-string select="." regex="&amp;#([^;]+);">
            <xsl:matching-substring>
                <xsl:variable name="replacement" as="xs:string*" select="$unicodemap(regex-group(1))"/>
                <xsl:choose>
                    <xsl:when test="exists($replacement)">
                        <xsl:value-of select="$replacement"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="."/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template> 
    
</xsl:stylesheet>
