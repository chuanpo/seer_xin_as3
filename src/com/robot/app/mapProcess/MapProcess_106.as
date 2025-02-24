package com.robot.app.mapProcess
{
   import com.robot.app.energy.utils.EnergyController;
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.task.CateInfo;
   import com.robot.core.info.task.DayTalkInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.SOManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.Direction;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.utils.ByteArray;
   import flash.utils.Timer;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.ToolTipManager;
   
   public class MapProcess_106 extends BaseMapProcess
   {
      private var fightMC:MovieClip;
      
      private var timer:Timer;
      
      private var type:uint;
      
      private var makeTa_btn:SimpleButton;
      
      private var ta_mc:MovieClip;
      
      private var shieldGame:AppModel;
      
      public function MapProcess_106()
      {
         super();
      }
      
      override protected function init() : void
      {
         var btn:SimpleButton = null;
         this.fightMC = conLevel["fightMC"];
         this.makeTa_btn = conLevel["makeTa_btn"];
         this.ta_mc = conLevel["ta_mc"];
         this.ta_mc.gotoAndStop(1);
         this.ta_mc.visible = true;
         ToolTipManager.add(this.ta_mc,"防空塔");
         this.makeTa_btn.visible = false;
         for(var i:uint = 0; i < 2; i++)
         {
            btn = conLevel.getChildByName("btn_" + i) as SimpleButton;
            btn.addEventListener(MouseEvent.CLICK,this.pull);
         }
         if(TasksManager.getTaskStatus(307) == TasksManager.COMPLETE)
         {
            this.fightMC.mouseEnabled = true;
            conLevel["bossMC"].gotoAndStop(3);
         }
         else
         {
            this.fightMC.mouseEnabled = false;
            conLevel["bossMC"].gotoAndStop(1);
         }
         this.ta_mc.buttonMode = true;
         this.ta_mc.addEventListener(MouseEvent.CLICK,this.clickTaMcHandler);
         this.timer = new Timer(10 * 1000,1);
         this.timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
      }
      
      private function clickTaMcHandler(e:MouseEvent) : void
      {
         if(this.ta_mc.currentFrame != 2)
         {
            SocketConnection.addCmdListener(CommandID.JOIN_GAME,this.onBeginGame);
            SocketConnection.send(CommandID.JOIN_GAME,1);
         }
      }
      
      private function onBeginGame(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.JOIN_GAME,this.onBeginGame);
         if(!this.shieldGame)
         {
            this.shieldGame = new AppModel(ClientConfig.getGameModule("ShieldGame"),"正在防护塔游戏");
            this.shieldGame.setup();
         }
         this.shieldGame.show();
         var by:ByteArray = e.data as ByteArray;
         var bonusID:uint = by.readUnsignedInt();
         SocketConnection.addCmdListener(CommandID.GAME_OVER,this.onGameOver);
         trace(bonusID + "\t ok");
      }
      
      private function onGameOver(evt:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GAME_OVER,this.onGameOver);
      }
      
      private function makeTaClickHandler(e:MouseEvent) : void
      {
      }
      
      private function onWalk(evt:RobotEvent) : void
      {
         var str:String = null;
         MainManager.actorModel.sprite.removeEventListener(RobotEvent.WALK_START,this.onWalk);
         this.timer.stop();
         this.timer.reset();
         MainManager.actorModel.stop();
         MainManager.actorModel.scaleX = 1;
         if(this.type == 1)
         {
            str = "豆豆果实";
         }
         else
         {
            str = "纳格晶体";
         }
         Alarm.show("随便走动是无法挖到" + str + "的!");
      }
      
      override public function destroy() : void
      {
         this.ta_mc.removeEventListener(MouseEvent.CLICK,this.clickTaMcHandler);
         this.ta_mc = null;
         this.makeTa_btn.removeEventListener(MouseEvent.CLICK,this.makeTaClickHandler);
         this.makeTa_btn = null;
         MainManager.actorModel.sprite.removeEventListener(RobotEvent.WALK_START,this.onWalk);
         this.fightMC = null;
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         this.timer = null;
      }
      
      private function pull(event:MouseEvent) : void
      {
         conLevel["bossMC"].nextFrame();
         if(conLevel["bossMC"].currentFrame == 3)
         {
            this.fightMC.mouseEnabled = true;
         }
      }
      
      public function fight() : void
      {
         FightInviteManager.fightWithBoss("纳多雷",0);
      }
      
      public function hitDoor() : void
      {
         MapManager.changeMap(46);
      }
      
      public function catchMine2() : void
      {
         this.type = 2;
         if(MainManager.actorInfo.actionType == 1)
         {
            NpcTipDialog.show("   你正处于飞行中,是不能进行能源采集的...",null,NpcTipDialog.SHU_KE,-80);
            return;
         }
         if(!this.checkCloth())
         {
            return;
         }
         EnergyController.exploit();
      }
      
      public function catchMine() : void
      {
         this.type = 1;
         if(MainManager.actorInfo.actionType == 1)
         {
            NpcTipDialog.show("   你正处于飞行中,是不能进行能源采集的...",null,NpcTipDialog.SHU_KE,-80);
            return;
         }
         if(!this.checkCloth())
         {
            return;
         }
         EnergyController.exploit(1);
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         MainManager.actorModel.sprite.removeEventListener(RobotEvent.WALK_START,this.onWalk);
         SocketConnection.addCmdListener(CommandID.TALK_CATE,this.onSuccess);
         if(this.type == 1)
         {
            SocketConnection.send(CommandID.TALK_CATE,11);
         }
         else
         {
            SocketConnection.send(CommandID.TALK_CATE,10);
         }
      }
      
      private function onSuccess(event:SocketEvent) : void
      {
         var so:SharedObject = null;
         MainManager.actorModel.direction = Direction.DOWN;
         MainManager.actorModel.scaleX = 1;
         SocketConnection.removeCmdListener(CommandID.TALK_CATE,this.onSuccess);
         var info:DayTalkInfo = event.data as DayTalkInfo;
         var _cateInfo:CateInfo = info.outList[0];
         var str:String = ItemXMLInfo.getName(_cateInfo.id);
         NpcTipDialog.show("看样子你采集到了" + _cateInfo.count.toString() + "个" + str + "。" + str + "都已经放入你的储存箱里了。\n<font color=\'#FF0000\'> " + "   快去飞船动力室看看它有什么用</font>",null,NpcTipDialog.DOCTOR,-80);
         if(this.type == 1)
         {
            so = SOManager.getUserSO(SOManager.MINE_400012);
            if(!so.data["isCatch"])
            {
               so.data["isCatch"] = true;
               SOManager.flush(so);
            }
         }
         else
         {
            so = SOManager.getUserSO(SOManager.MINE_400011);
            if(!so.data["isCatch"])
            {
               so.data["isCatch"] = true;
               SOManager.flush(so);
            }
         }
      }
      
      private function checkCloth() : Boolean
      {
         var b:Boolean = true;
         if(this.type == 1)
         {
            if(MainManager.actorInfo.clothIDs.indexOf(100059) == -1 && MainManager.actorInfo.clothIDs.indexOf(100717) == -1)
            {
               b = false;
               Alarm.show("你必须装备上" + TextFormatUtil.getRedTxt(ItemXMLInfo.getName(100059)) + "才能进行采集哦！");
            }
         }
         else if(MainManager.actorInfo.clothIDs.indexOf(100014) == -1 && MainManager.actorInfo.clothIDs.indexOf(100717) == -1)
         {
            b = false;
            Alarm.show("你必须装备上" + TextFormatUtil.getRedTxt(ItemXMLInfo.getName(100014)) + "才能进行采集哦！");
         }
         return b;
      }
   }
}

