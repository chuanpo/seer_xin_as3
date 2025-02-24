package com.robot.core.manager.map
{
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.media.Sound;
   import org.taomee.utils.Utils;
   
   public class MapLibManager
   {
      private static var _loader:Loader;
      
      public function MapLibManager()
      {
         super();
      }
      
      public static function setup(loader:Loader) : void
      {
         _loader = loader;
      }
      
      public static function get loader() : Loader
      {
         return _loader;
      }
      
      public static function getClass(str:String) : Class
      {
         return Utils.getClassFromLoader(str,_loader);
      }
      
      public static function getMovieClip(str:String) : MovieClip
      {
         return Utils.getMovieClipFromLoader(str,_loader);
      }
      
      public static function getButton(str:String) : SimpleButton
      {
         return Utils.getSimpleButtonFromLoader(str,_loader);
      }
      
      public static function getBitmap(str:String) : Bitmap
      {
         return new Bitmap(Utils.getBitmapDataFromLoader(str,_loader));
      }
      
      public static function getSound(str:String) : Sound
      {
         return Utils.getSoundFromLoader(str,_loader);
      }
   }
}

