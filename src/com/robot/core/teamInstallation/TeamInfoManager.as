package com.robot.core.teamInstallation
{
   import com.robot.core.CommandID;
   import com.robot.core.info.team.SimpleTeamInfo;
   import com.robot.core.info.team.TeamLogoInfo;
   import com.robot.core.net.SocketConnection;
   import org.taomee.events.SocketEvent;
   
   public class TeamInfoManager
   {
      public function TeamInfoManager()
      {
         super();
      }
      
      public static function getSimpleTeamInfo(id:uint, fun:Function = null) : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_GET_INFO,function(event:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.TEAM_GET_INFO,arguments.callee);
            var info:SimpleTeamInfo = event.data as SimpleTeamInfo;
            if(fun != null)
            {
               fun(info);
            }
         });
         SocketConnection.send(CommandID.TEAM_GET_INFO,id);
      }
      
      public static function getTeamLogoInfo(uid:uint, fun:Function = null) : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_GET_LOGO_INFO,function(event:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.TEAM_GET_LOGO_INFO,arguments.callee);
            var info:TeamLogoInfo = event.data as TeamLogoInfo;
            if(fun != null)
            {
               fun(info);
            }
         });
         SocketConnection.send(CommandID.TEAM_GET_LOGO_INFO,uid);
      }
   }
}

