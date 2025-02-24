package org.taomee.component.event
{
   import flash.events.Event;
   
   public class LayoutEvent extends Event
   {
      public static const LAYOUT_SET_CHANGED:String = "layoutSetChanged";
      
      public function LayoutEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

