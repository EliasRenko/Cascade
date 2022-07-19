package commands;

import core.Command;
import core.Project;
import haxe.Exception;
import haxe.ds.Option;
import Cmd;

class Clean extends Command {

    public function new(project:Project) {
        
        super(project);
    }

	override public function run(args:Array<String>, cmd:Cmd):Option<Exception> {

        var _directoryName:String = '';

        switch(args[1]) {

            case 'js':

                _directoryName = 'js';

                if (__project.debug) _directoryName += '.debug';

            case 'windows':

                _directoryName = 'windows';

                if (__project.debug) _directoryName += '.debug';

            default:

                return Some(new Exception('Invalid build argument.'));
        }

        trace("Clear");

        cleanResources(__project.path + 'bin/' + _directoryName + '/' + __project.resourcePath);
        
        return None;
	}
}