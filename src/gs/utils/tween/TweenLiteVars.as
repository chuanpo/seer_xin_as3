package gs.utils.tween
{
   import gs.TweenLite;
   
   public dynamic class TweenLiteVars
   {
      public static const version:Number = 2.03;
      
      protected var _glowFilter:GlowFilterVars;
      
      protected var _transformAroundCenter:TransformAroundCenterVars;
      
      public var easeParams:Array;
      
      protected var _shortRotation:Object;
      
      protected var _colorMatrixFilter:ColorMatrixFilterVars;
      
      protected var _frameLabel:String;
      
      public var onStartParams:Array;
      
      public const isTV:Boolean = true;
      
      public var onUpdateParams:Array;
      
      protected var _visible:Boolean = true;
      
      public var startAt:TweenLiteVars;
      
      public var onComplete:Function;
      
      protected var _volume:Number;
      
      protected var _setSize:Object;
      
      protected var _removeTint:Boolean;
      
      public var renderOnStart:Boolean = false;
      
      protected var _quaternions:Object;
      
      protected var _blurFilter:BlurFilterVars;
      
      protected var _colorTransform:ColorTransformVars;
      
      protected var _frame:int;
      
      protected var _autoAlpha:Number;
      
      public var delay:Number = 0;
      
      public var onUpdate:Function;
      
      public var overwrite:int = 2;
      
      protected var _transformAroundPoint:TransformAroundPointVars;
      
      protected var _endArray:Array;
      
      public var runBackwards:Boolean = false;
      
      protected var _exposedVars:Object;
      
      protected var _dropShadowFilter:DropShadowFilterVars;
      
      protected var _orientToBezier:Array;
      
      public var onStart:Function;
      
      protected var _bevelFilter:BevelFilterVars;
      
      public var persist:Boolean = false;
      
      protected var _tint:uint;
      
      public var onCompleteParams:Array;
      
      protected var _bezierThrough:Array;
      
      protected var _hexColors:Object;
      
      public var ease:Function;
      
      protected var _bezier:Array;
      
      public function TweenLiteVars($vars:Object = null)
      {
         var p:String = null;
         var pv:Object = null;
         super();
         _exposedVars = {};
         if($vars != null)
         {
            for(p in $vars)
            {
               if(!(p == "blurFilter" || p == "glowFilter" || p == "colorMatrixFilter" || p == "bevelFilter" || p == "dropShadowFilter" || p == "transformAroundPoint" || p == "transformAroundCenter" || p == "colorTransform"))
               {
                  if(p != "protectedVars")
                  {
                     this[p] = $vars[p];
                  }
               }
            }
            if($vars.blurFilter != null)
            {
               this.blurFilter = BlurFilterVars.createFromGeneric($vars.blurFilter);
            }
            if($vars.bevelFilter != null)
            {
               this.bevelFilter = BevelFilterVars.createFromGeneric($vars.bevelFilter);
            }
            if($vars.colorMatrixFilter != null)
            {
               this.colorMatrixFilter = ColorMatrixFilterVars.createFromGeneric($vars.colorMatrixFilter);
            }
            if($vars.dropShadowFilter != null)
            {
               this.dropShadowFilter = DropShadowFilterVars.createFromGeneric($vars.dropShadowFilter);
            }
            if($vars.glowFilter != null)
            {
               this.glowFilter = GlowFilterVars.createFromGeneric($vars.glowFilter);
            }
            if($vars.transformAroundPoint != null)
            {
               this.transformAroundPoint = TransformAroundPointVars.createFromGeneric($vars.transformAroundPoint);
            }
            if($vars.transformAroundCenter != null)
            {
               this.transformAroundCenter = TransformAroundCenterVars.createFromGeneric($vars.transformAroundCenter);
            }
            if($vars.colorTransform != null)
            {
               this.colorTransform = ColorTransformVars.createFromGeneric($vars.colorTransform);
            }
            if($vars.protectedVars != null)
            {
               pv = $vars.protectedVars;
               for(p in pv)
               {
                  this[p] = pv[p];
               }
            }
         }
         if(TweenLite.version < 10.05)
         {
            trace("TweenLiteVars error! Please update your TweenLite class or try deleting your ASO files. TweenLiteVars requires a more recent version. Download updates at http://www.TweenLite.com.");
         }
      }
      
      public function set setSize($o:Object) : void
      {
         _setSize = _exposedVars.setSize = $o;
      }
      
      public function set frameLabel($s:String) : void
      {
         _frameLabel = _exposedVars.frameLabel = $s;
      }
      
      public function get quaternions() : Object
      {
         return _quaternions;
      }
      
      public function get volume() : Number
      {
         return _volume;
      }
      
      public function set transformAroundCenter($tp:TransformAroundCenterVars) : void
      {
         _transformAroundCenter = _exposedVars.transformAroundCenter = $tp;
      }
      
      public function get shortRotation() : Object
      {
         return _shortRotation;
      }
      
      public function set bevelFilter($f:BevelFilterVars) : void
      {
         _bevelFilter = _exposedVars.bevelFilter = $f;
      }
      
      public function set quaternions($q:Object) : void
      {
         _quaternions = _exposedVars.quaternions = $q;
      }
      
      protected function appendCloneVars($vars:Object, $protectedVars:Object) : void
      {
         var props:Array = null;
         var special:Array = null;
         var i:int = 0;
         var p:String = null;
         props = ["delay","ease","easeParams","onStart","onStartParams","onUpdate","onUpdateParams","onComplete","onCompleteParams","overwrite","persist","renderOnStart","runBackwards","startAt"];
         for(i = props.length - 1; i > -1; i--)
         {
            $vars[props[i]] = this[props[i]];
         }
         special = ["_autoAlpha","_bevelFilter","_bezier","_bezierThrough","_blurFilter","_colorMatrixFilter","_colorTransform","_dropShadowFilter","_endArray","_frame","_frameLabel","_glowFilter","_hexColors","_orientToBezier","_quaternions","_removeTint","_setSize","_shortRotation","_tint","_transformAroundCenter","_transformAroundPoint","_visible","_volume","_exposedVars"];
         for(i = special.length - 1; i > -1; i--)
         {
            $protectedVars[special[i]] = this[special[i]];
         }
         for(p in this)
         {
            $vars[p] = this[p];
         }
      }
      
      public function get transformAroundCenter() : TransformAroundCenterVars
      {
         return _transformAroundCenter;
      }
      
      public function set volume($n:Number) : void
      {
         _volume = _exposedVars.volume = $n;
      }
      
      public function get endArray() : Array
      {
         return _endArray;
      }
      
      public function set colorMatrixFilter($f:ColorMatrixFilterVars) : void
      {
         _colorMatrixFilter = _exposedVars.colorMatrixFilter = $f;
      }
      
      public function set shortRotation($o:Object) : void
      {
         _shortRotation = _exposedVars.shortRotation = $o;
      }
      
      public function set removeTint($b:Boolean) : void
      {
         _removeTint = _exposedVars.removeTint = $b;
      }
      
      public function get dropShadowFilter() : DropShadowFilterVars
      {
         return _dropShadowFilter;
      }
      
      public function get colorTransform() : ColorTransformVars
      {
         return _colorTransform;
      }
      
      public function addProps($name1:String, $value1:Number, $relative1:Boolean = false, $name2:String = null, $value2:Number = 0, $relative2:Boolean = false, $name3:String = null, $value3:Number = 0, $relative3:Boolean = false, $name4:String = null, $value4:Number = 0, $relative4:Boolean = false, $name5:String = null, $value5:Number = 0, $relative5:Boolean = false, $name6:String = null, $value6:Number = 0, $relative6:Boolean = false, $name7:String = null, $value7:Number = 0, $relative7:Boolean = false, $name8:String = null, $value8:Number = 0, $relative8:Boolean = false, $name9:String = null, $value9:Number = 0, $relative9:Boolean = false, $name10:String = null, $value10:Number = 0, $relative10:Boolean = false, $name11:String = null, $value11:Number = 0, $relative11:Boolean = false, $name12:String = null, $value12:Number = 0, $relative12:Boolean = false, $name13:String = null, $value13:Number = 0, $relative13:Boolean = false, $name14:String = null, $value14:Number = 0, $relative14:Boolean = false, $name15:String = null, $value15:Number = 0, $relative15:Boolean = false) : void
      {
         addProp($name1,$value1,$relative1);
         if($name2 != null)
         {
            addProp($name2,$value2,$relative2);
         }
         if($name3 != null)
         {
            addProp($name3,$value3,$relative3);
         }
         if($name4 != null)
         {
            addProp($name4,$value4,$relative4);
         }
         if($name5 != null)
         {
            addProp($name5,$value5,$relative5);
         }
         if($name6 != null)
         {
            addProp($name6,$value6,$relative6);
         }
         if($name7 != null)
         {
            addProp($name7,$value7,$relative7);
         }
         if($name8 != null)
         {
            addProp($name8,$value8,$relative8);
         }
         if($name9 != null)
         {
            addProp($name9,$value9,$relative9);
         }
         if($name10 != null)
         {
            addProp($name10,$value10,$relative10);
         }
         if($name11 != null)
         {
            addProp($name11,$value11,$relative11);
         }
         if($name12 != null)
         {
            addProp($name12,$value12,$relative12);
         }
         if($name13 != null)
         {
            addProp($name13,$value13,$relative13);
         }
         if($name14 != null)
         {
            addProp($name14,$value14,$relative14);
         }
         if($name15 != null)
         {
            addProp($name15,$value15,$relative15);
         }
      }
      
      public function clone() : TweenLiteVars
      {
         var vars:Object = {"protectedVars":{}};
         appendCloneVars(vars,vars.protectedVars);
         return new TweenLiteVars(vars);
      }
      
      public function set orientToBezier($a:*) : void
      {
         if($a is Array)
         {
            _orientToBezier = _exposedVars.orientToBezier = $a;
         }
         else if($a == true)
         {
            _orientToBezier = _exposedVars.orientToBezier = [["x","y","rotation",0]];
         }
         else
         {
            _orientToBezier = null;
            delete _exposedVars.orientToBezier;
         }
      }
      
      public function get glowFilter() : GlowFilterVars
      {
         return _glowFilter;
      }
      
      public function get hexColors() : Object
      {
         return _hexColors;
      }
      
      public function get exposedVars() : Object
      {
         var p:String = null;
         var o:Object = {};
         for(p in _exposedVars)
         {
            o[p] = _exposedVars[p];
         }
         for(p in this)
         {
            o[p] = this[p];
         }
         return o;
      }
      
      public function get frame() : int
      {
         return _frame;
      }
      
      public function set transformAroundPoint($tp:TransformAroundPointVars) : void
      {
         _transformAroundPoint = _exposedVars.transformAroundPoint = $tp;
      }
      
      public function get visible() : Boolean
      {
         return _visible;
      }
      
      public function set endArray($a:Array) : void
      {
         _endArray = _exposedVars.endArray = $a;
      }
      
      public function set blurFilter($f:BlurFilterVars) : void
      {
         _blurFilter = _exposedVars.blurFilter = $f;
      }
      
      public function get frameLabel() : String
      {
         return _frameLabel;
      }
      
      public function get setSize() : Object
      {
         return _setSize;
      }
      
      public function set dropShadowFilter($f:DropShadowFilterVars) : void
      {
         _dropShadowFilter = _exposedVars.dropShadowFilter = $f;
      }
      
      public function get bevelFilter() : BevelFilterVars
      {
         return _bevelFilter;
      }
      
      public function set colorTransform($ct:ColorTransformVars) : void
      {
         _colorTransform = _exposedVars.colorTransform = $ct;
      }
      
      public function get colorMatrixFilter() : ColorMatrixFilterVars
      {
         return _colorMatrixFilter;
      }
      
      public function get removeTint() : Boolean
      {
         return _removeTint;
      }
      
      public function addProp($name:String, $value:Number, $relative:Boolean = false) : void
      {
         if($relative)
         {
            this[$name] = String($value);
         }
         else
         {
            this[$name] = $value;
         }
      }
      
      public function get orientToBezier() : *
      {
         return _orientToBezier;
      }
      
      public function get transformAroundPoint() : TransformAroundPointVars
      {
         return _transformAroundPoint;
      }
      
      public function get blurFilter() : BlurFilterVars
      {
         return _blurFilter;
      }
      
      public function set bezier($a:Array) : void
      {
         _bezier = _exposedVars.bezier = $a;
      }
      
      public function set glowFilter($f:GlowFilterVars) : void
      {
         _glowFilter = _exposedVars.glowFilter = $f;
      }
      
      public function set bezierThrough($a:Array) : void
      {
         _bezierThrough = _exposedVars.bezierThrough = $a;
      }
      
      public function set hexColors($o:Object) : void
      {
         _hexColors = _exposedVars.hexColors = $o;
      }
      
      public function get bezier() : Array
      {
         return _bezier;
      }
      
      public function set frame($n:int) : void
      {
         _frame = _exposedVars.frame = $n;
      }
      
      public function set visible($b:Boolean) : void
      {
         _visible = _exposedVars.visible = $b;
      }
      
      public function set autoAlpha($n:Number) : void
      {
         _autoAlpha = _exposedVars.autoAlpha = $n;
      }
      
      public function get bezierThrough() : Array
      {
         return _bezierThrough;
      }
      
      public function get autoAlpha() : Number
      {
         return _autoAlpha;
      }
      
      public function set tint($n:uint) : void
      {
         _tint = _exposedVars.tint = $n;
      }
      
      public function get tint() : uint
      {
         return _tint;
      }
   }
}

