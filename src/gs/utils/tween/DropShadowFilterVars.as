package gs.utils.tween
{
   public class DropShadowFilterVars extends FilterVars
   {
      protected var _blurX:Number;
      
      protected var _blurY:Number;
      
      protected var _distance:Number;
      
      protected var _inner:Boolean;
      
      protected var _quality:uint;
      
      protected var _knockout:Boolean;
      
      protected var _angle:Number;
      
      protected var _alpha:Number;
      
      protected var _strength:Number;
      
      protected var _hideObject:Boolean;
      
      protected var _color:uint;
      
      public function DropShadowFilterVars($distance:Number = 4, $blurX:Number = 4, $blurY:Number = 4, $alpha:Number = 1, $angle:Number = 45, $color:uint = 0, $strength:Number = 2, $inner:Boolean = false, $knockout:Boolean = false, $hideObject:Boolean = false, $quality:uint = 2, $remove:Boolean = false, $index:int = -1, $addFilter:Boolean = false)
      {
         super($remove,$index,$addFilter);
         this.distance = $distance;
         this.blurX = $blurX;
         this.blurY = $blurY;
         this.alpha = $alpha;
         this.angle = $angle;
         this.color = $color;
         this.strength = $strength;
         this.inner = $inner;
         this.knockout = $knockout;
         this.hideObject = $hideObject;
         this.quality = $quality;
      }
      
      public static function createFromGeneric($vars:Object) : DropShadowFilterVars
      {
         if($vars is DropShadowFilterVars)
         {
            return $vars as DropShadowFilterVars;
         }
         return new DropShadowFilterVars(Number($vars.distance) || 0,Number($vars.blurX) || 0,Number($vars.blurY) || 0,Number($vars.alpha) || 0,$vars.angle == null ? 45 : Number($vars.angle),$vars.color == null ? 0 : uint($vars.color),$vars.strength == null ? 2 : Number($vars.strength),Boolean($vars.inner),Boolean($vars.knockout),Boolean($vars.hideObject),uint($vars.quality) || 2,Boolean($vars.remove),$vars.index == null ? -1 : int($vars.index),$vars.addFilter);
      }
      
      public function get strength() : Number
      {
         return _strength;
      }
      
      public function set strength($n:Number) : void
      {
         _strength = this.exposedVars.strength = $n;
      }
      
      public function set alpha($n:Number) : void
      {
         _alpha = this.exposedVars.alpha = $n;
      }
      
      public function set quality($n:uint) : void
      {
         _quality = this.exposedVars.quality = $n;
      }
      
      public function set color($n:uint) : void
      {
         _color = this.exposedVars.color = $n;
      }
      
      public function set hideObject($b:Boolean) : void
      {
         _hideObject = this.exposedVars.hideObject = $b;
      }
      
      public function get blurX() : Number
      {
         return _blurX;
      }
      
      public function get inner() : Boolean
      {
         return _inner;
      }
      
      public function get angle() : Number
      {
         return _angle;
      }
      
      public function get alpha() : Number
      {
         return _alpha;
      }
      
      public function get blurY() : Number
      {
         return _blurY;
      }
      
      public function get color() : uint
      {
         return _color;
      }
      
      public function set blurX($n:Number) : void
      {
         _blurX = this.exposedVars.blurX = $n;
      }
      
      public function set distance($n:Number) : void
      {
         _distance = this.exposedVars.distance = $n;
      }
      
      public function set inner($b:Boolean) : void
      {
         _inner = this.exposedVars.inner = $b;
      }
      
      public function set angle($n:Number) : void
      {
         _angle = this.exposedVars.angle = $n;
      }
      
      public function get hideObject() : Boolean
      {
         return _hideObject;
      }
      
      public function set knockout($b:Boolean) : void
      {
         _knockout = this.exposedVars.knockout = $b;
      }
      
      public function get distance() : Number
      {
         return _distance;
      }
      
      public function get knockout() : Boolean
      {
         return _knockout;
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

