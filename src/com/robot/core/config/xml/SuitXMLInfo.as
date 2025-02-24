package com.robot.core.config.xml
{
   import org.taomee.ds.HashMap;
   import org.taomee.utils.ArrayUtil;
   
   public class SuitXMLInfo
   {
      private static var _dataMap:HashMap;
      
      private static var map:HashMap;
      
      private static var xmlClass:Class = SuitXMLInfo_xmlClass;
      
      setup();
      
      public function SuitXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         var array:Array = null;
         _dataMap = new HashMap();
         map = new HashMap();
         var xl:XMLList = XML(new xmlClass()).elements("item");
         for each(item in xl)
         {
            _dataMap.add(uint(item.@id),item);
            array = String(item.@cloths).split(" ");
            array.forEach(function(element:String, index:int, arr:Array):void
            {
               arr[index] = uint(element);
            });
            array.sort(Array.NUMERIC);
            map.add(array.join(","),item);
         }
      }
      
      public static function getSuitID(clothIDs:Array) : uint
      {
         var str:String;
         var xml:XML;
         var array:Array = clothIDs.slice();
         array = array.filter(function(e:uint, index:int, _a:Array):Boolean
         {
            if(ItemXMLInfo.getType(e) == "bg")
            {
               return false;
            }
            return true;
         });
         array.forEach(function(element:String, index:int, arr:Array):void
         {
            arr[index] = uint(element);
         });
         array.sort(Array.NUMERIC);
         str = array.join(",");
         xml = map.getValue(str);
         if(Boolean(xml))
         {
            return xml.@id;
         }
         return 0;
      }
      
      public static function getIsTransform(id:uint) : Boolean
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return uint(xml.@transform) == 1;
         }
         return false;
      }
      
      public static function getCloths(id:uint) : Array
      {
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            return String(item.@cloths).split(" ");
         }
         return null;
      }
      
      public static function getSuitTranSpeed(id:uint) : Number
      {
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            return Number(item.@tranSpeed);
         }
         return 4;
      }
      
      public static function getName(id:uint) : String
      {
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            return String(item.@name);
         }
         return "";
      }
      
      public static function getClothsForItem(itemID:uint) : Array
      {
         var item:XML = null;
         var carr:Array = null;
         var arr:Array = _dataMap.getValues();
         for each(item in arr)
         {
            carr = String(item.@cloths).split(" ");
            if(carr.indexOf(itemID.toString()) != -1)
            {
               return carr;
            }
         }
         return null;
      }
      
      public static function getIDForItem(itemID:uint) : uint
      {
         var item:XML = null;
         var carr:Array = null;
         var arr:Array = _dataMap.getValues();
         for each(item in arr)
         {
            carr = String(item.@cloths).split(" ");
            if(carr.indexOf(itemID) != -1)
            {
               return uint(item.@id);
            }
         }
         return 0;
      }
      
      public static function getIsEliteItems(items:Array) : Array
      {
         var item:XML = null;
         var carr:Array = null;
         var itemID:uint = 0;
         var idList:Array = [];
         var arr:Array = _dataMap.getValues();
         for each(item in arr)
         {
            carr = String(item.@cloths).split(" ");
            for each(itemID in items)
            {
               if(ArrayUtil.arrayContainsValue(carr,itemID.toString()))
               {
                  if(getIsElite(item.@id))
                  {
                     idList.push(uint(item.@id));
                     break;
                  }
               }
            }
         }
         return idList;
      }
      
      public static function getIDsForItems(items:Array) : Array
      {
         var item:XML = null;
         var carr:Array = null;
         var itemID:uint = 0;
         var idList:Array = [];
         var arr:Array = _dataMap.getValues();
         for each(item in arr)
         {
            carr = String(item.@cloths).split(" ");
            for each(itemID in items)
            {
               if(ArrayUtil.arrayContainsValue(carr,itemID.toString()))
               {
                  idList.push(uint(item.@id));
                  break;
               }
            }
         }
         return idList;
      }
      
      private static function getIsElite(id:uint) : Boolean
      {
         var item:XML = _dataMap.getValue(id);
         return Boolean(uint(item.@elite));
      }
      
      public static function getIsVip(id:uint) : Boolean
      {
         var item:XML = _dataMap.getValue(id);
         return Boolean(uint(item.@VipOnly));
      }
   }
}

