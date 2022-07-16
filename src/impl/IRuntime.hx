package src.impl;

interface IRuntime {
    
    // ** Publics.

    public var active(get, null):Bool;

    public var name(get, null):String;

    // ** 

    public function init():Void;

    public function release():Void;

    public function pollEvents():Void;

    public function requestLoopFrame():Void;

    public function __loop(timestamp:Float):Void;
}