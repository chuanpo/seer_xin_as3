package com.robot.core.config.xml
{
   import org.taomee.ds.HashMap;
   
   public class EmotionXMLInfo
   {
      private static var _hashMap:HashMap;
      
      private static var _xml:XML;
      
      private static var _xmllist:XMLList;
      
      private static var path:String;
      
      private static var xmlClass:Class = EmotionXMLInfo_xmlClass;
      
      setup();
      
      public function EmotionXMLInfo()
      {
         super();
      }
      
      private static function setup() : void
      {
         var i:XML = null;
         _xml = XML(new xmlClass());
         path = _xml.@path;
         _hashMap = new HashMap();
         _xmllist = _xml.emotion;
         for each(i in _xmllist)
         {
            _hashMap.add(i.@shortcut.toString(),i);
         }
      }
      
      public static function getURL(key:String) : String
      {
         var xml:XML = _hashMap.getValue(key);
         if(!xml)
         {
            throw new Error("不存在该表情快捷键");
         }
         return path + xml.@id + ".swf";
      }
      
      public static function getDes(key:String) : String
      {
         var xml:XML = _hashMap.getValue(key);
         if(!xml)
         {
            throw new Error("不存在该表情快捷键");
         }
         return xml.@des;
      }
   }
}

