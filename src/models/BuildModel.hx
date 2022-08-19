package models;

@:structInit
class BuildModel {
    
    public var debug(default, null):Bool;

    public var dependencies(default, null):Null<Array<String>>;

    public var flags(default, null):Array<String>;

    public var mainClass(default, null):String;

    public var path(default, null):String;

    public var sourceFolder(default, null):String;

    public var resourcesFolder(default, null):String;
}