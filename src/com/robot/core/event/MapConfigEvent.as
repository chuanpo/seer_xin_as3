package com.robot.core.event
{
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class MapConfigEvent extends Event
   {
      public static const HIT_MAP_COMPONENT:String = "hitMapComponent";
      
      private var _hitMC:Sprite;
      
      public function MapConfigEvent(type:String, mc:Sprite, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._hitMC = mc;
      }
      
      public function get hitMC() : Sprite
      {
         return this._hitMC;
      }
   }
}

