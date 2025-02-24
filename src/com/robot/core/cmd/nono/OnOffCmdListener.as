package com.robot.core.cmd.nono
{
   import com.robot.core.CommandID;
   import com.robot.core.event.NonoActionEvent;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class OnOffCmdListener extends BaseBeanController
   {
      public function OnOffCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.NONO_CLOSE_OPEN,this.onChanged);
         finish();
      }
      
      private function onChanged(e:SocketEvent) : void
      {
         var data:ByteArray = e.data as ByteArray;
         var id:uint = data.readUnsignedInt();
         var state:Boolean = Boolean(data.readUnsignedInt());
         NonoManager.dispatchAction(id,NonoActionEvent.CLOSE_OPEN,state);
      }
   }
}

