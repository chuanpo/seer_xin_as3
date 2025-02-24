package com.robot.core.utils
{
   public class NumberUtils
   {
      public function NumberUtils()
      {
         super();
      }
      
      public static function random(min:Number, max:Number) : Number
      {
         var nTemp:Number = NaN;
         if(min > max)
         {
            nTemp = min;
            min = max;
            max = nTemp;
         }
         var nRange:Number = max - min;
         var nRandomNumber:Number = Math.random() * nRange;
         nRandomNumber += min;
         return Math.round(nRandomNumber);
      }
      
      public static function getGaussian(mu:Number = 0, sigma:Number = 1) : Number
      {
         var r1:Number = Math.random();
         var r2:Number = Math.random();
         return Math.sqrt(-2 * Math.log(r1)) * Math.cos(2 * Math.PI * r2) * sigma + mu;
      }
   }
}

