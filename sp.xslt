<?xml version='1.0'?>
<!-- 
OpenSearchProviderToHTML
http://deletethis.net/dave/search/sp.html

Copyright (c) 2009 David Risney

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.
                
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
-->
<xsl:stylesheet version='1.0'  
 xmlns:xsl='http://www.w3.org/1999/XSL/Transform' 
 xmlns:os='http://a9.com/-/spec/opensearch/1.1/' >
    <xsl:output method="html"/>
    <xsl:template match="os:OpenSearchDescription">
        <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html></xsl:text>
        <html>
            <head>
                <xsl:if test="os:Image[@type='image/vnd.microsoft.icon']">
                    <link rel="shortcut icon" href="{os:Image[@type='image/vnd.microsoft.icon']}"/>
                </xsl:if>
		<link rel="search" type="application/opensearchdescription+xml" href="#" title="{os:ShortName}"/>

                <script>
                    function canInstallSearchProvider() {
                        var installable = false;
                        try {
                            window.external.AddSearchProvider("");
                        }
                        catch (e) {
                            installable = e.message === "Permission denied";
                        }
			return installable;
                    }

                    function installSearchProvider(searchProvider) {
                        if (window.external &amp;&amp; ("AddSearchProvider" in window.external)) {
                            window.external.AddSearchProvider(searchProvider);
                        }
                        else {
                            alert('Your browser does not support the installation of OpenSearch descriptions.');
                        }
                    }

                    function doSearch(searchTerm, searchUrlTemplate) {
                        location = searchUrlTemplate
                            .replace(/\{searchTerms\??\}/g, encodeURIComponent(searchTerm))
                            .replace(/\{count\??\}/g, "50")
                            .replace(/\{startIndex\??\}/g, "1")
                            .replace(/\{startPage\??\}/g, "1")
                            .replace(/\{language\??\}/g, "*")
                            .replace(/\{inputEncoding\??\}/g, "UTF-8")
                            .replace(/\{outputEncoding\??\}/g, "UTF-8")
                            .replace(/\{[^\}]*\}/g, "");
                    }

                    document.addEventListener("DOMContentLoaded", function() {
                        if (canInstallSearchProvider()) {
                            document.getElementsByTagName("html").className += " installable";
                        }
                    });
                </script>

                <style>
                    body { font-family: sans-serif; }
                    blockquote { font-style: italic; }
                    img { vertical-align: middle; margin: 2pt; }
                    p, blockquote, form { margin-left: 30pt; }
                    input[type='text'] { width: 50%; }
		    .installText { display: none; }
		    .installable .installText { display: block; }
                </style>
            </head>
            <body>
                <h1>
                    <xsl:choose>
                        <xsl:when test="os:ShortName">
                            <xsl:value-of select="os:ShortName"/>
                        </xsl:when>
                        <xsl:otherwise>OpenSearch Description</xsl:otherwise>
                    </xsl:choose>
                </h1>
                <xsl:if test="os:Description or os:Image">
                    <blockquote>
                        <xsl:if test="os:Image">
                            <img src="{os:Image}"/>
                        </xsl:if>
                        <xsl:value-of select="os:Description"/>
                    </blockquote>
                </xsl:if>
                <h2>Install</h2>
                <p class="installText">Using the following link, you may <a href='javascript:installSearchProvider(location)'>install this OpenSearch description.</a></p>
                <xsl:if test='os:Url'>
                    <h2>Search</h2>
                    <xsl:apply-templates select='os:Url[@rel="results" or not(@rel)]'/>
                </xsl:if>
                <h2>About</h2>
                <p>This document was generated by the <a href="http://deletethis.net/dave/search/sp.html">OpenSearchDescriptionToHTML tool</a> 
                created by <a href="http://deletethis.net/dave/">David Risney</a>.  
                The tool is available under the <a href="http://deletethis.net/dave/search/sp.html#license">MIT license</a>.</p>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="os:Url">
        <xsl:variable name="resultsTypeName">
           <xsl:choose>
               <xsl:when test="not(@type) or @type='text/html'">HTML results</xsl:when>
               <xsl:when test="@type='application/rss+xml' or @type='application/atom+xml'">feed results</xsl:when>
               <xsl:otherwise><xsl:value-of select="@type"/> results</xsl:otherwise>
           </xsl:choose>
        </xsl:variable>
        <form onsubmit='doSearch({generate-id(.)}SearchInput.value, "{@template}"); return false;'>
            <input type='text' name='{generate-id(.)}SearchInput' value='{//os:Query[@role="example"]/@searchTerms}'/>
            <input type='submit' value='Search with {$resultsTypeName}' />
        </form>
    </xsl:template>
</xsl:stylesheet>
