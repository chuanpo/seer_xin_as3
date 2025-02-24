package com.robot.app.cmd
{
   import com.robot.app.im.TeamChatController;
   import com.robot.app.im.talk.TeamChatData;
   import com.robot.core.CommandID;
   import com.robot.core.event.MapEvent;
   import com.robot.core.info.TeamChatInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.MessageManager;
   import com.robot.core.manager.SOManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.net.SharedObject;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class TeamChatCmdListener extends BaseBeanController
   {
      public static const TEAM_CHAT_CUTBMP:String = "Team_Chat_CutBmp";
      
      private var icon:SimpleButton;
      
      public function TeamChatCmdListener()
      {
         super();
      }
      
      public static function sendTeamChatMsg(teamNum:uint, byte:ByteArray, msgLen:uint, byteMsg:ByteArray) : void
      {
         SocketConnection.send(CommandID.TEAM_CHAT,teamNum,byte,msgLen,byteMsg);
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_CHAT,this.getTeamChatMsg);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,this.onSwitchMap);
         finish();
      }
      
      private function onSwitchMap(event:MapEvent) : void
      {
         TeamChatController.isOpen = false;
      }
      
      private function getTeamChatMsg(evt:SocketEvent) : void
      {
         var data:TeamChatInfo = null;
         var so:SharedObject = SOManager.getUser_Info();
         if(!so.data["isHackTeam"] || so.data["isHackTeam"] == false)
         {
            data = evt.data as TeamChatInfo;
            trace("teamChat -----------------> ",data.msg);
            if(!TeamChatController.isOpen)
            {
               MessageManager.addTeamChatInfo(data);
            }
            TeamChatData.addTeamChat(data);
         }
      }
      
      private function showIcon() : void
      {
         if(!this.icon)
         {
            this.icon = UIManager.getButton("Talk_Icon");
            this.icon.x = 115;
            this.icon.y = 20;
            this.icon.addEventListener(MouseEvent.CLICK,this.showTeamChatMsg);
         }
         LevelManager.iconLevel.addChild(this.icon);
      }
      
      private function hideIcon() : void
      {
         DisplayUtil.removeForParent(this.icon);
      }
      
      private function showTeamChatMsg(evt:MouseEvent) : void
      {
         TeamChatController.show();
         this.icon.visible = false;
      }
   }
}

