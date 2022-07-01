package;

import core.Person;
import core.JsonParser;
import commands.Build;
import commands.Clean;
import core.Command;
import core.Project;
import core.Resources;
import debug.Logger;
import haxe.Exception;
import haxe.ds.Option;
import sys.FileSystem;

/** 

    Build: 

    Clean:

    Resources:

    Setup:

**/

class Cascade {
    
    public static function main():Void {
        
        var _args:Array<String> = Sys.args();

        if (_args.length <= 1) {

            Logger.print('No argument has been found. No task to complete.');

            Sys.exit(0);
        }

        var _path:String = _args[_args.length - 1];

        _args.pop();

        try {

            if (FileSystem.isDirectory(_args[_args.length - 1])) {

                _path = _args[_args.length - 1];
    
                _args.pop();
            }

        } catch(e:Exception) {

            Logger.print('Using default directory path: ${_path}');
        }

        var _project:Project = Resources.parseProject(_path);

        switch (_args[0]) {

            case 'build':

                runCommand(_args, new Build(_project));

               //Resources.getProject(_path);

            case 'clean':

                //runCommand(_args, new Clean(_project));

            default:

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
}