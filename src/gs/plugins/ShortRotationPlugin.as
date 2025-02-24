package gs.plugins
{
   import flash.display.*;
   import gs.*;
   
   public class ShortRotationPlugin extends TweenPlugin
   {
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
      
      public function ShortRotationPlugin()
      {
         super();
         this.propName = "shortRotation";
         this.overwriteProps = [];
      }
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         var p:String = null;
         if(typeof $value == "number")
         {
            trace("WARNING: You appear to be using the old shortRotation syntax. Instead of passing a number, please pass an object with properties that correspond to the rotations values For example, TweenMax.to(mc, 2, {shortRotation:{rotationX:-170, rotationY:25}})");
            return false;
         }
         for(p in $value)
         {
            initRotation($target,p,$target[p],$value[p]);
         }
         return true;
      }
      
      public function initRotation($target:Object, $propName:String, $start:Number, $end:Number) : void
      {
         var dif:Number = ($end - $start) % 360;
         if(dif != dif % 180)
         {
            dif = dif < 0 ? dif + 360 : dif - 360;
         }
         addTween($target,$propName,$start,$start + dif,$propName);
         this.overwriteProps[this.overwriteProps.length] = $propName;
      }
   }
}

