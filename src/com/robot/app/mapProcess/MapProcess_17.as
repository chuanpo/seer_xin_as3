package com.robot.app.mapProcess
{
   import com.robot.app.task.SeerInstructor.NewInstructorContoller;
   import com.robot.app.task.boss.HuLiAo;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.aimat.AimatController;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.ActorModel;
   import com.robot.core.mode.PetModel;
   import com.robot.core.ui.DialogBox;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.taomee.utils.DisplayUtil;
   import com.robot.core.mode.BossModel;
   import flash.events.MouseEvent;
   import org.taomee.manager.ToolTipManager;
   import com.robot.core.npc.NpcDialog;
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.CommandID;
   import org.taomee.events.SocketEvent;
   import com.robot.core.info.pet.PetShowInfo;
   import flash.geom.Point;
   import org.taomee.manager.EventManager;
   import com.robot.core.event.PetFightEvent;
   import com.robot.core.info.SystemTimeInfo;
   import com.robot.core.info.task.MiningCountInfo;
   
   public class MapProcess_17 extends BaseMapProcess
   {
      public static var bFight:Boolean;
      
      private var npc:MovieClip;
      
      private var strArray:Array = ["快点来救我，旁边这个大怪物太可怕了","你就不能去找个工具铺条路出来","我这还被火烤着呢？！想办法把火灭了"];
      
      private var index:uint = 0;
      
      private var timer:Timer;
      
      private var stone1:MovieClip;
      
      private var stone2:MovieClip;
      
      private var bShoot1:Boolean;
      
      private var bShoot2:Boolean;
      
      private var bShootFire:Boolean;
      
      private var fire_mc:MovieClip;
      
      private var catchTimer:Timer;
      
      private var isCacthing:Boolean = false;

      private var gelin_mc:BossModel;
      
      private var buluIDs:Array = [108,109,110];

      public function MapProcess_17()
      {
         super();
      }
      
      override protected function init() : void
      {
         var msgBox:DialogBox = null;
         NewInstructorContoller.chekWaste();
         if(TasksManager.taskList[302] != 3)
         {
            this.npc = depthLevel["npc"];
            this.fire_mc = depthLevel["fire_mc"];
            this.timer = new Timer(8000);
            this.timer.addEventListener(TimerEvent.TIMER,this.timerEvent);
            this.timer.start();
            msgBox = new DialogBox();
            msgBox.show(this.strArray[this.index],10,-msgBox.height - 2,this.npc);
            ++this.index;
         }
         this.stone1 = conLevel["s1_mc"];
         this.stone2 = conLevel["s2_mc"];
         AimatController.addEventListener(AimatEvent.PLAY_END,this.onAimat);
         if(TasksManager.taskList[302] == 3)
         {
            depthLevel["npc"].visible = false;
            conLevel["bossHu1"].visible = false;
            DisplayUtil.removeForParent(typeLevel["thirdMC"]);
            depthLevel["fire_mc"].visible = false;
         }
         if(HuLiAo.changeStatus)
         {
            (depthLevel["fire_mc"] as MovieClip).stop();
            depthLevel["fire_mc"].visible = false;
            DisplayUtil.removeForParent(typeLevel["thirdMC"]);
            MapManager.currentMap.makeMapArray();
            this.bShootFire = true;
            HuLiAo.changeStatus = false;
         }
         if(HuLiAo.bFirstWin)
         {
            NpcTipDialog.show("感谢你来营救我，但你别得意，我们海盗和赛尔的事情没完，我们一定会战胜你的。后会有期！",this.getAward,NpcTipDialog.BAD_GUARD);
            HuLiAo.bFirstWin = false;
         }
         if(HuLiAo.bStart)
         {
            HuLiAo.removeListener();
            HuLiAo.bStart = false;
         }
         this.catchTimer = new Timer(10 * 1000,1);
         this.catchTimer.addEventListener(TimerEvent.TIMER,this.onCatchTimer);
         SocketConnection.addCmdListener(CommandID.SYSTEM_TIME, function(evt:SocketEvent) : void{
            SocketConnection.removeCmdListener(CommandID.SYSTEM_TIME,arguments.callee);
            var date:Date = (evt.data as SystemTimeInfo).date;
            if([0,6].indexOf(date.day) == -1)return;
            if(MainManager.actorModel.pet != null)
            {
               initGelin(buluIDs.indexOf(int(MainManager.actorModel.pet.info.petID)) > -1);
            }
            SocketConnection.addCmdListener(CommandID.PET_SHOW,petShowHandle);
         })
         SocketConnection.send(CommandID.SYSTEM_TIME);
      }
      public function petShowHandle(event:SocketEvent):void{
         var data:PetShowInfo = event.data as PetShowInfo;
         if(data.userID == MainManager.actorInfo.userID)
         {
            initGelin(this.buluIDs.indexOf(int(data.petID)) > -1 && data.flag == 1);
         }
      };
      public function initGelin(flag:Boolean):void
      {
         SocketConnection.addCmdListener(CommandID.TALK_COUNT,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.TALK_COUNT,arguments.callee);
            var oreCountInfo:MiningCountInfo = e.data as MiningCountInfo;
            var count:uint = oreCountInfo.miningCount;
            if(!gelin_mc)
               {
                  gelin_mc = new BossModel(62,17);
                  gelin_mc.show(new Point(480,240),0);
                  gelin_mc.mouseEnabled = true;
                  gelin_mc.addEventListener(MouseEvent.CLICK,fightGelin);
                  ToolTipManager.add(gelin_mc,"格林");
               }
            gelin_mc.visible = count == 0 ? flag : false;
         })
         SocketConnection.send(CommandID.TALK_COUNT,700001 - 500000);
      }
      public function fightGelin(e:MouseEvent):void
      {
         NpcDialog.show(62,["布鲁，我终于找到你啦！#1"],["(他看起来很高兴呢~[进入捕捉页面])","装傻"],
            [function():void{
               FightInviteManager.fightWithBoss("格林",1);
               EventManager.addEventListener(PetFightEvent.FIGHT_CLOSE,onFightOver);
            },null])
      }
      public function onFightOver(e:PetFightEvent):void
      {
         EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,arguments.callee);
         this.initGelin(true);
      }
      public function clearWaste() : void
      {
         NewInstructorContoller.setWaste();
      }
      
      override public function destroy() : void
      {
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
         if(Boolean(this.timer))
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.timerEvent);
            this.timer = null;
         }
         if(Boolean(this.fire_mc))
         {
            this.fire_mc.removeEventListener(Event.ENTER_FRAME,this.onEnterFire);
            this.fire_mc = null;
         }
         if(Boolean(this.stone1))
         {
            this.stone1.removeEventListener(Event.ENTER_FRAME,this.onEnterStone1);
            this.stone1 = null;
         }
         if(Boolean(this.stone2))
         {
            this.stone2.removeEventListener(Event.ENTER_FRAME,this.onEnterStone2);
            this.stone2 = null;
         }
         this.npc = null;
         trace(HuLiAo.changeStatus + "**************");
         this.catchTimer.stop();
         this.catchTimer.removeEventListener(TimerEvent.TIMER,this.onCatchTimer);
         this.catchTimer = null;
         var mode:ActorModel = MainManager.actorModel;
         mode.removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
         SocketConnection.removeCmdListener(CommandID.PET_SHOW,this.petShowHandle);
      }
      
      private function getAward() : void
      {
      }
      
      private function timerEvent(event:TimerEvent) : void
      {
         var msgBox:DialogBox = new DialogBox();
         msgBox.show(this.strArray[this.index],10,-msgBox.height - 2,this.npc);
         ++this.index;
         if(this.index > this.strArray.length - 1)
         {
            this.index = 0;
         }
      }
      
      private function onAimat(e:AimatEvent) : void
      {
         var info:AimatInfo = e.info;
         if(info.userID != MainManager.actorID)
         {
            return;
         }
         if(info.id != 10002)
         {
            return;
         }
         if(this.bShoot1 && this.bShoot2 && this.bShootFire)
         {
            return;
         }
         if(this.stone1.hitTestPoint(info.endPos.x,info.endPos.y) && !this.bShoot1)
         {
            this.stone1.play();
            this.stone1.addEventListener(Event.ENTER_FRAME,this.onEnterStone1);
         }
         if(this.stone2.hitTestPoint(info.endPos.x,info.endPos.y) && !this.bShoot2)
         {
            this.stone2.play();
            this.stone2.addEventListener(Event.ENTER_FRAME,this.onEnterStone2);
         }
         if(this.fire_mc == null)
         {
            return;
         }
         if(this.fire_mc.hitTestPoint(info.endPos.x,info.endPos.y) && !this.bShootFire)
         {
            this.fire_mc.gotoAndStop(2);
            this.fire_mc.addEventListener(Event.ENTER_FRAME,this.onEnterFire);
         }
      }
      
      public function changeBoss() : void
      {
         if(TasksManager.taskList[302] == 3)
         {
            HuLiAo.startFight();
         }
         else
         {
            NpcTipDialog.show("赛尔机器人" + MainManager.actorInfo.nick + "，你真是好心人前来营救我！快点想办法击败身边这个精灵，我可打不过它，它要再扑过来，咱们都完蛋。",this.startFight,NpcTipDialog.BAD_GUARD);
         }
      }
      
      private function startFight() : void
      {
         HuLiAo.startFight();
      }
      
      private function onEnterFire(e:Event) : void
      {
         if(this.fire_mc.currentFrame == this.fire_mc.totalFrames)
         {
            this.fire_mc.removeEventListener(Event.ENTER_FRAME,this.onEnterFire);
            this.fire_mc.stop();
            DisplayUtil.removeForParent(typeLevel["thirdMC"]);
            MapManager.currentMap.makeMapArray();
            this.bShootFire = true;
            this.changeWord();
         }
      }
      
      private function changeWord() : void
      {
         if(this.bShoot1 && this.bShoot2 && this.bShootFire)
         {
            this.strArray = ["快点来救我，旁边这个大怪物太可怕了"];
         }
         if(this.bShoot1 && this.bShoot2)
         {
            this.strArray = ["快点来救我，旁边这个大怪物太可怕了","我这还被火烤着呢？！想办法把火灭了"];
         }
         if(this.bShootFire)
         {
            this.strArray = ["快点来救我，旁边这个大怪物太可怕了","你就不能去找个工具铺条路出来"];
         }
         this.index = 0;
      }
      
      private function onEnterStone2(e:Event) : void
      {
         if(this.stone2.currentFrame == this.stone2.totalFrames)
         {
            this.stone2.removeEventListener(Event.ENTER_FRAME,this.onEnterStone2);
            this.stone2.stop();
            DisplayUtil.removeForParent(typeLevel["secondMC"]);
            MapManager.currentMap.makeMapArray();
            this.bShoot2 = true;
            this.changeWord();
         }
      }
      
      private function onEnterStone1(e:Event) : void
      {
         if(this.stone1.currentFrame == this.stone1.totalFrames)
         {
            this.stone1.removeEventListener(Event.ENTER_FRAME,this.onEnterStone1);
            this.stone1.stop();
            DisplayUtil.removeForParent(typeLevel["firstMC"]);
            MapManager.currentMap.makeMapArray();
            this.bShoot1 = true;
            this.changeWord();
         }
      }
      
      public function clickBrume() : void
      {
         var mc:MovieClip = null;
         mc = conLevel["brumeMC"];
         var mode:ActorModel = MainManager.actorModel;
         var petMode:PetModel = mode.pet;
         if(Boolean(petMode))
         {
            if(PetXMLInfo.getType(petMode.info.petID) == "2")
            {
               mc.mouseEnabled = false;
               mc.mouseChildren = false;
               mc["mc"].gotoAndPlay(3);
               mc.addFrameScript(62,function():void
               {
                  DisplayUtil.removeForParent(mc);
               });
            }
         }
      }
      
      public function catchStone() : void
      {
      }
      
      private function onCheckTask(b:Boolean) : void
      {
         if(b)
         {
            Alarm.show("你已经收集过炎晶了");
            return;
         }
         if(MainManager.actorInfo.clothIDs.indexOf(100014) == -1)
         {
            Alarm.show("矿石挖掘需要专业工具挖矿钻头，若你已从机械室找到它，快把它装备上吧！");
            return;
         }
         this.catchTimer.stop();
         this.catchTimer.reset();
         this.catchTimer.start();
         this.isCacthing = true;
         var mode:ActorModel = MainManager.actorModel;
         mode.addEventListener(RobotEvent.WALK_START,this.onWalkStart);
         mode.specialAction(100014);
         mode.parent.addChild(mode);
         mode.skeleton.getBodyMC().scaleX = -1;
      }
      
      private function onCatchTimer(event:TimerEvent) : void
      {
         this.isCacthing = false;
      }
      
      private function onWalkStart(event:RobotEvent) : void
      {
         var mode:ActorModel = null;
         if(this.isCacthing)
         {
            Alarm.show("随便走动是无法收集炎晶的哦！");
            this.isCacthing = false;
            mode = MainManager.actorModel;
            mode.skeleton.getBodyMC().scaleX = 1;
            this.catchTimer.stop();
         }
      }
   }
}

