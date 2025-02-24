package gs.plugins
{
   import flash.display.*;
   import gs.*;
   
   public class FastTransformPlugin extends TweenPlugin
   {
      public static const VERSION:Number = 1.02;
      
      public static const API:Number = 1;
      
      protected var widthStart:Number;
      
      protected var rotationStart:Number;
      
      protected var xChange:Number = 0;
      
      protected var yChange:Number = 0;
      
      protected var xStart:Number;
      
      protected var rotationChange:Number = 0;
      
      protected var scaleYStart:Number;
      
      protected var widthChange:Number = 0;
      
      protected var scaleXChange:Number = 0;
      
      protected var scaleYChange:Number = 0;
      
      protected var yStart:Number;
      
      protected var _target:DisplayObject;
      
      protected var scaleXStart:Number;
      
      protected var heightChange:Number = 0;
      
      protected var heightStart:Number;
      
      public function FastTransformPlugin()
      {
         super();
         this.propName = "fastTransform";
         this.overwriteProps = [];
      }
      
      override public function set changeFactor($n:Number) : void
      {
         if(xChange != 0)
         {
            _target.x = xStart + $n * xChange;
         }
         if(yChange != 0)
         {
            _target.y = yStart + $n * yChange;
         }
         if(widthChange != 0)
         {
            _target.width = widthStart + $n * widthChange;
         }
         if(heightChange != 0)
         {
            _target.height = heightStart + $n * heightChange;
         }
         if(scaleXChange != 0)
         {
            _target.scaleX = scaleXStart + $n * scaleXChange;
         }
         if(scaleYChange != 0)
         {
            _target.scaleY = scaleYStart + $n * scaleYChange;
         }
         if(rotationChange != 0)
         {
            _target.rotation = rotationStart + $n * rotationChange;
         }
      }
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         _target = $target as DisplayObject;
         if("x" in $value)
         {
            xStart = _target.x;
            xChange = typeof $value.x == "number" ? $value.x - _target.x : Number($value.x);
            this.overwriteProps[this.overwriteProps.length] = "x";
         }
         if("y" in $value)
         {
            yStart = _target.y;
            yChange = typeof $value.y == "number" ? $value.y - _target.y : Number($value.y);
            this.overwriteProps[this.overwriteProps.length] = "y";
         }
         if("width" in $value)
         {
            widthStart = _target.width;
            widthChange = typeof $value.width == "number" ? $value.width - _target.width : Number($value.width);
            this.overwriteProps[this.overwriteProps.length] = "width";
         }
         if("height" in $value)
         {
            heightStart = _target.height;
            heightChange = typeof $value.height == "number" ? $value.height - _target.height : Number($value.height);
            this.overwriteProps[this.overwriteProps.length] = "height";
         }
         if("scaleX" in $value)
         {
            scaleXStart = _target.scaleX;
            scaleXChange = typeof $value.scaleX == "number" ? $value.scaleX - _target.scaleX : Number($value.scaleX);
            this.overwriteProps[this.overwriteProps.length] = "scaleX";
         }
         if("scaleY" in $value)
         {
            scaleYStart = _target.scaleY;
            scaleYChange = typeof $value.scaleY == "number" ? $value.scaleY - _target.scaleY : Number($value.scaleY);
            this.overwriteProps[this.overwriteProps.length] = "scaleY";
         }
         if("rotation" in $value)
         {
            rotationStart = _target.rotation;
            rotationChange = typeof $value.rotation == "number" ? $value.rotation - _target.rotation : Number($value.rotation);
            this.overwriteProps[this.overwriteProps.length] = "rotation";
         }
         return true;
      }
      
      override public function killProps($lookup:Object) : void
      {
         var p:String = null;
         for(p in $lookup)
         {
            if(p + "Change" in this && !isNaN(this[p + "Change"]))
            {
               this[p + "Change"] = 0;
            }
         }
         super.killProps($lookup);
      }
   }
}

