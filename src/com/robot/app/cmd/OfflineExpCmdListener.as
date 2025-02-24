package com.robot.app.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.info.SystemMsgInfo;
   import com.robot.core.info.SystemTimeInfo;
   import com.robot.core.net.SocketConnection;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class OfflineExpCmdListener
   {
      private var num:uint;
      
      private var panel:MovieClip;
      
      public function OfflineExpCmdListener()
      {
         super();
      }
      
      public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.OFF_LINE_EXP,this.onOffline);
      }
      
      private function onOffline(event:SocketEvent) : void
      {
         var data:ByteArray = event.data as ByteArray;
         this.num = data.readUnsignedInt();
         setTimeout(function():void
         {
            show();
         },10000);
      }
      
      private function show() : void
      {
         SocketConnection.addCmdListener(CommandID.SYSTEM_TIME,function(event:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.SYSTEM_TIME,arguments.callee);
            var date:Date = (event.data as SystemTimeInfo).date;
            var info:SystemMsgInfo = new SystemMsgInfo();
            info.npc = 3;
            info.type = 0;
            info.msgTime = date.getTime() / 1000;
            info.msg = "    亲爱的小赛尔，在你的休息期间，你的精灵们参加了模拟训练，积累的经验已经存入<font color=\'#ffff00\'>经验分配器</font>中。" + "\r    本次获得离线经验<font color=\'#ffff00\'>" + num + "</font>点";
            SysMsgCmdListener.getInstance().addInfo(info);
         });
         SocketConnection.send(CommandID.SYSTEM_TIME);
      }
      
      private function closeHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this.panel);
      }
   }
}

