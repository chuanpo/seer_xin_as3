package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.task.machinewar.MissileFirePanel;
   import com.robot.app.temp.MachinePet;
   import com.robot.core.CommandID;
   import com.robot.core.aimat.AimatController;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.event.PetFightEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.fightInfo.attack.FightOverInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.map.MapLibManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.BasePeoleModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.newloader.MCLoader;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.filters.ColorMatrixFilter;
   import flash.geom.Point;
   import flash.media.Sound;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.utils.DisplayUtil;
   import com.robot.core.npc.NpcDialog;
   import com.robot.core.npc.NPC;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import org.taomee.manager.ToolTipManager;
   
   public class MapProcess_320 extends BaseMapProcess
   {
      public static var bossnum:uint = 0;
      
      public static var bossArr:Array = new Array();
      
      private var wrongHand:MovieClip;
      
      private var machineHand:MovieClip;
      
      private var machineHand1:MovieClip;
      
      private var machineHand2:MovieClip;
      
      private var handHitMC:MovieClip;
      
      private var bodyMC:MovieClip;
      
      private var body2:MovieClip;
      
      private var body3:MovieClip;
      
      private var eyeHitMC:MovieClip;
      
      private var missileMC:MovieClip;
      
      private var volumnMC:MovieClip;
      
      private var leiYiMC:MovieClip;
      
      private var baiLunMC:MovieClip;
      
      private var cangetPet:MachinePet;
      
      private var timer:Timer;
      
      private var randomTime:uint = 2000;
      
      private var electricHead:MovieClip;
      
      private var isLive:Boolean = false;
      
      private var state:String = "";
      
      private var aimatCount:uint = 0;
      
      private var fightData:FightOverInfo;
      
      private var oldSpeed:Number = 0;
      
      private var _panel:MissileFirePanel;
      
      public function MapProcess_320()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.setWarState();
         this.leiYiMC = conLevel["leiyi_mc"];
         this.leiYiMC.buttonMode = true;
         this.leiYiMC.addEventListener(MouseEvent.CLICK,this.onLeiYiClickHandler);
         AimatController.addEventListener(AimatEvent.PLAY_END,this.onAimat);
         this.animatorLevel.mouseChildren = true;
         this.animatorLevel.mouseEnabled = true;
         this.volumnMC = topLevel["volume_mc"];
         this.volumnMC.visible = false;
         this.bodyMC = animatorLevel["body_mc"];
         this.missileMC = animatorLevel["missile_mc"];
         this.missileMC.buttonMode = true;
         this.electricHead = topLevel["machine_head"];
         this.electricHead.addEventListener(Event.ENTER_FRAME,this.onFrameHandler1);
         this.electricHead.addEventListener(MouseEvent.CLICK,this.onHeadClickHandler);
         this.electricHead.buttonMode = true;
         ToolTipManager.add(this.electricHead,"赫尔卡巨人");
         this.machineHand = animatorLevel["hand_mc"];
         this.randomTime = 4000 * Math.random() + 1000;
         this.timer = new Timer(this.randomTime,1);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.start();
         this.depthLevel["war2"].visible = false;
         this.depthLevel["war3"].visible = false;
      }
      
      private function setWarState() : void
      {
      }
      
      private function onLeiYiClickHandler(e:MouseEvent) : void
      {
         this.leiYiMC.removeEventListener(MouseEvent.CLICK,this.onLeiYiClickHandler);
         this.leiYiMC.gotoAndStop(2);
         this.leiYiMC.mouseEnabled = false;
      }
      
      private function onHeadClickHandler(e:MouseEvent):void{
         NpcDialog.show(4714,["小家伙，你想挑战我吗?!"],["看我揍死你！","装傻"],[function():void{
            //NpcTipDialog.show("啊!!! 赛...赛尔，手...手下留情！别...别揍我T_T\n赫尔卡巨人目前还在检修中，请过一段时间再来挑战他吧！",null,NpcTipDialog.XITA)
            FightInviteManager.fightWithBoss("赫尔卡巨人",0);
         },null])
      }

      private function sceneState(state:String) : void
      {
         switch(state)
         {
            case "firststate":
               this.machineHand.gotoAndStop(1);
               this.machineHand1 = this.machineHand["machine_hand"];
               this.machineHand1.gotoAndStop(this.machineHand1.totalFrames);
               break;
            case "noSendMissile":
               this.bodyMC.gotoAndStop(1);
               this.machineHand.gotoAndStop(1);
               this.missileMC.addEventListener(MouseEvent.CLICK,this.onMissileMCClickHandler);
               break;
            case "noHitHand":
               this.bodyMC.gotoAndStop(1);
               this.machineHand.gotoAndStop(2);
               this.machineHand.addEventListener(Event.ENTER_FRAME,function():void
               {
                  machineHand2 = machineHand["hand2"];
                  if(Boolean(machineHand2))
                  {
                     machineHand.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                     machineHand2.addEventListener(Event.ENTER_FRAME,onFrameHandler);
                  }
               });
               this.volumnMC.visible = true;
               break;
            case "noHitHandPart":
               this.bodyMC.gotoAndStop(1);
               this.machineHand.gotoAndStop(3);
               this.machineHand.addEventListener(Event.ENTER_FRAME,function():void
               {
                  wrongHand = machineHand["wronghand_mc"];
                  if(Boolean(wrongHand))
                  {
                     machineHand.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                     wrongHand.addEventListener(Event.ENTER_FRAME,onFrameHandler);
                  }
               });
               break;
            case "noHitBoss":
               this.bodyMC.gotoAndStop(2);
               this.bodyMC.addEventListener(Event.ENTER_FRAME,function():void
               {
                  body2 = bodyMC["safemachine_mc"];
                  if(Boolean(body2))
                  {
                     bodyMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                     body2.addEventListener(Event.ENTER_FRAME,onFrameHandler);
                  }
               });
               this.machineHand.gotoAndStop(3);
               break;
            case "noHitHead":
               trace(this.bodyMC.currentFrame + "   ***");
               this.volumnMC.visible = true;
               this.bodyMC.gotoAndStop(3);
               this.bodyMC.addEventListener(Event.ENTER_FRAME,function():void
               {
                  eyeHitMC = bodyMC["eye_mc"];
                  if(Boolean(eyeHitMC))
                  {
                     bodyMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  }
               });
               this.machineHand.gotoAndStop(3);
               break;
            case "noFly":
               this.bodyMC.gotoAndStop(4);
               this.machineHand.gotoAndStop(3);
               this.baiLunMC = btnLevel["bailun_mc"];
               this.baiLunMC.buttonMode = true;
               this.baiLunMC.addEventListener(MouseEvent.CLICK,this.onBailunMCClickHandler);
               break;
            case "fly":
               this.bodyMC.gotoAndStop(4);
               this.machineHand.gotoAndStop(3);
         }
      }
      
      private function onBailunMCClickHandler(e:MouseEvent) : void
      {
      }
      
      private function onLoadMovie2(event:MCLoadEvent) : void
      {
      }
      
      private function onAimat(e:AimatEvent) : void
      {
      }
      
      private function onFrameHandler(e:Event) : void
      {
      }
      
      private function onFightMachineHandler(e:MouseEvent) : void
      {
         FightInviteManager.fightWithBoss("赫卡特",1);
         EventManager.addEventListener(PetFightEvent.FIGHT_RESULT,this.onCloseFight(e.currentTarget as MovieClip));
      }
      
      private function onCloseFight(mc:MovieClip) : Function
      {
         var func:Function = function(e:PetFightEvent):void
         {
         };
         return func;
      }
      
      private function onPartMCClickHandler(e:MouseEvent) : void
      {
         this.wrongHand["part_mc"].removeEventListener(MouseEvent.CLICK,this.onPartMCClickHandler);
         MainManager.actorModel.addEventListener(RobotEvent.WALK_END,this.onWalkEnd);
         MainManager.actorModel.walkAction(new Point(400,350));
      }
      
      private function onWalkEnd(e:RobotEvent) : void
      {
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_END,this.onWalkEnd);
         this.state = "noHitBoss";
         this.sceneState(this.state);
      }
      
      private function onMissileMCClickHandler(e:MouseEvent) : void
      {
         if(!this._panel)
         {
            this._panel = new MissileFirePanel();
         }
         this._panel.show();
         this._panel.addEventListener("canSend",this.onCanSendHandler);
      }
      
      private function onCanSendHandler(e:Event) : void
      {
         this.missileMC.gotoAndStop(2);
         this.machineHand.gotoAndStop(2);
         this.missileMC.mouseEnabled = false;
         setTimeout(this.showDialog,300);
      }
      
      private function showDialog() : void
      {
      }
      
      private function electriced(obj:Sprite) : void
      {
         var timer1:Timer = null;
         var objmc:MovieClip = null;
         var matrix:Array = [0.6,1.2,0.1,0,-263,0.6,1.2,0.16,0,-263,0.6,1.2,0.16,0,-263,0,0,0,1,0];
         if(obj is BasePeoleModel)
         {
            objmc = BasePeoleModel(obj).skeleton.getSkeletonMC();
            objmc.filters = [new ColorMatrixFilter(matrix)];
         }
         else
         {
            obj.filters = [new ColorMatrixFilter(matrix)];
         }
         timer1 = new Timer(2000,1);
         timer1.addEventListener(TimerEvent.TIMER_COMPLETE,function(e:TimerEvent):void
         {
            var objmc:MovieClip = null;
            timer1.removeEventListener(TimerEvent.TIMER_COMPLETE,arguments.callee);
            if(obj is BasePeoleModel)
            {
               objmc = BasePeoleModel(obj).skeleton.getSkeletonMC();
               objmc.filters = null;
            }
            else
            {
               obj.filters = null;
            }
         });
         timer1.start();
      }
      
      private function onFrameHandler1(e:Event) : void
      {
         var sound:Sound = null;
         if(Boolean(this.electricHead.getChildByName("electric_mc") as MovieClip))
         {
            if(Boolean((this.electricHead.getChildByName("electric_mc") as MovieClip).getChildByName("mc2")))
            {
               if((this.electricHead.getChildByName("electric_mc") as MovieClip).getChildByName("mc2").hitTestObject(MainManager.actorModel.sprite))
               {
                  this.electriced(MainManager.actorModel.sprite);
                  sound = MapLibManager.getSound("electricSound");
                  sound.play();
                  return;
               }
            }
         }
         if(Boolean(this.electricHead.getChildByName("electric_mc") as MovieClip))
         {
            if(Boolean((this.electricHead.getChildByName("electric_mc") as MovieClip).getChildByName("mc1")))
            {
               if((this.electricHead.getChildByName("electric_mc") as MovieClip).getChildByName("mc1").hitTestObject(MainManager.actorModel.sprite))
               {
                  this.electriced(MainManager.actorModel.sprite);
                  sound = MapLibManager.getSound("electricSound");
                  sound.play();
                  return;
               }
            }
         }
         try
         {
            sound.close();
            sound = null;
         }
         catch(e:Error)
         {
         }
      }
      
      private function onTimer(evt:TimerEvent) : void
      {
         this.randomTime = 5000 * Math.random() + 3000;
         this.timer.stop();
         this.timer.reset();
         this.timer.start();
         if(Boolean(this.cangetPet))
         {
            this.cangetPet.removeEventListener(MouseEvent.CLICK,this.onClickSprite);
            MapManager.currentMap.depthLevel.removeChild(this.cangetPet);
            this.cangetPet.destroy();
            this.cangetPet = null;
         }
         this.addCanGetPet();
      }
      
      private function addCanGetPet() : void
      {
      }
      
      private function onClickSprite(evt:MouseEvent) : void
      {
         FightInviteManager.fightWithBoss("卡塔");
         SocketConnection.addCmdListener(CommandID.CATCH_MONSTER,this.onCatchMonster);
      }
      
      private function onCatchMonster(event:SocketEvent) : void
      {
      }
      
      override public function destroy() : void
      {
         this.animatorLevel.mouseChildren = false;
         this.animatorLevel.mouseEnabled = false;
         MainManager.actorModel.removeEventListener(RobotEvent.WALK_END,this.onWalkEnd);
         if(this.machineHand.hasEventListener(Event.ENTER_FRAME))
         {
            this.machineHand.removeEventListener(Event.ENTER_FRAME,this.onMachineHandFrame);
         }
         if(Boolean(this.cangetPet))
         {
            this.cangetPet.removeEventListener(MouseEvent.CLICK,this.onClickSprite);
            MapManager.currentMap.depthLevel.removeChild(this.cangetPet);
            this.cangetPet.destroy();
            this.cangetPet = null;
         }
         if(Boolean(this.timer))
         {
            this.timer.stop();
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer = null;
         }
         if(Boolean(this._panel))
         {
            this._panel.removeEventListener("canSend",this.onCanSendHandler);
            this._panel = null;
         }
         if(Boolean(this.wrongHand))
         {
            this.wrongHand.removeEventListener(Event.ENTER_FRAME,this.onFrameHandler);
            if(Boolean(this.wrongHand["part_mc"]))
            {
               this.wrongHand["part_mc"].removeEventListener(MouseEvent.CLICK,this.onPartMCClickHandler);
            }
         }
         if(Boolean(this.machineHand2))
         {
            this.machineHand2.removeEventListener(Event.ENTER_FRAME,this.onFrameHandler);
         }
         if(Boolean(this.body2))
         {
            this.body2.removeEventListener(Event.ENTER_FRAME,this.onFrameHandler);
         }
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
         if(Boolean(this.electricHead))
         {
            this.electricHead.removeEventListener(Event.ENTER_FRAME,this.onFrameHandler1);
            this.electricHead.removeEventListener(MouseEvent.CLICK,this.onHeadClickHandler);
            ToolTipManager.remove(this.electricHead);
         }
      }
      
      public function changMap() : void
      {
         if(this.state == "firststate")
         {
            if(this.machineHand1.currentFrame == this.machineHand1.totalFrames)
            {
               MapManager.changeMap(35);
               return;
            }
            this.machineHand1.gotoAndPlay(2);
            this.machineHand1.addEventListener(Event.ENTER_FRAME,this.onMachineHandFrame);
         }
         else
         {
            MapManager.changeMap(35);
         }
      }
      
      private function onMachineHandFrame(e:Event) : void
      {
         if(this.machineHand1.currentFrame == this.machineHand1.totalFrames)
         {
            this.machineHand1.removeEventListener(Event.ENTER_FRAME,this.onMachineHandFrame);
            this.playMovie();
         }
      }
      
      private function playMovie() : void
      {
         var mclloader:MCLoader = new MCLoader("resource/bounsMovie/down.swf",LevelManager.appLevel,1,"哇！不好！掉入？？？");
         mclloader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadMovie);
         mclloader.doLoad();
      }
      
      private function onLoadMovie(event:MCLoadEvent) : void
      {
         var content:MovieClip = null;
         content = event.getContent() as MovieClip;
         MainManager.getStage().addChild(content);
         MapManager.changeMap(35);
         content.addEventListener("EFFECT_END",function(event:Event):void
         {
            DisplayUtil.removeForParent(content);
         });
      }
   }
}

