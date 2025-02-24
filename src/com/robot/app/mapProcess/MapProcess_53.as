package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.mapProcess.active.ActivePet;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class MapProcess_53 extends BaseMapProcess
   {
      private static var isFightPet:Boolean = false;
      
      private var activePet:ActivePet;
      
      private var stoneMC:MovieClip;
      
      private var oldP:Point;
      
      private var rung:MovieClip;
      
      private var boss:MovieClip;
      
      private var bossMC:MovieClip;
      
      private var rungClickedCnt:uint = 1;
      
      public function MapProcess_53()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(!isFightPet)
         {
            this.activePet = new ActivePet(178);
         }
         this.stoneMC = conLevel["stoneMC"];
         this.stoneMC.buttonMode = true;
         this.oldP = new Point(this.stoneMC.x,this.stoneMC.y);
         this.stoneMC.addEventListener(MouseEvent.CLICK,this.clickStone);
         this.initTask_58();
      }
      
      private function clickStone(event:MouseEvent) : void
      {
         event.stopPropagation();
         this.stoneMC.startDrag(true);
         this.stoneMC.mouseEnabled = false;
         MainManager.getStage().addEventListener(MouseEvent.CLICK,this.dropStone);
      }
      
      private function dropStone(event:MouseEvent) : void
      {
         var mc:MovieClip = null;
         var i:uint = 0;
         MainManager.getStage().removeEventListener(MouseEvent.CLICK,this.dropStone);
         this.stoneMC.stopDrag();
         var b:Boolean = false;
         for(i = 0; i < 2; i++)
         {
            mc = conLevel["stoneHit_" + i];
            if(mc.hitTestObject(this.stoneMC))
            {
               b = true;
               break;
            }
         }
         if(b)
         {
            if(i == 0)
            {
               if(Boolean(this.activePet))
               {
                  this.activePet.fillLeft();
               }
            }
            else if(Boolean(this.activePet))
            {
               this.activePet.fillRight();
            }
            this.stoneMC.rotation = 90;
            this.stoneMC.y = 0;
            this.stoneMC.x = 0;
            mc.addChild(this.stoneMC);
         }
         else
         {
            this.stoneMC.rotation = 0;
            this.stoneMC.x = this.oldP.x;
            this.stoneMC.y = this.oldP.y;
            this.stoneMC.mouseEnabled = true;
         }
      }
      
      override public function destroy() : void
      {
         this.activePet.destroy();
         this.activePet = null;
         this.rung = null;
         this.boss = null;
         this.bossMC = null;
      }
      
      private function initTask_58() : void
      {
         this.rung = conLevel["rung"];
         this.bossMC = conLevel["bossMC"];
         this.bossMC.gotoAndStop(1);
         this.bossMC.visible = false;
         this.boss = conLevel["boss"];
         this.bossMC.visible = true;
         this.rung.buttonMode = true;
         this.rung.addEventListener(MouseEvent.CLICK,this.onClickRung);
      }
      
      private function onClickRung(evt:MouseEvent) : void
      {
         ++this.rungClickedCnt;
         this.bossMC.gotoAndStop(this.rungClickedCnt);
         if(this.rungClickedCnt == 4)
         {
            this.boss.buttonMode = true;
            this.boss.addEventListener(MouseEvent.CLICK,this.onClickBoss);
         }
      }
      
      private function onClickBoss(evt:MouseEvent) : void
      {
         FightInviteManager.fightWithBoss("魔狮迪露",1);
      }
   }
}

