package com.robot.core.cmd.nono
{
   import com.robot.core.CommandID;
   import com.robot.core.event.NonoActionEvent;
   import com.robot.core.manager.NonoManager;
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
         SocketConnection.addCmdListener(CommandID.NONO_CHANGE_COLOR,this.onChange);
         finish();
      }
      
      private function onChange(e:SocketEvent) : void
      {
         var data:ByteArray = e.data as ByteArray;
         var id:uint = data.readUnsignedInt();
         var color:uint = data.readUnsignedInt();
         NonoManager.dispatchAction(id,NonoActionEvent.COLOR_CHANGE,color);
      }
   }
}

