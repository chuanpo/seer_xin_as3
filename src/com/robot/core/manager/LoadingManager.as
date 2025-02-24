package com.robot.core.manager
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import org.taomee.utils.Utils;
   
   public class LoadingManager
   {
      private static var _loader:Loader;
      
      public function LoadingManager()
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
      
      public static function getMovieClip(str:String) : MovieClip
      {
         return Utils.getMovieClipFromLoader(str,_loader);
      }
   }
}

