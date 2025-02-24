package com.robot.core.teamInstallation
{
   import com.robot.core.cmd.UserListCmdListener;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.event.TeamEvent;
   import com.robot.core.info.team.TeamLogoInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.mode.BasePeoleModel;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.taomee.ds.HashMap;
   import org.taomee.manager.EventManager;
   
   public class ShowTeamLogo extends BaseBeanController
   {
      private static var owner:ShowTeamLogo;
      
      private var timer:Timer;
      
      private var userList:Array;
      
      private var hashMap:HashMap = new HashMap();
      
      private var people:BasePeoleModel;
      
      public function ShowTeamLogo()
      {
         super();
         owner = this;
      }
      
      public static function showLogo(p:BasePeoleModel) : void
      {
         if(Boolean(owner))
         {
            owner._showLogo(p);
         }
      }
      
      override public function start() : void
      {
         EventManager.addEventListener(RobotEvent.FILTER_SUPER_TEAM,this.onCreatedMapUser);
         EventManager.addEventListener(TeamEvent.MODIFY_LOGO,this.onModifyLogo);
         finish();
      }
      
      private function onModifyLogo(event:TeamEvent) : void
      {
         if(!MainManager.actorInfo.teamInfo.isShow)
         {
            return;
         }
         var id:uint = MainManager.actorInfo.teamInfo.id;
      }
      
      private function onCreatedMapUser(event:RobotEvent) : void
      {
         this.getTeamLogo(UserListCmdListener.superList);
      }
      
      public function getTeamLogo(array:Array) : void
      {
         if(!this.timer)
         {
            this.timer = new Timer(30 * 60 * 1000);
            this.timer.addEventListener(TimerEvent.TIMER,this.clearData);
            this.timer.start();
         }
         this.userList = array.slice();
         this.load();
      }
      
      private function load() : void
      {
         var uid:uint;
         var teamID:uint = 0;
         if(this.userList.length == 0)
         {
            return;
         }
         uid = uint(this.userList.shift());
         if(uid == MainManager.actorID)
         {
            this.people = MainManager.actorModel;
         }
         else
         {
            this.people = UserManager.getUserModel(uid);
         }
         if(!this.people.info.teamInfo)
         {
            this.load();
            return;
         }
         teamID = this.people.info.teamInfo.id;
         if(teamID == 0)
         {
            this.load();
            return;
         }
         if(!this.hashMap.containsKey(teamID))
         {
            TeamInfoManager.getTeamLogoInfo(this.people.info.userID,function(info:TeamLogoInfo):void
            {
               hashMap.add(teamID,info);
               people.showTeamLogo(info);
               load();
            });
         }
         else
         {
            this.people.showTeamLogo(this.hashMap.getValue(teamID));
            this.load();
         }
      }
      
      private function clearData(event:TimerEvent) : void
      {
         this.hashMap.clear();
         this.hashMap = new HashMap();
      }
      
      public function _showLogo(p:BasePeoleModel) : void
      {
         if(!p.info.teamInfo)
         {
            return;
         }
         var teamID:uint = p.info.teamInfo.id;
         if(teamID == 0)
         {
            return;
         }
         var info:TeamLogoInfo = new TeamLogoInfo();
         info.logoBg = p.info.teamInfo.logoBg;
         info.logoColor = p.info.teamInfo.logoColor;
         info.logoIcon = p.info.teamInfo.logoIcon;
         info.txtColor = p.info.teamInfo.txtColor;
         info.logoWord = p.info.teamInfo.logoWord;
         p.showTeamLogo(info);
      }
   }
}

