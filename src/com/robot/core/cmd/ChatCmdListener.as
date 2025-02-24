package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.event.ChatEvent;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.info.ChatInfo;
   import com.robot.core.manager.MessageManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.net.SocketConnection;
   import org.taomee.events.SocketEvent;
   
   public class ChatCmdListener
   {
      public function ChatCmdListener()
      {
         super();
      }
      
      public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.CHAT,this.onChat);
      }
      
      private function onChat(event:SocketEvent) : void
      {
         var data:ChatInfo = event.data as ChatInfo;
         if(data.toID == 0)
         {
            UserManager.dispatchAction(data.senderID,PeopleActionEvent.CHAT,data.msg);
            MessageManager.dispatchEvent(new ChatEvent(ChatEvent.CHAT_COM,data));
         }
         else
         {
            MessageManager.addChatInfo(data);
         }
      }
   }
}

