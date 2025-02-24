package gs.plugins
{
   import flash.display.*;
   import flash.filters.*;
   import gs.*;
   
   public class BlurFilterPlugin extends FilterPlugin
   {
      public static const VERSION:Number = 1;
      
      public static const API:Number = 1;
      
      public function BlurFilterPlugin()
      {
         super();
         this.propName = "blurFilter";
         this.overwriteProps = ["blurFilter"];
      }
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         _target = $target;
         _type = BlurFilter;
         initFilter($value,new BlurFilter(0,0,int($value.quality) || 2));
         return true;
      }
   }
}

