package org.taomee.component.event
{
   import flash.events.Event;
   
   public class MComponentEvent extends Event
   {
      public static const UPDATE:String = "onUpdate";
      
      public function MComponentEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

