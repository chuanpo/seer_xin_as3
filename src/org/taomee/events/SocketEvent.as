package org.taomee.events
{
   import flash.events.Event;
   import org.taomee.tmf.HeadInfo;
   
   public class SocketEvent extends Event
   {
      public static const COMPLETE:String = Event.COMPLETE;
      
      private var _data:Object;
      
      private var _headInfo:HeadInfo;
      
      public function SocketEvent(type:String, headInfo:HeadInfo, data:Object)
      {
         super(type,false,false);
         _headInfo = headInfo;
         _data = data;
      }
      
      public function get data() : Object
      {
         return _data;
      }
      
      public function get headInfo() : HeadInfo
      {
         return _headInfo;
      }
   }
}

