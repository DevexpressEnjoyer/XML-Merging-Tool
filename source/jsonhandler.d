import std.stdio, std.conv, std.file, std.string, std.json;
import std.exception : enforce;

class ChangeScope{   
    public string sourcePath, destPath;

    static immutable tags = getTags();

    static foreach(string tag; tags){
            mixin("public string[] " ~ tag ~ "s;\n");
            mixin("public bool exist" ~ capitalize(tag) ~ "s;\n");
    }

    this(){
        JSONValue configJson = this.handleJson();

        static foreach(string tag; tags){
            try{
                foreach(value; configJson[tag].array){
                    if(value.str.length > 0){
                        mixin(tag ~ "s.length++;" ~ tag ~ "s[$-1] =  value.str; exist" ~ capitalize(tag) ~ "s = true;");
                    }
                }
            }
            catch(Exception e){
                mixin("exist" ~ capitalize(tag) ~ "s = false;");
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
        enforce(exists(this.destPath), "Destination file not found.");
        
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