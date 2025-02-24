package com.robot.app.bag
{
   import flash.events.Event;
   
   public class BagTypeEvent extends Event
   {
      public static const SELECT:String = "bagSelect";
      
      private var _showType:int;
      
      private var _suitID:uint;
      
      public function BagTypeEvent(type:String, showType:int, suitID:uint = 0)
      {
         super(type);
         this._showType = showType;
         this._suitID = suitID;
      }
      
      public function get showType() : int
      {
         return this._showType;
      }
      
      public function get suitID() : int
      {
         return this._suitID;
      }
   }
}

