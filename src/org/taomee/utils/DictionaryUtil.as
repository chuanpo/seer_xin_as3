package org.taomee.utils
{
   import flash.utils.Dictionary;
   
   public class DictionaryUtil
   {
      public function DictionaryUtil()
      {
         super();
      }
      
      public static function getValues(d:Dictionary) : Array
      {
         var value:Object = null;
         var a:Array = new Array();
         for each(value in d)
         {
            a.push(value);
         }
         return a;
      }
      
      public static function getKeys(d:Dictionary) : Array
      {
         var key:Object = null;
         var a:Array = new Array();
         for(key in d)
         {
            a.push(key);
         }
         return a;
      }
   }
}

