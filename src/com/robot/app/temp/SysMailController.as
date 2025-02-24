package com.robot.app.temp
{
   import com.robot.core.CommandID;
   import com.robot.core.info.SystemMsgInfo;
   import com.robot.core.info.SystemTimeInfo;
   import com.robot.core.net.SocketConnection;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.taomee.events.SocketEvent;
   
   public class SysMailController
   {
      private static var timer:Timer;
      
      private static var obj:Object = new Object();
      
      public function SysMailController()
      {
         super();
      }
      
      public static function setup() : void
      {
         timer = new Timer(10 * 60 * 1000);
         timer.addEventListener(TimerEvent.TIMER,onTimer);
         timer.start();
      }
      
      private static function onTimer(event:TimerEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.SYSTEM_TIME,function(event:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.SYSTEM_TIME,arguments.callee);
            var date:Date = (event.data as SystemTimeInfo).date;
            if(date.getDate() == 5)
            {
               checkDate(date);
            }
         });
         SocketConnection.send(CommandID.SYSTEM_TIME);
      }
      
      private static function checkDate(date:Date) : void
      {
         var info:SystemMsgInfo = new SystemMsgInfo();
         info.msgTime = date.getTime() / 1000;
         info.npc = 3;
      }
   }
}

