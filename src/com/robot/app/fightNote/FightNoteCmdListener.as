package com.robot.app.fightNote
{
   import com.robot.app.info.fightInvite.InviteHandleInfo;
   import com.robot.app.info.fightInvite.InviteNoteInfo;
   import com.robot.app.user.UserInfoController;
   import com.robot.core.CommandID;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.event.PetFightEvent;
   import com.robot.core.info.fightInfo.FightStartInfo;
   import com.robot.core.info.fightInfo.NoteReadyToFightInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.loading.Loading;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.events.TextEvent;
   import flash.utils.getDefinitionByName;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class FightNoteCmdListener extends BaseBeanController
   {
      private var readyData:NoteReadyToFightInfo;
      
      private var DLL_PATH:String = "com.robot.petFightModule.PetFightEntry";
      
      public function FightNoteCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.NOTE_INVITE_TO_FIGHT,this.noteInviteToFight);
         SocketConnection.addCmdListener(CommandID.NOTE_HANDLE_FIGHT_INVITE,this.noteHandlerFightInvite);
         SocketConnection.addCmdListener(CommandID.NOTE_READY_TO_FIGHT,this.noteReadyToFight);
         SocketConnection.addCmdListener(CommandID.NOTE_START_FIGHT,this.startFight);
         finish();
      }
      
      private function noteInviteToFight(event:SocketEvent) : void
      {
         var data:InviteNoteInfo = event.data as InviteNoteInfo;
         FightInviteManager.add(data);
      }
      
      private function noteHandlerFightInvite(event:SocketEvent) : void
      {
         var data:InviteHandleInfo = null;
         var sprite:Sprite = null;
         data = event.data as InviteHandleInfo;
         if(data.result == 0)
         {
            sprite = Alarm.show("<a href=\'event:\'><u><font color=\'#ff0000\'>" + data.nickName + "(" + data.userID + ")</font></u></a>拒绝了你的邀请");
            sprite.addEventListener(TextEvent.LINK,function():void
            {
               UserInfoController.show(data.userID);
               LevelManager.topLevel.addChild(UserInfoController.panel);
            });
            FightWaitPanel.hide();
         }
         else if(data.result == 2)
         {
            Alarm.show("对方在线时长超过6小时！");
            FightWaitPanel.hide();
         }
         else if(data.result == 3)
         {
            Alarm.show("对方没有可以出战的精灵");
            FightWaitPanel.hide();
         }
         else if(data.result == 4)
         {
            Alarm.show("对方不在线");
            FightWaitPanel.hide();
         }
      }
      
      private function noteReadyToFight(event:SocketEvent) : void
      {
         var cls:* = undefined;
         var loader:MCLoader = null;
         this.readyData = event.data as NoteReadyToFightInfo;
         try
         {
            cls = getDefinitionByName(this.DLL_PATH);
            cls.setup(this.readyData.userInfoArray,this.readyData.petArray,this.readyData.skillArray);
         }
         catch(e:Error)
         {
            loader = new MCLoader("resource/module/PetFightDLL.swf",LevelManager.topLevel,Loading.TITLE_AND_PERCENT,"正在进入对战系统",true,true);
            loader.setIsShowClose(false);
            loader.addEventListener(MCLoadEvent.SUCCESS,onLoadDLL);
            loader.doLoad();
         }
         FightWaitPanel.hide();
      }
      
      private function onLoadDLL(event:MCLoadEvent) : void
      {
         var cls:* = getDefinitionByName(this.DLL_PATH);
         cls.setup(this.readyData.userInfoArray,this.readyData.petArray,this.readyData.skillArray);
      }
      
      private function startFight(event:SocketEvent) : void
      {
         var data:FightStartInfo = event.data as FightStartInfo;
         EventManager.dispatchEvent(new PetFightEvent(PetFightEvent.START_FIGHT,[data.myInfo,data.otherInfo]));
         var petFightEvet:PetFightEvent = new PetFightEvent(PetFightEvent.START_FIGHT,data);
         var cls:* = getDefinitionByName("com.robot.petFightModule.PetFightEntry") as Class;
         EventDispatcher(cls.fighterCon).dispatchEvent(petFightEvet);
      }
   }
}

