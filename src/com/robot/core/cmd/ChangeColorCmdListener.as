package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class ChangeColorCmdListener extends BaseBeanController
   {
      public function ChangeColorCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.CHANGE_COLOR,this.onChange);
         finish();
      }
      
      private function onChange(e:SocketEvent) : void
      {
         var data:ByteArray = e.data as ByteArray;
         var _id:uint = data.readUnsignedInt();
         var _color:uint = data.readUnsignedInt();
         var _t:uint = data.readUnsignedInt();
         var _coins:uint = data.readUnsignedInt();
         UserManager.dispatchAction(_id,PeopleActionEvent.COLOR_CHANGE,{
            "color":_color,
            "coins":_coins
         });
      }
   }
}

