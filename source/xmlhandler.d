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
    writeln("Succesfully parsed ", xmlType, " XML file");

    bool foundLine = false;
	auto attributes = xmlRange.front.attributes;
	while(!xmlRange.empty()){
		foreach(ref area; mergeArea){

			if(xmlRange.front.type == EntityType.elementStart){
				attributes = xmlRange.front.attributes;
			}

			if(!foundLine){
				while(!attributes.empty){
					if(xmlRange.front.name == area.tagName && attributes.front.name == "id" && attributes.front.value == area.tagId){
						area.start = xmlRange.front.pos.line;
						writeln("Found start of " ~ area.tagName ~ " tag with id " ~ area.tagId ~ " in line " ~ to!string(area.start) ~ "in " ~ xmlType ~ " file.");
						foundLine = true;
					}
					attributes.popFront();
				}
			}else{
				if(xmlRange.front.type == EntityType.elementEnd && xmlRange.front.name == area.tagName){
					area.stop = xmlRange.front.pos.line;
					foundLine = false;
					writeln("Found end of " ~ area.tagName ~ " tag with id " ~ area.tagId ~ " in line " ~ to!string(area.stop) ~ "in " ~ xmlType ~ " file.");
				}
			}

            if(xmlRange.empty()) break;
			xmlRange.popFront();
		}
	}
}