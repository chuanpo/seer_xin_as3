package com.robot.core.config
{
   public class UpdateConfig
   {
      private static var _xml:XML;
      
      public static var loadingArray:Array = [];
      
      public static var mapScrollArray:Array = [];
      
      public static var blueArray:Array = [];
      
      public static var greenArray:Array = [];
      
      public static var brotherArray:Array = [];
      
      public static var niusiArray:Array = [];
      
      public static var niuChangeMapArray:Array = [];
      
      public function UpdateConfig()
      {
         super();
      }
      
      public static function setup(xml:XML) : void
      {
         var i:XML = null;
         var str:String = null;
         _xml = xml;
         for each(i in xml.loading.list)
         {
            loadingArray.push(i.@str);
         }
         for each(i in xml.map.list)
         {
            mapScrollArray.push(i.@str);
         }
         for each(i in xml.blue.list)
         {
            str = String(i.@str);
            str = str.replace(/\$/g,"\r");
            blueArray.push(str);
         }
         for each(i in xml.green.list)
         {
            str = String(i.@str);
            str = str.replace(/\$/g,"\r");
            greenArray.push(str);
         }
         for each(i in xml.brother.list)
         {
            brotherArray.push(i.@str);
         }
         for each(i in xml.news.list)
         {
            niusiArray.push(i.@str);
         }
         for each(i in xml.newsChangeMap.list)
         {
            niuChangeMapArray.push(i.@id);
         }
      }
   }
}

