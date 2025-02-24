package com.robot.core.event
{
   import flash.events.Event;
   
   public class TeamEvent extends Event
   {
      public static const MODIFY_LOGO:String = "modifyLogo";
      
      public function TeamEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

