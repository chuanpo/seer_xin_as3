package com.robot.app.mapProcess
{
   import com.robot.core.CommandID;
   import com.robot.core.aimat.AimatController;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.event.MapEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.info.fbGame.FBGameOverInfo;
   import com.robot.core.info.fbGame.GameOverUserInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.ActorModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.utils.Timer;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_502 extends BaseMapProcess
   {
      private var _film:MovieClip;
      
      private var mode:ActorModel;
      
      private var isReady:Boolean = false;
      
      private var bossOutMC:MovieClip;
      
      private var bossMC:MovieClip;
      
      private var aimatTimer:Timer;
      
      private var startTime:Number;
      
      private var endTime:Number;
      
      private var aimatCount:uint = 0;
      
      private var rightStage:String;
      
      public function MapProcess_502()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.bossOutMC = conLevel["effectAndBoss"];
         this.mode = MainManager.actorModel;
         this.mode.addEventListener(RobotEvent.WALK_START,this.onWalkStart);
         AimatController.addEventListener(AimatEvent.PLAY_END,this.onAimat);
         SocketConnection.addCmdListener(CommandID.FB_GAME_OVER,this.onGameOverHandler);
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,this.onMapSwitchHandler);
      }
      
      private function onMapSwitchHandler(e:MapEvent) : void
      {
         if(this.isReady)
         {
            SocketConnection.addCmdListener(CommandID.LEAVE_GAME,this.onLeaveGameHandler);
            SocketConnection.send(CommandID.LEAVE_GAME,[1]);
            Alarm.show("你已经离开了游戏位置");
         }
      }
      
      private function onGameOverHandler(e:SocketEvent) : void
      {
         var userinfo:GameOverUserInfo = null;
         this.isReady = false;
         this.mode.removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
         SocketConnection.removeCmdListener(CommandID.FB_GAME_OVER,this.onGameOverHandler);
         this.conLevel[this.rightStage].filters = null;
         if(this.bossOutMC.currentFrame >= 2)
         {
            this.bossOutMC.gotoAndPlay(1);
         }
         this.bossOutMC.gotoAndPlay(2);
         this.bossOutMC.addEventListener(Event.ENTER_FRAME,this.onBossOutMCFrameHandler);
         var data:FBGameOverInfo = e.data as FBGameOverInfo;
         var arr:Array = data.userList as Array;
         var userID:uint = uint(MainManager.actorModel.info.userID);
         for(var i:uint = 0; i < arr.length; i++)
         {
            userinfo = arr[i] as GameOverUserInfo;
            if(userID == userinfo.id)
            {
               MainManager.actorModel.walkAction(userinfo.pos);
            }
         }
      }
      
      private function onBossOutMCFrameHandler(e:Event) : void
      {
         if(this.bossOutMC.currentFrame == this.bossOutMC.totalFrames)
         {
            this.bossOutMC.removeEventListener(Event.ENTER_FRAME,this.onBossOutMCFrameHandler);
            this.bossMC = this.bossOutMC["bossMC"];
            this.bossMC.buttonMode = true;
            ResourceManager.getResource(ClientConfig.getResPath("eff/film.swf"),this.onLoad);
            this.aimatTimer = new Timer(1000);
            this.aimatTimer.addEventListener(TimerEvent.TIMER,this.onAimatTimerHandler);
            this.aimatTimer.start();
            this.startTime = new Date().getTime();
         }
      }
      
      private function onAimatTimerHandler(e:TimerEvent) : void
      {
         this.endTime = new Date().getTime();
         if(this.aimatCount >= 5)
         {
            if(Boolean(this._film))
            {
               AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
               this._film.addFrameScript(this._film.totalFrames - 1,this.onEnter);
               this._film.gotoAndPlay("s_3");
               this.bossMC.addEventListener(MouseEvent.CLICK,this.onBossClickHandler);
               this.aimatTimer.stop();
               this.aimatTimer.removeEventListener(TimerEvent.TIMER,this.onAimatTimerHandler);
               this.aimatTimer = null;
            }
         }
         if((this.endTime - this.startTime) / 1000 / 60 >= 1)
         {
            this.startTime = new Date().getTime();
            this.aimatCount = 0;
         }
      }
      
      private function onBossClickHandler(e:MouseEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.CHALLENGE_BOSS,this.onChallengeBOSSHandler);
         SocketConnection.send(CommandID.CHALLENGE_BOSS,0);
      }
      
      private function onEnter() : void
      {
         if(Boolean(this._film))
         {
            this._film.addFrameScript(this._film.totalFrames - 1,null);
         }
         DisplayUtil.removeForParent(this._film);
         this._film = null;
      }
      
      private function onLoad(o:DisplayObject) : void
      {
         this._film = o as MovieClip;
         this._film.scaleY = 1.5;
         this._film.scaleX = 1.5;
         this._film.y = -10;
         this._film.gotoAndStop("s_1");
         this.bossMC.addChild(this._film);
      }
      
      private function onAimat(e:AimatEvent) : void
      {
         var info:AimatInfo = e.info;
         if(info.id == 10001)
         {
            if(Boolean(this._film))
            {
               if(this._film.hitTestPoint(info.endPos.x,info.endPos.y))
               {
                  ++this.aimatCount;
                  if(this._film.currentLabel != "s_2")
                  {
                     this._film.gotoAndPlay("s_2");
                  }
                  SocketConnection.send(CommandID.ATTACK_BOSS,0);
               }
            }
         }
      }
      
      private function onWalkStart(e:RobotEvent) : void
      {
         if(this.isReady)
         {
            SocketConnection.addCmdListener(CommandID.LEAVE_GAME,this.onLeaveGameHandler);
            SocketConnection.send(CommandID.LEAVE_GAME,[1]);
         }
      }
      
      private function onChallengeBOSSHandler(e:SocketEvent) : void
      {
      }
      
      override public function destroy() : void
      {
         this.isReady = false;
         this.aimatCount = 0;
         if(Boolean(this.aimatTimer))
         {
            this.aimatTimer.stop();
            this.aimatTimer.removeEventListener(TimerEvent.TIMER,this.onAimatTimerHandler);
            this.aimatTimer = null;
         }
         if(Boolean(this.mode))
         {
            this.mode.removeEventListener(RobotEvent.WALK_START,this.onWalkStart);
            this.mode = null;
         }
         if(this.bossOutMC.hasEventListener(Event.ENTER_FRAME))
         {
            this.bossOutMC.removeEventListener(Event.ENTER_FRAME,this.onBossOutMCFrameHandler);
         }
         this.onEnter();
         SocketConnection.removeCmdListener(CommandID.FB_GAME_OVER,this.onGameOverHandler);
         MapManager.removeEventListener(MapEvent.MAP_SWITCH_OPEN,this.onMapSwitchHandler);
         SocketConnection.removeCmdListener(CommandID.CHALLENGE_BOSS,this.onChallengeBOSSHandler);
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
         this.bossOutMC = null;
         this.bossMC = null;
      }
      
      public function onStand(mc:MovieClip) : void
      {
         this.rightStage = mc.name;
         var arr:Array = [];
         switch(mc.name)
         {
            case "standMC_0":
               arr.push(1);
               break;
            case "standMC_1":
               arr.push(2);
               break;
            case "standMC_2":
               arr.push(3);
         }
         SocketConnection.addCmdListener(CommandID.JOIN_GAME,this.onJoinGameHandler);
         SocketConnection.send(CommandID.JOIN_GAME,arr);
      }
      
      private function onJoinGameHandler(e:SocketEvent) : void
      {
         this.isReady = true;
         var glowFilter:GlowFilter = new GlowFilter();
         glowFilter.blurX = 50;
         glowFilter.blurY = 50;
         glowFilter.strength = 8;
         glowFilter.alpha = 1;
         glowFilter.color = 16777215;
         var arr:Array = new Array(glowFilter);
         this.conLevel[this.rightStage].filters = arr;
         this.conLevel["standMC_0"].mouseEnabled = false;
         this.conLevel["standMC_1"].mouseEnabled = false;
         this.conLevel["standMC_2"].mouseEnabled = false;
         SocketConnection.removeCmdListener(CommandID.JOIN_GAME,this.onJoinGameHandler);
      }
      
      private function onLeaveGameHandler(e:SocketEvent) : void
      {
         this.conLevel[this.rightStage].filters = null;
         this.isReady = false;
         SocketConnection.removeCmdListener(CommandID.LEAVE_GAME,this.onLeaveGameHandler);
         this.conLevel["standMC_0"].mouseEnabled = true;
         this.conLevel["standMC_1"].mouseEnabled = true;
         this.conLevel["standMC_2"].mouseEnabled = true;
      }
   }
}

