package com.robot.core.config.xml
{
   import com.robot.core.config.ClientConfig;
   import flash.geom.Point;
   import org.taomee.ds.HashMap;
   import org.taomee.gemo.IntDimension;
   
   public class MailTemplateXMLInfo
   {
      private static var _hashMap:HashMap;
      
      private static var _xml:XML;
      
      private static var _xmllist:XMLList;
      
      private static var xmlClass:Class = MailTemplateXMLInfo_xmlClass;
      
      setup();
      
      public function MailTemplateXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var item:XML = null;
         _hashMap = new HashMap();
         _xml = XML(new xmlClass());
         _xmllist = _xml.elements("item");
         for each(item in _xmllist)
         {
            _hashMap.add(uint(item.@id),item);
         }
      }
      
      public static function getTemplateSwf(id:uint) : String
      {
         return ClientConfig.getMapPath(id);
      }
      
      public static function getTitle(id:uint) : String
      {
         var xml:XML = _hashMap.getValue(id);
         if(xml == null)
         {
            return "";
         }
         return xml;
      }
      
      public static function getTxtPos(id:uint) : Point
      {
         var xml:XML = _hashMap.getValue(id);
         return new Point(uint(xml.@x),uint(xml.@y));
      }
      
      public static function getTxtSize(id:uint) : IntDimension
      {
         var xml:XML = _hashMap.getValue(id);
         return new IntDimension(uint(xml.@width),uint(xml.@height));
      }
      
      public static function getCategoryList(type:uint) : Array
      {
         var l:XMLList = null;
         var array:Array = null;
         var i:XML = null;
         l = _xmllist.(@type == type.toString());
         array = [];
         for each(i in l)
         {
            array.push(i.@id);
         }
         return array;
      }
   }
}

