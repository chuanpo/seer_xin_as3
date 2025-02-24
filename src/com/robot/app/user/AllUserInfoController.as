package com.robot.app.user
{
   import com.robot.core.info.UserInfo;
   import com.robot.core.manager.MainManager;
   import flash.display.DisplayObjectContainer;
   import org.taomee.utils.DisplayUtil;
   
   public class AllUserInfoController
   {
      private static var _myPanel:AllUserInfoPanel;
      
      private static var _oTherPanel:AllUserInfoPanel;
      
      private static var status:Boolean = false;
      
      public function AllUserInfoController()
      {
         super();
      }
      
      public static function get myPanel() : AllUserInfoPanel
      {
         if(!_myPanel)
         {
            _myPanel = new AllUserInfoPanel();
         }
         return _myPanel;
      }
      
      public static function get oTherPanel() : AllUserInfoPanel
      {
         if(!_oTherPanel)
         {
            _oTherPanel = new AllUserInfoPanel();
         }
         return _oTherPanel;
      }
      
      public static function show(info:UserInfo, container:DisplayObjectContainer) : void
      {
         if(info.userID == MainManager.actorInfo.userID)
         {
            if(!DisplayUtil.hasParent(myPanel))
            {
               myPanel.show(info,container);
            }
            else
            {
               myPanel.init(info);
            }
         }
         else
         {
            if(!DisplayUtil.hasParent(oTherPanel))
            {
               oTherPanel.show(info,container);
            }
            else
            {
               oTherPanel.init(info);
            }
            status = true;
         }
      }
      
      public static function hide() : void
      {
         oTherPanel.hide();
         status = false;
      }
      
      public static function set setStatus(b1:Boolean) : void
      {
         status = b1;
      }
      
      public static function get getStatus() : Boolean
      {
         return status;
      }
   }
}

