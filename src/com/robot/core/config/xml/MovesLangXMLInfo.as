package com.robot.core.config.xml
{
   import org.taomee.ds.HashMap;
   
   public class MovesLangXMLInfo
   {
      private static var _dataMap:HashMap;
      
      private static var xmlClass:Class = MovesLangXMLInfo_xmlClass;
      
      setup();
      
      public function MovesLangXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         _dataMap = new HashMap();
         var xl:XMLList = XML(new xmlClass()).elements("moves");
         for each(item in xl)
         {
            _dataMap.add(uint(item.@id),item.elements("lang"));
         }
      }
      
      public static function getRandomLang(id:uint) : String
      {
         var xxx:XML = null;
         var item:XMLList = _dataMap.getValue(id);
         if(Boolean(item))
         {
            xxx = item[int(item.length() * Math.random())];
            return xxx.toString();
         }
         return "";
      }
   }
}

