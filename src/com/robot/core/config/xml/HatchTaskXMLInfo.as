package com.robot.core.config.xml
{
   import org.taomee.ds.HashMap;
   
   public class HatchTaskXMLInfo
   {
      private static var _dataMap:HashMap;
      
      private static const PRO:String = "pro";
      
      private static var xmlClass:Class = HatchTaskXMLInfo_xmlClass;
      
      setup();
      
      public function HatchTaskXMLInfo()
      {
         super();
      }
      
      public static function get dataMap() : HashMap
      {
         return _dataMap;
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         var _id:uint = 0;
         _dataMap = new HashMap();
         var xmlList:XMLList = XML(new xmlClass()).elements("task");
         for each(item in xmlList)
         {
            _id = uint(item.@ID);
            _dataMap.add(_id,item);
         }
      }
      
      public static function getName(id:uint) : String
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return xml.@name.toString();
         }
         return "";
      }
      
      public static function getTaskProCount(id:uint) : int
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return xml.elements(PRO).length();
         }
         return 0;
      }
      
      public static function getTaskMapList(id:uint) : Array
      {
         var arr:Array = [];
         for(var i:uint = 0; i < getTaskProCount(id); i++)
         {
            arr.push(getProMap(id,i));
         }
         return arr;
      }
      
      public static function isDir(id:uint) : Boolean
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return Boolean(int(xml.@isDir));
         }
         return false;
      }
      
      public static function isMat(id:uint) : Boolean
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return Boolean(int(xml.@isMat));
         }
         return false;
      }
      
      public static function getProName(id:uint, pro:uint) : String
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return xml.elements(PRO)[pro].@name.toString();
         }
         return "";
      }
      
      public static function getProMCName(id:uint, pro:uint) : String
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return xml.elements(PRO)[pro].@mc.toString();
         }
         return "";
      }
      
      public static function getProMap(id:uint, pro:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return xml.elements(PRO)[pro].@map;
         }
         return 0;
      }
      
      public static function getMapPro(id:uint, mapID:uint) : Array
      {
         var xmlList:XMLList = null;
         var i:uint = 0;
         var arr:Array = [];
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            xmlList = xml.elements(PRO);
            for(i = 0; i < xmlList.length(); i++)
            {
               if(xmlList[i].@map == mapID)
               {
                  arr.push(i);
               }
            }
         }
         return arr;
      }
      
      public static function getProParent(id:uint, pro:uint) : Boolean
      {
         var b:Boolean = false;
         if(pro == 0)
         {
            return true;
         }
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return Boolean(xml.elements(PRO)[pro - 1].@isMat);
         }
         return false;
      }
      
      public static function getMapSoulBeadList(mapID:uint) : Array
      {
         var xml:XML = null;
         var itemID:uint = 0;
         var arr:Array = [];
         var xmll:XML = XML(new xmlClass());
         var xmlList:XMLList = xmll..pro;
         for each(xml in xmlList)
         {
            if(xml.@map == mapID)
            {
               itemID = uint(xml.parent().@ID);
               arr.push(itemID);
            }
         }
         return arr;
      }
      
      public static function getProDes(id:uint, pro:uint) : String
      {
         var str:String = null;
         var xml:XML = _dataMap.getValue(id);
         if(Boolean(xml))
         {
            return String(xml.elements(PRO)[pro].@des);
         }
         return "";
      }
   }
}

