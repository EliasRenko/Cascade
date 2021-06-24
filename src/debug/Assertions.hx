package debug;

import haxe.macro.Context;
import haxe.macro.Expr;

class Assertions {

    macro static public function assert(expr:Expr, message:ExprOf<String>):Expr {

        return macro @:pos(Context.currentPos()) {

            if(!$expr) throw debug.AssertionsError.assertion($message);
        }

        return macro null;
    }

    macro static public function assertNull(value:Expr, message:ExprOf<String>):Expr {

        return macro @:pos(Context.currentPos()) {

            if($value == null) throw debug.AssertionsError.null_assertion($message);
        }

        return macro null;
    }
}