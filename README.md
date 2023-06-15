# XML Merging Tool
 XML merging tool written in D
This tool is designed for merging large XML documents that are for example used in bigger application to store data about their structure.
What's special about this tool is that it uses D programming language meta-programming features which make this tool easy scalable and
customizable for different XML documents. 
Developer can choose which tags should be served by his version of tool just by modifying config.json - the application will adjust it's code.
It also makes application able to skip parts that are not supposed to be merged and therefore make it work faster.
Moreover developer is forced to rethink the changes he wants to merge by putting tag's ids into configuration json file.
