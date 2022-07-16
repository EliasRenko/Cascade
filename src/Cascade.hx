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
import sys.FileSystem;
import src.core.Configuration;
import src.core.Cmd;

/** 

    Build: 

    Clean:

    Resources:

    Setup:

**/

class Cascade {
    
    public static var project:Project;

    public static function main():Void {
        
        var configuration:Configuration = prepareConfiguration();

        configuration.init();

        var _args:Array<String> = Sys.args();

        if (_args.length <= 1) {

            Logger.print('No argument has been found. No task to complete.');

            Sys.exit(0);
        }

        trace("BUILD: " + configuration.options);

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

        project = Resources.parseProject(_path);

        trace("DATA: " + configuration.options);

        // ** Check commands

        configuration.runCommands();

        // Logger.print('Invalid command');
    }

    public static function runBuild(command:Cmd, type:Int):Void {
        
        trace("BUILD");

        runCommand(null, new Build(project), command);

        // if (configuration.options.exists('-build')) {

        //     runCommand(_args, new Build(_project), configuration.options.get('-build'));

        //     return;
        // }

        // if (configuration.options.exists('-clean')) {

        //     //runCommand(_args, new Clean(_project));

        //     trace("CLEAN COMMAND: " + configuration.options);

        //     return;
        // }

        // Logger.print('Invalid command');
    }

    public static function runClean(command:Cmd, type:Int):Void {

        runCommand(null, new Clean(project), command);
    }

    public static function runCommand(args:Array<String>, command:Command, cmd:Cmd):Void {

        var _result:haxe.ds.Option<Exception> = command.run(args, cmd);

        switch(_result) {

            case None:

                Logger.print('Success!');

            case Some(value):

                Logger.print('Fail: ${value.message}');
        }
    }

    public static function prepareConfiguration():Configuration {
     
        var configuration:Configuration = new Configuration();

        configuration.addEventListener(runBuild, 1);
        configuration.addEventListener(runClean, 2);

        var cmd_build:Cmd = new Cmd(1, "");

        configuration.addOption("-build", cmd_build);

        var cmd_clean:Cmd = new Cmd(2, "");

        cmd_clean.addProperty('x');
        cmd_clean.addProperty('y');

        configuration.addOption("-clean", cmd_clean);

        return configuration;
    }
}