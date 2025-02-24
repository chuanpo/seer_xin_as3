package com.robot.core.cmd.nono
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.event.NonoActionEvent;
   import com.robot.core.event.NonoEvent;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class NonoPlayCmdListener extends BaseBeanController
   {
      public function NonoPlayCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.NONO_PLAY,this.onChanged);
         finish();
      }
      
      private function onChanged(e:SocketEvent) : void
      {
         var ai:uint = 0;
         var data:ByteArray = e.data as ByteArray;
         var id:uint = data.readUnsignedInt();
         var itemID:uint = data.readUnsignedInt();
         var playID:uint = ItemXMLInfo.getPlayID(itemID);
         if(playID != 0)
         {
            NonoManager.dispatchAction(id,NonoActionEvent.NONO_PLAY,playID);
         }
         if(id != MainManager.actorID)
         {
            return;
         }
         if(Boolean(NonoManager.info))
         {
            NonoManager.info.power = data.readUnsignedInt() / 1000;
            ai = data.readUnsignedShort();
            if(ai > NonoManager.info.ai)
            {
               NonoManager.dispatchEvent(new NonoEvent(NonoEvent.INFO_CHANGE,NonoManager.info));
            }
            NonoManager.info.ai = ai;
            NonoManager.info.mate = data.readUnsignedInt() / 1000;
            NonoManager.info.iq = data.readUnsignedInt();
         }
      }
   }
}

