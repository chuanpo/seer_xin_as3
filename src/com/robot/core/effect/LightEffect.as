package com.robot.core.effect
{
   import com.oaxoa.fx.Lightning;
   import com.oaxoa.fx.LightningFadeType;
   import com.robot.core.manager.LevelManager;
   import flash.display.BlendMode;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.TimerEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Point;
   import flash.utils.Timer;
   import org.taomee.utils.DisplayUtil;
   
   public class LightEffect
   {
      private var timer:Timer;
      
      private var ll:Lightning;
      
      public function LightEffect()
      {
         super();
         this.timer = new Timer(1500,1);
         this.timer.addEventListener(TimerEvent.TIMER,this.onTimer);
      }
      
      public function show(startPoint:Point, endPoint:Point, isFlash:Boolean = true, color:uint = 16777215, filterColor:uint = 16777215, strength:Number = 1.8) : Sprite
      {
         var dis:Number = NaN;
         this.ll = new Lightning(color,2);
         this.ll.blendMode = BlendMode.ADD;
         this.ll.childrenDetachedEnd = false;
         this.ll.childrenLifeSpanMin = 0.1;
         this.ll.childrenLifeSpanMax = 2;
         this.ll.childrenMaxCount = 3;
         this.ll.childrenMaxCountDecay = 0.5;
         this.ll.steps = 350;
         this.ll.wavelength = 0.36;
         this.ll.amplitude = 0.76;
         if(isFlash)
         {
            dis = Point.distance(startPoint,endPoint);
            this.ll.maxLength = dis * (2 / 3);
            this.ll.maxLengthVary = dis * (1.5 / 3);
         }
         this.ll.startX = startPoint.x;
         this.ll.startY = startPoint.y;
         this.ll.endX = endPoint.x;
         this.ll.endY = endPoint.y;
         this.ll.alphaFadeType = LightningFadeType.GENERATION;
         var glow:GlowFilter = new GlowFilter(filterColor);
         glow.strength = strength;
         glow.quality = 3;
         glow.blurY = 10;
         glow.blurX = 10;
         this.ll.filters = [glow];
         LevelManager.mapLevel.addChild(this.ll);
         this.ll.childrenProbability = 0.3;
         this.ll.addEventListener(Event.ENTER_FRAME,this.onEnter);
         this.timer.start();
         return this.ll;
      }
      
      private function onTimer(event:TimerEvent) : void
      {
         this.timer.stop();
         this.timer.removeEventListener(TimerEvent.TIMER,this.onTimer);
         this.timer = null;
         this.ll.kill();
         this.ll.removeEventListener(Event.ENTER_FRAME,this.onEnter);
         DisplayUtil.removeForParent(this.ll);
         this.ll = null;
      }
      
      private function onEnter(event:Event) : void
      {
         this.ll.update();
      }
   }
}

