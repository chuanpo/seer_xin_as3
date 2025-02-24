package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.controller.SaveUserInfo;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.info.ChangeUserNameInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import org.taomee.events.SocketEvent;
   
   public class ChangeNameCmdListener extends BaseBeanController
   {
      public function ChangeNameCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.CHANG_NICK_NAME,this.onNameChanged);
         finish();
      }
      
      private function onNameChanged(e:SocketEvent) : void
      {
         var nickInfo:ChangeUserNameInfo = e.data as ChangeUserNameInfo;
         if(nickInfo.userId == MainManager.actorInfo.userID)
         {
            SaveUserInfo.saveSo();
         }
         UserManager.dispatchAction(nickInfo.userId,PeopleActionEvent.NAME_CHANGE,nickInfo);
      }
   }
}

