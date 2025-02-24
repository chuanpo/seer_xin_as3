package gs.easing
{
   public class Quint
   {
      public function Quint()
      {
         super();
      }
      
      public static function easeOut(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * ((t = t / d - 1) * t * t * t * t + 1) + b;
      }
      
      public static function easeIn(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * (t = t / d) * t * t * t * t + b;
      }
      
      public static function easeInOut(t:Number, b:Number, c:Number, d:Number) : Number
      {
         t = t / (d / 2);
         if(t < 1)
         {
            return c / 2 * t * t * t * t * t + b;
         }
         return c / 2 * ((t = t - 2) * t * t * t * t + 2) + b;
      }
   }
}

