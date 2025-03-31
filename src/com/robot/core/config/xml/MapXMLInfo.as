package com.robot.core.config.xml
{
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import flash.geom.Point;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.XmlLoader;
   import com.robot.core.config.XmlConfig;
   
   public class MapXMLInfo
   {
      private static var _dataMap:HashMap;

      private static var _path:String = "210";
      
      // private static var xmlClass:Class = MapXMLInfo_xmlClass;
      
      setup();
      
      public function MapXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         _dataMap = new HashMap();
         var onLoad:Function = function(xml:XML):void
         {
            var xl:XMLList = xml.elements("map");
            for each(item in xl)
            {
               _dataMap.add(uint(item.@id),item);
            }
            xmlLoader = null;
         }
         var xmlLoader:XmlLoader =  new XmlLoader();
         xmlLoader.loadXML(_path,XmlConfig.getXmlVerByPath(_path),onLoad);
         // var xl:XMLList = XML(new xmlClass()).elements("map");
         // for each(item in xl)
         // {
         //    _dataMap.add(uint(item.@id),item);
         // }
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
      
      public static function getDefaultPos(id:uint) : Point
      {
         var item:XML = _dataMap.getValue(id);
         if(Boolean(item))
         {
            return new Point(int(item.@x),int(item.@y));
         }
         return MainManager.getStageCenterPoint();
      }
      
      public static function getRoomDefaultFloPos(styleID:uint) : Point
      {
         if(styleID < MapManager.ID_MAX)
         {
            return MainManager.getStageCenterPoint();
         }
         var item:XML = _dataMap.getValue(styleID);
         if(Boolean(item))
         {
            return new Point(int(item.@fx),int(item.@fy));
         }
         return MainManager.getStageCenterPoint();
      }
      
      public static function getRoomDefaultWapPos(styleID:uint) : Point
      {
         if(styleID < MapManager.ID_MAX)
         {
            return MainManager.getStageCenterPoint();
         }
         var item:XML = _dataMap.getValue(styleID);
         if(Boolean(item))
         {
            return new Point(int(item.@wx),int(item.@wy));
         }
         return MainManager.getStageCenterPoint();
      }
      
      public static function getHeadPos(styleID:uint) : Point
      {
         if(styleID < MapManager.ID_MAX)
         {
            return MainManager.getStageCenterPoint();
         }
         var item:XML = _dataMap.getValue(styleID);
         if(Boolean(item))
         {
            return new Point(int(item.@hx),int(item.@hy));
         }
         return MainManager.getStageCenterPoint();
      }
      
      public static function getIsLocal(id:uint) : Boolean
      {
         var item:XML = _dataMap.getValue(id);
         if(!item)
         {
            return false;
         }
         if(Boolean(item.hasOwnProperty("@isLocal")))
         {
            return Boolean(uint(item.@isLocal));
         }
         return false;
      }
   }
}

