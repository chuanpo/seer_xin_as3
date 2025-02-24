package org.taomee.component.event
{
   import flash.events.Event;
   
   public class MEvent extends Event
   {
      public static const PANEL_CLOSED:String = "panelClosed";
      
      public function MEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

