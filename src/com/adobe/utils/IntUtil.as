package com.adobe.utils
{
   public class IntUtil
   {
      private static var hexChars:String = "0123456789abcdef";
      
      public function IntUtil()
      {
         super();
      }
      
      public static function toHex(n:int, bigEndian:Boolean = false) : String
      {
         var i:int = 0;
         var x:int = 0;
         var s:String = "";
         if(bigEndian)
         {
            for(i = 0; i < 4; i++)
            {
               s += hexChars.charAt(n >> (3 - i) * 8 + 4 & 0x0F) + hexChars.charAt(n >> (3 - i) * 8 & 0x0F);
            }
         }
         else
         {
            for(x = 0; x < 4; x++)
            {
               s += hexChars.charAt(n >> x * 8 + 4 & 0x0F) + hexChars.charAt(n >> x * 8 & 0x0F);
            }
         }
         return s;
      }
      
      public static function ror(x:int, n:int) : uint
      {
         var nn:int = 32 - n;
         return x << nn | x >>> 32 - nn;
      }
      
      public static function rol(x:int, n:int) : int
      {
         return x << n | x >>> 32 - n;
      }
   }
}

