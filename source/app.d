import std.stdio, std.typecons;
import jsonhandler, xmlhandler;
import dxml.parser;

void main()
{
	auto sourceChangedScopes = new ChangeScope();
	auto destChangedScopes = new ChangeScope();

	string sourceFileContent, destFileContent;
	getXmlContent(sourceFileContent, destFileContent, sourceChangedScopes.sourcePath, sourceChangedScopes.destPath);
	findMergeAreas(sourceFileContent, sourceChangedScopes.mergeArea, "source");
	findMergeAreas(destFileContent, destChangedScopes.mergeArea, "destination");

	writeln(sourceChangedScopes.mergeArea);
	writeln(destChangedScopes.mergeArea);
}