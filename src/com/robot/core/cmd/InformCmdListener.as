package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.info.InformInfo;
   import com.robot.core.manager.MessageManager;
   import com.robot.core.net.SocketConnection;
   import org.taomee.events.DynamicEvent;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class InformCmdListener
   {
      public function InformCmdListener()
      {
         super();
      }
      
      private static function onInform(e:SocketEvent) : void
      {
         var info:InformInfo = e.data as InformInfo;
         if(info.type == 1004)
         {
            EventManager.dispatchEvent(new DynamicEvent("DS_TASK",info.accept));
         }
         else
         {
            MessageManager.addInformInfo(info);
         }
      }
      
      public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.INFORM,onInform);
      }
   }
}

