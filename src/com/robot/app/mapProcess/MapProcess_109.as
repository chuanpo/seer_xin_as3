package com.robot.app.mapProcess
{
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.CommandID;
   import com.robot.core.aimat.AimatController;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.NonoManager;
   import com.robot.core.manager.map.MapLibManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.ArrayUtil;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_109 extends BaseMapProcess
   {
      private var superStone:MovieClip;
      
      private var weightLessHouse:MovieClip;
      
      private var oreGather:MovieClip;
      
      private var suitAlarm:MovieClip;
      
      private var nonoSuit:MovieClip;
      
      private var sinNum:Number = 0;
      
      private var stoneNum:uint = 0;
      
      private var stoneList:Array = [];
      
      private var oldSpeed:Number;
      
      public function MapProcess_109()
      {
         super();
      }
      
      private function createStone() : void
      {
         var stonex:Number = NaN;
         var stoney:Number = NaN;
         var scaleNum:Number = NaN;
         var stone:Stone = null;
         while(this.stoneNum > 20 || this.stoneNum < 15)
         {
            this.stoneNum = Math.floor(Math.random() * 20);
         }
         for(var i:uint = 0; i < this.stoneNum; i++)
         {
            stonex = this.getGaussian(40 * (i + 1),50);
            stoney = this.getGaussian(20 * (i + 1),100);
            scaleNum = Math.random();
            while(scaleNum < 0.7)
            {
               scaleNum = Math.random();
            }
            stone = new Stone(Math.ceil(Math.random() * 5));
            stone.x = stonex;
            stone.y = stoney;
            stone.scaleX = scaleNum;
            stone.scaleY = scaleNum;
            conLevel.addChild(stone);
            stone.addEventListener(Stone.CLEAR,this.onClear);
            this.stoneList.push(stone);
            trace(stonex + "   " + stoney + "  " + scaleNum);
         }
      }
      
      private function onClear(event:Event) : void
      {
         var stone:Stone = event.currentTarget as Stone;
         stone.removeEventListener(Stone.CLEAR,this.onClear);
         var index:int = int(this.stoneList.indexOf(stone));
         if(index != -1)
         {
            this.stoneList.splice(index,1);
         }
      }
      
      override protected function init() : void
      {
         var array:Array;
         this.oldSpeed = MainManager.actorModel.speed;
         MainManager.actorModel.speed = this.oldSpeed / 2;
         this.createStone();
         AimatController.addEventListener(AimatEvent.PLAY_END,this.onAimat);
         this.suitAlarm = MapLibManager.getMovieClip("suitAlarm");
         this.superStone = this.conLevel["superStone"];
         this.weightLessHouse = this.conLevel["weightLessHouse"];
         this.oreGather = this.conLevel["oreGather"];
         array = MainManager.actorInfo.clothIDs;
         if(!ArrayUtil.arrayContainsValue(array,100054) && !ArrayUtil.arrayContainsValue(array,100110) && !ArrayUtil.arrayContainsValue(array,100158) && !ArrayUtil.arrayContainsValue(array,100167))
         {
            LevelManager.appLevel.addChild(this.suitAlarm);
            DisplayUtil.align(this.suitAlarm,null,AlignType.MIDDLE_CENTER);
            this.suitAlarm["closeBtn"].addEventListener(MouseEvent.CLICK,function():void
            {
               MapManager.changeMap(107);
            });
            return;
         }
         MainManager.actorModel.addEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalk);
         MainManager.actorModel.addEventListener(RobotEvent.WALK_END,this.onWalkEnd);
      }
      
      override public function destroy() : void
      {
         var i:Stone = null;
         MainManager.actorModel.speed = this.oldSpeed;
         LevelManager.openMouseEvent();
         if(!MainManager.actorModel.nono)
         {
            MainManager.actorModel.showNono(NonoManager.info,MainManager.actorInfo.actionType);
         }
         for each(i in this.stoneList)
         {
            i.removeEventListener(Stone.CLEAR,this.onClear);
         }
         if(Boolean(this.suitAlarm))
         {
            DisplayUtil.removeForParent(this.suitAlarm);
         }
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
         SocketConnection.removeCmdListener(CommandID.NO_GRAVITY_SHIP,this.onSocketSuccessHandler);
         this.stoneList = [];
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_ENTER_FRAME,this.onWalk);
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_END,this.onWalkEnd);
         if(Boolean(this.nonoSuit))
         {
            if(this.nonoSuit.hasEventListener(Event.ENTER_FRAME))
            {
               this.nonoSuit.removeEventListener(Event.ENTER_FRAME,this.onNonoSuitFrameHandler);
            }
         }
         if(this.weightLessHouse.hasEventListener(Event.ENTER_FRAME))
         {
            this.weightLessHouse.removeEventListener(Event.ENTER_FRAME,this.onFrameHandler("*"));
         }
      }
      
      private function onAimat(e:AimatEvent) : void
      {
         var i:Stone = null;
         var info:AimatInfo = e.info;
         if(info.userID != MainManager.actorID)
         {
            return;
         }
         for each(i in this.stoneList)
         {
            if(i.hitTestPoint(info.endPos.x,info.endPos.y,true))
            {
               i.play();
               break;
            }
         }
      }
      
      public function onSuperStoneClickHandler() : void
      {
         if(!MainManager.actorInfo.superNono)
         {
            Alarm.show("你必须要带上超能NoNo哦！");
            return;
         }
         if(!MainManager.actorModel.nono)
         {
            Alarm.show("你必须要带上超能NoNo哦！");
            return;
         }
         MainManager.actorModel.hideNono();
         LevelManager.closeMouseEvent();
         this.superStone.gotoAndStop(2);
         setTimeout(this.superStonePlay,300);
      }
      
      private function superStonePlay() : void
      {
         var mc:MovieClip = null;
         var num:uint = uint(this.superStone.numChildren);
         for(var i:uint = 0; i < num; i++)
         {
            mc = this.superStone.getChildAt(i) as MovieClip;
            if(Boolean(mc))
            {
               if(mc.name == "colorMC")
               {
                  DisplayUtil.FillColor(mc,MainManager.actorInfo.nonoColor);
               }
               if(mc.name == "stoneMC")
               {
                  mc.addEventListener(Event.ENTER_FRAME,this.sendToServer);
               }
            }
         }
      }
      
      private function sendToServer(event:Event) : void
      {
         var mc:MovieClip = event.currentTarget as MovieClip;
         if(mc.totalFrames == mc.currentFrame)
         {
            mc.removeEventListener(Event.ENTER_FRAME,this.sendToServer);
            DisplayUtil.removeForParent(this.superStone);
            MainManager.actorModel.showNono(NonoManager.info,MainManager.actorInfo.actionType);
            Stone.send(1);
            LevelManager.openMouseEvent();
         }
      }
      
      public function onWeightLessHouseClickHandler() : void
      {
         SocketConnection.addCmdListener(CommandID.NO_GRAVITY_SHIP,this.onSocketSuccessHandler);
         SocketConnection.send(CommandID.NO_GRAVITY_SHIP);
      }
      
      private function onWalk(event:RobotEvent) : void
      {
         this.sinNum += 0.1;
         MainManager.actorModel.y += Math.sin(this.sinNum) * 20;
         MainManager.actorModel.x += Math.sin(this.sinNum) * 20;
      }
      
      private function onWalkEnd(e:RobotEvent) : void
      {
         this.sinNum = 0;
      }
      
      private function onSocketSuccessHandler(e:SocketEvent) : void
      {
         MainManager.actorModel.hideNono();
         LevelManager.closeMouseEvent();
         if(MainManager.actorInfo.superNono)
         {
            this.weightLessHouse.gotoAndPlay(3);
            this.weightLessHouse.addEventListener(Event.ENTER_FRAME,this.onFrameHandler("superNono"));
         }
         else
         {
            this.weightLessHouse.gotoAndPlay(2);
            this.weightLessHouse.addEventListener(Event.ENTER_FRAME,this.onFrameHandler("normalNono"));
         }
         var by:ByteArray = e.data as ByteArray;
         var power:uint = by.readUnsignedInt();
         var closeness:uint = by.readUnsignedInt();
         NonoManager.info.power = power / 1000;
         NonoManager.info.mate = closeness / 1000;
      }
      
      private function onFrameHandler(mcName:String) : Function
      {
         var func:Function = function(e:Event):void
         {
            var colorTrans:ColorTransform = null;
            if(Boolean(weightLessHouse.getChildByName(mcName)))
            {
               nonoSuit = (weightLessHouse.getChildByName(mcName) as MovieClip).getChildByName("nonoSuit") as MovieClip;
               colorTrans = nonoSuit.transform.colorTransform;
               colorTrans.color = MainManager.actorInfo.nonoColor;
               nonoSuit.transform.colorTransform = colorTrans;
               nonoSuit.addEventListener(Event.ENTER_FRAME,onNonoSuitFrameHandler);
            }
         };
         return func;
      }
      
      private function onNonoSuitFrameHandler(event:Event) : void
      {
         if(this.nonoSuit.currentFrame == this.nonoSuit.totalFrames)
         {
            this.nonoSuit.removeEventListener(Event.ENTER_FRAME,this.onNonoSuitFrameHandler);
            this.weightLessHouse.gotoAndStop(1);
            this.weightLessHouse.removeEventListener(Event.ENTER_FRAME,this.onFrameHandler("*"));
            MainManager.actorModel.showNono(NonoManager.info,MainManager.actorInfo.actionType);
            if(this.nonoSuit.parent.name == "superNono")
            {
               NpcTipDialog.show("O(∩_∩)O  NoNo精神满满，主人，你也要加油哦！！！",null,NpcTipDialog.NONO);
            }
            else
            {
               NpcTipDialog.show("O(∩_∩)O  NoNo精神满满，主人，你也要加油哦！！！",null,NpcTipDialog.NONO_2);
            }
            LevelManager.openMouseEvent();
         }
      }
      
      public function getGaussian(mu:Number = 0, sigma:Number = 1) : Number
      {
         var r1:Number = Math.random();
         var r2:Number = Math.random();
         return Math.sqrt(-2 * Math.log(r1)) * Math.cos(2 * Math.PI * r2) * sigma + mu;
      }
   }
}

