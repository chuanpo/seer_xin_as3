package com.robot.app.service
{
   import com.robot.app.vipSession.VipSession;
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class Service
   {
      setup();
      
      public function Service()
      {
         super();
      }
      
      private static function setup() : void
      {
         SocketConnection.addCmdListener(CommandID.USER_CONTRIBUTE,onContribute);
      }
      
      private static function onContribute(event:SocketEvent) : void
      {
         Alarm.show("邮件已发送成功！");
      }
      
      public static function contribute(title:String, msg:String, type:uint = 0) : Boolean
      {
         if(title.replace(/ /g,"") == "")
         {
            Alarm.show("请输入标题！");
            return false;
         }
         if(msg.replace(/ /g,"") == "")
         {
            Alarm.show("请输入内容！");
            return false;
         }
         var titleByte:ByteArray = new ByteArray();
         titleByte.writeUTFBytes(title);
         if(titleByte.length > 120)
         {
            Alarm.show("你输入的标题过长！");
            return false;
         }
         var msgByte:ByteArray = new ByteArray();
         msgByte.writeUTFBytes(msg);
         if(120 + msgByte.length > 3600)
         {
            Alarm.show("你输入的内容过长！");
            return false;
         }
         titleByte.length = 120;
         trace(titleByte.toString());
         var msgLength:uint = uint(120 + msgByte.length);
         SocketConnection.send(CommandID.USER_CONTRIBUTE,type,msgLength,titleByte,msgByte);
         return true;
      }
      
      public static function openNono() : void
      {
         var r:VipSession = new VipSession();
         r.addEventListener(VipSession.GET_SESSION,function(event:Event):void
         {
         });
         r.getSession();
      }
   }
}

