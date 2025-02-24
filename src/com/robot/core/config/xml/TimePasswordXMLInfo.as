package com.robot.core.config.xml
{
   import org.taomee.ds.HashMap;
   
   public class TimePasswordXMLInfo
   {
      private static var _dataMap:HashMap;
      
      private static var _xml:XML;
      
      private static var xmlClass:Class = TimePasswordXMLInfo_xmlClass;
      
      setup();
      
      public function TimePasswordXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         _dataMap = new HashMap();
         _xml = XML(new xmlClass());
         var xl:XMLList = _xml.elements("item");
         for each(item in xl)
         {
            _dataMap.add(item.@id.toString(),item);
         }
      }
      
      public static function getIDList() : Array
      {
         return _dataMap.getKeys();
      }
   }
}