import com.robot.core.CommandID;
import com.robot.core.config.xml.ItemXMLInfo;
import com.robot.core.info.task.BossMonsterInfo;
import com.robot.core.manager.LevelManager;
import com.robot.core.manager.map.MapLibManager;
import com.robot.core.net.SocketConnection;
import com.robot.core.ui.alert.Alarm;
import com.robot.core.ui.alert.ItemInBagAlert;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;
import org.taomee.events.SocketEvent;
import org.taomee.utils.DisplayUtil;

class Stone extends Sprite
{
   public static const CLEAR:String = "clear";
   
   private var mc:MovieClip;
   
   private var isHited:Boolean = false;
   
   private var sub:MovieClip;
   
   public function Stone(i:uint)
   {
      super();
      this.mc = MapLibManager.getMovieClip("stone" + i);
      this.mc["mc"].gotoAndStop(1);
      this.mc.cacheAsBitmap = true;
      addChild(this.mc);
      this.mc["light"].gotoAndStop(1);
      this.sub = this.mc["mc"];
      this.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
      this.addEventListener(MouseEvent.ROLL_OUT,this.onOut);
   }
   
   public static function send(type:uint) : void
   {
      SocketConnection.addCmdListener(CommandID.HIT_STONE,function(e:SocketEvent):void
      {
         var i:Object = null;
         var itemCnt:uint = 0;
         var itemID:uint = 0;
         var name:String = null;
         var str:String = null;
         SocketConnection.removeCmdListener(CommandID.HIT_STONE,arguments.callee);
         var info:BossMonsterInfo = e.data as BossMonsterInfo;
         for each(i in info.monBallList)
         {
            itemCnt = uint(i["itemCnt"]);
            itemID = uint(i["itemID"]);
            name = ItemXMLInfo.getName(itemID);
            if(itemID < 10)
            {
               str = "恭喜你得到了" + itemCnt + "个<font color=\'#FF0000\'>" + name + "</font>";
               LevelManager.tipLevel.addChild(Alarm.show(str));
            }
            else
            {
               str = itemCnt + "个<font color=\'#FF0000\'>" + name + "</font>已经放入了你的储存箱！";
               LevelManager.tipLevel.addChild(ItemInBagAlert.show(itemID,str));
            }
         }
      });
      SocketConnection.send(CommandID.HIT_STONE,type);
   }
   
   private function onOver(event:MouseEvent) : void
   {
      this.mc["light"].gotoAndPlay(2);
   }
   
   private function onOut(event:MouseEvent) : void
   {
      this.mc["light"].gotoAndStop(1);
   }
   
   public function play() : void
   {
      if(!this.isHited)
      {
         this.isHited = true;
         this.sub.gotoAndPlay(2);
         this.mc["light"].visible = false;
         this.sub.addEventListener(Event.ENTER_FRAME,this.onEnter);
      }
   }
   
   private function onEnter(event:Event) : void
   {
      if(this.sub.currentFrame == this.sub.totalFrames)
      {
         this.sub.removeEventListener(Event.ENTER_FRAME,this.onEnter);
         DisplayUtil.removeForParent(this);
         dispatchEvent(new Event(CLEAR));
         send(0);
      }
   }
}
