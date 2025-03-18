package org.taomee.manager
{
   import flash.display.DisplayObjectContainer;
   import flash.display.Stage;
   import com.robot.core.manager.SOManager;
   import flash.net.SharedObject;
   
   public class TaomeeManager
   {
      private static var _root:DisplayObjectContainer;
      
      public static var stageHeight:int;
      
      public static var stageWidth:int;
      
      private static var _stage:Stage;
      
      public static var fightSpeed:Number = 1;
      
      public function TaomeeManager()
      {
         super();
      }
      
      public static function set root(r:DisplayObjectContainer) : void
      {
         _root = r;
      }
      
      public static function get root() : DisplayObjectContainer
      {
         return _root;
      }
      
      public static function get stage() : Stage
      {
         return _stage;
      }
      
      public static function set stage(s:Stage) : void
      {
         _stage = s;
      }
      
      public static function setup(root:DisplayObjectContainer, stage:Stage) : void
      {
         _root = root;
         _stage = stage;
      }

      public static function initFightSpeed():void
      {
         var so:SharedObject = SOManager.getUserSO(SOManager.LOCAL_CONFIG);
         if(!so.data["speed"])
         {
            so.data["speed"] = 1;
            SOManager.flush();
         }else
         {
            fightSpeed = so.data["speed"]
         }
      }
   }
}

