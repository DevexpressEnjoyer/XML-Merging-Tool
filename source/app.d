import std.stdio, std.typecons, std.file, std.string, std.conv;
import jsonhandler, xmlhandler, mergesource;
import dxml.parser;

void main()
{
	auto sourceChangedScopes = new ChangeScope();
	auto destChangedScopes = new ChangeScope();

	string sourceFileContent, destFileContent;
	getXmlContent(sourceFileContent, destFileContent, sourceChangedScopes.sourcePath, sourceChangedScopes.destPath);
	findMergeAreas(sourceFileContent, sourceChangedScopes.mergeArea, "source");
	findMergeAreas(destFileContent, destChangedScopes.mergeArea, "destination");

	if(sourceChangedScopes.mergeArea.length != destChangedScopes.mergeArea.length) writeln("WARNING: Number or tags found is different for both files!");
	writeln("\nStart merging...");

	merge(sourceChangedScopes.sourcePath, sourceChangedScopes.destPath, sourceChangedScopes.mergeArea, destChangedScopes.mergeArea);
}