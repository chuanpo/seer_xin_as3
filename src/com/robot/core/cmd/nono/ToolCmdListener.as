package com.robot.core.cmd.nono
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.event.NonoActionEvent;
   import com.robot.core.event.NonoEvent;
   import com.robot.core.info.NonoImplementsToolResquestInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import org.taomee.events.SocketEvent;
   
   public class ToolCmdListener extends BaseBeanController
   {
      public function ToolCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.NONO_IMPLEMENT_TOOL,this.onChange);
         finish();
      }
      
      private function onChange(e:SocketEvent) : void
      {
         var data:NonoImplementsToolResquestInfo = e.data as NonoImplementsToolResquestInfo;
         if(data.id != MainManager.actorID)
         {
            return;
         }
         if(Boolean(NonoManager.info))
         {
            NonoManager.info.power = data.power;
            if(data.ai > NonoManager.info.ai)
            {
               NonoManager.dispatchEvent(new NonoEvent(NonoEvent.INFO_CHANGE,NonoManager.info));
            }
            NonoManager.info.ai = data.ai;
            NonoManager.info.mate = data.mate;
            NonoManager.info.iq = data.iq;
            if(data.itemId <= 700060)
            {
               NonoManager.info.func[data.itemId - 700001] = true;
            }
         }
         var actionid:uint = ItemXMLInfo.getPlayID(data.itemId);
         if(actionid != 0)
         {
            NonoManager.dispatchAction(data.id,NonoActionEvent.NONO_PLAY,actionid);
         }
      }
   }
}

