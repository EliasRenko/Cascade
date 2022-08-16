package core;

import haxe.Exception;
import haxe.Json;
import json.Parser;
import json.Tools;
import sys.io.File;

class Resources {

    public static function parseProject(path:String):Project {
        
        // ** Local functions.

        function isNull<T>(name:String, value:T, defaultValue:T):T {
            
            if (value == null) {

                return defaultValue;
            }

            return value;
        }

        // ** 

        var _projectSource:String;

        var _projectJson:Dynamic;

        try {

            _projectSource = File.getContent('${path}project.json');
        }
        catch(e:Exception) {

            throw 'Project file does not exist: ${e}';
        }

        try {

            _projectJson = Json.parse(_projectSource);
        }
        catch(e:Exception) {

            throw 'Failed to parse the project file: ${e}';
        }

        var _project:Project = {

            name: isNull('name', _projectJson.project.name, "default"),

            debug: isNull('debug', _projectJson.project.debug, true),

            dependencies: isNull('dependencies', _projectJson.project.build.dependencies, []),

            flags: isNull('flags', _projectJson.project.build.flags, []),

            mainClass: isNull('mainClass', _projectJson.project.build.mainClass, 'drc.core.App'),

            path: path,

            sourcePath: isNull('source', _projectJson.project.build.sourceFolder, "src"),

            resourcePath: isNull('Resources', _projectJson.project.build.resourcesFolder, "res"),

            version: isNull('Version', _projectJson.project.version, "0")
        };

        return _project;
    }

    public static function getProject(path:String) {
        
        var _projectSource:String;

        _projectSource = File.getContent('${path}project.json');

        
    }
}