package test;

import unit.TestRunner;
import test.ConfigurationTest;

class UnitTest {
    
    public static function main() {
        
        var r = new TestRunner();

        r.add(new test.ConfigurationTest());

        r.run();
    }
}