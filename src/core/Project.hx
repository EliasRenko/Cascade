package core;

import models.BuildModel;

@:structInit
class Project {

    // ** Publics

    public var build(default, null):BuildModel;

    public var name:String;

    public var version:String;

    public function new(name:String, version:String) {

        this.name = name;

        this.version = version;
    }
}