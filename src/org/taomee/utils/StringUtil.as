package org.taomee.utils
{
   import flash.utils.ByteArray;
   
   public class StringUtil
   {
      private static const HEX_Head:String = "0x";
      
      public function StringUtil()
      {
         super();
      }
      
      public static function trim(input:String) : String
      {
         return StringUtil.leftTrim(StringUtil.rightTrim(input));
      }
      
      public static function ipToUint(i:String) : uint
      {
         var str:String = null;
         var arr:Array = i.split(".");
         str = HEX_Head;
         arr.forEach(function(item:String, index:int, array:Array):void
         {
            str += uint(item).toString(16);
         });
         return uint(str);
      }
      
      public static function timeFormat(value:int, sm:String = "-") : String
      {
         var t:Date = new Date(value * 1000);
         return t.getFullYear().toString() + sm + (t.getMonth() + 1).toString() + sm + t.getDate().toString();
      }
      
      public static function endsWith(input:String, suffix:String) : Boolean
      {
         return suffix == input.substring(input.length - suffix.length);
      }
      
      public static function remove(input:String, remove:String) : String
      {
         return StringUtil.replace(input,remove,"");
      }
      
      public static function leftTrim(input:String) : String
      {
         var size:Number = input.length;
         for(var i:Number = 0; i < size; i++)
         {
            if(input.charCodeAt(i) > 32)
            {
               return input.substring(i);
            }
         }
         return "";
      }
      
      public static function stopwatchFormat(value:int) : String
      {
         var minute:int = value / 60;
         var second:int = value % 60;
         var strM:String = minute < 10 ? "0" + minute.toString() : minute.toString();
         var strS:String = second < 10 ? "0" + second.toString() : second.toString();
         return strM + ":" + strS;
      }
      
      public static function stringHasValue(s:String) : Boolean
      {
         return s != null && s.length > 0;
      }
      
      public static function beginsWith(input:String, prefix:String) : Boolean
      {
         return prefix == input.substring(0,prefix.length);
      }
      
      public static function replace(input:String, replace:String, replaceWith:String) : String
      {
         var j:Number = NaN;
         var sb:String = new String();
         var found:Boolean = false;
         var sLen:Number = input.length;
         var rLen:Number = replace.length;
         for(var i:Number = 0; i < sLen; i++)
         {
            if(input.charAt(i) == replace.charAt(0))
            {
               found = true;
               for(j = 0; j < rLen; j++)
               {
                  if(input.charAt(i + j) != replace.charAt(j))
                  {
                     found = false;
                     break;
                  }
               }
               if(found)
               {
                  sb += replaceWith;
                  i += rLen - 1;
                  continue;
               }
            }
            sb += input.charAt(i);
         }
         return sb;
      }
      
      public static function renewZero(str:String, len:int) : String
      {
         var i:int = 0;
         var bul:String = "";
         var strLen:int = str.length;
         if(strLen < len)
         {
            for(i = 0; i < len - strLen; i++)
            {
               bul += "0";
            }
            return bul + str;
         }
         return str;
      }
      
      public static function toByteArray(s:String, length:uint) : ByteArray
      {
         var _byte:ByteArray = new ByteArray();
         _byte.writeUTFBytes(s);
         _byte.length = length;
         _byte.position = 0;
         return _byte;
      }
      
      public static function stringsAreEqual(s1:String, s2:String, caseSensitive:Boolean) : Boolean
      {
         if(caseSensitive)
         {
            return s1 == s2;
         }
         return s1.toUpperCase() == s2.toUpperCase();
      }
      
      public static function uintToIp(v:uint) : String
      {
         var str:String = v.toString(16);
         var ip1:String = uint(HEX_Head + str.slice(0,2)).toString();
         var ip2:String = uint(HEX_Head + str.slice(2,4)).toString();
         var ip3:String = uint(HEX_Head + str.slice(4,6)).toString();
         var ip4:String = uint(HEX_Head + str.slice(6)).toString();
         return ip1 + "." + ip2 + "." + ip3 + "." + ip4;
      }
      
      public static function hexToIp(a:uint) : String
      {
         var by:ByteArray = new ByteArray();
         by.writeUnsignedInt(a);
         by.position = 0;
         var str:String = "";
         for(var i:uint = 0; i < 4; i++)
         {
            str += by.readUnsignedByte().toString() + ".";
         }
         return str.substr(0,str.length - 1);
      }
      
      public static function rightTrim(input:String) : String
      {
         var size:Number = input.length;
         for(var i:Number = size; i > 0; i--)
         {
            if(input.charCodeAt(i - 1) > 32)
            {
               return input.substring(0,i);
            }
         }
         return "";
      }
   }
}

