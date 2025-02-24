package com.robot.core.event
{
   import com.robot.core.info.AimatInfo;
   import flash.events.Event;
   
   public class AimatEvent extends Event
   {
      public static const OPEN:String = "open";
      
      public static const CLOSE:String = "close";
      
      public static const PLAY_START:String = "playStart";
      
      public static const PLAY_END:String = "playEnd";
      
      private var _info:AimatInfo;
      
      public function AimatEvent(type:String, info:AimatInfo)
      {
         super(type);
         this._info = info;
      }
      
      public function get info() : AimatInfo
      {
         return this._info;
      }
   }
}

