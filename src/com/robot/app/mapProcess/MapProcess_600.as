package com.robot.app.mapProcess
{
   import com.robot.app.fightLevel.FightPetBagController;
   import com.robot.app.freshFightLevel.FightLevelModel;
   import com.robot.app.freshFightLevel.FreshSuccessFightRequestInfo;
   import com.robot.app.toolBar.ToolBarController;
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.event.PetFightEvent;
   import com.robot.core.info.fightInfo.PetFightModel;
   import com.robot.core.info.fightInfo.attack.FightOverInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.utils.clearTimeout;
   import flash.utils.getDefinitionByName;
   import flash.utils.setTimeout;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ResourceManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   import com.robot.app.protectSys.KillPluginSys;
   import com.robot.app.automaticFight.AutomaticFightManager;
   
   public class MapProcess_600 extends BaseMapProcess
   {
      private var b1:Boolean = true;
      
      private var _allBossA:Array = [];
      
      private var _curIndex:uint = 0;
      
      private var _bossContainer:Sprite;
      
      private var _allPointA:Array = [new Point(410,296),new Point(490,296),new Point(570,296)];
      
      private var tt:uint;
      
      private var nextBossId:Array;
      
      private var NUM:Number = 1/60;
      
      public function MapProcess_600()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.b1 = true;
         LevelManager.iconLevel.visible = false;
         ToolBarController.panel.hide();
         this.upDatahandler();
      }
      
      private function upDatahandler() : void
      {
         var max:uint = 0;
         var level:String = null;
         var bai:uint = 0;
         var ge:uint = 0;
         if(FightLevelModel.getCurLevel > FightLevelModel.maxLevel)
         {
            max = FightLevelModel.maxLevel;
         }
         else
         {
            max = FightLevelModel.getCurLevel;
         }
         if(FightLevelModel.getCurLevel < 10)
         {
            conLevel["tens_mc"].gotoAndStop(2);
            conLevel["units_mc"].gotoAndStop(FightLevelModel.getCurLevel + 2);
         }
         else if(FightLevelModel.getCurLevel == 30)
         {
            conLevel["tens_mc"].gotoAndStop(5);
            conLevel["units_mc"].gotoAndStop(2);
         }
         else
         {
            level = String(FightLevelModel.getCurLevel);
            bai = uint(level.slice(0,1));
            ge = uint(level.slice(1,2));
            conLevel["tens_mc"].gotoAndStop(bai + 2);
            conLevel["units_mc"].gotoAndStop(ge + 2);
         }
         ToolTipManager.add(conLevel["door_0"],"离开");
         ToolTipManager.add(conLevel["mosterMc"],"精灵背包");
         conLevel["mosterMc"].addEventListener(MouseEvent.CLICK,this.onMonsterHandler);
         this._allBossA = [];
         this._curIndex = 0;
         this.loadBoss(FightLevelModel.getBossId[0]);
      }
      
      private function onMonsterHandler(e:MouseEvent) : void
      {
         FightPetBagController.show();
      }
      
      override public function destroy() : void
      {
         var i1:int = 0;
         ToolTipManager.remove(conLevel["mosterMc"]);
         conLevel["mosterMc"].removeEventListener(MouseEvent.CLICK,this.onMonsterHandler);
         ToolTipManager.remove(conLevel["door_0"]);
         if(Boolean(this._allBossA))
         {
            for(i1 = 0; i1 < this._allBossA.length; i1++)
            {
               ToolTipManager.remove(this._allBossA[i1]);
               DisplayUtil.removeForParent(this._allBossA[i1]);
               this._allBossA[i1] = null;
            }
            this._allBossA = null;
         }
         if(Boolean(this._bossContainer))
         {
            this._bossContainer.removeEventListener(MouseEvent.CLICK,this.onFightBtnClickHandler);
            DisplayUtil.removeForParent(this._bossContainer);
            this._bossContainer = null;
         }
      }
      
      private function loadBoss(id:uint) : void
      {
         var url:String = ClientConfig.getPetSwfPath(id);
         ResourceManager.getResource(url,this.loadComHandler,"pet");
      }
      
      private function loadComHandler(dis:DisplayObject) : void
      {
         var mc:MovieClip = null;
         mc = dis as MovieClip;
         if(Boolean(mc))
         {
            mc.gotoAndStop("down");
            mc.addEventListener(Event.ENTER_FRAME,function():void
            {
               var mc1:MovieClip = mc.getChildAt(0) as MovieClip;
               if(Boolean(mc1))
               {
                  mc1.gotoAndStop(1);
                  mc.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               }
            });
            this._allBossA.push(mc);
            if(this._allBossA.length < FightLevelModel.getBossId.length)
            {
               this.loadBoss(FightLevelModel.getBossId[this._allBossA.length]);
            }
            else
            {
               this.addAllBossToMap();
            }
         }
      }
      
      private function addAllBossToMap() : void
      {
         var w:Number = NaN;
         this._bossContainer = new Sprite();
         for(var i1:int = 0; i1 < this._allBossA.length; i1++)
         {
            this._bossContainer.addChild(this._allBossA[i1] as MovieClip);
            w = this._allBossA[i1].width * 1.5;
            this._allBossA[i1].width *= 1.6;
            this._allBossA[i1].height *= 1.6;
            ToolTipManager.add(this._allBossA[i1],PetXMLInfo.getName(FightLevelModel.getBossId[i1]));
         }
         if(this._allBossA.length == 1)
         {
            this._allBossA[0].x = this._allPointA[1].x;
            this._allBossA[0].y = this._allPointA[1].y;
            this._allBossA[0].scaleX *= 1.2;
            this._allBossA[0].scaleY *= 1.2;
         }
         MapManager.currentMap.depthLevel.addChild(this._bossContainer);
         this._bossContainer.buttonMode = true;
         this._bossContainer.addEventListener(MouseEvent.CLICK,this.onFightBtnClickHandler);
      }
      
      private function onFightBtnClickHandler(e:MouseEvent) : void
      {
         if(Math.random() < NUM && !AutomaticFightManager.isStart)
         {
            KillPluginSys.start();
            return;
         }
         e.currentTarget.buttonMode = false;
         e.currentTarget.removeEventListener(MouseEvent.CLICK,this.onFightBtnClickHandler);
         this.tt = setTimeout(this.timeOutHandler,2000);
         EventManager.addEventListener(PetFightEvent.FIGHT_CLOSE,this.handle);
         PetFightModel.mode = PetFightModel.MULTI_MODE;
         PetFightModel.status = PetFightModel.FIGHT_WITH_BOSS;
         SocketConnection.addCmdListener(CommandID.FRESH_START_FIGHT_LEVEL,this.onSuccessHandler);
         SocketConnection.send(CommandID.FRESH_START_FIGHT_LEVEL);
      }
      
      private function timeOutHandler() : void
      {
         clearTimeout(this.tt);
      }
      
      private function onSuccessHandler(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.FRESH_START_FIGHT_LEVEL,this.onSuccessHandler);
         var id:FreshSuccessFightRequestInfo = e.data as FreshSuccessFightRequestInfo;
         this.nextBossId = id.getBossId;
      }
      
      private function handle(e:PetFightEvent) : void
      {
         var data:FightOverInfo;
         var cls:*;
         EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,this.handle);
         data = e.dataObj["data"];
         cls = getDefinitionByName("com.robot.petFightModule.PetFightEntry");
         if(Boolean(cls.fighterCon.isEscape))
         {
            this.b1 = true;
            return;
         }
         if(data.winnerID == MainManager.actorInfo.userID)
         {
            this.b1 = true;
            ++MainManager.actorInfo.curFreshStage;
            ++MainManager.actorInfo.maxFreshStage;
            if(MainManager.actorInfo.curFreshStage > FightLevelModel.maxLevel)
            {
               this.leaveFight();
            }
            else
            {
               FightLevelModel.setBossId = this.nextBossId;
               FightLevelModel.setCurLevel = MainManager.actorInfo.curFreshStage;
               trace("做个事件判断判断             。。。。。。。。。。。。。。。。。。。");
               trace(MainManager.actorInfo.curFreshStage);
               if(MainManager.actorInfo.curFreshStage >= 10)
               {
                  if(TasksManager.getTaskStatus(89) == TasksManager.ALR_ACCEPT)
                  {
                     TasksManager.getProStatusList(89,function(arr:Array):void
                     {
                        if(Boolean(arr[0]) && !arr[1])
                        {
                           TasksManager.complete(89,1,null,true);
                        }
                     });
                  }
               }
               MapManager.changeMap(600);
            }
         }
         else if(data.reason != 2)
         {
            this.b1 = false;
            this.leaveFight();
         }
      }
      
      private function onLeaveFightHandler(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.FRESH_LEAVE_FIGHT_LEVEL,this.onLeaveFightHandler);
         ToolBarController.panel.show();
         LevelManager.iconLevel.visible = true;
         if(this.b1 == false)
         {
            LevelManager.iconLevel.addChild(Alarm.show("很遗憾，刚才的战斗你没有获胜，你需要重新开始挑战，不要气馁，再接再厉。"));
         }
         else
         {
            this.b1 = false;
         }
      }
      
      public function leaveFight() : void
      {
         SocketConnection.addCmdListener(CommandID.FRESH_LEAVE_FIGHT_LEVEL,this.onLeaveFightHandler);
         SocketConnection.send(CommandID.FRESH_LEAVE_FIGHT_LEVEL);
      }
   }
}

