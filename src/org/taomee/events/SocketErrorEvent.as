package org.taomee.events
{
   import flash.events.Event;
   import org.taomee.tmf.HeadInfo;
   
   public class SocketErrorEvent extends Event
   {
      public static const ERROR:String = "error";
      
      private var _headInfo:HeadInfo;
      
      public function SocketErrorEvent(type:String, headInfo:HeadInfo, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         _headInfo = headInfo;
      }
      
      public function get headInfo() : HeadInfo
      {
         return _headInfo;
      }
   }
}

