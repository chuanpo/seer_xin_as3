package com.robot.core.config.xml
{
   import org.taomee.ds.HashMap;
   import org.taomee.utils.Utils;
   
   public class PetXMLInfo
   {
      private static var _dataMap:HashMap;
      
      private static var _xml:XML;
      
      private static var xmlClass:Class = PetXMLInfo_xmlClass;
      
      setup();
      
      public function PetXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         _dataMap = new HashMap();
         _xml = XML(new xmlClass());
         var xl:XMLList = _xml.elements("Monster");
         for each(item in xl)
         {
            _dataMap.add(item.@ID.toString(),item);
         }
      }
      
      public static function getIdList() : Array
      {
         return _dataMap.getKeys();
      }
      
      public static function get dataList() : Array
      {
         return _dataMap.getValues();
      }
      
      public static function getName(id:uint) : String
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return xml.@DefName.toString();
         }
         return "";
      }
      
      public static function getType(id:uint) : String
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return xml.@Type.toString();
         }
         return "";
      }
      
      public static function getTypeList(t:uint) : XMLList
      {
         return _xml.(@Type == t);
      }
      
      public static function getClass(id:uint) : Class
      {
         var xml:XML = _dataMap.getValue(id);
         if(xml == null)
         {
            return null;
         }
         if(!xml.hasOwnProperty("@className"))
         {
            return null;
         }
         var cla:Class = Utils.getClass(xml.@className.toString());
         if(Boolean(cla))
         {
            return cla;
         }
         return null;
      }
      
      public static function getEvolvFlag(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         return xml.@EvolvFlag;
      }
      
      public static function getEvolvingLv(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         return xml.@EvolvingLv;
      }
      
      public static function getSkillListForLv(id:uint, lv:uint) : Array
      {
         var xml:XML = null;
         var xmlList:XMLList = null;
         var item:XML = null;
         var arr:Array = [];
         xml = _dataMap.getValue(id);
         if(xml == null)
         {
            return arr;
         }
         xmlList = xml.elements("LearnableMoves")[0].elements("Move");
         for each(item in xmlList)
         {
            if(uint(item.@LearningLv) <= lv)
            {
               arr.push(uint(item.@ID));
            }
         }
         return arr;
      }
      
      public static function getTypeCN(id:uint) : String
      {
         var i:uint = uint(getType(id));
         return SkillXMLInfo.dict["key_" + i]["cn"];
      }
      
      public static function getTypeEN(id:uint) : String
      {
         var i:uint = uint(getType(id));
         return SkillXMLInfo.dict["key_" + i]["en"];
      }
      
      public static function fuseMaster(id:uint) : Boolean
      {
         var xml:XML = _dataMap.getValue(id);
         return Boolean(uint(xml.@FuseMaster));
      }
      
      public static function fuseSub(id:uint) : Boolean
      {
         var xml:XML = _dataMap.getValue(id);
         return Boolean(uint(xml.@FuseSub));
      }
   }
}

