package com.robot.core.net
{
   import flash.events.EventDispatcher;
   import org.taomee.ds.HashMap;
   import org.taomee.events.SocketEvent;
   
   [Event(name="complete",type="org.taomee.events.SocketEvent")]
   public class SocketLoader extends EventDispatcher
   {
      private static var _map:HashMap = new HashMap();
      
      public var extData:Object;
      
      private var _cmdID:uint;
      
      public function SocketLoader(cmdID:uint)
      {
         var arr:Array = null;
         super();
         this._cmdID = cmdID;
         if(Boolean(this._cmdID))
         {
            arr = _map.getValue(this._cmdID);
            if(arr == null)
            {
               arr = [];
               _map.add(this._cmdID,arr);
            }
            arr.push(this);
         }
      }
      
      private static function onEvent(e:SocketEvent) : void
      {
         var sl:SocketLoader = null;
         var arr:Array = _map.getValue(e.headInfo.cmdID);
         if(Boolean(arr))
         {
            sl = arr.shift() as SocketLoader;
            if(arr.length == 0)
            {
               _map.remove(e.headInfo.cmdID);
               SocketConnection.removeCmdListener(e.headInfo.cmdID,onEvent);
            }
            if(Boolean(sl))
            {
               sl.dispatchEvent(new SocketEvent(SocketEvent.COMPLETE,e.headInfo,e.data));
            }
         }
      }
      
      public function get cmdID() : uint
      {
         return this._cmdID;
      }
      
      public function load(... args) : void
      {
         if(this._cmdID == 0)
         {
            throw new Error("命令ID不能为0");
         }
         SocketConnection.addCmdListener(this._cmdID,onEvent);
         SocketConnection.send_2(this._cmdID,args);
      }
      
      public function canel() : void
      {
         var arr:Array = null;
         var index:int = 0;
         if(Boolean(this._cmdID))
         {
            arr = _map.getValue(this._cmdID);
            if(Boolean(arr))
            {
               index = arr.indexOf(this);
               if(index != -1)
               {
                  arr.splice(index,1);
                  if(arr.length == 0)
                  {
                     _map.remove(this._cmdID);
                     SocketConnection.removeCmdListener(this._cmdID,onEvent);
                  }
               }
            }
         }
      }
      
      public function destroy() : void
      {
         this.canel();
         this.extData = null;
      }
   }
}

