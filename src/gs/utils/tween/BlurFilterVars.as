package gs.utils.tween
{
   public class BlurFilterVars extends FilterVars
   {
      protected var _quality:uint;
      
      protected var _blurX:Number;
      
      protected var _blurY:Number;
      
      public function BlurFilterVars($blurX:Number = 10, $blurY:Number = 10, $quality:uint = 2, $remove:Boolean = false, $index:int = -1, $addFilter:Boolean = false)
      {
         super($remove,$index,$addFilter);
         this.blurX = $blurX;
         this.blurY = $blurY;
         this.quality = $quality;
      }
      
      public static function createFromGeneric($vars:Object) : BlurFilterVars
      {
         if($vars is BlurFilterVars)
         {
            return $vars as BlurFilterVars;
         }
         return new BlurFilterVars(Number($vars.blurX) || 0,Number($vars.blurY) || 0,uint($vars.quality) || 2,Boolean($vars.remove),$vars.index == null ? -1 : int($vars.index),Boolean($vars.addFilter));
      }
      
      public function set blurX($n:Number) : void
      {
         _blurX = this.exposedVars.blurX = $n;
      }
      
      public function set blurY($n:Number) : void
      {
         _blurY = this.exposedVars.blurY = $n;
      }
      
      public function get blurX() : Number
      {
         return _blurX;
      }
      
      public function get blurY() : Number
      {
         return _blurY;
      }
      
      public function set quality($n:uint) : void
      {
         _quality = this.exposedVars.quality = $n;
      }
      
      public function get quality() : uint
      {
         return _quality;
      }
   }
}

