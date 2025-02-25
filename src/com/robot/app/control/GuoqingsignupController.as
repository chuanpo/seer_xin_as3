package com.robot.app.control
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.mode.AppModel;
   import flash.display.MovieClip;
   import flash.events.*;
   import flash.net.SharedObject;
   import org.taomee.manager.ToolTipManager;
   
   public class GuoqingsignupController
   {
      private static var iconMc:MovieClip;
      
      private static var _so:SharedObject;
      
      private static var _panel:AppModel;
      
      public function GuoqingsignupController()
      {
         super();
      }
      
      public static function createIcon() : void
      {
         //iconMc = TaskIconManager.getIcon("ui_guoqing") as MovieClip;
         //ToolTipManager.add(iconMc,"国庆");
         var date:Date = new Date();
         if(date.fullYear == 2018 && date.month == 9 && date.date >= 1 && date.date <= 7)
         {
            TaskIconManager.addIcon(iconMc);
            iconMc["btn"].addEventListener(MouseEvent.CLICK,onClickHandler);
         }
         else
         {
            TaskIconManager.addIcon(iconMc);
            iconMc["btn"].addEventListener(MouseEvent.CLICK,onClickHandler);
         }
      }
      
      private static function onClickHandler(event:MouseEvent) : void
      {
         show();
      }
      
      private static function show() : void
      {
         showPanel();
      }
      
      private static function showPanel() : void
      {
         if(!_panel)
         {
            _panel = new AppModel(ClientConfig.getAppModule("GuoqingSignupPanel"),"正在打开");
            _panel.setup();
         }
         _panel.show();
      }
      
      public static function delIcon() : void
      {
         TaskIconManager.delIcon(iconMc);
      }
   }
}

