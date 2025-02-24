package com.robot.core.event
{
   import flash.events.Event;
   
   public class CutBmpEvent extends Event
   {
      public static const CUT_BMP_COMPLETE:String = "cutBmpComplete";
      
      private var _imgUrl:String;
      
      private var _toID:uint;
      
      public function CutBmpEvent(type:String, str:String, toID:uint = 0, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._imgUrl = str;
         this._toID = toID;
      }
      
      public function get imgURL() : String
      {
         return this._imgUrl;
      }
      
      public function get toID() : uint
      {
         return this._toID;
      }
   }
}

