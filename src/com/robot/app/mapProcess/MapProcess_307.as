package com.robot.app.mapProcess
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.sceneInteraction.MazeController;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.ui.Mouse;
   import flash.utils.Timer;
   
   public class MapProcess_307 extends BaseMapProcess
   {
      private var line_0:MovieClip;
      
      private var line_1:MovieClip;
      
      private var line_2:MovieClip;
      
      private var plug_0:MovieClip;
      
      private var plug_1:MovieClip;
      
      private var plug_2:MovieClip;
      
      private var xiantou:MovieClip;
      
      private var clickLine:MovieClip;
      
      private var canConnected:Boolean = false;
      
      private var isClick:Boolean = false;
      
      private var checkArr:Array = [];
      
      private var rightArr:Array = [];
      
      private var count:uint = 0;
      
      private var plugArr:Array = [];
      
      private var dianliu:MovieClip;
      
      private var xita:MovieClip;
      
      public function MapProcess_307()
      {
         super();
      }
      
      override protected function init() : void
      {
         MazeController.setup();
         this.line_0 = conLevel["line_0"];
         this.line_1 = conLevel["line_1"];
         this.line_2 = conLevel["line_2"];
         this.line_0.buttonMode = true;
         this.line_1.buttonMode = true;
         this.line_2.buttonMode = true;
         this.line_0.mouseChildren = false;
         this.line_1.mouseChildren = false;
         this.line_2.mouseChildren = false;
         this.plug_0 = conLevel["plug_0"];
         this.plug_1 = conLevel["plug_1"];
         this.plug_2 = conLevel["plug_2"];
         this.plug_0.buttonMode = true;
         this.plug_1.buttonMode = true;
         this.plug_2.buttonMode = true;
         this.plug_0.mouseEnabled = false;
         this.plug_1.mouseEnabled = false;
         this.plug_2.mouseEnabled = false;
         this.plugArr = [this.plug_0,this.plug_1,this.plug_2];
         this.dianliu = conLevel["dianliu"];
         this.line_0.addEventListener(MouseEvent.CLICK,this.onClickLine);
         this.line_1.addEventListener(MouseEvent.CLICK,this.onClickLine);
         this.line_2.addEventListener(MouseEvent.CLICK,this.onClickLine);
         this.xiantou = conLevel["xiantou"];
         this.xiantou.visible = false;
         this.xiantou.mouseChildren = false;
         this.xiantou.addEventListener(Event.ENTER_FRAME,this.onXiantouEntFrame);
         this.xiantou.addEventListener(MouseEvent.CLICK,this.onXiantouClick);
         this.xita = conLevel["xita"];
         this.xita.visible = false;
      }
      
      override public function destroy() : void
      {
         MazeController.destroy();
         this.xiantou.removeEventListener(Event.ENTER_FRAME,this.onXiantouEntFrame);
         this.xiantou = null;
         Mouse.show();
         this.xita.removeEventListener(MouseEvent.CLICK,this.onFightXita);
      }
      
      private function onClickLine(evt:MouseEvent) : void
      {
         this.canConnected = true;
         this.clickLine = evt.currentTarget as MovieClip;
         this.xiantou.visible = true;
         Mouse.hide();
      }
      
      private function onXiantouClick(evt:MouseEvent) : void
      {
         var plugMC:MovieClip = null;
         var m:MovieClip = null;
         var mc:MovieClip = evt.currentTarget as MovieClip;
         var num:uint = 0;
         if(mc != null)
         {
            for each(m in this.plugArr)
            {
               if(m != null)
               {
                  if(mc.hitTestObject(m))
                  {
                     num = uint(m.name.split("_")[1]);
                     plugMC = m;
                     this.isClick = true;
                  }
               }
            }
         }
         if(!this.isClick)
         {
            Mouse.show();
            this.xiantou.visible = false;
            return;
         }
         if(this.canConnected)
         {
            this.clickLine.gotoAndStop(num + 2);
            this.checkArr[num] = true;
            this.canConnected = false;
            ++this.count;
            this.clickLine.removeEventListener(MouseEvent.CLICK,this.onClickLine);
            this.clickLine.buttonMode = false;
            plugMC.buttonMode = false;
            Mouse.show();
            this.xiantou.visible = false;
            this.isClick = false;
            if(this.clickLine.name.split("_")[1] == plugMC.name.split("_")[1])
            {
               this.rightArr[num] = true;
            }
            else
            {
               this.rightArr[num] = false;
            }
         }
         if(this.count == 3)
         {
            this.check();
         }
      }
      
      private function check() : void
      {
         var i:Boolean = false;
         var timer:Timer = null;
         for each(i in this.checkArr)
         {
            if(i == false)
            {
               return;
            }
         }
         if(this.rightArr[0] == true && this.rightArr[1] == true && this.rightArr[2] == true)
         {
            timer = new Timer(1000,1);
            timer.start();
            timer.addEventListener(TimerEvent.TIMER,function(evt:TimerEvent):void
            {
               timer.removeEventListener(TimerEvent.TIMER,arguments.callee);
               timer.stop();
               timer = null;
            });
         }
         else
         {
            this.xiantou.removeEventListener(Event.ENTER_FRAME,this.onXiantouEntFrame);
            this.xita.buttonMode = true;
            this.xita.visible = true;
            this.xita.addEventListener(MouseEvent.CLICK,this.onFightXita);
         }
         this.dianliu.visible = false;
      }
      
      private function onXiantouEntFrame(evt:Event) : void
      {
         this.xiantou.x = MainManager.getStage().mouseX - 10;
         this.xiantou.y = MainManager.getStage().mouseY - 10;
      }
      
      private function onFightXita(evt:MouseEvent) : void
      {
         FightInviteManager.fightWithBoss("西塔");
      }
   }
}

