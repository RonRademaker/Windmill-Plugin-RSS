<?xml version='1.0'?>
<!DOCTYPE xsl:stylesheet>
<xsl:stylesheet version='1.0'
	xmlns:xsl='http://www.w3.org/1999/XSL/Transform'
	xmlns:media='http://search.yahoo.com/mrss/'
	xmlns:chap='http://www.connectholland.nl/chap/'
	xmlns:php='http://php.net/xsl'
	exclude-result-prefixes='php'>
	<!--
	Main RSS creating XSL

	Since: Fri Dec 19 2008
	Author: Niels Nijens
	-->

	<!--
	Output XML
	-->
	<xsl:output method='xml'/>

	<!--
	Create rss and channel nodes

	*match* root wmpage

	Since: Fri Dec 19 2008
	-->
	<xsl:template match='/wmpage'>
		<rss version='2.0' xmlns:media='http://search.yahoo.com/mrss/' xmlns:chap='http://www.connectholland.nl/chap/'>
			<channel>
				<xsl:apply-templates select='self::node()' mode='rssInfo'/>
				<generator>Windmill RSS Generator</generator>
				<xsl:apply-templates select='self::node()' mode='chapContent'/>
				<xsl:apply-templates select='node()' mode='rssItem'/>
			</channel>
		</rss>
	</xsl:template>

	<!--
	Add information about the channel

	*match* wmpage
	*mode* rssInfo

	Since: Fri Dec 19 2008
	-->
	<xsl:template match='wmpage' mode='rssInfo'>
		<title><xsl:apply-templates select='self::node()' mode='rssInfoTitle'/></title>
		<link><xsl:apply-templates select='self::node()' mode='rssInfoLink'/></link>
		<language><xsl:value-of select='php:function("strtolower", translate(@language, "_", "-") )'/></language>
		<copyright>Copyright (c) <xsl:value-of select='php:function("date", "Y")'/>, <xsl:value-of select='php:function("WMXSLFunctions::getHttpHost")'/></copyright>
		<description><xsl:apply-templates select='self::node()' mode='rssInfoDescription'/></description>
	</xsl:template>

	<!--
	Add the title to the channel node

	*match* wmpage
	*mode* rssInfoTitle

	Since: Fri Dec 19 2008
	-->
	<xsl:template match='wmpage' mode='rssInfoTitle'/>

	<!--
	Add the link to the channel node

	*match* wmpage
	*mode* rssInfoLink

	Since: Fri Dec 19 2008
	-->
	<xsl:template match='wmpage' mode='rssInfoLink'>
		<xsl:text>http://</xsl:text>
		<xsl:value-of select='php:function("WMXSLFunctions::getHttpHost")'/>
	</xsl:template>

	<!--
	Add the description to the channel node

	*match* wmpage
	*mode* rssInfoDescription

	Since: Fri Dec 19 2008
	-->
	<xsl:template match='wmpage' mode='rssInfoDescription'/>

	<!--
	Add CHAP content to the channel node

	*match* wmpage
	*mode* chapContent

	Since: Tue Dec 23 2008
	-->
	<xsl:template match='wmpage' mode='chapContent'/>

	<!--
	Adds the nodes of this node (module tagname) as item to the channel

	*match* node()
	*mode* rssItem

	Since: Fri Dec 19 2008
	-->
	<xsl:template match='node()' mode='rssItem'>
		<xsl:apply-templates select='node()' mode='rssItem'/>
	</xsl:template>
	<xsl:template match='query | pager | user | aeroplane' mode='rssItem'/>

	<!--
	Adds nodes containing name or title as item to the channel

	*match* node()[name or title]
	*mode* rssItem
	*name* rssItem

	Since: Fri Dec 19 2008
	-->
	<xsl:template match='node()[name or title]' mode='rssItem' name='rssItemDefault'>
		<item>
			<title><xsl:apply-templates select='self::node()' mode='rssItemTitle'/></title>
			<link><xsl:apply-templates select='self::node()' mode='rssItemLink'/></link>
			<category><xsl:apply-templates select='self::node()' mode='rssItemCategory'/></category>
			<description>
				<xsl:apply-templates select='contentblocks' mode='rssItemDescription'/>
			</description>
			<xsl:apply-templates select='self::node()' mode='chapContent'/>
			<xsl:apply-templates select='contentblocks' mode='rssItemMedia'/>
		</item>
	</xsl:template>

	<!--
	Adds nodes containing @collection as item to the channel
	Collection RSS

	*match* node()[@collection]
	*mode* rssItem

	Since: Tue Dec 30 2008
	-->
	<xsl:template match='node()[@collection]' mode='rssItem'>
		<item>
			<title><xsl:apply-templates select='self::node()' mode='rssItemTitle'/></title>
			<link><xsl:apply-templates select='self::node()' mode='rssItemLink'/></link>
			<category><xsl:apply-templates select='self::node()' mode='rssItemCategory'/></category>
			<description>
				<xsl:apply-templates select='contentblocks' mode='rssItemDescription'/>
			</description>
			<xsl:apply-templates select='self::node()' mode='chapContent'/>
			<xsl:apply-templates select='contentblocks' mode='rssItemMedia'/>
		</item>
	</xsl:template>

	<!--
	Adds content to the title node of an item

	*match* node()
	*mode* rssItemTitle

	Since: Tue Jan 13 2009
	-->
	<xsl:template match='node()' mode='rssItemTitle'>
		<xsl:value-of select='title | name | @collection'/>
	</xsl:template>

	<!--
	Adds content to the link node of an item

	*match* node()
	*mode* rssItemLink

	Since: Fri Dec 19 2008
	-->
	<xsl:template match='node()' mode='rssItemLink'>
		<xsl:apply-templates select='parent::node()/parent::node()' mode='rssInfoLink'/>
	</xsl:template>

	<!--
	Adds content to the link node of an item
	Collection RSS

	*match* node()[@collection]
	*mode* rssItemLink

	Since: Tue Dec 30 2008
	-->
	<xsl:template match='node()[@collection]' mode='rssItemLink'>
		<xsl:apply-templates select='parent::node()/parent::node()' mode='rssInfoLink'/>
		<xsl:value-of select='contentblocks/contentblock[link]/link'/>
	</xsl:template>

	<!--
	Adds content to the category node of an item

	*match* node()
	*mode* rssItemCategory

	Since: Fri Dec 19 2008
	-->
	<xsl:template match='node()' mode='rssItemCategory'/>

	<!--
	Adds content to the description node of an item

	*match* contentblocks
	*mode* rssItemDescription

	Since: Fri Dec 19 2008
	-->
	<xsl:template match='contentblocks' mode='rssItemDescription'>
		<xsl:apply-templates select='contentblock' mode='rssItemDescription'/>
	</xsl:template>

	<!--
	Adds content to the description node of an item

	*match* contentblock[contentblocktemplate/name = "text"] | contentblock[contentblocktemplate/name = "textphoto"] | contentblock[node()[@contenttype = "richtext"] ]
	*mode* rssItemDescription

	Since: Fri Dec 19 2008
	-->
	<xsl:template match='contentblock[contentblocktemplate/name = "text"] | contentblock[contentblocktemplate/name = "textphoto"] | contentblock[node()[@contenttype = "richtext"] ]' mode='rssItemDescription'>
		<xsl:value-of select='text | node()[@contenttype = "richtext"]'/>
	</xsl:template>
	<xsl:template match='contentblock' mode='rssItemDescription'/>

	<!--
	Adds CHAP content to an item node

	*match* node()[name or title]
	*mode* chapContent

	Since: Tue Dec 23 2008
	-->
	<xsl:template match='node()[name or title]' mode='chapContent'/>

	<!--
	Adds a media group to an item

	*match* contentblocks[count(contentblock[node()[@contenttype="image" or @contenttype="video"] ]) &gt; 0]
	*mode* rssItemMedia

	Since: Fri Dec 19 2008
	-->
	<xsl:template match='contentblocks[count(contentblock[node()[@contenttype="image" or @contenttype="video"] ]) &gt; 0]' mode='rssItemMedia'>
		<media:group>
			<xsl:apply-templates select='contentblock' mode='rssItemMedia'/>
		</media:group>
	</xsl:template>
	<xsl:template match='contentblocks' mode='rssItemMedia'/>

	<!--
	Adds media to an item

	*match* contentblock[contentblocktemplate/name = "text"] | contentblock[contentblocktemplate/name = "textphoto"]
	*mode* rssItemDescription

	Since: Fri Dec 19 2008
	-->
	<xsl:template match='contentblock' mode='rssItemMedia'>
		<xsl:apply-templates select='node()' mode='rssItemMedia'/>
	</xsl:template>

	<!--
	Adds media items under a contentgroup

	*match* node()[@contenttype = "group"]"
	*mode* rssItemMedia

	Since: Mon Jul 18 2011
	-->
	<xsl:template match='node()[@contenttype = "group"]' mode='rssItemMedia'>
		<xsl:apply-templates select='node()' mode='rssItemMedia'/>
	</xsl:template>

	<!--
	Adds a media content to the media group of an item

	*match* node()[@contenttype = "image" or @contenttype = "video"]
	*mode* rssItemMedia

	Since: Fri Dec 19 2008
	-->
	<xsl:template match='node()[@contenttype = "image" or @contenttype = "video"]' mode='rssItemMedia'>
		<media:content>
			<xsl:apply-templates select='self::node()' mode='rssItemMediaType'/>
			<xsl:apply-templates select='self::node()' mode='rssItemMediaMedium'/>
			<xsl:apply-templates select='self::node()' mode='rssItemMediaURL'/>
		</media:content>
	</xsl:template>
	<xsl:template match='node()' mode='rssItemMedia'/>

	<!--
	Adds the type attribute to the media content
	(This kind of mime-type checking is not very good. Needs improvement, but will do for now)

	*match* node()[@contenttype = "image"]
	*mode* rssItemMediaType

	Since: Fri Dec 19 2008
	-->
	<xsl:template match='node()[@contenttype = "image"]' mode='rssItemMediaType'>
		<xsl:attribute name='type'>image/jpeg</xsl:attribute>
	</xsl:template>
	<xsl:template match='node()[@contenttype = "image" and php:function("WMString::endsWith", string(self::node() ), ".gif")]' mode='rssItemMediaType'>
		<xsl:attribute name='type'>image/gif</xsl:attribute>
	</xsl:template>
	<xsl:template match='node()[@contenttype = "video"]' mode='rssItemMediaType'>
		<xsl:attribute name='type'>video/x-flv</xsl:attribute>
	</xsl:template>
	<xsl:template match='node()' mode='rssItemMediaType'/>

	<!--
	Adds the medium attribute to the media content

	*match* node()[@contenttype = "image"]
	*mode* rssItemMediaMedium

	Since: Fri Dec 19 2008
	-->
	<xsl:template match='node()[@contenttype = "image"]' mode='rssItemMediaMedium'>
		<xsl:attribute name='medium'>image</xsl:attribute>
	</xsl:template>
	<xsl:template match='node()[@contenttype = "video"]' mode='rssItemMediaMedium'>
		<xsl:attribute name='medium'>video</xsl:attribute>
	</xsl:template>
	<xsl:template match='node()' mode='rssItemMediaMedium'/>

	<!--
	Adds the url attribute to the media content

	*match* node()
	*mode* rssItemMediaURL

	Since: Fri Dec 19 2008
	-->
	<xsl:template match='node()' mode='rssItemMediaURL'>
		<xsl:attribute name='url'>
			<xsl:text>http://</xsl:text>
			<xsl:value-of select='php:function("WMXSLFunctions::getHttpHost")'/>
			<xsl:apply-templates select='self::node()' mode='rssItemMediaURLPrefix'/>
			<xsl:value-of select='self::node()'/>
		</xsl:attribute>
	</xsl:template>

	<!--
	Adds the url possibility to add resizer or download commands to the url

	*match* node()
	*mode* rssItemMediaURLPrefix

	Since: Tue Sep 29 2009
	-->
	<xsl:template match='node()' mode='rssItemMediaURLPrefix'/>

</xsl:stylesheet>
