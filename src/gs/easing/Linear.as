package gs.easing
{
   public class Linear
   {
      public function Linear()
      {
         super();
      }
      
      public static function easeOut(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * t / d + b;
      }
      
      public static function easeIn(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * t / d + b;
      }
      
      public static function easeInOut(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * t / d + b;
      }
      
      public static function easeNone(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * t / d + b;
      }
   }
}

