# OpenSearchProviderToHTML

## About

This is an XSLT to reference from your [OpenSearch provider XML](http://www.opensearch.org/Home) that renders it as an HTML page with the following features:

 - Search with the provider.
 - Install the provider.
 - Describe the provider file.

## Usage

Copy sp.xslt to the same origin as your provider XML file. 
Add the following line to the top of your OpenSearch provider XML.

    <?xml-stylesheet href="sp.xslt" type="text/xsl"?>

## License

Available under the [MIT license](LICENSE).
