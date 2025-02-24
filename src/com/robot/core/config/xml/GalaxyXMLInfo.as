package com.robot.core.config.xml
{
   import org.taomee.ds.HashMap;
   
   public class GalaxyXMLInfo
   {
      private static var _hashMap:HashMap;
      
      private static var _xml:XML;
      
      private static var _xmllist:XMLList;
      
      private static var xmlClass:Class = GalaxyXMLInfo_xmlClass;
      
      setup();
      
      public function GalaxyXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         _hashMap = new HashMap();
         _xml = XML(new xmlClass());
         _xmllist = _xml.elements("galaxy");
         for each(item in _xmllist)
         {
            _hashMap.add(uint(item.@id),item);
         }
      }
      
      public static function getName(id:uint) : String
      {
         var xml:XML = _hashMap.getValue(id);
         if(Boolean(xml))
         {
            return xml.@name;
         }
         return "";
      }
   }
}

