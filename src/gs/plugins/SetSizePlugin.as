package gs.plugins
{
   import flash.display.*;
   import gs.*;
   
   public class SetSizePlugin extends TweenPlugin
   {
      public static const VERSION:Number = 1.01;
      
      public static const API:Number = 1;
      
      protected var _setWidth:Boolean;
      
      public var width:Number;
      
      public var height:Number;
      
      protected var _hasSetSize:Boolean;
      
      protected var _setHeight:Boolean;
      
      protected var _target:Object;
      
      public function SetSizePlugin()
      {
         super();
         this.propName = "setSize";
         this.overwriteProps = ["setSize","width","height","scaleX","scaleY"];
         this.round = true;
      }
      
      override public function killProps($lookup:Object) : void
      {
         super.killProps($lookup);
         if(_tweens.length == 0 || "setSize" in $lookup)
         {
            this.overwriteProps = [];
         }
      }
      
      override public function onInitTween($target:Object, $value:*, $tween:TweenLite) : Boolean
      {
         _target = $target;
         _hasSetSize = Boolean("setSize" in _target);
         if("width" in $value && _target.width != $value.width)
         {
            addTween(_hasSetSize ? this : _target,"width",_target.width,$value.width,"width");
            _setWidth = _hasSetSize;
         }
         if("height" in $value && _target.height != $value.height)
         {
            addTween(_hasSetSize ? this : _target,"height",_target.height,$value.height,"height");
            _setHeight = _hasSetSize;
         }
         return true;
      }
      
      override public function set changeFactor($n:Number) : void
      {
         updateTweens($n);
         if(_hasSetSize)
         {
            _target.setSize(_setWidth ? this.width : _target.width,_setHeight ? this.height : _target.height);
         }
      }
   }
}

