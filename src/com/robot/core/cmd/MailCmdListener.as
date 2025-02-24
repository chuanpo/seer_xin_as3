package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.event.MailEvent;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.manager.mail.MailManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class MailCmdListener extends BaseBeanController
   {
      public static var isShowTip:Boolean = true;
      
      public function MailCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.MAIL_NEW_NOTE,this.onNewMail);
         SocketConnection.addCmdListener(CommandID.MAIL_SEND,this.onSendMail);
         SocketConnection.addCmdListener(CommandID.MAIL_DEL_ALL,this.onDeleteAll);
         SocketConnection.addCmdListener(CommandID.MAIL_DELETE,this.onDelete);
         MailManager.showIcon();
         finish();
      }
      
      private function onNewMail(event:SocketEvent) : void
      {
         MailManager.getNew();
      }
      
      private function onSendMail(event:SocketEvent) : void
      {
         var data:ByteArray = event.data as ByteArray;
         var coins:uint = data.readUnsignedInt();
         MainManager.actorInfo.coins = coins;
         Alarm.show("恭喜你，邮件发送成功！");
         MailManager.dispatchEvent(new MailEvent(MailEvent.MAIL_SEND));
      }
      
      private function onDelete(event:SocketEvent) : void
      {
         if(isShowTip)
         {
            Alarm.show("邮件删除成功");
         }
         else
         {
            isShowTip = true;
         }
         MailManager.dispatchEvent(new MailEvent(MailEvent.MAIL_DELETE));
      }
      
      private function onDeleteAll(event:SocketEvent) : void
      {
         Alarm.show("邮件删除成功");
         MailManager.dispatchEvent(new MailEvent(MailEvent.MAIL_CLEAR));
      }
   }
}

