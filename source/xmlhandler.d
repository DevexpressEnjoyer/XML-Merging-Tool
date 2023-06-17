import std.stdio, std.file, std.conv;
import app, jsonhandler;
import dxml.parser;

void getXmlContent(ref string source, ref string dest, string sourcePath, string destPath){
    auto sourceFile = File(sourcePath, "r");

    while(!sourceFile.eof()){
        source ~= sourceFile.readln();
    }

    sourceFile.close();
    auto destFile = File(destPath, "r");

    while(!destFile.eof()){
        dest ~= destFile.readln();
    }

    destFile.close();
}

void findMergeAreas(string xmlContent, ref MergeArea[] mergeArea, string xmlType){
    auto xmlRange = parseXML!simpleXML(xmlContent);
    writeln("\nSuccesfully parsed ", xmlType, " XML file, tags found:");
	bool foundEnd = false;
	auto attributes = xmlRange.front.attributes;

	foreach(ref area; mergeArea){
		foundEnd = false;
		xmlRange = parseXML!simpleXML(xmlContent);
		while(!xmlRange.empty()){
			if(xmlRange.front.type == EntityType.elementStart && xmlRange.front.name == area.tagName){
				attributes = xmlRange.front.attributes;
				while(!attributes.empty){
					if(attributes.front.name == "id" && attributes.front.value == area.tagId){
						writeln("Found start tag ", xmlRange.front.name, " with id ", attributes.front.value, " in line ", xmlRange.front.pos.line);
						area.start = xmlRange.front.pos.line;
						break;
					}
					attributes.popFront();
				}
			}
			if(area.start != 0){
				while(!xmlRange.empty() && !foundEnd){
					if(xmlRange.front.type == EntityType.elementEnd && xmlRange.front.name == area.tagName){
						writeln("Found end tag ", xmlRange.front.name, " with id ", attributes.front.value, " in line ", xmlRange.front.pos.line);
						area.stop = xmlRange.front.pos.line;
					}
					if(area.stop == 0) xmlRange.popFront();
					else{
						foundEnd = true;
					}
				}
			}

			if(area.stop != 0){
				break;
			}

			xmlRange.popFront();
		}
	}
}