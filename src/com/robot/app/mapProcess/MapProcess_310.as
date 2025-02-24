package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.sceneInteraction.MazeController;
   import com.robot.core.aimat.AimatController;
   import com.robot.core.event.AimatEvent;
   import com.robot.core.info.AimatInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class MapProcess_310 extends BaseMapProcess
   {
      private var lili:MovieClip;
      
      private var miaozhunMC:MovieClip;
      
      private var oilcanArr:Array = [];
      
      private var count:uint = 0;
      
      private var hitArr:Array = [];
      
      public function MapProcess_310()
      {
         super();
      }
      
      override protected function init() : void
      {
         var name:String = null;
         var mc:MovieClip = null;
         var hitName:String = null;
         var hitMC:MovieClip = null;
         MazeController.setup();
         for(var i:uint = 0; i < 8; i++)
         {
            name = "oilcan_" + i;
            mc = conLevel[name] as MovieClip;
            mc.gotoAndStop(1);
            this.oilcanArr.push(mc);
            hitName = "hitMC_" + i;
            hitMC = conLevel[hitName] as MovieClip;
            hitMC.addEventListener(MouseEvent.MOUSE_OVER,this.onHitMcOver);
            hitMC.addEventListener(MouseEvent.MOUSE_OUT,this.onHitMcOut);
            this.hitArr.push(hitMC);
         }
         this.lili = conLevel["lili"];
         this.lili.visible = false;
         this.miaozhunMC = conLevel["miaozhunMC"];
         this.miaozhunMC.visible = false;
         AimatController.addEventListener(AimatEvent.PLAY_END,this.onAimat);
      }
      
      override public function destroy() : void
      {
         MazeController.destroy();
         AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
      }
      
      private function onAimat(e:AimatEvent) : void
      {
         var ran:Number = NaN;
         var info:AimatInfo = e.info;
         if(info.userID != MainManager.actorID)
         {
            return;
         }
         var point:Point = info.endPos;
         for(var i:uint = 0; i < this.hitArr.length; i++)
         {
            if(Boolean(this.hitArr[i].hitTestPoint(point.x,point.y)))
            {
               if(this.oilcanArr[i].currentFrame != 2)
               {
                  this.oilcanArr[i].gotoAndStop(2);
                  this.hitArr[i].removeEventListener(MouseEvent.MOUSE_OVER,this.onHitMcOver);
                  this.hitArr[i].removeEventListener(MouseEvent.MOUSE_OUT,this.onHitMcOut);
                  ++this.count;
               }
            }
         }
         if(this.count == 8)
         {
            AimatController.removeEventListener(AimatEvent.PLAY_END,this.onAimat);
            ran = Math.random();
            if(ran <= 0.1)
            {
               this.lili.visible = true;
               this.lili.buttonMode = true;
               this.lili.addEventListener(MouseEvent.CLICK,this.onFightLili);
            }
            if(ran >= 0.9)
            {
               MapManager.changeMap(314);
            }
         }
      }
      
      private function onFightLili(evt:MouseEvent) : void
      {
         FightInviteManager.fightWithBoss("果冻鸭");
      }
      
      private function onHitMcOver(evt:MouseEvent) : void
      {
         this.miaozhunMC.visible = true;
         this.miaozhunMC.x = MainManager.getStage().mouseX;
         this.miaozhunMC.y = MainManager.getStage().mouseY;
      }
      
      private function onHitMcOut(evt:MouseEvent) : void
      {
         this.miaozhunMC.visible = false;
      }
   }
}

