package core;

import haxe.Json;
import sys.io.File;

@:generic
class JsonParser<T> {
    
    //** Publics.
	
	public var data(get, null):Dynamic;
	
	//** Privates.
	
	/** @private **/ private var __currentField:Dynamic = null;
	
	/** @private **/ private var __data:Dynamic;

    /** @private **/ private var __type:Class<Dynamic>;
	
	public function new(path:String, type:Class<Dynamic>) {

        var _projectSource = File.getContent('${path}project.json');

		__data = haxe.Json.parse(_projectSource);

        __type = type;

        toObject(__data);
	}

    public function toObject(data:Dynamic):Void {

        var obj = Type.createInstance(__type, []);

        var projectData = data.Project;

        var fields = Reflect.fields(projectData);

        for (field in fields) {

            var _value:Dynamic = Reflect.field(projectData, field);

            if (Reflect.isObject(_value)) {

                trace('Is object: ' + field);
            }
            else {

                Reflect.setField(obj, field, Reflect.field(projectData, field));
            }
        }
    }

    public function encodeObject():Void {
        
    }

    public function encodeValue(value:Dynamic):Void {
        
    }

    //** Getters and setters.
	
	private function get_data():Dynamic {

        return __data;
    }
}