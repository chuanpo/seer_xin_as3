package com.robot.core.utils
{
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.system.System;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.utils.Timer;
   import flash.utils.setTimeout;
   
   public class PerformanceMeasure extends Sprite
   {
      private var _tf:TextField;
      
      private var _timer:Timer;
      
      private var _frameCount:int = 0;
      
      private var _fps:int;
      
      private var _gcCount:int;
      
      public function PerformanceMeasure(draggable:Boolean = true, init:Boolean = true)
      {
         super();
         if(init)
         {
            this.initialize(draggable);
         }
      }
      
      public function startGCCycle() : void
      {
         this._gcCount = 0;
         addEventListener(Event.ENTER_FRAME,this.doGC);
      }
      
      private function doGC(evt:Event) : void
      {
         System.gc();
         if(++this._gcCount > 1)
         {
            removeEventListener(Event.ENTER_FRAME,this.doGC);
            setTimeout(this.lastGC,40);
         }
      }
      
      private function lastGC() : void
      {
         System.gc();
      }
      
      private function initialize(draggable:Boolean = true) : void
      {
         this._tf = new TextField();
         this._tf.text = "";
         this._tf.autoSize = TextFieldAutoSize.LEFT;
         this._tf.background = true;
         this._tf.backgroundColor = 0;
         this._tf.textColor = 16777215;
         this._tf.selectable = false;
         addChild(this._tf);
         if(draggable)
         {
            buttonMode = true;
            addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
            addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         }
         this._timer = new Timer(1000);
         this._timer.addEventListener(TimerEvent.TIMER,this.runT);
         this._timer.start();
         addEventListener(Event.ENTER_FRAME,this.runEf);
      }
      
      private function onMouseUp(event:MouseEvent) : void
      {
         stopDrag();
      }
      
      private function onMouseDown(event:MouseEvent) : void
      {
         startDrag(false);
      }
      
      private function runT(event:TimerEvent) : void
      {
         this._fps = this._frameCount;
         this._frameCount = 0;
      }
      
      private function runEf(event:Event) : void
      {
         this.mem();
         ++this._frameCount;
      }
      
      private function mem() : void
      {
         this._tf.text = this.format(System.totalMemory / 1024 / 1024) + " MB | " + this._fps + " FPS";
      }
      
      private function format(num:Number) : String
      {
         var r:String = null;
         var temp:Number = Math.pow(10,2);
         num = Math.round(num * temp) / temp;
         if(num <= 9)
         {
            r = "0" + num;
         }
         else
         {
            r = num.toString();
         }
         var tail:String = r.split(".")[1];
         if(Boolean(tail))
         {
            if(tail.length < 2)
            {
               return r + "0";
            }
            return r;
         }
         return r + ".00";
      }
      
      public function finalize() : void
      {
         this._timer.stop();
         this._timer.removeEventListener(TimerEvent.TIMER,this.runT);
         this._timer = null;
         removeEventListener(Event.ENTER_FRAME,this.runEf);
         removeEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         removeEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
      }
   }
}

