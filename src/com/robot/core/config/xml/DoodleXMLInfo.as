package com.robot.core.config.xml
{
   public class DoodleXMLInfo
   {
      private static var _dataList:XMLList;
      
      private static var _url:String;
      
      private static var _preUrl:String;
      
      public function DoodleXMLInfo()
      {
         super();
      }
      
      public static function setup(data:XML) : void
      {
         _url = data.@url.toString();
         _preUrl = _url.replace(/swf\//,"prev/");
         _dataList = data.elements("Item");
      }
      
      public static function getSwfURL(texture:uint) : String
      {
         if(texture == 0)
         {
            return "";
         }
         return _url + texture.toString() + ".swf";
      }
      
      public static function getPrevURL(texture:uint) : String
      {
         if(texture == 0)
         {
            return "";
         }
         return _preUrl + texture.toString() + ".swf";
      }
      
      public static function getName(id:uint) : String
      {
         return _dataList.(@ID == id.toString()).@name[0].toString();
      }
      
      public static function getPrice(id:uint) : uint
      {
         return uint(_dataList.(@ID == id.toString()).@Price[0].toString());
      }
      
      public static function getColor(id:uint) : uint
      {
         return uint(_dataList.(@ID == id.toString()).@Color[0]);
      }
      
      public static function getTexture(id:uint) : uint
      {
         return uint(_dataList.(@ID == id.toString()).@Texture[0]);
      }
      
      public static function getLength() : int
      {
         return _dataList.length();
      }
      
      public static function getList() : XMLList
      {
         return _dataList;
      }
   }
}

