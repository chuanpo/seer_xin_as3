package com.robot.app.toolBar
{
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.teamPK.TeamPKManager;
   
   public class ToolBarController extends BaseBeanController
   {
      private static var _toolBarPanel:ToolBarPanel;
      
      public function ToolBarController()
      {
         super();
      }
      
      public static function get panel() : ToolBarPanel
      {
         if(_toolBarPanel == null)
         {
            _toolBarPanel = new ToolBarPanel();
         }
         return _toolBarPanel;
      }
      
      public static function aimatOff() : void
      {
         _toolBarPanel.aimatOff();
      }
      
      public static function bagOff() : void
      {
         _toolBarPanel.bagOff();
      }
      
      public static function homeOff() : void
      {
         _toolBarPanel.homeOff();
      }
      
      public static function aimatOn() : void
      {
         _toolBarPanel.aimatOn();
      }
      
      public static function bagOn() : void
      {
         _toolBarPanel.bagOn();
      }
      
      public static function homeOn() : void
      {
         _toolBarPanel.homeOn();
      }
      
      public static function closePetBag(b1:Boolean) : void
      {
         if(Boolean(_toolBarPanel))
         {
            _toolBarPanel.closePetBag(b1);
         }
      }
      
      public static function showBubble(nick:String) : void
      {
         if(Boolean(_toolBarPanel))
         {
            _toolBarPanel.bubble(nick);
         }
      }
      
      override public function start() : void
      {
         TeamPKManager.setup();
         panel.show();
         finish();
      }
   }
}

