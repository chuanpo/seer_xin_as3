package com.robot.core.config.xml
{
   import com.robot.core.manager.MainManager;
   import flash.geom.Point;
   import org.taomee.ds.HashMap;
   
   public class HelpXMLInfo
   {
      private static var _dataMap:HashMap;
      
      private static var xl:XMLList;
      
      private static var xmlClass:Class = HelpXMLInfo_xmlClass;
      
      private static const PRO:String = "pro";
      
      setup();
      
      public function HelpXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         _dataMap = new HashMap();
         xl = new XML(new xmlClass()).elements("help");
         for each(item in xl)
         {
            _dataMap.add(uint(item.@id),item);
         }
      }
      
      public static function getIdList() : Array
      {
         return _dataMap.getKeys();
      }
      
      public static function getType(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         return uint(xml.@type);
      }
      
      public static function getArrowPoint(id:uint) : Point
      {
         var xml:XML = _dataMap.getValue(id);
         return new Point(xml.@arrowX,xml.@arrowY);
      }
      
      public static function getMapId(id:uint) : uint
      {
         var xml:XML = _dataMap.getValue(id);
         return new uint(xml.@mapId);
      }
      
      public static function getIsBack(id:uint) : Boolean
      {
         var boolean:Boolean = false;
         var xml:XML = _dataMap.getValue(id);
         if(xml.@isBack == "1")
         {
            boolean = true;
         }
         else
         {
            boolean = false;
         }
         return boolean;
      }
      
      public static function getItemAry(id:uint) : Array
      {
         var xml:XML = _dataMap.getValue(id);
         var len:uint = uint(xml.elements(PRO).length());
         var array:Array = new Array();
         for(var i:int = 0; i < len; i++)
         {
            array.push(new Array(xml.elements(PRO)[i].@item,xml.elements(PRO)[i].@clickTo));
         }
         return array;
      }
      
      public static function getComment(id:uint) : String
      {
         var xml:XML = _dataMap.getValue(id);
         var str:String = String(xml.des);
         str = str.replace(/#nick/g,MainManager.actorInfo.nick);
         return str.replace("$","\r");
      }
   }
}

