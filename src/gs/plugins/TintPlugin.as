package gs.plugins
{
   import flash.display.*;
   import flash.geom.ColorTransform;
   import gs.*;
   import gs.utils.tween.TweenInfo;
   
   public class TintPlugin extends TweenPlugin
   {
      public static const VERSION:Number = 1.1;
      
      public static const API:Number = 1;
      
      protected static var _props:Array = ["redMultiplier","greenMultiplier","blueMultiplier","alphaMultiplier","redOffset","greenOffset","blueOffset","alphaOffset"];
      
      protected var _target:DisplayObject;
      
      protected var _ct:ColorTransform;
      
      protected var _ignoreAlpha:Boolean;
      
      public function TintPlugin()
      {
         super();
         this.propName = "tint";
         this.overwriteProps = ["tint"];
      }
      
      public function init($target:DisplayObject, $end:ColorTransform) : void
      {
         var i:int = 0;
         var p:String = null;
         _target = $target;
         _ct = _target.transform.colorTransform;
         for(i = _props.length - 1; i > -1; i--)
         {
            p = _props[i];
            if(_ct[p] != $end[p])
            {
               _tweens[_tweens.length] = new TweenInfo(_ct,p,_ct[p],$end[p] - _ct[p],"tint",false);
            }
         }
      }
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         if(!($target is DisplayObject))
         {
            return false;
         }
         var end:ColorTransform = new ColorTransform();
         if($value != null && $tween.exposedVars.removeTint != true)
         {
            end.color = uint($value);
         }
         _ignoreAlpha = true;
         init($target as DisplayObject,end);
         return true;
      }
      
      override public function set changeFactor($n:Number) : void
      {
         var ct:ColorTransform = null;
         updateTweens($n);
         if(_ignoreAlpha)
         {
            ct = _target.transform.colorTransform;
            _ct.alphaMultiplier = ct.alphaMultiplier;
            _ct.alphaOffset = ct.alphaOffset;
         }
         _target.transform.colorTransform = _ct;
      }
   }
}

