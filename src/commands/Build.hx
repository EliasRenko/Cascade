package commands;

import haxe.io.Path;
import core.Resources;
import sys.io.File;
import sys.FileSystem;
import sys.io.Process;
import core.Command;
import core.Project;
import haxe.Exception;
import haxe.ds.Option;
import Cmd;

class Build extends Command {
    
    // ** Privates.

    /** @private **/ //private var __directoryName:String;

    public function new(project:Project) {
        
        super(project);
    }

	override public function run(args:Array<String>, cmd:Cmd):Option<Exception> {

        var _directoryName:String = '';

        var _hxmlArgs:Array<String> = [];

        _hxmlArgs.push('-main');

        _hxmlArgs.push(__project.mainClass);

        _hxmlArgs.push('-cp');

        _hxmlArgs.push(__project.path + __project.sourcePath);

        trace("PATH! " + __project.path);

        switch(cmd.value) {

            case 'js':

                _directoryName = 'js';

                if (__project.debug) _directoryName += '.debug';

                _hxmlArgs.push('-js');

                _hxmlArgs.push(__project.path + 'bin/' + _directoryName + '/main.js');

            case 'neko':

                _directoryName = 'neko';

                if (__project.debug) _directoryName += '.debug';

                _hxmlArgs.push('-neko');

                _hxmlArgs.push(__project.path + 'run.n');

            case 'windows':

                _directoryName = 'windows';

                if (__project.debug) _directoryName += '.debug';

                _hxmlArgs.push('-cpp');

                _hxmlArgs.push(__project.path + 'bin/' + _directoryName);

            default:

                return Some(new Exception('Invalid build argument.'));
        }

        for (i in 0...__project.dependencies.length) {

            var _dependencyPath:String = new Process('haxelib', ['libpath', __project.dependencies[i]]).stdout.readLine().toString();

            trace("Help :" + _dependencyPath);

            if (FileSystem.exists(_dependencyPath + 'project.json')) {

                var _dependencyProject:Project = Resources.parseProject(_dependencyPath);

                copyResources(_dependencyPath + _dependencyProject.resourcePath, __project.path + 'bin/' + _directoryName + '/' + __project.resourcePath);
            }
            else {

                trace("fuck :" + _dependencyPath + 'project.json');
            }
        }

        if (FileSystem.exists(__project.path + __project.resourcePath)) {

            copyResources(__project.path + __project.resourcePath, __project.path + 'bin/' + _directoryName + '/' + __project.resourcePath);
        }
        else {

            throw 'Resources directory `${__project.resourcePath}` does not exist.';
        }

        // ** Dependency libs.

        for (i in 0...__project.dependencies.length) {

            _hxmlArgs.push('-lib');

            _hxmlArgs.push(__project.dependencies[i]);
        }

        // ** Flags.

        if (__project.debug) {

            _hxmlArgs.push('-debug');
        }

        for (i in 0...__project.flags.length) {

            var _r = ~/[ ]+/g;

            var _flags:Array<String> = _r.split(__project.flags[i]);

            for (j in 0..._flags.length) {

                _hxmlArgs.push(_flags[j]);
            }
        }

        //_hxmlArgs.push("--macro");

        //_hxmlArgs.push("keep(\"src/" + __project.mainClass + "\")");

        //_hxmlArgs.push(__project.mainClass);

        var _result:Int = Sys.command('haxe', _hxmlArgs);

        var _hxml:String = "";

        //_hxmlArgs.pop();

        for (i in 0..._hxmlArgs.length) {

            _hxml += _hxmlArgs[i] + " ";

            if (i < _hxmlArgs.length - 1) {

                if (_hxmlArgs[i + 1].charAt(0) == "-") {

                    _hxml += "\n";
                }
            }
        }

        File.saveContent(__project.path + "/build.hxml", _hxml);

        if (_result != 0) {

            throw 'Build failed with compilation errors, result: ${_result}';

            /** Log Error. **/

            //Logger.print('Build failed with compilation errors.');
        }

        return None;
	}
}