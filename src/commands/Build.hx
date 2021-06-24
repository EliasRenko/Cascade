package commands;

import sys.FileSystem;
import sys.io.Process;
import core.Command;
import core.Project;
import haxe.Exception;
import haxe.ds.Option;

class Build extends Command {
    
    // ** Privates.

    /** @private **/ //private var __directoryName:String;

    public function new(project:Project) {
        
        super(project);
    }

	override public function run(args:Array<String>):Option<Exception> {

        var _directoryName:String = '';

        var _hxmlArgs:Array<String> = [];

        _hxmlArgs.push('-main');

        _hxmlArgs.push('drc.core.App');

        _hxmlArgs.push('-cp');

        _hxmlArgs.push(__project.path + __project.sourcePath);

        switch(args[1]) {

            case 'js':

                _directoryName = 'js';

                if (__project.debug) _directoryName += '.debug';

                _hxmlArgs.push('-js');

                _hxmlArgs.push(__project.path + 'bin/' + _directoryName + '/main.js');

            case 'windows':

                _directoryName = 'windows';

                if (__project.debug) _directoryName += '.debug';

                _hxmlArgs.push('-cpp');

                _hxmlArgs.push(__project.path + 'bin/' + _directoryName);

            default:

                return Some(new Exception('Invalid build argument.'));
        }

        for (i in 0...__project.dependencies.length) {

            var _dependencyPath:String = new Process('haxelib', ['libpath', __project.dependencies[i]]).stdout.readAll().toString();

            if (FileSystem.exists(_dependencyPath + 'project.json')) {

                //var _dependencyProject:Pro = utils.Resources.getProject(_dependencyPath + 'project.json');

                //Common.copyResources(_dependencyProject, __directoryName);
            }
        }

        trace(_hxmlArgs);

        return None;
	}
}