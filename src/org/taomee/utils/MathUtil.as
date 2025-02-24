package org.taomee.utils
{
   public class MathUtil
   {
      public function MathUtil()
      {
         super();
      }
      
      public static function randomHalfAdd(v:Number) : Number
      {
         return v + Math.random() * (v / 2);
      }
      
      public static function randomHalve(v:Number) : Number
      {
         return v - Math.random() * (v / 2);
      }
      
      public static function randomRegion(start:Number, end:Number) : Number
      {
         return start + Math.random() * (end - start);
      }
   }
}

