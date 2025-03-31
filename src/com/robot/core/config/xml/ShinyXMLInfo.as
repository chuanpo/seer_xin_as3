package com.robot.core.config.xml
{
   import com.robot.core.manager.MainManager;
   import flash.geom.Point;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.XmlLoader;
   import com.robot.core.config.XmlConfig;
   
   public class ShinyXMLInfo
   {
      private static var _dataMap:HashMap;
      
      private static var _path:String = "291";

      // private static var xmlClass:Class = ShinyXMLInfo_xmlClass;
            
      public function ShinyXMLInfo()
      {
         super();
      }
      
      public static function setup(callBack:Function) : void
      {
         var item:XML = null;
         _dataMap = new HashMap();
         var onLoad:Function = function(xml:XML):void
         {
            var xl:XMLList = xml.elements("filter");
            for each(item in xl)
            {
               _dataMap.add(uint(item.@petId),item);
            }
            callBack();
            xmlLoader = null;
         }
         var xmlLoader:XmlLoader =  new XmlLoader();
         xmlLoader.loadXML(_path,XmlConfig.getXmlVerByPath(_path),onLoad);
         // var xl:XMLList = XML(new xmlClass()).elements("filter");
         // for each(item in xl)
         // {
         //    _dataMap.add(uint(item.@petId),item);
         // }
      }

      public static function getShinyArray(petId:uint) : Array
      {
         var shinyArray:Array = [
            0.8, 0.1, 0.1, 0, 50,  // 红色通道稍微增强，增加一些亮度
            0.1, 0.8, 0.1, 0, 50,  // 绿色通道稍微增强，增加一些亮度
            0.1, 0.1, 0.8, 0, 50,  // 蓝色通道稍微增强，增加一些亮度
            0,   0,   0,   1, 0    // 透明度保持不变
         ];
         var xml:XML = _dataMap.getValue(petId.toString());
         if(Boolean(xml))
         {
            try
            {
               var args:String = xml.@args;
               var strArray:Array = args.split(",");
               return strArray;
            }catch(e:Error)
            {
               return shinyArray;
            }
         }
         return shinyArray;
      }
      public static function getGlowArray(petId:uint) : Array
      {
         var glowArray:Array = [0xFFC125,1,20,20,1.6]
         var xml:XML = _dataMap.getValue(petId.toString());
         if(Boolean(xml))
         {
            try
            {
               var glow:String = xml.@glow;
               var strArray:Array = glow.split(",");
               return strArray;
            }
            catch(e:Error)
            {
               return glowArray;
            }
         }
         return glowArray;
      }
   }
}

