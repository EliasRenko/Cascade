package;

import Command;
import Configuration;
import commands.Build;
import commands.Clean;
import core.Job;
import core.Project;
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
    
    public static var project:Project;

    public static function main():Void {

        var _args:Array<String> = Sys.args();

        trace("ARGS: " + Sys.args());

        if (_args.length <= 1) {

            Logger.print('No argument has been found. No task to complete.');

            Sys.exit(0);
        }

        var _path:String = _args[_args.length - 1];

        //_args.pop();

        try {

            if (FileSystem.isDirectory(_args[_args.length - 1])) {

                _path = _args[_args.length - 1];
    
                _args.pop();
            }

        } catch(e:Exception) {

            Logger.print('Using default directory path: ${_path}');
        }

        // project = Resources.parseProject(_path);

        var configuration:Configuration = prepareConfiguration();

        configuration.parse(_args);

        configuration.runCommands();

        // Logger.print('Invalid command');
    }

    public static function runBuild(command:Command, type:Int):Void {
        
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

    public static function runClean(command:Command, type:Int):Void {

        runCommand(null, new Clean(project), command);
    }

    public static function runCommand(args:Array<String>, job:Job, cmd:Command):Void {

        var _result:Option<Exception> = job.run(args, cmd);

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

        var cmd_build:Command = new Command(1, "");

        configuration.addOption("-build", cmd_build);

        var cmd_clean:Command = new Command(2, "");

        cmd_clean.addProperty('x');
        cmd_clean.addProperty('y');

        configuration.addOption("-clean", cmd_clean);

        return configuration;
    }
}