package org.taomee.component.event
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   
   public class LoadPaneEvent extends Event
   {
      public static const ON_LOAD_CONTENT:String = "onLoadContent";
      
      private var content:DisplayObject;
      
      public function LoadPaneEvent(type:String, content:DisplayObject, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this.content = content;
      }
      
      public function getContent() : DisplayObject
      {
         return content;
      }
   }
}

