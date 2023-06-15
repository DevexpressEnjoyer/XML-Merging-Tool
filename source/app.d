import std.stdio, std.typecons;
import jsonhandler, xmlhandler;
import dxml.parser;

alias mergeArea = Tuple!(uint, "start", uint, "stop", string, "tagName", string, "tagId");

void main()
{
	writeln("Hello, world!");
	auto changedScopes = new ChangeScope();

	string sourceFileContent, destFileContent;
	getXmlContent(sourceFileContent, destFileContent, changedScopes.sourcePath, changedScopes.destPath);

	auto sourceXml = parseXML!simpleXML(sourceFileContent);
	auto destXml = parseXML!simpleXML(destFileContent);

	mergeArea[] mergeAreas;

	writeln(changedScopes.viewmodels, "   ", changedScopes.existViewmodels);
	writeln(changedScopes.models, "   ", changedScopes.existModels);
}