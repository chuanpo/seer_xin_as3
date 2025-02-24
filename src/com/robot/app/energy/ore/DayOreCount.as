package com.robot.app.energy.ore
{
   import com.robot.core.CommandID;
   import com.robot.core.info.task.MiningCountInfo;
   import com.robot.core.net.SocketConnection;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import org.taomee.events.SocketEvent;
   
   public class DayOreCount extends EventDispatcher
   {
      public static var oreCount:uint;
      
      public static const countOK:String = "COUNT_OK";
      
      public static const countError:String = "COUNT_ERROR";
      
      public function DayOreCount()
      {
         super();
      }
      
      public function sendToServer(type:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.TALK_COUNT,this.onCount);
         SocketConnection.send(CommandID.TALK_COUNT,type);
      }
      
      private function onCount(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TALK_COUNT,this.onCount);
         var oreCountInfo:MiningCountInfo = e.data as MiningCountInfo;
         oreCount = oreCountInfo.miningCount;
         dispatchEvent(new Event(countOK));
      }
   }
}

