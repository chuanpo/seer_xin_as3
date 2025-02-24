package gs.utils.tween
{
   public dynamic class TweenMaxVars extends TweenLiteVars
   {
      public static const version:Number = 2.01;
      
      protected var _roundProps:Array;
      
      public var loop:Number;
      
      public var yoyo:Number;
      
      public var onCompleteListener:Function;
      
      public var onStartListener:Function;
      
      public var onUpdateListener:Function;
      
      public function TweenMaxVars($vars:Object = null)
      {
         super($vars);
      }
      
      public function get roundProps() : Array
      {
         return _roundProps;
      }
      
      public function set roundProps($a:Array) : void
      {
         _roundProps = _exposedVars.roundProps = $a;
      }
      
      override protected function appendCloneVars($vars:Object, $protectedVars:Object) : void
      {
         super.appendCloneVars($vars,$protectedVars);
         var props:Array = ["onStartListener","onUpdateListener","onCompleteListener","onCompleteAllListener","yoyo","loop"];
         for(var i:int = props.length - 1; i > -1; i--)
         {
            $vars[props[i]] = this[props[i]];
         }
         $protectedVars._roundProps = _roundProps;
      }
      
      override public function clone() : TweenLiteVars
      {
         var vars:Object = {"protectedVars":{}};
         appendCloneVars(vars,vars.protectedVars);
         return new TweenMaxVars(vars);
      }
   }
}

