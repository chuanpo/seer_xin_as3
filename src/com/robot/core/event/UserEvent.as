package com.robot.core.event
{
   import com.robot.core.info.UserInfo;
   import flash.events.Event;
   
   public class UserEvent extends Event
   {
      public static const CLICK:String = "userClick";
      
      public static const INFO_CHANGE:String = "infoChange";
      
      public static const REMOVED_FROM_MAP:String = "removedFromMap";
      
      private var _userInfo:UserInfo;
      
      public function UserEvent(type:String, userInfo:UserInfo = null, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
         this._userInfo = userInfo;
      }
      
      public function get userInfo() : UserInfo
      {
         return this._userInfo;
      }
   }
}

