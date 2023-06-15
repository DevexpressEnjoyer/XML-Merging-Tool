import std.stdio, std.file;
import app, jsonhandler;

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