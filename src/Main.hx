package;

import test.CommandsTest;

class Main {
	public static function main() {

		var r = new unit.TestRunner();

		r.add(new CommandsTest());

		r.run();
	}
}
