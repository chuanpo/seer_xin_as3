package com.robot.app.task.boss
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.core.CommandID;
   import com.robot.core.event.PetEvent;
   import com.robot.core.event.PetFightEvent;
   import com.robot.core.info.fightInfo.attack.FightOverInfo;
   import com.robot.core.info.task.BossMonsterInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class HuLiAo
   {
      public static var changeStatus:Boolean;
      
      public static var bWin:Boolean;
      
      public static var bFirstWin:Boolean;
      
      public static var bStart:Boolean;
      
      public function HuLiAo()
      {
         super();
      }
      
      public static function startFight() : void
      {
         if(bStart)
         {
            return;
         }
         bStart = true;
         setTimeout(function():void
         {
            bStart = false;
         },2000);
         FightInviteManager.fightWithBoss("里奥斯");
         EventManager.addEventListener(PetFightEvent.FIGHT_CLOSE,onCloseFight);
      }
      
      public static function removeListener() : void
      {
         EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,onCloseFight);
      }
      
      private static function onGetBossMonster(e:SocketEvent) : void
      {
         var _taskInfo:BossMonsterInfo = e.data as BossMonsterInfo;
         trace(PetManager.length.toString());
         if(PetManager.length >= 6)
         {
            PetManager.addStorage(_taskInfo.petID,_taskInfo.captureTm);
            LevelManager.iconLevel.addChild(Alarm.show("恭喜你获得了<font color=\'#00CC00\'>胡里亚</font>，你可以在基地仓库里找到"));
            return;
         }
         PetManager.addEventListener(PetEvent.ADDED,onPetAddBag);
         PetManager.setIn(_taskInfo.captureTm,1);
      }
      
      private static function onPetAddBag(e:PetEvent) : void
      {
         PetManager.removeEventListener(PetEvent.ADDED,onPetAddBag);
         LevelManager.iconLevel.addChild(Alarm.show("恭喜你获得了<font color=\'#00CC00\'>胡里亚</font>，你可以点击右下方的精灵按钮来查看"));
      }
      
      private static function onCloseFight(e:PetFightEvent) : void
      {
         HuLiAo.changeStatus = true;
         EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,onCloseFight);
         SocketConnection.removeCmdListener(CommandID.GET_BOSS_MONSTER,onGetBossMonster);
         var fightCls:* = getDefinitionByName("com.robot.petFightModule.PetFightEntry") as Class;
         var fightData:FightOverInfo = e.dataObj["data"];
         if(fightData.winnerID == MainManager.actorInfo.userID)
         {
            bWin = true;
         }
      }
   }
}

