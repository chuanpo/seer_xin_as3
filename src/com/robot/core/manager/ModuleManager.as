package com.robot.core.manager
{
   import com.robot.core.mode.AppModel;
   import org.taomee.ds.HashMap;
   
   public class ModuleManager
   {
      private static var _moduleMap:HashMap = new HashMap();
      
      public function ModuleManager()
      {
         super();
      }
      
      public static function getModule(url:String, title:String) : AppModel
      {
         var app:AppModel = _moduleMap.getValue(url);
         if(Boolean(app))
         {
            return app;
         }
         app = new AppModel(url,title);
         _moduleMap.add(url,app);
         return app;
      }
      
      public static function remove(url:String) : void
      {
         _moduleMap.remove(url);
      }
   }
}

