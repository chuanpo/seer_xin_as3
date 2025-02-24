package com.robot.app.vipSession
{
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class VipSession extends EventDispatcher
   {
      public static const GET_SESSION:String = "getSession";
      
      public var time:uint;
      
      public var key:String;
      
      public function VipSession()
      {
         super();
      }
      
      public function getSession() : void
      {
         SocketConnection.addCmdListener(CommandID.GET_SESSION_KEY,this.onGet);
         SocketConnection.send(CommandID.GET_SESSION_KEY);
      }
      
      private function onGet(event:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GET_SESSION_KEY,this.onGet);
         var by:ByteArray = event.data as ByteArray;
         this.time = by.readUnsignedInt();
         this.key = by.readUTFBytes(32);
         this.key = this.key.toLowerCase();
         dispatchEvent(new Event(GET_SESSION));
      }
   }
}

