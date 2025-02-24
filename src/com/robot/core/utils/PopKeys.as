package com.robot.core.utils
{
   import flash.display.Stage;
   import flash.events.KeyboardEvent;
   
   public class PopKeys
   {
      private static var aState:Array = [];
      
      public function PopKeys()
      {
         super();
      }
      
      public static function addStageLis(stg:Stage) : void
      {
         if(Boolean(stg))
         {
            stg.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
            stg.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         }
      }
      
      public static function clearStageLis(stg:Stage) : void
      {
         stg.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
         stg.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
         aState = [];
      }
      
      public static function isDown(code:uint) : Boolean
      {
         return aState[code] == true;
      }
      
      public static function onKeyDown(evt:KeyboardEvent) : void
      {
         var keyCode:uint = evt.keyCode;
         aState[keyCode] = true;
      }
      
      public static function onKeyUp(evt:KeyboardEvent) : void
      {
         var keyCode:uint = evt.keyCode;
         aState[keyCode] = false;
      }
   }
}

