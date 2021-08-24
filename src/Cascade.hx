package;

import sys.FileSystem;
import commands.Build;
import commands.Clean;
import core.Command;
import core.Project;
import debug.Assertions;
import debug.Logger;
import haxe.Exception;
import haxe.Json;
import haxe.ds.Option;
import sys.io.File;

/** 

    Build: 

    Clean:

    Resources:

    Setup:

**/

class Cascade {
    
    public static function main():Void {

        trace(Sys.args());
        
        var _args:Array<String> = Sys.args();

        if (_args.length <= 1) {

            Logger.print('No argument has been found. No task to complete.');

            Sys.exit(0);
        }

        var _path:String = _args[_args.length - 1];

        _args.pop();
        
        if (FileSystem.isDirectory(_args[_args.length - 1])) {

            _path = _args[_args.length - 1];

            _args.pop();
        }

        trace(_path);
        
        var _project:Project = parseProject(_path);

        switch (_args[0]) {

            case 'build':

                runCommand(_args, new Build(_project));

            case 'clean':

                runCommand(_args, new Clean(_project));

            default:

                //throw 'Invalid command';

                Logger.print('Invalid command');
        }
    }

    public static function runCommand(args:Array<String>, command:Command):Void {

        var _result:Option<Exception> = command.run(args);

        switch(_result) {

            case None:

                Logger.print('Success!');

            case Some(value):

                Logger.print('Fail: ${value.message}');
        }
    }

    // ** Improve!

    public static function parseProject(path:String):Project {
        
        // ** Local functions.

        function isNull<T>(name:String, value:T, defaultValue:T):T {
            
            if (value == null) {

                return defaultValue;
            }

            return value;
        }

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

            name: isNull('name', _projectJson.Project.Name, "default"),

            applicationId: isNull('applicationId', _projectJson.Project.App.Package, "Your name"),

            author: isNull('author', _projectJson.Project.Author, "Your name"),

            debug: isNull('debug', _projectJson.Project.Debug, true),

            dependencies: isNull('dependencies', _projectJson.Project.Build.Dependencies, []),

            flags: isNull('flags', _projectJson.Project.Build.Flags, []),

            mainClass: isNull('mainClass', _projectJson.Project.Build.MainClass, 'drc.core.App'),

            path: path,

            sourcePath: isNull('source', _projectJson.Project.Build.SourceFolder, "src"),

            resourcePath: isNull('Resources', _projectJson.Project.Build.ResourcesFolder, "res"),

            version: isNull('Version', _projectJson.Project.Version, "0")
        };

        return _project;
    }
}