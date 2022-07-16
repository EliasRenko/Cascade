package src.core;

class Cmd {
    
    // ** Publics.

    public var type:Int = 0;
    
    public var value:String;

    public var defaultValue:String;

    // ** Privates.

    private var __properties:Map<String, String> = new Map<String, String>();

    public function new(type:Int, defaultValue:String = null) {
        
        this.type = type;

        this.defaultValue = value;
    }

    public function addProperty(name:String, value:String = null):Void {
        
        __properties.set(name, value);
    }

    public function propertyExists(name:String):Bool {
        
        return __properties.exists(name);
    }
}