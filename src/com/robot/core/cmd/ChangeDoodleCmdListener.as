package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.info.item.DoodleInfo;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class ChangeDoodleCmdListener extends BaseBeanController
   {
      public function ChangeDoodleCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.CHANGE_DOODLE,this.onChange);
         finish();
      }
      
      private function onChange(e:SocketEvent) : void
      {
         var data:ByteArray = e.data as ByteArray;
         var info:DoodleInfo = new DoodleInfo(data);
         UserManager.dispatchAction(info.userID,PeopleActionEvent.DOODLE_CHANGE,info);
      }
   }
}

