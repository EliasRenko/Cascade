package;

import json.Json;
import test.CommandsTest;
import test.JsonTest;

class Unit {
	public static function main() {

		var r = new unit.TestRunner();

		//r.add(new CommandsTest());
		r.add(new JsonTest());

		r.run();
	}
}
