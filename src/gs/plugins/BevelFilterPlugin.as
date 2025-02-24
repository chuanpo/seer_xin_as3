package gs.plugins
{
   import flash.display.*;
   import flash.filters.*;
   import gs.*;
   
   public class BevelFilterPlugin extends FilterPlugin
   {
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
      
      public function BevelFilterPlugin()
      {
         super();
         this.propName = "bevelFilter";
         this.overwriteProps = ["bevelFilter"];
      }
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         _target = $target;
         _type = BevelFilter;
         initFilter($value,new BevelFilter(0,0,16777215,0.5,0,0.5,2,2,0,int($value.quality) || 2));
         return true;
      }
   }
}

