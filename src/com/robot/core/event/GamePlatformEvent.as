package com.robot.core.event
{
   import flash.events.Event;
   
   public class GamePlatformEvent extends Event
   {
      public static const GAME_WIN:String = "gameWin";
      
      public static const GAME_LOST:String = "gameLost";
      
      public function GamePlatformEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
   }
}

