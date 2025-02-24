package gs.plugins
{
   import flash.display.*;
   import gs.*;
   
   public class ScalePlugin extends TweenPlugin
   {
      public static const VERSION:Number = 1.11;
      
      public static const API:Number = 1;
      
      protected var _changeX:Number;
      
      protected var _changeY:Number;
      
      protected var _target:Object;
      
      protected var _startX:Number;
      
      protected var _startY:Number;
      
      public function ScalePlugin()
      {
         super();
         this.propName = "scale";
         this.overwriteProps = ["scaleX","scaleY","width","height"];
      }
      
      override public function killProps($lookup:Object) : void
      {
         for(var i:int = this.overwriteProps.length - 1; i > -1; i--)
         {
            if(this.overwriteProps[i] in $lookup)
            {
               this.overwriteProps = [];
               return;
            }
         }
      }
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         if(!$target.hasOwnProperty("scaleX"))
         {
            return false;
         }
         _target = $target;
         _startX = _target.scaleX;
         _startY = _target.scaleY;
         if(typeof $value == "number")
         {
            _changeX = $value - _startX;
            _changeY = $value - _startY;
         }
         else
         {
            _changeX = _changeY = Number($value);
         }
         return true;
      }
      
      override public function set changeFactor($n:Number) : void
      {
         _target.scaleX = _startX + $n * _changeX;
         _target.scaleY = _startY + $n * _changeY;
      }
   }
}

