package org.taomee.component.event
{
   import flash.events.Event;
   import org.taomee.component.UIComponent;
   
   public class ContainerEvent extends Event
   {
      public static const COMP_ADDED:String = "compAdded";
      
      public static const COMP_REMOVED:String = "compRemoved";
      
      private var comp:UIComponent;
      
      public function ContainerEvent(type:String, comp:UIComponent, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.comp = comp;
      }
      
      public function get component() : UIComponent
      {
         return comp;
      }
   }
}

