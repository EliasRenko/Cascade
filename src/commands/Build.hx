package commands;

import Command;
import core.Job;
import core.Project;
import core.Resources;
import haxe.Exception;
import haxe.Json;
import haxe.ds.Option;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;
import sys.io.Process;

class Build extends Job {
    
    // ** Privates.

    /** @private **/ //private var __directoryName:String;

    public function new(project:Project) {
        
        super(project);
    }

	override public function run(path:String, cmd:Command):Option<Exception> {

        trace("Build: " + __project.build);

        var _directoryName:String = '';

        var _hxmlArgs:Array<String> = [];

        _hxmlArgs.push('-cp');

        _hxmlArgs.push(__project.build.sourceFolder);

        _hxmlArgs.push('-main');

        _hxmlArgs.push(__project.build.mainClass);

        //trace("PATH! " + __project.path);

        trace("Lenght: " + __project.build.dependencies == null);

        switch(cmd.value) {

            case 'js':

                _directoryName = 'js';

                if (__project.build.debug) _directoryName += '.debug';

                _hxmlArgs.push('-js');

                _hxmlArgs.push(path + 'bin/' + _directoryName + '/main.js');

            case 'neko':

                _directoryName = 'neko';

                if (__project.build.debug) _directoryName += '.debug';

                _hxmlArgs.push('-neko');

                _hxmlArgs.push(path + 'run.n');

            case 'windows':

                _directoryName = 'windows';

                if (__project.build.debug) _directoryName += '.debug';

                _hxmlArgs.push('-cpp');

                _hxmlArgs.push(path + 'bin/' + _directoryName);

            default:

                return Some(new Exception('Invalid `Build` argument.'));
        }

        for (i in 0...__project.build.dependencies.length) {

            var _dependencyPath:String = new Process('haxelib', ['libpath', __project.build.dependencies[i]]).stdout.readLine().toString();

            trace("Help :" + _dependencyPath);

            if (FileSystem.exists(_dependencyPath + 'project.json')) {

                var _dependencyProject:Project;

                try {

                    var _projectSource:String = File.getContent('${_dependencyPath}project.json');
        
                    _dependencyProject = Json.parse(_projectSource);
                }
                catch(e:Exception) {
        
                    throw 'Failed to load the project file of a dependency: ${e}';
                }

                copyResources(_dependencyPath + _dependencyProject.build.resourcesFolder, path + 'bin/' + _directoryName + '/' + __project.build.resourcesFolder);
            }
            else {

                trace("fuck :" + _dependencyPath + 'project.json');
            }
        }

        // ** Manage resources

        if (FileSystem.exists(path + __project.build.resourcesFolder)) {

            copyResources(path + __project.build.resourcesFolder, path + 'bin/' + _directoryName + '/' + __project.build.resourcesFolder);
        }
        else {

            // TODO: Create new resource directory

            throw 'Resources directory `${__project.build.resourcesFolder}` does not exist.';
        }

        // ** Dependency libs.

        for (i in 0...__project.build.dependencies.length) {

            _hxmlArgs.push('-lib');

            _hxmlArgs.push(__project.build.dependencies[i]);
        }

        // ** Flags.

        if (__project.build.debug) {

            _hxmlArgs.push('--debug');
        }

        for (i in 0...__project.build.flags.length) {

            var _r = ~/[ ]+/g;

            var _flags:Array<String> = _r.split(__project.build.flags[i]);

            for (j in 0..._flags.length) {

                _hxmlArgs.push(_flags[j]);
            }
        }

        //_hxmlArgs.push("--macro");

        //_hxmlArgs.push("keep(\"src/" + __project.mainClass + "\")");

        //_hxmlArgs.push(__project.mainClass);

        var _result:Int = Sys.command('haxe', _hxmlArgs);

        trace("HXML: " + _hxmlArgs);

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

        File.saveContent(path + "/build.hxml", _hxml);

        if (_result != 0) {

            throw 'Build failed with compilation errors, result: ${_result}';

            /** Log Error. **/

            //Logger.print('Build failed with compilation errors.');
        }

        return None;
	}
}