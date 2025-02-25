package com.robot.app.mapProcess
{
   import com.robot.app.fightLevel.FightMHTController;
   import com.robot.app.fightLevel.FightPetBagController;
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.toolBar.ToolBarController;
   import com.robot.core.CommandID;
   import com.robot.core.event.PetFightEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.fightInfo.attack.FightOverInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.Alert;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ToolTipManager;
   
   public class MapProcess_514 extends BaseMapProcess
   {
      private const OPEN_LEVEL:uint = 2;
      
      private var currentMC:MovieClip;
      
      private var doornum:uint = 2;
      
      private var doorindex:uint = 0;
      
      private var _type:uint = 0;
      
      public function MapProcess_514()
      {
         super();
      }
      
      override protected function init() : void
      {
         ToolBarController.panel.hide();
         LevelManager.iconLevel.visible = false;
         FightMHTController.destroy();
         ToolTipManager.add(conLevel["door_0"],"离开");
         depthLevel["mhtHitMc"].buttonMode = true;
         ToolTipManager.add(depthLevel["mhtHitMc"],"谱尼");
         ToolTipManager.add(conLevel["bagMc"],"精灵背包");
         conLevel["bagMc"].addEventListener(MouseEvent.CLICK,this.onBagHandler);
         depthLevel["mhtHitMc"].addEventListener(MouseEvent.CLICK,this.onMhtClickHandler);
         for(var i:uint = 0; i < this.doornum; i++)
         {
            if(MainManager.actorInfo.dailyResArr[40 + i] == false)
            {
               conLevel["cachetMc_" + i].gotoAndStop(1);
            }
            else
            {
               conLevel["cachetMc_" + i].gotoAndStop(3);
            }
         }
         EventManager.addEventListener(RobotEvent.ERROR_11027,this.onError11027Handler);
         EventManager.addEventListener(RobotEvent.ERROR_11028,this.onError11028Handler);
      }
      
      private function onError11027Handler(e:RobotEvent) : void
      {
         switch(this.doorindex)
         {
            case 1:
               break;
            case 2:
               Alarm.show("只有战胜谱尼的第一封印：虚无，才能挑战第二封印：元素的化身。");
               break;
            case 3:
               Alarm.show("只有战胜谱尼的第二封印：元素，才能挑战第三封印：能量的化身。");
         }
      }
      
      private function onError11028Handler(e:RobotEvent) : void
      {
         switch(this.doorindex)
         {
            case 1:
               Alarm.show("谱尼的第一封印：虚无 已进入暂时封闭状态，明天将会再度打开。");
               break;
            case 2:
               Alarm.show("谱尼的第二封印：元素 已进入暂时封闭状态，明天将会再度打开。");
               break;
            case 3:
               Alarm.show("谱尼的第三封印：能量 已进入暂时封闭状态，明天将会再度打开。");
         }
      }
      
      public function onCachetMc0Handler(mc:MovieClip) : void
      {
         this.currentMC = null;
         this.currentMC = mc;
         var bossindex:uint = uint(uint(this.currentMC.name.split("_")[1]) + 1);
         this.doorindex = bossindex;
         if(MainManager.actorInfo.dailyResArr[40 + this.doorindex - 1] == true)
         {
            EventManager.dispatchEvent(new RobotEvent(RobotEvent.ERROR_11028));
            return;
         }
         switch(mc.name)
         {
            case "cachetMc_0":
               Alert.show("谱尼的第一封印：虚无 已经开启，只有战胜谱尼内心的封印化身才能解除这个封印，你准备好去挑战了吗？",this.sureHandler);
               break;
            case "cachetMc_1":
               Alert.show("谱尼的第二封印：元素 已经开启，只有战胜谱尼内心的封印化身才能解除这个封印，你准备好去挑战了吗？",this.sureHandler);
               break;
            case "cachetMc_2":
               Alert.show("谱尼的第三封印：能量 已经开启，只有战胜谱尼内心的封印化身才能解除这个封印，你准备好去挑战了吗？",this.sureHandler);
               break;
            case "cachetMc_3":
               Alert.show("谱尼的第四封印：生命 已经开启，只有战胜谱尼内心的封印化身才能解除这个封印，你准备好去挑战了吗？",this.sureHandler);
               break;
            case "cachetMc_4":
               break;
               Alert.show("谱尼的第五封印：轮回 已经开启，只有战胜谱尼内心的封印化身才能解除这个封印，你准备好去挑战了吗？",this.sureHandler);
               break;
            case "cachetMc_5":
               break;
               Alert.show("谱尼的第六封印：永恒 已经开启，只有战胜谱尼内心的封印化身才能解除这个封印，你准备好去挑战了吗？",this.sureHandler);
               break;
            case "cachetMc_6":
               break;
               Alert.show("谱尼的第七封印：圣洁 已经开启，只有战胜谱尼内心的封印化身才能解除这个封印，你准备好去挑战了吗？",this.sureHandler);
         }
      }
      
      private function sureHandler() : void
      {
         var bossname:String = null;
         bossname = String(this.currentMC.des).split("-")[1] + "的化身";
         this.currentMC.gotoAndStop(2);
         this.currentMC.mouseChildren = false;
         this.currentMC.mouseEnabled = false;
         setTimeout(function():void
         {
            if(currentMC == null)
            {
               return;
            }
            currentMC.gotoAndStop(1);
            currentMC.mouseChildren = true;
            currentMC.mouseEnabled = true;
         },500);
         this._type = 0;
         SocketConnection.addCmdListener(CommandID.CHALLENGE_BOSS,this.onFSucHandler);
         EventManager.addEventListener(PetFightEvent.FIGHT_CLOSE,this.onCloseFight);
         FightInviteManager.fightWithBoss(bossname,this.doorindex,true);
      }
      
      private function onBagHandler(e:MouseEvent) : void
      {
         FightPetBagController.show();
      }
      
      private function onMhtClickHandler(e:MouseEvent) : void
      {
         if(TasksManager.getTaskStatus(462) != TasksManager.COMPLETE)
         {
            depthLevel["mhtHitMc"].removeEventListener(MouseEvent.CLICK,this.onMhtClickHandler);
            setTimeout(function():void
            {
               depthLevel["mhtHitMc"].addEventListener(MouseEvent.CLICK,onMhtClickHandler);
            },1500);
            this._type = 1;
            SocketConnection.addCmdListener(CommandID.CHALLENGE_BOSS,this.onFSucHandler);
            FightInviteManager.fightWithBoss("谱尼");
         }
         else
         {
            Alarm.show("谱尼的能量波动非常不稳定，继续战斗会有危险，明天再来挑战它吧。");
         }
      }
      
      private function onCloseFight(e:PetFightEvent) : void
      {
         var fightData:FightOverInfo = null;
         EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,this.onCloseFight);
         if(this._type == 0)
         {
            conLevel["aiMc"].gotoAndPlay(2);
            fightData = e.dataObj["data"];
            if(fightData.winnerID == MainManager.actorID)
            {
               this.currentMC.gotoAndStop(3);
               ++MainManager.actorInfo.maxPuniLv;
               switch(MainManager.actorInfo.maxPuniLv)
               {
                  case 1:
                     Alarm.show(" 谱尼的第一封印：虚无 已经解除，只有将谱尼所有封印内的化身击败才能真正战胜它。");
                     break;
                  case 2:
                     Alarm.show(" 谱尼的第二封印：元素 已经解除，只有将谱尼所有封印内的化身击败才能真正战胜它。");
                     break;
                  case 3:
                     Alarm.show(" 谱尼的第三封印：能量 已经解除，只有将谱尼所有封印内的化身击败才能真正战胜它。");
               }
            }
         }
      }
      
      private function onFSucHandler(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.CHALLENGE_BOSS,this.onFSucHandler);
         if(this._type == 1)
         {
            TasksManager.setTaskStatus(462,TasksManager.COMPLETE);
         }
         else
         {
            MainManager.actorInfo.dailyResArr[40 + this.doorindex - 1] = true;
         }
      }
      
      override public function destroy() : void
      {
         EventManager.removeEventListener(RobotEvent.ERROR_11027,this.onError11027Handler);
         EventManager.removeEventListener(RobotEvent.ERROR_11028,this.onError11028Handler);
         SocketConnection.removeCmdListener(CommandID.CHALLENGE_BOSS,this.onFSucHandler);
         ToolTipManager.remove(conLevel["bagMc"]);
         ToolTipManager.remove(depthLevel["mhtHitMc"]);
         ToolTipManager.remove(conLevel["door_0"]);
         depthLevel["mhtHitMc"].removeEventListener(MouseEvent.CLICK,this.onMhtClickHandler);
         ToolBarController.panel.show();
         LevelManager.iconLevel.visible = true;
      }
      
      public function onLeaveHandler() : void
      {
         MapManager.changeMap(108);
         FightPetBagController.destroy();
      }
   }
}

