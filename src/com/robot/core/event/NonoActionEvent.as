package com.robot.core.event
{
   import flash.events.Event;
   
   public class NonoActionEvent extends Event
   {
      public static const COLOR_CHANGE:String = "colorChange";
      
      public static const NAME_CHANGE:String = "nameChange";
      
      public static const CLOSE_OPEN:String = "closeOpen";
      
      public static const CHARGEING:String = "chargeing";
      
      public static const NONO_PLAY:String = "nonoPlay";
      
      private var _actionType:String;
      
      private var _data:Object;
      
      public function NonoActionEvent(type:String, actionType:String, data:Object)
      {
         super(type);
         this._actionType = actionType;
         this._data = data;
      }
      
      public function get actionType() : String
      {
         return this._actionType;
      }
      
      public function get data() : Object
      {
         return this._data;
      }
   }
}

