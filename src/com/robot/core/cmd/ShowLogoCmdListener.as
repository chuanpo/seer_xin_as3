package com.robot.core.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.info.team.TeamLogoInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UserManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.teamInstallation.TeamInfoManager;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class ShowLogoCmdListener extends BaseBeanController
   {
      private var _isShow:uint;
      
      private var _uid:uint;
      
      public function ShowLogoCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_SHOW_LOGO,this.onShowComHandler);
         finish();
      }
      
      private function onShowComHandler(e:SocketEvent) : void
      {
         var model:BasePeoleModel = null;
         var by:ByteArray = e.data as ByteArray;
         this._uid = by.readUnsignedInt();
         this._isShow = by.readUnsignedInt();
         if(this._uid == MainManager.actorInfo.userID)
         {
            MainManager.actorInfo.teamInfo.isShow = Boolean(this._isShow);
         }
         else
         {
            model = UserManager.getUserModel(this._uid);
            model.info.teamInfo.isShow = Boolean(this._isShow);
         }
         this.setLogo(this._uid,Boolean(this._isShow));
      }
      
      private function setLogo(uid:uint, isShow:Boolean) : void
      {
         TeamInfoManager.getTeamLogoInfo(uid,function(teamInfo:TeamLogoInfo):void
         {
            var model:BasePeoleModel = null;
            if(uid == MainManager.actorID)
            {
               model = MainManager.actorModel;
            }
            else
            {
               model = UserManager.getUserModel(uid);
            }
            if(Boolean(model))
            {
               if(isShow)
               {
                  model.showTeamLogo(teamInfo);
               }
               else
               {
                  model.removeTeamLogo();
               }
            }
         });
      }
   }
}

