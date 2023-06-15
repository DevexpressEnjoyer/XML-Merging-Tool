import std.stdio, std.conv, std.file, std.string, std.json, std.typecons;
import std.exception : enforce;
import app;

alias MergeArea = Tuple!(uint, "start", uint, "stop", string, "tagName", string, "tagId");

class ChangeScope{   
    public string sourcePath, destPath;
    public MergeArea[] mergeArea;
    static immutable tags = getTags();

    this(){
        JSONValue configJson = this.handleJson();

        static foreach(string tag; tags){
            try{
                foreach(value; configJson[tag].array){
                    if(value.str.length > 0){
                        mergeArea.length++;
                        mergeArea[$-1].tagName = tag;
                        mergeArea[$-1].tagId = value.str;
                    }
                }
            }
            catch(Exception e){
            }
        }
    }

    private JSONValue handleJson(){
        enforce(exists("config.json"), "Configuration file not found.");

        File configFile = File("config.json", "r");
        string jsonContent;
            
        while(!configFile.eof()){
            jsonContent ~= configFile.readln();
        }

        JSONValue configJson;

        try{
            configJson = parseJSON(jsonContent);
        }
        catch(Exception e){
            throw new Exception("Config.json file could not be parsed.");
        }
        
        this.sourcePath = configJson["sourceFilePath"].str;
        this.destPath = configJson["destinationFilePath"].str;

        enforce(exists(this.sourcePath), "Source file not found.");
        writeln("Found source XML file in path ", this.sourcePath);
        enforce(exists(this.destPath), "Destination file not found.");
        writeln("Found destination XML file in path ", this.destPath);
        
        return configJson;
    }

    private static string[] getTags(){
        static immutable string jsonContent = import("config.json");

        immutable JSONValue configJson = parseJSON(jsonContent);

        string[] result;

        static foreach(value; configJson["tag"].array){
            result ~= value.str;
        }

        return result;
    }
}