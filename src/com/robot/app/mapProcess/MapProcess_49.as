package com.robot.app.mapProcess
{
   import com.robot.app.buyItem.ItemAction;
   import com.robot.app.control.ExploreStationController;
   import com.robot.app.energy.utils.EnergyController;
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.event.ItemEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.task.CateInfo;
   import com.robot.core.info.task.DayTalkInfo;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.Direction;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.taomee.events.SocketEvent;
   
   public class MapProcess_49 extends BaseMapProcess
   {
      private var bossMC:MovieClip;
      
      private var bossBtn:SimpleButton;
      
      private var station:MovieClip;
      
      private var _panel:AppModel;
      
      private var timer:Timer;
      
      public function MapProcess_49()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.bossMC = conLevel["bossMC"];
         this.bossBtn = conLevel["bossBtn"];
         this.bossBtn.mouseEnabled = false;
         this.bossMC.addEventListener(MouseEvent.CLICK,this.clickBossMC);
         this.bossBtn.addEventListener(MouseEvent.CLICK,this.fightBoss);
         this.timer = new Timer(10 * 1000,1);
         this.timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
      }
      
      override public function destroy() : void
      {
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_START,this.onWalk);
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         this.timer = null;
         if(Boolean(this._panel))
         {
            this._panel.destroy();
         }
         this._panel = null;
         this.bossMC.removeEventListener(MouseEvent.CLICK,this.clickBossMC);
         this.bossBtn.removeEventListener(MouseEvent.CLICK,this.fightBoss);
         this.bossMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
         this.bossBtn = null;
         this.bossMC = null;
      }
      
      private function clickBossMC(event:MouseEvent) : void
      {
         this.bossMC.gotoAndPlay(2);
         this.bossMC.addEventListener(Event.ENTER_FRAME,function(event:Event):void
         {
            if(bossMC.currentFrame == bossMC.totalFrames)
            {
               bossMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
               bossBtn.mouseEnabled = true;
            }
         });
      }
      
      private function fightBoss(event:MouseEvent) : void
      {
         FightInviteManager.fightWithBoss("雷纳多");
      }
      
      private function onClickStation(evt:MouseEvent) : void
      {
      }
      
      public function giveThings() : void
      {
         ItemManager.addEventListener(ItemEvent.CLOTH_LIST,this.onList);
         ItemManager.getCloth();
      }
      
      private function onList(event:ItemEvent) : void
      {
         ItemManager.removeEventListener(ItemEvent.CLOTH_LIST,this.onList);
         var ids:Array = ItemManager.getClothIDs();
         if(ids.indexOf(100014) != -1 && ids.indexOf(100015) != -1)
         {
            Alarm.show("你已经拥有矿工头盔和采矿钻头了，快去帮忙吧！");
         }
         if(ids.indexOf(100014) == -1)
         {
            ItemAction.buyItem(100014,false);
         }
         if(ids.indexOf(100015) == -1)
         {
            ItemAction.buyItem(100015,false);
         }
      }
      
      public function getStone() : void
      {
         if(!this.checkCloth())
         {
            return;
         }
         EnergyController.exploit();
      }
      
      private function timerHandler(event:TimerEvent) : void
      {
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_START,this.onWalk);
         SocketConnection.addCmdListener(CommandID.TALK_CATE,this.onSuccess);
         SocketConnection.send(CommandID.TALK_CATE,12);
      }
      
      private function onWalk(evt:RobotEvent) : void
      {
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_START,this.onWalk);
         this.timer.stop();
         this.timer.reset();
         MainManager.actorModel.scaleX = 1;
         MainManager.actorModel.stop();
         Alarm.show("随便走动是无法挖到电能石的!");
      }
      
      private function onSuccess(event:SocketEvent) : void
      {
         MainManager.actorModel.direction = Direction.DOWN;
         MainManager.actorModel.scaleX = 1;
         SocketConnection.removeCmdListener(CommandID.TALK_CATE,this.onSuccess);
         var info:DayTalkInfo = event.data as DayTalkInfo;
         var _cateInfo:CateInfo = info.outList[0];
         var str:String = ItemXMLInfo.getName(_cateInfo.id);
         NpcTipDialog.show("看样子你采集到了" + _cateInfo.count.toString() + "个" + str + "。" + str + "都已经放入你的储存箱里了。\n<font color=\'#FF0000\'> " + "   快去飞船动力室看看它有什么用</font>",null,NpcTipDialog.DOCTOR,-80);
      }
      
      private function checkCloth() : Boolean
      {
         var b:Boolean = true;
         if(MainManager.actorInfo.clothIDs.indexOf(100014) == -1 && MainManager.actorInfo.clothIDs.indexOf(100717) == -1)
         {
            b = false;
            Alarm.show("你必须装备上" + TextFormatUtil.getRedTxt(ItemXMLInfo.getName(100014)) + "才能进行采集哦！");
         }
         return b;
      }
      
      public function showStationPanel() : void
      {
         ExploreStationController.showPanel("双子贝塔星");
      }
   }
}

