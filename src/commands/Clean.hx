package commands;

import core.Command;
import core.Project;
import haxe.Exception;
import haxe.ds.Option;

class Clean extends Command {

    public function new(project:Project) {
        
        super(project);
    }

	override public function run(args:Array<String>):Option<Exception> {

        return None;
	}
}