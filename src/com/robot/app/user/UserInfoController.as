package com.robot.app.user
{
   import com.robot.core.event.MapEvent;
   import com.robot.core.event.UserEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import org.taomee.manager.EventManager;
   import org.taomee.utils.DisplayUtil;
   
   public class UserInfoController extends BaseBeanController
   {
      private static var _uip:UserInfoPanel;
      
      public function UserInfoController()
      {
         super();
      }
      
      public static function get panel() : UserInfoPanel
      {
         if(_uip == null)
         {
            _uip = new UserInfoPanel();
         }
         return _uip;
      }
      
      public static function show(userID:uint) : void
      {
         if(!DisplayUtil.hasParent(panel))
         {
            panel.show(userID);
         }
         else
         {
            panel.init(userID);
         }
      }
      
      private static function onMapSwitch(e:MapEvent) : void
      {
         if(Boolean(_uip))
         {
            _uip.destroy();
            _uip = null;
         }
      }
      
      override public function start() : void
      {
         EventManager.addEventListener(UserEvent.CLICK,this.onClick);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,onMapSwitch);
         finish();
      }
      
      private function onClick(e:UserEvent) : void
      {
         if(e.userInfo.userID == MainManager.actorID)
         {
            AllUserInfoController.show(e.userInfo,LevelManager.appLevel);
         }
         else
         {
            UserInfoController.show(e.userInfo.userID);
         }
      }
   }
}

