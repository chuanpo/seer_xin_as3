package gs.utils.tween
{
   import gs.plugins.*;
   
   public class ColorMatrixFilterVars extends FilterVars
   {
      protected static var _ID_MATRIX:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
      
      protected static var _lumR:Number = 0.212671;
      
      protected static var _lumG:Number = 0.71516;
      
      protected static var _lumB:Number = 0.072169;
      
      public var matrix:Array;
      
      public function ColorMatrixFilterVars($colorize:uint = 16777215, $amount:Number = 1, $saturation:Number = 1, $contrast:Number = 1, $brightness:Number = 1, $hue:Number = 0, $threshold:Number = -1, $remove:Boolean = false, $index:int = -1, $addFilter:Boolean = false)
      {
         super($remove,$index,$addFilter);
         this.matrix = _ID_MATRIX.slice();
         if($brightness != 1)
         {
            setBrightness($brightness);
         }
         if($contrast != 1)
         {
            setContrast($contrast);
         }
         if($hue != 0)
         {
            setHue($hue);
         }
         if($saturation != 1)
         {
            setSaturation($saturation);
         }
         if($threshold != -1)
         {
            setThreshold($threshold);
         }
         if($colorize != 16777215)
         {
            setColorize($colorize,$amount);
         }
      }
      
      public static function createFromGeneric($vars:Object) : ColorMatrixFilterVars
      {
         var v:ColorMatrixFilterVars = null;
         if($vars is ColorMatrixFilterVars)
         {
            v = $vars as ColorMatrixFilterVars;
         }
         else if($vars.matrix != null)
         {
            v = new ColorMatrixFilterVars();
            v.matrix = $vars.matrix;
         }
         else
         {
            v = new ColorMatrixFilterVars(uint($vars.colorize) || 16777215,$vars.amount == null ? 1 : Number($vars.amount),$vars.saturation == null ? 1 : Number($vars.saturation),$vars.contrast == null ? 1 : Number($vars.contrast),$vars.brightness == null ? 1 : Number($vars.brightness),Number($vars.hue) || 0,$vars.threshold == null ? -1 : Number($vars.threshold),Boolean($vars.remove),$vars.index == null ? -1 : int($vars.index),Boolean($vars.addFilter));
         }
         return v;
      }
      
      public function setContrast($n:Number) : void
      {
         this.matrix = this.exposedVars.matrix = ColorMatrixFilterPlugin.setContrast(this.matrix,$n);
      }
      
      public function setColorize($color:uint, $amount:Number = 1) : void
      {
         this.matrix = this.exposedVars.matrix = ColorMatrixFilterPlugin.colorize(this.matrix,$color,$amount);
      }
      
      public function setHue($n:Number) : void
      {
         this.matrix = this.exposedVars.matrix = ColorMatrixFilterPlugin.setHue(this.matrix,$n);
      }
      
      public function setThreshold($n:Number) : void
      {
         this.matrix = this.exposedVars.matrix = ColorMatrixFilterPlugin.setThreshold(this.matrix,$n);
      }
      
      public function setBrightness($n:Number) : void
      {
         this.matrix = this.exposedVars.matrix = ColorMatrixFilterPlugin.setBrightness(this.matrix,$n);
      }
      
      public function setSaturation($n:Number) : void
      {
         this.matrix = this.exposedVars.matrix = ColorMatrixFilterPlugin.setSaturation(this.matrix,$n);
      }
   }
}

