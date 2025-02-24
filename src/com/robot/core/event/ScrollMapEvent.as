package com.robot.core.event
{
   import flash.events.Event;
   
   public class ScrollMapEvent extends Event
   {
      public static const SCROLL_COMPLETE:String = "scrollComplete";
      
      public function ScrollMapEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

