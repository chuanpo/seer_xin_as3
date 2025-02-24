package com.robot.core.event
{
   import com.robot.core.info.ChatInfo;
   import flash.events.Event;
   
   public class ChatEvent extends Event
   {
      public static const TALK:String = "talk";
      
      public static const CHAT_COM:String = "chatCom";
      
      private var _info:ChatInfo;
      
      public function ChatEvent(type:String, info:ChatInfo)
      {
         super(type,false,false);
         this._info = info;
      }
      
      public function get info() : ChatInfo
      {
         return this._info;
      }
   }
}

