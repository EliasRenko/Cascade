package core;

class Person {
    
    var applicationId:String;

    var author:String;

    var debug:Bool;

    var dependencies:Array<String>;

    var flags:Array<String>;

    var mainClass:String;

    var name:String;

    var path:String;

    var sourcePath:String;

    var resourcePath:String;

    var version:String;

    var color:Color = new Color();
}

private class Color {
    
    var value:Int;

    public function new() {
        
    }
}