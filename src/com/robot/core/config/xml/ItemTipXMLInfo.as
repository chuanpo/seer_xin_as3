package com.robot.core.config.xml
{
   import org.taomee.ds.HashMap;
   import org.taomee.utils.XmlLoader;
   import com.robot.core.config.XmlConfig;
   
   public class ItemTipXMLInfo
   {
      private static var xmllist:XMLList;
      
      private static var _map:HashMap;
      
      // private static var xmlClass:Class = ItemTipXMLInfo_xmlClass;
      
      private static var xml:XML;
      
      private static var _path:String = "43";

      public static var isSetup:Boolean = false;

      // setup();
      
      public function ItemTipXMLInfo()
      {
         super();
      }
      
      public static function setup(callBack:Function) : void
      {
         var onLoad:Function = function(_xml:XML):void
         {
            var i:XML = null;
            _map = new HashMap();
            xml = _xml;
            xmllist = xml.descendants("item");
            for each(i in xmllist)
            {
               _map.add(uint(i.@id),i);
            }
            isSetup = true;
            callBack();
            xmlLoader = null;
         }
         var xmlLoader:XmlLoader =  new XmlLoader();
         xmlLoader.loadXML(_path,XmlConfig.getXmlVerByPath(_path),onLoad);
      }
      
      public static function getItemDes(id:uint) : String
      {
         var xml:XML = _map.getValue(id);
         if(Boolean(xml))
         {
            return xml.@des;
         }
         return "";
      }
      
      public static function getItemColor(id:uint) : String
      {
         var xml:XML = _map.getValue(id);
         if(Boolean(xml))
         {
            return xml.@color;
         }
         return "#ffffff";
      }
      
      public static function getPetDes(id:uint, level:uint = 1) : String
      {
         var xml:XML;
         var str:String = null;
         var _x:XML = null;
         var i:XML = null;
         if(level == 0)
         {
            level = 1;
         }
         xml = _map.getValue(id);
         if(Boolean(xml))
         {
            str = "";
            _x = xml.pet.level.(@value == level.toString())[0];
            if(_x == null)
            {
               return "";
            }
            for each(i in _x.list)
            {
               str += i.@des + "\r";
            }
            return str;
         }
         return "";
      }
      
      public static function getTeamPKDes(id:uint, level:uint = 1) : String
      {
         var xml:XML;
         var str:String = null;
         var _x:XML = null;
         var i:XML = null;
         if(level == 0)
         {
            level = 1;
         }
         xml = _map.getValue(id);
         if(Boolean(xml))
         {
            str = "";
            _x = xml.teamPK.level.(@value == level.toString())[0];
            if(_x == null)
            {
               return "";
            }
            for each(i in _x.list)
            {
               str += i.@des + "\r";
            }
            return str;
         }
         return "";
      }
   }
}

