package src.core;

import Type.ValueType;
import src.core.Cmd;

class Configuration extends EventDispacher<Cmd> {

    // ** Publics.

    public var options:Map<String, Cmd> = new Map<String, Cmd>();

    public function new() {
        
        super();
    }

    public function init():Void {
        
        // ** Local functions.

        function isCommand(arg:String):Bool {

            return arg.charAt(0) == "-";
        }

        var args:Array<String> = Sys.args();

        var lastOption:Cmd = null;

        var index:Int = 0;

        while (index < args.length - 1) {

            var arg:String = args[index];

            trace(arg);

            if (isCommand(arg)) {

                var _option:Cmd = options.get(arg);

                if (_option == null) {

                    throw "Command `" + arg + "` " + "doesn't exist!";
                }
                else {
                    
                    index ++;

                    _option.value = args[index];

                    lastOption = _option;
                }
            }
            else {

                if (lastOption.propertyExists(arg)) {

                    index ++;

                    lastOption.addProperty(arg, args[index]);
                }
                else throw "Parameter `" + arg + "` " + "doesn't exist!";
            }

            index ++;
        }
    }

    public function addOption(name:String, command:Cmd):Void {

        options.set(name, command);
    }

    public function getOption(name:String):Cmd {
        
        return options.get(name);
    }

    public function hasValue(name:String):Bool {
        
        var _command:Cmd = options.get(name);

        if (_command == null) return false;

        if (_command.value == null) return false;
        else return true;
    }

    public function runCommands():Void {
        
        trace(this.__listeners);

        for (name => option in options) {

            if (option.value == null) continue;

            dispatchEvent(option, option.type);
        }
    }
}