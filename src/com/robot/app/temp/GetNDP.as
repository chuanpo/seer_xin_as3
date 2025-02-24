package com.robot.app.temp
{
   import com.robot.app.energy.ore.DayOreCount;
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.events.Event;
   import org.taomee.events.SocketEvent;
   
   public class GetNDP
   {
      public function GetNDP()
      {
         super();
      }
      
      public static function send() : void
      {
         var o:DayOreCount = new DayOreCount();
         o.addEventListener(DayOreCount.countOK,onCount);
         o.sendToServer(1002);
      }
      
      private static function onCount(event:Event) : void
      {
         if(DayOreCount.oreCount >= 1)
         {
            Alarm.show("你本周已经领取过扭蛋牌了！");
         }
         else
         {
            SocketConnection.addCmdListener(CommandID.TALK_CATE,onSuccess);
            SocketConnection.send(CommandID.TALK_CATE,1002);
         }
      }
      
      private static function onSuccess(event:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TALK_CATE,onSuccess);
         Alarm.show("恭喜你获得一个<font color=\'#ff0000\'>扭蛋牌</font>");
      }
   }
}

