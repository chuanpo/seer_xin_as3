package com.robot.core.config.xml
{
   import org.taomee.ds.HashMap;
   
   public class GoldProductXMLInfo
   {
      private static var _productMap:HashMap;
      
      private static var _itemMap:HashMap;
      
      private static var _xml:XML;
      
      private static var _xmllist:XMLList;
      
      private static var xmlClass:Class = GoldProductXMLInfo_xmlClass;
      
      setup();
      
      public function GoldProductXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         _productMap = new HashMap();
         _itemMap = new HashMap();
         _xml = XML(new xmlClass());
         _xmllist = _xml.elements("item");
         for each(item in _xmllist)
         {
            _productMap.add(item.@productID.toString(),item);
            _itemMap.add(item.@itemID.toString(),item);
         }
      }
      
      public static function getProductByItemId(id:uint) : uint
      {
         var xml:XML = _itemMap.getValue(id.toString());
         if(xml == null)
         {
            return 0;
         }
         return uint(xml.@productID);
      }
      
      public static function getItemIDs(proID:uint) : Array
      {
         var xml:XML = null;
         var str:String = null;
         xml = _xmllist.(@productID == proID)[0];
         str = xml.@itemID;
         return str.split("|");
      }
      
      public static function getNameByProID(proID:uint) : String
      {
         var xml:XML = _productMap.getValue(proID);
         if(Boolean(xml))
         {
            return xml.@name;
         }
         return "";
      }
      
      public static function getNameByItemID(id:uint) : String
      {
         var xml:XML = _itemMap.getValue(id);
         if(Boolean(xml))
         {
            return xml.@name;
         }
         return "";
      }
      
      public static function getPriceByProID(proID:uint) : uint
      {
         var xml:XML = null;
         xml = _xmllist.(@productID == proID)[0];
         return xml.@price;
      }
      
      public static function getPriceByItemID(id:uint) : uint
      {
         var xml:XML = null;
         xml = _xmllist.(@itemID == id)[0];
         return xml.@price;
      }
      
      public static function getVipByProID(proID:uint) : Number
      {
         var xml:XML = null;
         xml = _xmllist.(@productID == proID)[0];
         return xml.@vip;
      }
      
      public static function getVipByItemID(id:uint) : Number
      {
         var xml:XML = null;
         xml = _xmllist.(@itemID == id)[0];
         return xml.@vip;
      }
   }
}

