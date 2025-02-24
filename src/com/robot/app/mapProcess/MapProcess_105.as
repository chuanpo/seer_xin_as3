package com.robot.app.mapProcess
{
   import com.robot.app.buyItem.ItemAction;
   import com.robot.app.energy.utils.EnergyController;
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.spacesurvey.SpaceSurveyTool;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.event.ItemEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.fightInfo.CatchPetInfo;
   import com.robot.core.info.fightInfo.PetFightModel;
   import com.robot.core.info.task.CateInfo;
   import com.robot.core.info.task.DayTalkInfo;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.SOManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.Direction;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.net.SharedObject;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_105 extends BaseMapProcess
   {
      private var mcArr:Array;
      
      private var yoyoMC:MovieClip;
      
      private var isShow:Boolean = false;
      
      private var isCatch:Boolean = false;
      
      private var timer:Timer;
      
      private var clickArray:Array = [];
      
      private var clickMC:MovieClip;
      
      private var waterIndex:Number;
      
      public function MapProcess_105()
      {
         super();
      }
      
      override protected function init() : void
      {
         SpaceSurveyTool.getInstance().show("双子阿尔法星");
         this.timer = new Timer(10 * 1000,1);
         this.timer.addEventListener(TimerEvent.TIMER,this.timerHandler);
         this.yoyoMC = conLevel["yoyoMC"];
         if(TasksManager.getTaskStatus(23) != TasksManager.COMPLETE)
         {
            this.initNewPet();
         }
         conLevel["bridge"].mouseEnabled = false;
         conLevel["bridge"].mouseChildren = false;
      }
      
      private function onCatchMonster(event:SocketEvent) : void
      {
         var data:CatchPetInfo = event.data as CatchPetInfo;
         if(PetFightModel.defaultNpcID == 91 && data.catchTime > 0)
         {
            this.isCatch = true;
         }
      }
      
      private function initNewPet() : void
      {
         var i:MovieClip = null;
         this.clickArray = [conLevel["seven"],conLevel["eight"],conLevel["nine"],conLevel["ten"]];
         for each(i in this.clickArray)
         {
            i.buttonMode = true;
            i.addEventListener(MouseEvent.CLICK,this.clickMCHandler);
         }
      }
      
      private function clickMCHandler(event:MouseEvent) : void
      {
         var mc:MovieClip = event.currentTarget as MovieClip;
         if(mc == this.clickMC || this.isShow || this.isCatch)
         {
            return;
         }
         this.clickMC = mc;
         if(Math.random() < 0.1)
         {
            this.yoyoMC.x = this.clickMC.x;
            this.yoyoMC.y = this.clickMC.y;
            conLevel["yoyoHit"].x = this.yoyoMC.x + 100;
            conLevel["yoyoHit"].y = this.yoyoMC.y + 20;
            this.yoyoMC["yoyoMC"].gotoAndStop(2);
            this.isShow = true;
            setTimeout(this.hideYoyo,4000);
         }
      }
      
      private function hideYoyo() : void
      {
         if(Boolean(this.yoyoMC))
         {
            this.yoyoMC.y = -200;
            this.yoyoMC["yoyoMC"].gotoAndStop(1);
         }
         this.isShow = false;
      }
      
      public function fightYoyo() : void
      {
         if(this.isShow)
         {
            PetFightModel.defaultNpcID = 91;
            FightInviteManager.fightWithBoss("悠悠");
         }
      }
      
      private function onComHandler(a:Array) : void
      {
         this.waterIndex = 0;
         this.mcArr = new Array();
         this.mcArr = [conLevel["one"],conLevel["two"],conLevel["three"],conLevel["four"],conLevel["five"],conLevel["six"]];
         conLevel["bridge"].visible = false;
         if(!a[2] && Boolean(a[1]))
         {
            conLevel["animator_mc"].gotoAndStop(11);
            this.playWater();
            conLevel["bridge"].visible = true;
            DisplayUtil.removeForParent(typeLevel["bridge"]);
            conLevel["animator_mc"]["edison"].visible = false;
            conLevel["animator_mc"]["edison"].gotoAndStop(1);
            MapManager.currentMap.makeMapArray();
         }
         else if(!a[1] && Boolean(a[0]))
         {
            conLevel["animator_mc"].gotoAndStop(4);
            conLevel["bridge"].visible = false;
         }
         else if(Boolean(a[2]))
         {
            conLevel["animator_mc"].gotoAndStop(11);
            conLevel["bridge"].visible = true;
            DisplayUtil.removeForParent(typeLevel["bridge"]);
            conLevel["animator_mc"]["edison"].visible = false;
            conLevel["animator_mc"]["edison"].gotoAndStop(1);
            MapManager.currentMap.makeMapArray();
         }
      }
      
      private function playWater() : void
      {
         if(this.waterIndex < 5)
         {
            this.mcArr[this.waterIndex].gotoAndPlay(33);
            ++this.waterIndex;
            setTimeout(this.playWater,400);
            return;
         }
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
      
      public function changeScrene() : void
      {
         MapManager.changeMap(1);
      }
      
      override public function destroy() : void
      {
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_START,this.onWalk);
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.timerHandler);
         this.timer = null;
         SocketConnection.removeCmdListener(CommandID.CATCH_MONSTER,this.onCatchMonster);
         this.yoyoMC = null;
         SpaceSurveyTool.getInstance().hide();
      }
      
      public function alison() : void
      {
         MapManager.changeMap(106);
      }
      
      public function hitMine() : void
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
         SocketConnection.send(CommandID.TALK_CATE,9);
      }
      
      private function onWalk(evt:RobotEvent) : void
      {
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_START,this.onWalk);
         this.timer.stop();
         this.timer.reset();
         MainManager.actorModel.scaleX = 1;
         MainManager.actorModel.stop();
         Alarm.show("随便走动是无法挖到蘑菇结晶的!");
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
         so = SOManager.getUserSO(SOManager.MINE_400010);
         if(!so.data["isCatch"])
         {
            so.data["isCatch"] = true;
            SOManager.flush(so);
         }
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
   }
}

