package;

class Main {
	public static function main() {

		var _args:Array<String> = Sys.args();

		trace("Args: " + _args);

		var configuration:Configuration = new Configuration();

		configuration.parse(_args);

		trace(configuration);
 
        // ** No arguments

		if (_args.length <= 1) {

			trace('No argument has been found. No task to complete.');

			Sys.exit(0);
		}

        
	}
}
