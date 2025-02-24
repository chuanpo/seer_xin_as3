package com.robot.app.cutBmp
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.manager.ModuleManager;
   import com.robot.core.mode.AppModel;
   
   public class CutBmpController
   {
      private static var panel:AppModel;
      
      public static const CHAT_TYPE:uint = 1;
      
      public function CutBmpController()
      {
         super();
      }
      
      public static function show(toID:uint, type:uint = 1) : void
      {
         if(!panel)
         {
            panel = ModuleManager.getModule(ClientConfig.getAppModule("CutBmp"),"正在初始化载图程序");
         }
         panel.init({
            "_toID":toID,
            "_type":type
         });
         panel.setup();
         panel.show();
      }
   }
}

