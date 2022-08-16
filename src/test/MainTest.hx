package test;

import Log;
import unit.TestCase;

class MainTest extends TestCase {
    
    override public function setup():Void {

    }

    override public function tearDown():Void {

    }

    public function testBasic():Void {
        
        assertEquals("A", "A");
    }
}