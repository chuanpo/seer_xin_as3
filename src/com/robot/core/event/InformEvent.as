package com.robot.core.event
{
   import com.robot.core.info.InformInfo;
   import flash.events.Event;
   
   public class InformEvent extends Event
   {
      public static const INFORM:String = "inform";
      
      private var _info:InformInfo;
      
      public function InformEvent(type:String, info:InformInfo)
      {
         super(type,false,false);
         this._info = info;
      }
      
      public function get info() : InformInfo
      {
         return this._info;
      }
   }
}

