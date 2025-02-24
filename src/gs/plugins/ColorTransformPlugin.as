package gs.plugins
{
   import flash.display.*;
   import flash.geom.ColorTransform;
   import gs.*;
   
   public class ColorTransformPlugin extends TintPlugin
   {
      public static const VERSION:Number = 1.01;
      
      public static const API:Number = 1;
      
      public function ColorTransformPlugin()
      {
         super();
         this.propName = "colorTransform";
      }
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         var p:String = null;
         var ratio:Number = NaN;
         if(!($target is DisplayObject))
         {
            return false;
         }
         var end:ColorTransform = $target.transform.colorTransform;
         if($value.isTV == true)
         {
            $value = $value.exposedVars;
         }
         for(p in $value)
         {
            if(p == "tint" || p == "color")
            {
               if($value[p] != null)
               {
                  end.color = int($value[p]);
               }
            }
            else if(!(p == "tintAmount" || p == "exposure" || p == "brightness"))
            {
               end[p] = $value[p];
            }
         }
         if(!isNaN($value.tintAmount))
         {
            ratio = $value.tintAmount / (1 - (end.redMultiplier + end.greenMultiplier + end.blueMultiplier) / 3);
            end.redOffset *= ratio;
            end.greenOffset *= ratio;
            end.blueOffset *= ratio;
            end.redMultiplier = end.greenMultiplier = end.blueMultiplier = 1 - $value.tintAmount;
         }
         else if(!isNaN($value.exposure))
         {
            end.redOffset = end.greenOffset = end.blueOffset = 255 * ($value.exposure - 1);
            end.redMultiplier = end.greenMultiplier = end.blueMultiplier = 1;
         }
         else if(!isNaN($value.brightness))
         {
            end.redOffset = end.greenOffset = end.blueOffset = Math.max(0,($value.brightness - 1) * 255);
            end.redMultiplier = end.greenMultiplier = end.blueMultiplier = 1 - Math.abs($value.brightness - 1);
         }
         if($tween.exposedVars.alpha != undefined && $value.alphaMultiplier == undefined)
         {
            end.alphaMultiplier = $tween.exposedVars.alpha;
            $tween.killVars({"alpha":1});
         }
         init($target as DisplayObject,end);
         return true;
      }
   }
}

