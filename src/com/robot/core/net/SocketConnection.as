package com.robot.core.net
{
   import com.robot.core.manager.MapManager;
   import flash.events.Event;
   import org.taomee.net.SocketDispatcher;
   import org.taomee.net.SocketImpl;
   
   public class SocketConnection
   {
      private static var _mainSocket:SocketImpl;
      
      private static var _roomSocket:SocketImpl;
      
      public function SocketConnection()
      {
         super();
      }
      
      public static function get mainSocket() : SocketImpl
      {
         if(_mainSocket == null)
         {
            _mainSocket = new SocketImpl();
         }
         return _mainSocket;
      }
      
      public static function get roomSocket() : SocketImpl
      {
         if(_roomSocket == null)
         {
            _roomSocket = new SocketImpl();
         }
         return _roomSocket;
      }
      
      public static function addCmdListener(id:uint, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         SocketDispatcher.getInstance().addEventListener(id.toString(),listener,useCapture,priority,useWeakReference);
      }
      
      public static function removeCmdListener(id:uint, listener:Function, useCapture:Boolean = false) : void
      {
         SocketDispatcher.getInstance().removeEventListener(id.toString(),listener,useCapture);
      }
      
      public static function dispatchCmd(event:Event) : void
      {
         SocketDispatcher.getInstance().dispatchEvent(event);
      }
      
      public static function hasCmdListener(id:uint) : Boolean
      {
         return SocketDispatcher.getInstance().hasEventListener(id.toString());
      }
      
      public static function willTriggerCmd(id:uint) : Boolean
      {
         return SocketDispatcher.getInstance().willTrigger(id.toString());
      }
      
      public static function send(cmdID:uint, ... args) : void
      {
         if(MapManager.type == ConnectionType.MAIN)
         {
            if(!mainSocket.connected)
            {
               mainSocket.dispatchEvent(new Event(Event.CLOSE));
            }
            mainSocket.send(cmdID,args);
         }
         else if(MapManager.type == ConnectionType.ROOM)
         {
            roomSocket.send(cmdID,args);
         }
      }
      
      internal static function send_2(cmdID:uint, arr:Array) : void
      {
         if(MapManager.type == ConnectionType.MAIN)
         {
            if(!mainSocket.connected)
            {
               mainSocket.dispatchEvent(new Event(Event.CLOSE));
            }
            mainSocket.send(cmdID,arr);
         }
         else if(MapManager.type == ConnectionType.ROOM)
         {
            roomSocket.send(cmdID,arr);
         }
      }
   }
}

