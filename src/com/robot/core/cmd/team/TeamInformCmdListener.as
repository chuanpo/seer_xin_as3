package com.robot.core.cmd.team
{
   import com.robot.core.CommandID;
   import com.robot.core.info.team.TeamInformInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MessageManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class TeamInformCmdListener
   {
      public function TeamInformCmdListener()
      {
         super();
      }
      
      public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_INFORM,this.onInform);
         SocketConnection.addCmdListener(CommandID.TEAM_QUIT,this.onQuit);
      }
      
      private function onInform(e:SocketEvent) : void
      {
         var info:TeamInformInfo = e.data as TeamInformInfo;
         MessageManager.addTeamInformInfo(info);
      }
      
      private function onQuit(event:SocketEvent) : void
      {
         Alarm.show("你已经退出了战队：" + (event.data as ByteArray).readUnsignedInt());
         MainManager.actorInfo.teamInfo.id = 0;
         MainManager.actorInfo.teamInfo.priv = 5;
      }
   }
}

