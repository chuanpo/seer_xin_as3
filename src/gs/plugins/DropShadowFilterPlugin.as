package gs.plugins
{
   import flash.display.*;
   import flash.filters.*;
   import gs.*;
   
   public class DropShadowFilterPlugin extends FilterPlugin
   {
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
      
      public function DropShadowFilterPlugin()
      {
         super();
         this.propName = "dropShadowFilter";
         this.overwriteProps = ["dropShadowFilter"];
      }
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         _target = $target;
         _type = DropShadowFilter;
         initFilter($value,new DropShadowFilter(0,45,0,0,0,0,1,int($value.quality) || 2,$value.inner,$value.knockout,$value.hideObject));
         return true;
      }
   }
}

