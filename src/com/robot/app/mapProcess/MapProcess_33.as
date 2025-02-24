package com.robot.app.mapProcess
{
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.ui.DialogBox;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   
   public class MapProcess_33 extends BaseMapProcess
   {
      private var isShow:Boolean;
      
      private var powerMc:MovieClip;
      
      private var point:Point;
      
      public function MapProcess_33()
      {
         super();
      }
      
      override protected function init() : void
      {
         if(TasksManager.getTaskStatus(10) == TasksManager.COMPLETE)
         {
            this.isShow = false;
            conLevel["lightMc"].gotoAndStop(2);
            conLevel["maskMc"].gotoAndPlay(2);
            conLevel["iconMc"].gotoAndStop(5);
            this.configKey();
            return;
         }
         if(TasksManager.getTaskStatus(10) == TasksManager.UN_ACCEPT)
         {
            this.isShow = true;
            this.configLock();
            conLevel["iconMc"].gotoAndStop(1);
            TasksManager.accept(10);
            return;
         }
         if(TasksManager.getTaskStatus(10) == TasksManager.ALR_ACCEPT)
         {
            this.isShow = true;
            conLevel["maskMc"].gotoAndPlay(2);
            conLevel["iconMc"].gotoAndStop(1);
            this.configLock();
            this.configKey();
         }
      }
      
      private function onTimerHandler(e:TimerEvent) : void
      {
         var box:DialogBox = new DialogBox();
         box.show("墙上的奇怪图案是一位赫星长老的留言。",0,-80,depthLevel["aliceMc"]);
      }
      
      override public function destroy() : void
      {
         var i1:int = 0;
         if(this.isShow)
         {
            for(i1 = 0; i1 < 9; i1++)
            {
               conLevel["lockMc"]["mc" + i1].removeEventListener(MouseEvent.CLICK,this.onClickHandler);
            }
         }
      }
      
      private function configLock() : void
      {
         var frame:uint = 0;
         for(var i1:int = 0; i1 < 9; i1++)
         {
            frame = uint(uint(Math.random() * 4) + 1);
            conLevel["lockMc"]["mc" + i1].buttonMode = true;
            conLevel["lockMc"]["mc" + i1].gotoAndStop(frame);
            conLevel["lockMc"]["mc" + i1].addEventListener(MouseEvent.CLICK,this.onClickHandler);
         }
      }
      
      private function onClickHandler(e:MouseEvent) : void
      {
         if(e.currentTarget.currentFrame == e.currentTarget.totalFrames)
         {
            e.currentTarget.gotoAndStop(1);
         }
         else
         {
            e.currentTarget.gotoAndStop(e.currentTarget.currentFrame + 1);
         }
         if(this.checkSuccess())
         {
            conLevel["iconMc"].gotoAndPlay(1);
            conLevel["maskMc"].gotoAndPlay(2);
            conLevel["lightMc"].gotoAndStop(2);
            conLevel["lockMc"].mouseChildren = false;
            this.configKey();
            TasksManager.complete(10,1);
         }
      }
      
      private function checkSuccess() : Boolean
      {
         for(var i1:int = 0; i1 < 9; i1++)
         {
            if(conLevel["lockMc"]["mc" + i1].currentFrame != 1)
            {
               return false;
            }
         }
         return true;
      }
      
      private function configKey() : void
      {
         for(var i1:int = 0; i1 < 8; i1++)
         {
            conLevel["key" + i1].buttonMode = true;
            conLevel["key" + i1].addEventListener(MouseEvent.MOUSE_DOWN,this.onKeyDownHandler);
         }
      }
      
      private function onKeyDownHandler(e:MouseEvent) : void
      {
         this.powerMc = e.currentTarget as MovieClip;
         this.point = new Point(this.powerMc.x,this.powerMc.y);
         if(conLevel.getChildIndex(conLevel["doorMc"]) > conLevel.getChildIndex(this.powerMc))
         {
            conLevel.swapChildren(conLevel["doorMc"],this.powerMc);
         }
         this.powerMc.startDrag();
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.onUpHandler);
      }
      
      private function onUpHandler(e:MouseEvent) : void
      {
         var i1:int = 0;
         this.powerMc.stopDrag();
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUpHandler);
         if(conLevel.getChildIndex(conLevel["doorMc"]) < conLevel.getChildIndex(this.powerMc))
         {
            conLevel.swapChildren(conLevel["doorMc"],this.powerMc);
         }
         if(this.powerMc.hitTestObject(conLevel["hitMc"]) && this.powerMc == conLevel["key0"])
         {
            for(i1 = 0; i1 < 8; i1++)
            {
               conLevel["key" + i1].buttonMode = false;
               conLevel["key" + i1].removeEventListener(MouseEvent.MOUSE_DOWN,this.onKeyDownHandler);
            }
            conLevel["doorMc"].addEventListener(Event.ENTER_FRAME,this.onEnterHandler);
            conLevel["doorMc"].gotoAndPlay(2);
            this.powerMc.visible = false;
         }
         else
         {
            this.powerMc.x = this.point.x;
            this.powerMc.y = this.point.y;
         }
      }
      
      private function onEnterHandler(e:Event) : void
      {
         if(conLevel["doorMc"].currentFrame == conLevel["doorMc"].totalFrames)
         {
            conLevel["doorMc"].removeEventListener(Event.ENTER_FRAME,this.onEnterHandler);
         }
      }
   }
}

