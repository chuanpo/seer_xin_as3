package com.robot.core.display.tree
{
   import flash.events.Event;
   
   public class ItemClickEvent extends Event
   {
      public static const ITEMCLICK:String = "itemclick";
      
      public var item:Btn;
      
      public function ItemClickEvent(d:Btn, type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.item = d;
      }
   }
}

