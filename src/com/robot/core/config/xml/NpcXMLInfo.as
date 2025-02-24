package com.robot.core.config.xml
{
   import com.robot.core.manager.MainManager;
   import org.taomee.ds.HashMap;
   
   public class NpcXMLInfo
   {
      private static var _dataMap:HashMap;
      
      private static var xl:XMLList;
      
      private static var xmlClass:Class = NpcXMLInfo_xmlClass;
      
      setup();
      
      public function NpcXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         _dataMap = new HashMap();
         xl = XML(new xmlClass()).elements("npc");
         for each(item in xl)
         {
            _dataMap.add(uint(item.@id),item);
         }
      }
      
      public static function getIDList() : Array
      {
         return _dataMap.getKeys();
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
      
      public static function getType(id:uint) : String
      {
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            return String(item.@type);
         }
         throw new Error("没有该NPC");
      }
      
      public static function getNpcXmlByMap(id:uint) : XMLList
      {
         var xmlList:XMLList = null;
         xmlList = xl.(@mapID == id.toString());
         return xmlList;
      }
      
      public static function getStartIDs(id:uint) : Array
      {
         var str:String = null;
         var array:Array = null;
         var i1:int = 0;
         str = xl.(@id == id).@startTask.toString();
         if(str == "")
         {
            return [];
         }
         array = str.split("|");
         array.forEach(function(item:*, index:int, arr:Array):void
         {
            array[index] = uint(item);
         });
         if(MainManager.checkIsNovice())
         {
            for(i1 = 0; i1 < array.length; i1++)
            {
               if(array[i1] == 1 || array[i1] == 2 || array[i1] == 3 || array[i1] == 4)
               {
                  array.splice(i1,1);
                  i1--;
               }
            }
            if(array.length == 0)
            {
               array = [];
            }
         }
         return array;
      }
      
      public static function getEndIDs(id:uint) : Array
      {
         var str:String = null;
         var array:Array = null;
         str = xl.(@id == id).@endTask.toString();
         if(str == "")
         {
            return [];
         }
         array = str.split("|");
         array.forEach(function(item:*, index:int, arr:Array):void
         {
            array[index] = uint(item);
         });
         return array;
      }
      
      public static function getNpcProIDs(id:uint) : Array
      {
         var str:String = null;
         var array:Array = null;
         str = xl.(@id == id).@proTask.toString();
         if(str == "")
         {
            return [];
         }
         array = str.split("|");
         array.forEach(function(item:*, index:int, arr:Array):void
         {
            array[index] = uint(item);
         });
         return array;
      }
   }
}

