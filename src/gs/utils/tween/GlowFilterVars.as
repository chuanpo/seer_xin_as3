package gs.utils.tween
{
   public class GlowFilterVars extends FilterVars
   {
      protected var _quality:uint;
      
      protected var _blurY:Number;
      
      protected var _inner:Boolean;
      
      protected var _blurX:Number;
      
      protected var _alpha:Number;
      
      protected var _strength:Number;
      
      protected var _color:uint;
      
      protected var _knockout:Boolean;
      
      public function GlowFilterVars($blurX:Number = 10, $blurY:Number = 10, $color:uint = 16777215, $alpha:Number = 1, $strength:Number = 2, $inner:Boolean = false, $knockout:Boolean = false, $quality:uint = 2, $remove:Boolean = false, $index:int = -1, $addFilter:Boolean = false)
      {
         super($remove,$index,$addFilter);
         this.blurX = $blurX;
         this.blurY = $blurY;
         this.color = $color;
         this.alpha = $alpha;
         this.strength = $strength;
         this.inner = $inner;
         this.knockout = $knockout;
         this.quality = $quality;
      }
      
      public static function createFromGeneric($vars:Object) : GlowFilterVars
      {
         if($vars is GlowFilterVars)
         {
            return $vars as GlowFilterVars;
         }
         return new GlowFilterVars(Number($vars.blurX) || 0,Number($vars.blurY) || 0,$vars.color == null ? 0 : uint($vars.color),Number($vars.alpha) || 0,$vars.strength == null ? 2 : Number($vars.strength),Boolean($vars.inner),Boolean($vars.knockout),uint($vars.quality) || 2,Boolean($vars.remove),$vars.index == null ? -1 : int($vars.index),Boolean($vars.addFilter));
      }
      
      public function get strength() : Number
      {
         return _strength;
      }
      
      public function set strength($n:Number) : void
      {
         _strength = this.exposedVars.strength = $n;
      }
      
      public function set quality($n:uint) : void
      {
         _quality = this.exposedVars.quality = $n;
      }
      
      public function set color($n:uint) : void
      {
         _color = this.exposedVars.color = $n;
      }
      
      public function get blurX() : Number
      {
         return _blurX;
      }
      
      public function get blurY() : Number
      {
         return _blurY;
      }
      
      public function get inner() : Boolean
      {
         return _inner;
      }
      
      public function set blurY($n:Number) : void
      {
         _blurY = this.exposedVars.blurY = $n;
      }
      
      public function get alpha() : Number
      {
         return _alpha;
      }
      
      public function set blurX($n:Number) : void
      {
         _blurX = this.exposedVars.blurX = $n;
      }
      
      public function get color() : uint
      {
         return _color;
      }
      
      public function set inner($b:Boolean) : void
      {
         _inner = this.exposedVars.inner = $b;
      }
      
      public function set knockout($b:Boolean) : void
      {
         _knockout = this.exposedVars.knockout = $b;
      }
      
      public function get knockout() : Boolean
      {
         return _knockout;
      }
      
      public function set alpha($n:Number) : void
      {
         _alpha = this.exposedVars.alpha = $n;
      }
      
      public function get quality() : uint
      {
         return _quality;
      }
   }
}

