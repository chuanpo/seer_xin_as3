package com.robot.app.task.taskUtils.manage
{
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.Utils;
   
   public class TaskUIManage
   {
      private static var _loader:Loader;
      
      public static var loadHash:HashMap = new HashMap();
      
      public function TaskUIManage()
      {
         super();
      }
      
      public static function getMovieClip(str:String, id:uint) : MovieClip
      {
         _loader = loadHash.getValue(id);
         return Utils.getMovieClipFromLoader(str,_loader);
      }
      
      public static function getButton(str:String, id:uint) : SimpleButton
      {
         _loader = loadHash.getValue(id);
         return Utils.getSimpleButtonFromLoader(str,_loader);
      }
      
      public static function destroyLoder(id:uint) : void
      {
         var tmpLoad:Loader = loadHash.getValue(id);
         loadHash.remove(id);
         tmpLoad = null;
      }
   }
}

