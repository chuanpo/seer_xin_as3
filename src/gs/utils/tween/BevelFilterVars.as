package gs.utils.tween
{
   public class BevelFilterVars extends FilterVars
   {
      protected var _quality:uint;
      
      protected var _blurY:Number;
      
      protected var _distance:Number;
      
      protected var _blurX:Number;
      
      protected var _angle:Number;
      
      protected var _shadowAlpha:Number;
      
      protected var _strength:Number;
      
      protected var _highlightAlpha:Number;
      
      protected var _shadowColor:uint;
      
      protected var _highlightColor:uint;
      
      public function BevelFilterVars($distance:Number = 4, $blurX:Number = 4, $blurY:Number = 4, $strength:Number = 1, $angle:Number = 45, $highlightAlpha:Number = 1, $highlightColor:uint = 16777215, $shadowAlpha:Number = 1, $shadowColor:uint = 0, $quality:uint = 2, $remove:Boolean = false, $index:int = -1, $addFilter:Boolean = false)
      {
         super($remove,$index,$addFilter);
         this.distance = $distance;
         this.blurX = $blurX;
         this.blurY = $blurY;
         this.strength = $strength;
         this.angle = $angle;
         this.highlightAlpha = $highlightAlpha;
         this.highlightColor = $highlightColor;
         this.shadowAlpha = $shadowAlpha;
         this.shadowColor = $shadowColor;
         this.quality = $quality;
      }
      
      public static function createFromGeneric($vars:Object) : BevelFilterVars
      {
         if($vars is BevelFilterVars)
         {
            return $vars as BevelFilterVars;
         }
         return new BevelFilterVars(Number($vars.distance) || 0,Number($vars.blurX) || 0,Number($vars.blurY) || 0,$vars.strength == null ? 1 : Number($vars.strength),$vars.angle == null ? 45 : Number($vars.angle),$vars.highlightAlpha == null ? 1 : Number($vars.highlightAlpha),$vars.highlightColor == null ? 16777215 : uint($vars.highlightColor),$vars.shadowAlpha == null ? 1 : Number($vars.shadowAlpha),$vars.shadowColor == null ? 16777215 : uint($vars.shadowColor),uint($vars.quality) || 2,Boolean($vars.remove),$vars.index == null ? -1 : int($vars.index),Boolean($vars.addFilter));
      }
      
      public function get strength() : Number
      {
         return _strength;
      }
      
      public function set strength($n:Number) : void
      {
         _strength = this.exposedVars.strength = $n;
      }
      
      public function set shadowAlpha($n:Number) : void
      {
         _shadowAlpha = this.exposedVars.shadowAlpha = $n;
      }
      
      public function set quality($n:uint) : void
      {
         _quality = this.exposedVars.quality = $n;
      }
      
      public function set shadowColor($n:uint) : void
      {
         _shadowColor = this.exposedVars.shadowColor = $n;
      }
      
      public function get highlightAlpha() : Number
      {
         return _highlightAlpha;
      }
      
      public function get blurX() : Number
      {
         return _blurX;
      }
      
      public function get highlightColor() : uint
      {
         return _highlightColor;
      }
      
      public function get angle() : Number
      {
         return _angle;
      }
      
      public function set highlightColor($n:uint) : void
      {
         _highlightColor = this.exposedVars.highlightColor = $n;
      }
      
      public function get blurY() : Number
      {
         return _blurY;
      }
      
      public function set blurX($n:Number) : void
      {
         _blurX = this.exposedVars.blurX = $n;
      }
      
      public function set highlightAlpha($n:Number) : void
      {
         _highlightAlpha = this.exposedVars.highlightAlpha = $n;
      }
      
      public function get shadowAlpha() : Number
      {
         return _shadowAlpha;
      }
      
      public function set distance($n:Number) : void
      {
         _distance = this.exposedVars.distance = $n;
      }
      
      public function set angle($n:Number) : void
      {
         _angle = this.exposedVars.angle = $n;
      }
      
      public function get shadowColor() : uint
      {
         return _shadowColor;
      }
      
      public function get distance() : Number
      {
         return _distance;
      }
      
      public function set blurY($n:Number) : void
      {
         _blurY = this.exposedVars.blurY = $n;
      }
      
      public function get quality() : uint
      {
         return _quality;
      }
   }
}

