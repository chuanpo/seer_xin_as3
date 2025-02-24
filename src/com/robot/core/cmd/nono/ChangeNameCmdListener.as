package com.robot.core.cmd.nono
{
   import com.robot.core.CommandID;
   import com.robot.core.event.NonoActionEvent;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class ChangeNameCmdListener extends BaseBeanController
   {
      public function ChangeNameCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.NONO_CHANGE_NAME,this.onNameChanged);
         finish();
      }
      
      private function onNameChanged(e:SocketEvent) : void
      {
         var data:ByteArray = e.data as ByteArray;
         var id:uint = data.readUnsignedInt();
         var nick:String = data.readUTFBytes(16);
         NonoManager.dispatchAction(id,NonoActionEvent.NAME_CHANGE,nick);
      }
   }
}

