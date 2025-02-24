package com.robot.core.ui.nono
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.info.NonoInfo;
   import com.robot.core.manager.ModuleManager;
   import com.robot.core.mode.AppModel;
   import flash.events.Event;
   
   public class NonoInfoPanelController
   {
      private static var _panel:AppModel;
      
      public function NonoInfoPanelController()
      {
         super();
      }
      
      public static function show(_info:NonoInfo) : void
      {
         if(_panel == null)
         {
            _panel = ModuleManager.getModule(ClientConfig.getAppModule("NewNonoInfoPanel"),"正在打开NoNo信息面板...");
            _panel.setup();
            _panel.sharedEvents.addEventListener(Event.CLOSE,onNonoInfoPanelClose);
         }
         _panel.init({
            "info":_info,
            "point":null
         });
         _panel.show();
      }
      
      public static function destroy() : void
      {
         _panel.sharedEvents.removeEventListener(Event.CLOSE,onNonoInfoPanelClose);
         _panel.destroy();
         _panel = null;
      }
      
      private static function onNonoInfoPanelClose(e:Event) : void
      {
         destroy();
      }
   }
}

