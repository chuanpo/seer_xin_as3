package com.robot.core.config.xml
{
   import org.taomee.ds.HashMap;
   
   public class FortressItemXMLInfo
   {
      private static var _dataMap:HashMap;
      
      private static var xmlClass:Class = FortressItemXMLInfo_xmlClass;
      
      setup();
      
      public function FortressItemXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         _dataMap = new HashMap();
         var xl:XMLList = XML(new xmlClass()).elements("LiveItem");
         for each(item in xl)
         {
            _dataMap.add(uint(item.@ID),item);
         }
      }
      
      public static function getName(id:uint) : String
      {
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            return String(item.@Name);
         }
         return "";
      }
      
      public static function getPrice(id:uint) : uint
      {
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            return uint(item.@Price);
         }
         return 0;
      }
      
      public static function getDes(id:uint) : String
      {
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            return String(item.@Des);
         }
         return "";
      }
      
      public static function getPreBuildingID(id:uint) : uint
      {
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            return uint(item.@PreBuildingID);
         }
         return 0;
      }
      
      public static function getFormName(id:uint, form:uint) : String
      {
         var str:String = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               str = String(item.@Name);
               return str;
            }
         }
         return "";
      }
      
      public static function getNextLevel(id:uint, form:uint) : String
      {
         var str:String = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               str = String(item.@NeedTeamLv);
               return str;
            }
         }
         return "";
      }
      
      public static function getMaxLevel(id:uint) : String
      {
         var itemList:XMLList = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            itemList = item.elements("Form");
            if(Boolean(itemList))
            {
               if(itemList.length() == 0)
               {
                  return "";
               }
               item = itemList[itemList.length() - 1];
               return String(item.@ID);
            }
         }
         return "";
      }
      
      public static function getNextLevExp(id:uint, form:uint) : uint
      {
         var str:String = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               str = String(item.@NeedTeamExp);
               if(str != "")
               {
                  return uint(str);
               }
            }
         }
         return 0;
      }
      
      public static function getMaxHP(id:uint, form:uint) : String
      {
         var str:String = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               str = String(item.@MaxHP);
               return str;
            }
         }
         return "";
      }
      
      public static function getAtk(id:uint, form:uint) : String
      {
         var str:String = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               str = String(item.@Atk);
               return str;
            }
         }
         return "";
      }
      
      public static function getDef(id:uint, form:uint) : String
      {
         var str:String = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               str = String(item.@Def);
               return str;
            }
         }
         return "";
      }
      
      public static function getScience(id:uint, form:uint) : String
      {
         var str:String = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               str = String(item.@Science);
               return str;
            }
         }
         return "";
      }
      
      public static function getResearch(id:uint, form:uint) : String
      {
         var str:String = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               str = String(item.@Research);
               return str;
            }
         }
         return "";
      }
      
      public static function getEnergy(id:uint, form:uint) : String
      {
         var str:String = null;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               str = String(item.@Energy);
               return str;
            }
         }
         return "";
      }
      
      public static function getNextForm(id:uint, form:uint) : uint
      {
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               return uint(item.@NextForm);
            }
         }
         return 0;
      }
      
      public static function getNextFormNeedExp(id:uint, form:uint) : uint
      {
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               return uint(item.@NeedTeamExp);
            }
         }
         return 0;
      }
      
      public static function getResIDs(id:uint, form:uint) : Array
      {
         var arr:Array = null;
         var i:int = 0;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            arr = [];
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               for(i = 1; i <= 4; i++)
               {
                  arr.push(int(item.attribute("ResID" + i.toString())));
               }
               return arr;
            }
            return [];
         }
         return [];
      }
      
      public static function getResMaxs(id:uint, form:uint) : Array
      {
         var arr:Array = null;
         var i:int = 0;
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            arr = [];
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               for(i = 1; i <= 4; i++)
               {
                  arr.push(int(item.attribute("ResMax" + i.toString())));
               }
               return arr;
            }
            return [];
         }
         return [];
      }
      
      public static function getAllResMax(id:uint, form:uint) : uint
      {
         var total:uint = 0;
         var n:uint = 0;
         var arr:Array = getResMaxs(id,form);
         for each(n in arr)
         {
            total += n;
         }
         return total;
      }
      
      public static function getFunID(id:uint) : int
      {
         var item:XML = _dataMap.getValue(id);
         if(!item.hasOwnProperty("@Fun"))
         {
            return 0;
         }
         return int(item.@Fun);
      }
      
      public static function getFunIsCom(id:uint) : Boolean
      {
         var item:XML = _dataMap.getValue(id);
         if(!item.hasOwnProperty("@isCom"))
         {
            return false;
         }
         return Boolean(int(item.@isCom));
      }
      
      public static function getShootRadius(id:uint, form:uint) : uint
      {
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            item = item.elements("Form").(uint(@ID) == form)[0];
            if(Boolean(item))
            {
               return uint(item.@ShootRadius);
            }
         }
         return 0;
      }
   }
}

