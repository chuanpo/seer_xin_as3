package com.robot.app.mapProcess
{
   import com.robot.app.fightLevel.FightLevelModel;
   import com.robot.app.fightLevel.FightMHTController;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.ui.DialogBox;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import org.taomee.manager.ToolTipManager;
   
   public class MapProcess_108 extends BaseMapProcess
   {
      private var timer:Timer;
      
      private var _townMc:MovieClip;
      
      public function MapProcess_108()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.dd();
         this.timer = new Timer(9000);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.start();
         var box:DialogBox = new DialogBox();
         box.show("勇者之塔更新了，赛尔勇士们前进吧！",0,-85,conLevel["npc"]);
         this.configTown();
      }
      
      private function configTown() : void
      {
         this._townMc = conLevel["townMc"];
         this._townMc["llmc"].visible = false;
         this._townMc.addEventListener(MouseEvent.MOUSE_OVER,this.onTownOverHandler);
         this._townMc.addEventListener(MouseEvent.MOUSE_OUT,this.onTownOutHandler);
         this._townMc["mc"]["mc"].gotoAndStop(1);
         conLevel["lightMc1"].buttonMode = true;
         conLevel["lightMc1"].addEventListener(MouseEvent.CLICK,this.onLightMc1Handler);
         conLevel["lightMc2"].buttonMode = true;
         conLevel["lightMc2"].addEventListener(MouseEvent.CLICK,this.onLightMc2Handler);
      }
      
      private function onTownOverHandler(e:MouseEvent) : void
      {
         this._townMc["llmc"].visible = true;
         this._townMc["llmc"].gotoAndPlay(2);
      }
      
      private function onTownOutHandler(e:MouseEvent) : void
      {
         this._townMc["llmc"].visible = false;
         this._townMc["llmc"].gotoAndStop(1);
      }
      
      private function onLightMc1Handler(e:MouseEvent) : void
      {
         conLevel["lightMc1"].gotoAndStop(2);
         if(conLevel["lightMc2"].currentFrame == 2)
         {
            this.openDoor();
         }
      }
      
      private function onLightMc2Handler(e:MouseEvent) : void
      {
         conLevel["lightMc2"].gotoAndStop(2);
         if(conLevel["lightMc1"].currentFrame == 2)
         {
            this.openDoor();
         }
      }
      
      private function openDoor() : void
      {
         ToolTipManager.remove(this._townMc);
         ToolTipManager.add(this._townMc,"勇者之塔神秘领域");
         this._townMc["mc"]["mc"].gotoAndPlay(1);
         this._townMc["mc"].gotoAndPlay(2);
         this._townMc.addEventListener(Event.ENTER_FRAME,this.onEnterHandler);
      }
      
      private function onEnterHandler(e:Event) : void
      {
         if(this._townMc["mc"].currentFrame == this._townMc["mc"].totalFrames)
         {
            this._townMc["mc"]["mc"].gotoAndStop(1);
         }
      }
      
      private function onTimer(event:TimerEvent) : void
      {
         var box:DialogBox = new DialogBox();
         box.show("要申请创建战队的赛尔们，请到我这里来!",0,-85,conLevel["npc"]);
      }
      
      override public function destroy() : void
      {
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer.stop();
         this.timer = null;
         this._townMc.removeEventListener(MouseEvent.MOUSE_OVER,this.onTownOverHandler);
         this._townMc.removeEventListener(MouseEvent.MOUSE_OUT,this.onTownOutHandler);
         this._townMc.removeEventListener(Event.ENTER_FRAME,this.onEnterHandler);
         conLevel["lightMc1"].removeEventListener(MouseEvent.CLICK,this.onLightMc1Handler);
         conLevel["lightMc2"].removeEventListener(MouseEvent.CLICK,this.onLightMc2Handler);
         ToolTipManager.remove(this._townMc);
         this._townMc = null;
      }
      
      public function fightTownHandler() : void
      {
         if(this._townMc["mc"].currentFrame != 1)
         {
            FightMHTController.check();
            return;
         }
         FightMHTController.checkIsFight(function(b1:Boolean):void
         {
            if(b1)
            {
               LevelManager.closeMouseEvent();
               FightLevelModel.setUp();
            }
            else
            {
               Alarm.show("    勇者之塔里的精灵非常强大，30级以上的精灵才能勉强过关，你可以先去教官办公室里的试炼之塔锻炼你的精灵哦。");
            }
         });
      }
      
      private function dd() : void
      {
         var i:Object = null;
         var a:Array = PetManager.getBagMap();
         for(i in a)
         {
            trace(i.toString());
         }
      }
   }
}

