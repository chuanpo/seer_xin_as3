package com.robot.core.config.xml
{
   import flash.utils.Dictionary;
   import org.taomee.utils.ArrayUtil;
   
   public class SpecialXMLInfo
   {
      private static var array:Array;
      
      private static var dict:Dictionary;
      
      private static var xmlClass:Class = SpecialXMLInfo_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      setup();
      
      public function SpecialXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         var _id:uint = 0;
         var cloths:Array = null;
         array = [];
         dict = new Dictionary();
         var xl:XMLList = xml.elements("item");
         for each(item in xl)
         {
            _id = uint(item.@id);
            cloths = String(item.@cloths).split(",");
            array.push(cloths);
            dict[cloths] = _id;
         }
      }
      
      public static function getSpecialID(clothes:Array) : uint
      {
         var i:Array = null;
         var id:uint = 0;
         for each(i in array)
         {
            if(ArrayUtil.arraysAreEqual(clothes,i))
            {
               return uint(dict[i]);
            }
         }
         return id;
      }
   }
}

