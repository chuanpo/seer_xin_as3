package com.robot.app.mapProcess
{
   import com.robot.app.control.DivingGameController;
   import com.robot.app.games.FerruleGame.FerruleGamePanel;
   import com.robot.app.mapProcess.active.PetListController;
   import com.robot.app.spacesurvey.SpaceSurveyTool;
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.ModuleManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.ui.DialogBox;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import gs.TweenLite;
   import org.taomee.events.DynamicEvent;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ToolTipManager;
   
   public class MapProcess_51 extends BaseMapProcess
   {
      private static var panel:AppModel = null;
      
      private var npc:MovieClip;
      
      private var mushroom:MovieClip;
      
      private var box:DialogBox;
      
      private var timer:Timer;
      
      private var wordArr:Array = ["嗨，大个子！冰系精灵争霸赛已经闭幕咯！我很期待我们明年的比赛哟，有空常来哦！"];
      
      private var timerIndex:uint = 0;
      
      private var snow_mc:MovieClip;
      
      private var iceGameBtn:MovieClip;
      
      private var thimbleGameBtn:MovieClip;
      
      private var divingGameBtn:MovieClip;
      
      private var greenDoor:SimpleButton;
      
      private var listCon:PetListController;
      
      private var snowBallGameLevel:uint;
      
      private var snowBalldis:DisplayObject;
      
      private var inSnowGame:Boolean = false;
      
      private var gameSwitch:Boolean = false;
      
      private var icePanel:AppModel;
      
      public function MapProcess_51()
      {
         super();
      }
      
      override protected function init() : void
      {
         var i:uint;
         var n:MovieClip;
         var snowName:String = null;
         var mc:MovieClip = null;
         this.npc = this.depthLevel["npc"];
         this.timer = new Timer(7000);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimerHandler);
         this.timer.start();
         SpaceSurveyTool.getInstance().show("斯诺星");
         conLevel["door_1"].buttonMode = false;
         conLevel["door_1"].mouseEnabled = false;
         this.mushroom = conLevel["mushroomMC"];
         this.mushroom.gotoAndStop(1);
         this.mushroom.buttonMode = true;
         this.mushroom.addEventListener(MouseEvent.CLICK,this.onClickMushroom);
         for(i = 0; i < 6; i++)
         {
            snowName = "snow_" + i;
            mc = conLevel[snowName];
            mc.buttonMode = true;
            mc.gotoAndStop(1);
            mc.addEventListener(MouseEvent.CLICK,this.onClickSnow);
         }
         this.listCon = new PetListController(conLevel["manlist"],conLevel["monsterlist"]);
         conLevel["cici_btn"].addEventListener(MouseEvent.CLICK,function(e:MouseEvent):void
         {
            Alarm.show("每年的这几天是斯诺星最寒冷的时间，入口已经被冰雪堵住了！");
         });
         this.snow_mc = conLevel["snow_mc"];
         this.snow_mc.buttonMode = true;
         this.snow_mc.addEventListener(MouseEvent.CLICK,this.clickSnowMcHandler);
         ToolTipManager.add(this.snow_mc,"米鲁雪地疾走");
         this.iceGameBtn = conLevel["iceGameBtn"];
         this.iceGameBtn.buttonMode = true;
         this.iceGameBtn.addEventListener(MouseEvent.CLICK,this.startIceGame);
         this.thimbleGameBtn = conLevel["thimbleGameBtn"];
         this.thimbleGameBtn.buttonMode = true;
         this.thimbleGameBtn.addEventListener(MouseEvent.CLICK,this.startThimbleGame);
         this.divingGameBtn = conLevel["divingGameBtn"];
         this.divingGameBtn.buttonMode = true;
         this.divingGameBtn.addEventListener(MouseEvent.CLICK,this.startDivingGame);
         ToolTipManager.add(this.iceGameBtn,"智勇闯冰关");
         ToolTipManager.add(this.thimbleGameBtn,"赛尔套圈大赛");
         ToolTipManager.add(this.divingGameBtn,"大脚过木桩");
         this.greenDoor = conLevel["greendoor"];
         this.greenDoor.addEventListener(MouseEvent.CLICK,this.onGreenDoorClickHandler);
         ToolTipManager.add(this.greenDoor,"兑换米鲁套装");
         n = depthLevel["npc"];
      }
      
      private function onGreenDoorClickHandler(e:MouseEvent) : void
      {
         if(panel == null)
         {
            panel = new AppModel(ClientConfig.getAppModule("MiluClothPanel"),"正在套装兑换面板");
            panel.setup();
            panel.show();
         }
         else
         {
            panel.show();
         }
      }
      
      private function clickSnowMcHandler(e:MouseEvent) : void
      {
         this.starGame();
      }
      
      public function starGame() : void
      {
         if(this.gameSwitch)
         {
            return;
         }
         this.gameSwitch = true;
         this.resetGameSwicth();
         SocketConnection.addCmdListener(CommandID.JOIN_GAME,this.onJoin);
         SocketConnection.send(CommandID.JOIN_GAME,3);
      }
      
      private function onJoin(event:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.JOIN_GAME,this.onJoin);
         var mcloader:MCLoader = new MCLoader("resource/Games/SnowBallGame.swf",LevelManager.appLevel,1,"正在加载游戏");
         mcloader.addEventListener(MCLoadEvent.SUCCESS,this.onSuccess);
         mcloader.doLoad();
      }
      
      private function onSuccess(event:MCLoadEvent) : void
      {
         this.inSnowGame = true;
         MapManager.destroy();
         this.snowBalldis = event.getContent();
         LevelManager.gameLevel.addChild(this.snowBalldis);
         this.snowBalldis.addEventListener("outgamenow",this.outSnowBallGame);
      }
      
      private function outSnowBallGame(e:Event) : void
      {
         if(!this.inSnowGame)
         {
            return;
         }
         this.inSnowGame = false;
         var sp:* = e.target as Sprite;
         var obj:Object = sp.scoreObj;
         var sl:uint = uint(obj.level) * 10 + 10;
         MapManager.refMap();
         var coins:uint = 0;
         if(sl > 30 && sl < 60)
         {
            coins = 100;
         }
         else if(sl >= 60 && sl <= 80)
         {
            coins = 200;
         }
         else if(sl > 80)
         {
            coins = 300;
         }
         SocketConnection.send(CommandID.GAME_OVER,sl,sl);
      }
      
      private function onTimerHandler(e:TimerEvent) : void
      {
         if(this.timerIndex == this.wordArr.length)
         {
            this.timerIndex = 0;
         }
         var box:DialogBox = new DialogBox();
         box.show(this.wordArr[this.timerIndex],10,-45,this.npc["mc"]);
         ++this.timerIndex;
      }
      
      private function onClickSnow(evt:MouseEvent) : void
      {
         var mc:MovieClip = null;
         mc = evt.currentTarget as MovieClip;
         mc.buttonMode = false;
         mc.mouseEnabled = false;
         mc.gotoAndStop(2);
         setTimeout(function():void
         {
            TweenLite.to(mc,2,{"alpha":0});
         },1500);
         setTimeout(this.snowBackStatus,3500,mc);
      }
      
      private function snowBackStatus(mc:MovieClip) : void
      {
         mc.gotoAndStop(1);
         TweenLite.to(mc,2,{"alpha":1});
         setTimeout(function():void
         {
            mc.buttonMode = true;
            mc.mouseEnabled = true;
         },3500,mc);
      }
      
      private function onClickMushroom(evt:MouseEvent = null) : void
      {
         this.mushroom.buttonMode = false;
         this.mushroom.removeEventListener(MouseEvent.CLICK,this.onClickMushroom);
         this.mushroom.gotoAndStop(2);
         setTimeout(function():void
         {
            conLevel["door_1"].buttonMode = true;
            conLevel["door_1"].mouseEnabled = true;
         },2500);
      }
      
      override public function destroy() : void
      {
         this.listCon.destroy();
         this.listCon = null;
         if(Boolean(this.timer))
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimerHandler);
            this.timer = null;
         }
         if(Boolean(this.box))
         {
            this.box.destroy();
            this.box = null;
         }
         SpaceSurveyTool.getInstance().hide();
         DivingGameController.destroy();
      }
      
      private function startIceGame(evt:MouseEvent) : void
      {
         if(this.gameSwitch)
         {
            return;
         }
         this.gameSwitch = true;
         this.resetGameSwicth();
         SocketConnection.addCmdListener(CommandID.JOIN_GAME,function(evt:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.JOIN_GAME,arguments.callee);
            if(!icePanel)
            {
               icePanel = ModuleManager.getModule(ClientConfig.getGameModule("PetSkateGame"),"正在加载游戏");
               icePanel.setup();
            }
            icePanel.show();
         });
         SocketConnection.send(CommandID.JOIN_GAME,2);
      }
      
      private function startThimbleGame(evt:MouseEvent) : void
      {
         if(this.gameSwitch)
         {
            return;
         }
         this.gameSwitch = true;
         this.resetGameSwicth();
         SocketConnection.addCmdListener(CommandID.JOIN_GAME,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.JOIN_GAME,arguments.callee);
            FerruleGamePanel.getInstance().loadGame();
         });
         SocketConnection.send(CommandID.JOIN_GAME,4);
      }
      
      private function startDivingGame(evt:MouseEvent) : void
      {
         if(this.gameSwitch)
         {
            return;
         }
         this.gameSwitch = true;
         this.resetGameSwicth();
         SocketConnection.addCmdListener(CommandID.JOIN_GAME,function(evt:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.JOIN_GAME,arguments.callee);
            DivingGameController.showGame();
            EventManager.addEventListener("DivingGame_Pass",passDivingGame);
            EventManager.addEventListener("DivingGame_Over",loseDivingGame);
         });
         SocketConnection.send(CommandID.JOIN_GAME,1);
      }
      
      private function passDivingGame(evt:DynamicEvent) : void
      {
         SocketConnection.send(CommandID.GAME_OVER,100,100);
      }
      
      private function loseDivingGame(evt:DynamicEvent) : void
      {
         var precent:uint = 0;
         var cnt:uint = evt.paramObject as uint;
         if(cnt < 4)
         {
            precent = 0;
         }
         if(cnt >= 4 && cnt < 7)
         {
            precent = 40;
         }
         if(cnt >= 7 && cnt < 10)
         {
            precent = 80;
         }
         SocketConnection.send(CommandID.GAME_OVER,precent,precent);
      }
      
      private function resetGameSwicth() : void
      {
         setTimeout(function():void
         {
            gameSwitch = false;
         },1000);
      }
   }
}

