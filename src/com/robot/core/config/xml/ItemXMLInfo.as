package com.robot.core.config.xml
{
   import com.robot.core.info.item.ClothInfo;
   import com.robot.core.manager.MainManager;
   import org.taomee.ds.HashMap;
   
   public class ItemXMLInfo
   {
      private static var xmllist:XMLList;
      
      private static var _speedMap:HashMap;
      
      private static var xmlClass:Class = ItemXMLInfo_xmlClass;
      
      private static var xml:XML = XML(new xmlClass());
      
      public function ItemXMLInfo()
      {
         super();
      }
      
      public static function parseInfo() : void
      {
         var item:XML = null;
         _speedMap = new HashMap();
         xmllist = xml.descendants("Item");
         for each(item in xmllist)
         {
            if(String(item.@type) == "foot")
            {
               if(Boolean(xml.hasOwnProperty("@speed")))
               {
                  _speedMap.add(uint(item.@ID),MainManager.DfSpeed);
               }
               else
               {
                  _speedMap.add(uint(item.@ID),Number(item.@speed));
               }
            }
         }
         ClothInfo.parseInfo(xml.Cat.(@ID == 1)[0]);
         DoodleXMLInfo.setup(xml.Cat.(@ID == 2)[0]);
      }
      
      public static function getName(id:uint) : String
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return xml.@Name;
      }
      
      public static function getPrice(id:uint) : uint
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return xml.@Price;
      }
      
      public static function getSellPrice(id:uint) : uint
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return xml.@SellPrice;
      }
      
      public static function getRule(id:uint) : String
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         if(Boolean(xml.hasOwnProperty("@Rule")))
         {
            return xml.@Rule;
         }
         return "";
      }
      
      public static function getType(id:uint) : String
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return xml.@type;
      }
      
      public static function getSwfURL(id:uint, level:uint = 1) : String
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         if(level == 0 || level == 1)
         {
            return XML(xml.parent()).@url + id.toString() + ".swf";
         }
         return XML(xml.parent()).@url + id.toString() + "_" + level + ".swf";
      }
      
      public static function getPrevURL(id:uint, level:uint = 1) : String
      {
         return getSwfURL(id,level).replace(/swf\//,"prev/");
      }
      
      public static function getIconURL(id:uint, level:uint = 1) : String
      {
         return getSwfURL(id,level).replace(/swf\//,"icon/");
      }
      
      public static function getLifeTime(id:uint) : uint
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return xml.@LifeTime;
      }
      
      public static function getHP(id:uint) : uint
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return xml.@HP;
      }
      
      public static function getPP(id:uint) : uint
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return xml.@PP;
      }
      
      public static function getSpeed(clothes:Array) : Number
      {
         var id:uint = 0;
         var n:Number = NaN;
         for each(id in clothes)
         {
            n = _speedMap.getValue(id) as Number;
            if(Boolean(n))
            {
               return n;
            }
         }
         return MainManager.DfSpeed;
      }
      
      public static function getFunID(id:uint) : int
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         if(!xml.hasOwnProperty("@Fun"))
         {
            return 0;
         }
         return int(xml.@Fun);
      }
      
      public static function getFunIsCom(id:uint) : Boolean
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         if(!xml.hasOwnProperty("@isCom"))
         {
            return false;
         }
         return Boolean(int(xml.@isCom));
      }
      
      public static function getDisabledDir(id:uint) : Boolean
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         if(!xml.hasOwnProperty("@disabledDir"))
         {
            return false;
         }
         return Boolean(int(xml.@disabledDir));
      }
      
      public static function getDisabledStatus(id:uint) : Boolean
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         if(!xml.hasOwnProperty("@disabledStatus"))
         {
            return false;
         }
         return Boolean(int(xml.@disabledStatus));
      }
      
      public static function getCatID(id:uint) : uint
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return xml.parent().@ID;
      }
      
      public static function getPlayID(id:uint) : uint
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return uint(xml.@Play);
      }
      
      public static function getPower(id:uint) : uint
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return uint(xml.@AddPower);
      }
      
      public static function getIQ(id:uint) : uint
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return uint(xml.@AddIQ);
      }
      
      public static function getAiLevel(id:uint) : uint
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return uint(xml.@UseAI);
      }
      
      public static function getVipOnly(id:uint) : Boolean
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return Boolean(uint(xml.@VipOnly));
      }
      
      public static function getItemVipName(id:uint) : String
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         if(Boolean(xml.hasOwnProperty("@VipName")))
         {
            return String(xml.@VipName);
         }
         return "";
      }
      
      public static function getIsConsume(id:uint) : uint
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return uint(xml.@IsConsume);
      }
      
      public static function getIsSuper(id:uint) : Boolean
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return Boolean(uint(xml.@VipOnly));
      }
      
      public static function getUseEnergy(id:uint) : uint
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return xml.@UseEnergy;
      }
      
      public static function getIsFloor(id:uint) : Boolean
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         return Boolean(uint(xml.@floor));
      }
      
      public static function getSound(id:uint) : String
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         if(Boolean(xml))
         {
            if(Boolean(xml.hasOwnProperty("@sound")))
            {
               return String(xml.@sound);
            }
         }
         return "";
      }
      
      public static function getShotDis(id:uint) : uint
      {
         var xml:XML = null;
         var dis:uint = 0;
         xml = xmllist.(@ID == id)[0];
         if(Boolean(xml))
         {
            if(uint(xml.@PkFireRange) == 0)
            {
               dis = 100;
            }
            else
            {
               dis = uint(xml.@PkFireRange);
            }
         }
         else
         {
            dis = 100;
         }
         return dis;
      }
      
      public static function getIsShowInPetBag(id:uint) : Boolean
      {
         var xml:XML = null;
         xml = xmllist.(@ID == id)[0];
         if(Boolean(xml))
         {
            if(Boolean(xml.hasOwnProperty("@bShowPetBag")))
            {
               return Boolean(uint(xml.@bShowPetBag));
            }
         }
         return true;
      }
   }
}

