package gs.utils.tween
{
   public class ColorTransformVars extends SubVars
   {
      public function ColorTransformVars($tint:Number = NaN, $tintAmount:Number = NaN, $exposure:Number = NaN, $brightness:Number = NaN, $redMultiplier:Number = NaN, $greenMultiplier:Number = NaN, $blueMultiplier:Number = NaN, $alphaMultiplier:Number = NaN, $redOffset:Number = NaN, $greenOffset:Number = NaN, $blueOffset:Number = NaN, $alphaOffset:Number = NaN)
      {
         super();
         if(!isNaN($tint))
         {
            this.tint = uint($tint);
         }
         if(!isNaN($tintAmount))
         {
            this.tintAmount = $tintAmount;
         }
         if(!isNaN($exposure))
         {
            this.exposure = $exposure;
         }
         if(!isNaN($brightness))
         {
            this.brightness = $brightness;
         }
         if(!isNaN($redMultiplier))
         {
            this.redMultiplier = $redMultiplier;
         }
         if(!isNaN($greenMultiplier))
         {
            this.greenMultiplier = $greenMultiplier;
         }
         if(!isNaN($blueMultiplier))
         {
            this.blueMultiplier = $blueMultiplier;
         }
         if(!isNaN($alphaMultiplier))
         {
            this.alphaMultiplier = $alphaMultiplier;
         }
         if(!isNaN($redOffset))
         {
            this.redOffset = $redOffset;
         }
         if(!isNaN($greenOffset))
         {
            this.greenOffset = $greenOffset;
         }
         if(!isNaN($blueOffset))
         {
            this.blueOffset = $blueOffset;
         }
         if(!isNaN($alphaOffset))
         {
            this.alphaOffset = $alphaOffset;
         }
      }
      
      public static function createFromGeneric($vars:Object) : ColorTransformVars
      {
         if($vars is ColorTransformVars)
         {
            return $vars as ColorTransformVars;
         }
         return new ColorTransformVars($vars.tint,$vars.tintAmount,$vars.exposure,$vars.brightness,$vars.redMultiplier,$vars.greenMultiplier,$vars.blueMultiplier,$vars.alphaMultiplier,$vars.redOffset,$vars.greenOffset,$vars.blueOffset,$vars.alphaOffset);
      }
      
      public function get tint() : Number
      {
         return Number(this.exposedVars.tint);
      }
      
      public function get redOffset() : Number
      {
         return Number(this.exposedVars.redOffset);
      }
      
      public function set blueMultiplier($n:Number) : void
      {
         this.exposedVars.blueMultiplier = $n;
      }
      
      public function get exposure() : Number
      {
         return Number(this.exposedVars.exposure);
      }
      
      public function set greenMultiplier($n:Number) : void
      {
         this.exposedVars.greenMultiplier = $n;
      }
      
      public function get blueOffset() : Number
      {
         return Number(this.exposedVars.blueOffset);
      }
      
      public function set exposure($n:Number) : void
      {
         this.exposedVars.exposure = $n;
      }
      
      public function set redOffset($n:Number) : void
      {
         this.exposedVars.redOffset = $n;
      }
      
      public function get brightness() : Number
      {
         return Number(this.exposedVars.brightness);
      }
      
      public function get alphaOffset() : Number
      {
         return Number(this.exposedVars.alphaOffset);
      }
      
      public function set blueOffset($n:Number) : void
      {
         this.exposedVars.blueOffset = $n;
      }
      
      public function set brightness($n:Number) : void
      {
         this.exposedVars.brightness = $n;
      }
      
      public function set redMultiplier($n:Number) : void
      {
         this.exposedVars.redMultiplier = $n;
      }
      
      public function set tintAmount($n:Number) : void
      {
         this.exposedVars.tintAmount = $n;
      }
      
      public function set alphaOffset($n:Number) : void
      {
         this.exposedVars.alphaOffset = $n;
      }
      
      public function get greenMultiplier() : Number
      {
         return Number(this.exposedVars.greenMultiplier);
      }
      
      public function set greenOffset($n:Number) : void
      {
         this.exposedVars.greenOffset = $n;
      }
      
      public function get redMultiplier() : Number
      {
         return Number(this.exposedVars.redMultiplier);
      }
      
      public function get tintAmount() : Number
      {
         return Number(this.exposedVars.tintAmount);
      }
      
      public function get greenOffset() : Number
      {
         return Number(this.exposedVars.greenOffset);
      }
      
      public function get blueMultiplier() : Number
      {
         return Number(this.exposedVars.blueMultiplier);
      }
      
      public function set tint($n:Number) : void
      {
         this.exposedVars.tint = $n;
      }
      
      public function set alphaMultiplier($n:Number) : void
      {
         this.exposedVars.alphaMultiplier = $n;
      }
      
      public function get alphaMultiplier() : Number
      {
         return Number(this.exposedVars.alphaMultiplier);
      }
   }
}

