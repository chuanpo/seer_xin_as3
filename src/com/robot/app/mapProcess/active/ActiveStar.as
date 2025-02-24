package com.robot.app.mapProcess.active
{
   import com.robot.core.CommandID;
   import com.robot.core.info.SystemTimeInfo;
   import com.robot.core.manager.MapManager;
   import com.robot.core.net.SocketConnection;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.utils.Timer;
   import org.taomee.events.SocketEvent;
   
   public class ActiveStar
   {
      private var start:Point;
      
      private var end:Point;
      
      private var timer:Timer;
      
      public function ActiveStar(start:Point, end:Point)
      {
         super();
         this.start = start;
         this.end = end;
         SocketConnection.addCmdListener(CommandID.SYSTEM_TIME,function(event:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.SYSTEM_TIME,arguments.callee);
            var date:Date = (event.data as SystemTimeInfo).date;
            if(date.getDate() >= 24)
            {
               timer = new Timer(500);
               timer.addEventListener(TimerEvent.TIMER,onTimer);
               timer.start();
            }
         });
         SocketConnection.send(CommandID.SYSTEM_TIME);
      }
      
      private function onTimer(event:TimerEvent) : void
      {
         var star:Star = null;
         var x:Number = this.start.x + Math.random() * (this.end.x - this.end.y);
         star = new Star();
         star.x = x;
         star.y = -10;
         MapManager.currentMap.animatorLevel["mc"].addChild(star);
      }
      
      public function destroy() : void
      {
         if(Boolean(this.timer))
         {
            this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
            this.timer.stop();
            this.timer = null;
         }
      }
   }
}

import com.robot.core.manager.MainManager;
import com.robot.core.manager.map.MapLibManager;
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.InteractiveObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.EventDispatcher;

class Star extends Sprite
{
   private var mc:MovieClip;
   
   public function Star()
   {
      super();
      this.mc = MapLibManager.getMovieClip("star");
      if(!this.mc)
      {
         return;
      }
      addChild(this.mc);
      this.mc.alpha = 0.8;
      this.mc.scaleY = 0.8;
      this.mc.scaleX = 0.8;
      this.addEventListener(Event.ENTER_FRAME,this.onEnter);
   }
   
   private function onEnter(event:Event) : void
   {
      var num:uint = Math.floor(Math.random() * 4) + 8;
      this.mc.x += num * 1.3;
      this.mc.y += num;
      if(this.mc.x > MainManager.getStageWidth() || this.mc.y > MainManager.getStageHeight())
      {
         removeEventListener(Event.ENTER_FRAME,this.onEnter);
         this.mc = null;
      }
   }
}
