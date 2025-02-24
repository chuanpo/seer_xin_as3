package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.utils.Direction;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class SpecialCmdListener extends BaseBeanController
   {
      public function SpecialCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.DANCE_ACTION,this.onSpecial);
         finish();
      }
      
      private function onSpecial(e:SocketEvent) : void
      {
         var data:ByteArray = e.data as ByteArray;
         var userID:uint = data.readUnsignedInt();
         var type:uint = data.readUnsignedInt();
         var dir:String = Direction.indexToStr(data.readUnsignedInt());
         UserManager.dispatchAction(userID,PeopleActionEvent.SPECIAL,dir);
      }
   }
}

