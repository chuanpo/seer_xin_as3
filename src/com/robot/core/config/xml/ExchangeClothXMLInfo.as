package com.robot.core.config.xml
{
   public class ExchangeClothXMLInfo
   {
      private static var xmlClass:Class = ExchangeClothXMLInfo_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      public function ExchangeClothXMLInfo()
      {
         super();
      }
      
      public static function getExchangeIdByItemId(id:String) : uint
      {
         var xmllist:XMLList = null;
         var xml1:XML = null;
         xmllist = xml.descendants("Exchange");
         xml1 = xmllist.(@ItemID == id)[0];
         return uint(xml1.@ID);
      }
   }
}

