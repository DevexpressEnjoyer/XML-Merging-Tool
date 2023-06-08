import std.stdio, std.conv;
import std.json;
import jsonhandler;

void main()
{
	writeln("Hello, world!");

	auto changedScopes = new ChangeScope();

	writeln(changedScopes.refdata, "   ", changedScopes.existRefdata);
	writeln(changedScopes.viewmodels, "   ", changedScopes.existViewmodels);
	writeln(changedScopes.models, "   ", changedScopes.existModels);
}