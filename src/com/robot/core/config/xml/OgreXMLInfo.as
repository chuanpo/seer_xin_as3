package com.robot.core.config.xml
{
   import flash.geom.Point;
   import org.taomee.ds.HashMap;
   
   public class OgreXMLInfo
   {
      private static var _ogreMap:HashMap;
      
      private static var _bossMap:HashMap;
      
      private static var _specialMap:HashMap;
      
      private static var xmlClass:Class = OgreXMLInfo_xmlClass;
      
      setup();
      
      public function OgreXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         var bossXL:XMLList = null;
         var item2:XML = null;
         var specialXML:XMLList = null;
         var item3:XML = null;
         var str:String = null;
         var arr:Array = null;
         var len:int = 0;
         var i:int = 0;
         var parr:Array = null;
         var str1:String = null;
         var arr1:Array = null;
         var len1:int = 0;
         var parr1:Array = null;
         _ogreMap = new HashMap();
         var ogreXL:XMLList = XML(new xmlClass()).elements("ogre")[0].elements("item");
         for each(item in ogreXL)
         {
            str = item.@pList.toString();
            arr = str.split("|");
            len = int(arr.length);
            for(i = 0; i < len; i++)
            {
               parr = arr[i].split(",");
               arr[i] = new Point(parr[0],parr[1]);
            }
            _ogreMap.add(uint(item.@id),arr);
         }
         _bossMap = new HashMap();
         bossXL = XML(new xmlClass()).elements("boss")[0].elements("item");
         for each(item2 in bossXL)
         {
            _bossMap.add(uint(item2.@id),item2);
         }
         _specialMap = new HashMap();
         specialXML = XML(new xmlClass()).elements("special")[0].elements("item");
         for each(item3 in specialXML)
         {
            str1 = item3.@pList.toString();
            arr1 = str1.split("|");
            len1 = int(arr1.length);
            for(i = 0; i < len1; i++)
            {
               parr1 = arr1[i].split(",");
               arr1[i] = new Point(parr1[0],parr1[1]);
            }
            _specialMap.add(uint(item3.@id),arr1);
         }
      }
      
      public static function getOgreList(mapID:uint) : Array
      {
         return _ogreMap.getValue(mapID);
      }
      
      public static function getBossList(mapID:uint, region:uint) : Array
      {
         var str:String = null;
         var arr:Array = null;
         var len:int = 0;
         var k:int = 0;
         var parr:Array = null;
         var xml:XML = _bossMap.getValue(mapID);
         if(Boolean(xml))
         {
            xml = xml.elements("region").(@id == region)[0];
            if(Boolean(xml))
            {
               str = xml.@pList.toString();
               arr = str.split("|");
               len = int(arr.length);
               for(k = 0; k < len; k++)
               {
                  parr = arr[k].split(",");
                  arr[k] = new Point(parr[0],parr[1]);
               }
               return arr;
            }
         }
         return null;
      }
      
      public static function getSpecialList(mapID:uint) : Array
      {
         return _specialMap.getValue(mapID);
      }
   }
}

