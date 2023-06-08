import std.stdio, std.conv, std.file, std.string;
import std.exception : enforce;
import std.json;

class ChangeScope{
    public string[] refdata, viewmodels, models;
    public string sourcePath, destPath;
    public bool existRefdata, existViewmodels, existModels;

    this(){
        JSONValue configJson = this.handleJson();

        static foreach(string type; ["refdata", "viewmodels", "models"]){
            try{
                foreach(value; configJson[type].array){
                    if(value.str.length > 0){
                        mixin(type ~ ".length++;" ~ type ~ "[$-1] =  value.str; exist" ~ capitalize(type) ~ "= true;");
                    }
                }
            }
            catch(Exception e){
                mixin("exist" ~ capitalize(type) ~ " = false;");
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
}