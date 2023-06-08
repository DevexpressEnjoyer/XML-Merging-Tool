import std.stdio;
import jsonhandler;

void main()
{
	writeln("Hello, world!");

	auto changedScopes = new ChangeScope();

	writeln(changedScopes.viewmodels, "   ", changedScopes.existViewmodels);
	writeln(changedScopes.models, "   ", changedScopes.existModels);
}