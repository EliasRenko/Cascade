package json;

import json.Json;

class ClassParser<T> {
    
    public var object:T;

    public function new(json:Json) {
        

        getObject(json);
    }

    public function getObject(json:Json):Void {

        return switch (json.value) {

            case JObject(fields):

                //var result:T;

                for (field in fields) {

                    trace(field);

                    Reflect.setField(object, field.name, getValue(field.value));
                }
                    
            case _:

                throw 'ERROR PARSING';
        }
    }

    public static function getValue(json:Json):Any {
        return switch (json.value) {
            case JNull:
                null;
            case JString(string):
                string;
            case JBool(bool):
                bool;
            case JNumber(s):
                Std.parseFloat(s);
            case JObject(fields):
                var result = {};
                for (field in fields)
                    Reflect.setField(result, field.name, getValue(field.value));
                result;
            case JArray(values):
                [for (json in values) getValue(json)];
        }
    }
}