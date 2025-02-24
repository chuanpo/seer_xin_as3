package com.robot.core.config.xml
{
   import org.taomee.ds.HashMap;
   
   public class MapIntroXMLInfo
   {
      private static var _dataMap:HashMap;
      
      private static var xmlClass:Class = MapIntroXMLInfo_xmlClass;
      
      setup();
      
      public function MapIntroXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         _dataMap = new HashMap();
         var xl:XMLList = XML(new xmlClass()).elements("map");
         for each(item in xl)
         {
            _dataMap.add(uint(item.@id),item);
         }
      }
      
      public static function getType(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml.hasOwnProperty("@type")))
         {
            return uint(xml.@type);
         }
         return 0;
      }
      
      public static function getDifficulty(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml.hasOwnProperty("@difficulty")))
         {
            return uint(xml.@difficulty);
         }
         return 0;
      }
      
      public static function getLevel(id:uint) : String
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml.hasOwnProperty("@level")))
         {
            return String(xml.@level);
         }
         return "";
      }
      
      public static function getDes(id:uint) : String
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml.hasOwnProperty("@des")))
         {
            return String(xml.@des);
         }
         return "";
      }
      
      public static function getTasks(id:uint) : Array
      {
         var str:String = null;
         var arr:Array = null;
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml.hasOwnProperty("task")))
         {
            str = String(xml.task.@taskIDs);
            return str.split("|");
         }
         return [];
      }
      
      public static function getSprites(id:uint) : Array
      {
         var str:String = null;
         var arr:Array = null;
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml.hasOwnProperty("sprite")))
         {
            str = String(xml.sprite.@petIDs);
            return str.split("|");
         }
         return [];
      }
      
      public static function getMinerals(id:uint) : Array
      {
         var str:String = null;
         var arr:Array = null;
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml.hasOwnProperty("minerals")))
         {
            str = String(xml.minerals.@IDs);
            return str.split("|");
         }
         return [];
      }
      
      public static function getGames(id:uint) : Array
      {
         var str:String = null;
         var arr:Array = null;
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml.hasOwnProperty("game")))
         {
            str = String(xml.game.@names);
            return str.split("|");
         }
         return [];
      }
      
      public static function getNonos(id:uint) : Array
      {
         var str:String = null;
         var arr:Array = null;
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml.hasOwnProperty("nono")))
         {
            str = String(xml.nono.@names);
            return str.split("|");
         }
         return [];
      }
      
      public static function getNewgoods(id:uint) : Array
      {
         var str:String = null;
         var arr:Array = null;
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml.hasOwnProperty("newgoods")))
         {
            str = String(xml.newgoods.@names);
            return str.split("|");
         }
         return [];
      }
   }
}

