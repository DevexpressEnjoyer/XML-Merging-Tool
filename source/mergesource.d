import std.stdio, std.conv, std.string, std.file, std.typecons, std.array, std.algorithm;
import app, jsonhandler;

void merge(string sourcePath, string destPath, MergeArea[] sourceMergeArea, MergeArea[] destMergeArea){
    string tempPath = getTempFilePath(destPath);

    auto destFile = File(destPath, "r");
    auto tempFile = File(tempPath, "w");

    uint  destLineCounter = 1;
    string  destFileLine;
    destMergeArea.sort!((a, b) => a.start < b.start);

    foreach(change; destMergeArea){
        while(destLineCounter < change.start){
            destFileLine = destFile.readln();
            tempFile.write(destFileLine);
            destLineCounter++;
        }

        string changeFromSource = getSourceChangeString(sourcePath, sourceMergeArea, change);
        tempFile.write(changeFromSource);

        while(destLineCounter <= change.stop){
            destFileLine = destFile.readln();
            destLineCounter++;
        }
        
    }

    while(!destFile.eof()){
        destFileLine = destFile.readln();
        tempFile.write(destFileLine);
    }

    tempFile.close();
    destFile.close();
    writeln("\nFiles are succesfully merged!\nResult file: ", tempPath);
}

string getSourceChangeString(string sourcePath, MergeArea[] sourceMergeArea, MergeArea change){
    auto sourceFile = File(sourcePath, "r");
    string result, line;
    uint sourceLineCounter = 1;

    auto sourceChange = sourceMergeArea.filter!(a => a.tagName == change.tagName && a.tagId == change.tagId).array;  

    for(;sourceLineCounter <= sourceChange[0].stop; sourceLineCounter++){
        line = sourceFile.readln();
        if(sourceLineCounter >= sourceChange[0].start){
            result ~= line;
        }
    }

    sourceFile.close();
    return result;
}

string getTempFilePath(string path){
    long dirPos = (lastIndexOf(path, '\\'));

    return cast(string)path[0 .. dirPos+1] ~ "temp.xml";
}