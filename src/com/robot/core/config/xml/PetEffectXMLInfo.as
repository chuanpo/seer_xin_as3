package com.robot.core.config.xml
{
   import org.taomee.ds.HashMap;
   
   public class PetEffectXMLInfo
   {
      private static var _dataMap:HashMap;
      
      private static var _statXML:XMLList;
      
      private static var xmlClass:Class = PetEffectXMLInfo_xmlClass;
      
      setup();
      
      public function PetEffectXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         var _id:uint = 0;
         _dataMap = new HashMap();
         var xl:XMLList = XML(new xmlClass()).elements("NewSeIdx");
         _statXML = xl.(@Stat == 1);
         trace(_statXML);
         for each(item in xl)
         {
            _id = uint(item.@ItemId);
            if(_id > 0)
            {
               _dataMap.add(_id,item);
            }
         }
      }
      
      public static function getItemIdForEffectId(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id) as XML;
         return uint(xml.@ItemId);
      }
      
      public static function getDes(id:uint) : String
      {
         var xml:XML = _dataMap.getValue(id) as XML;
         return xml.@Des;
      }
      
      public static function getEffect(eid:uint, arg:String) : String
      {
         var xmllist:XMLList = null;
         var xml:XML = null;
         xmllist = _statXML.(@Eid == eid);
         if(xmllist.length() > 0)
         {
            xml = xmllist.(@Args == arg)[0];
            if(Boolean(xml))
            {
               return xml.@Desc;
            }
            return "";
         }
         return "";
      }
   }
}

