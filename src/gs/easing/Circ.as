package gs.easing
{
   public class Circ
   {
      public function Circ()
      {
         super();
      }
      
      public static function easeOut(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * Math.sqrt(1 - (t = t / d - 1) * t) + b;
      }
      
      public static function easeIn(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return -c * (Math.sqrt(1 - (t = t / d) * t) - 1) + b;
      }
      
      public static function easeInOut(t:Number, b:Number, c:Number, d:Number) : Number
      {
         t = t / (d / 2);
         if(t < 1)
         {
            return -c / 2 * (Math.sqrt(1 - t * t) - 1) + b;
         }
         return c / 2 * (Math.sqrt(1 - (t = t - 2) * t) + 1) + b;
      }
   }
}

