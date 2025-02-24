package com.robot.core.effect
{
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   
   public class GlowTween
   {
      private var _target:InteractiveObject;
      
      private var _color:uint;
      
      private var _toggle:Boolean;
      
      private var _blur:Number;
      
      public function GlowTween(target:InteractiveObject, color:uint = 16777215, openMouseEvent:Boolean = false)
      {
         super();
         this._target = target;
         this._color = color;
         this._toggle = true;
         this._blur = 2;
         if(openMouseEvent)
         {
            this.startGlowHandler();
         }
         else
         {
            target.addEventListener(MouseEvent.ROLL_OVER,this.startGlowHandler);
            target.addEventListener(MouseEvent.ROLL_OUT,this.stopGlowHandler);
         }
      }
      
      public function remove() : void
      {
         this._target.removeEventListener(MouseEvent.ROLL_OVER,this.startGlowHandler);
         this._target.removeEventListener(MouseEvent.ROLL_OUT,this.stopGlowHandler);
         this._target.removeEventListener(Event.ENTER_FRAME,this.blinkHandler);
         this._target.filters = null;
         this._target = null;
      }
      
      public function startGlowHandler(evt:MouseEvent = null) : void
      {
         this._target.addEventListener(Event.ENTER_FRAME,this.blinkHandler,false,0,true);
      }
      
      public function stopGlowHandler(evt:MouseEvent = null) : void
      {
         this._target.removeEventListener(Event.ENTER_FRAME,this.blinkHandler);
         this._target.filters = null;
      }
      
      private function blinkHandler(evt:Event) : void
      {
         if(this._blur >= 30)
         {
            this._toggle = false;
         }
         else if(this._blur <= 2)
         {
            this._toggle = true;
         }
         if(this._toggle)
         {
            ++this._blur;
         }
         else
         {
            --this._blur;
         }
         var glow:GlowFilter = new GlowFilter(this._color,1,this._blur,this._blur,2,2);
         this._target.filters = [glow];
      }
   }
}

