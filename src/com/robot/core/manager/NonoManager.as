package com.robot.core.manager
{
   import com.robot.core.CommandID;
   import com.robot.core.event.NonoActionEvent;
   import com.robot.core.event.NonoEvent;
   import com.robot.core.info.NonoInfo;
   import com.robot.core.net.SocketConnection;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.getTimer;
   import org.taomee.events.SocketEvent;
   
   public class NonoManager
   {
      public static var info:NonoInfo;
      
      private static var _time:int;
      
      private static var instance:EventDispatcher;
      
      public static var isBeckon:Boolean = false;
      
      public function NonoManager()
      {
         super();
      }
      
      public static function getInfo(t:Boolean = false) : void
      {
         if(t)
         {
            SocketConnection.addCmdListener(CommandID.NONO_INFO,onSocketInfo);
            SocketConnection.send(CommandID.NONO_INFO,MainManager.actorID);
            return;
         }
         var ct:int = getTimer() - _time;
         if(_time == 0 || ct > 200000)
         {
            SocketConnection.addCmdListener(CommandID.NONO_INFO,onSocketInfo);
            SocketConnection.send(CommandID.NONO_INFO,MainManager.actorID);
         }
         else
         {
            dispatchEvent(new NonoEvent(NonoEvent.GET_INFO,info));
         }
      }
      
      private static function onSocketInfo(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.NONO_INFO,onSocketInfo);
         _time = getTimer();
         info = new NonoInfo(e.data as ByteArray);
         dispatchEvent(new NonoEvent(NonoEvent.GET_INFO,info));
      }
      
      public static function getInstance() : EventDispatcher
      {
         if(instance == null)
         {
            instance = new EventDispatcher();
         }
         return instance;
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         getInstance().addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         getInstance().removeEventListener(type,listener,useCapture);
      }
      
      public static function dispatchEvent(event:Event) : void
      {
         if(hasEventListener(event.type))
         {
            getInstance().dispatchEvent(event);
         }
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return getInstance().hasEventListener(type);
      }
      
      public static function addActionListener(userID:uint, listener:Function) : void
      {
         getInstance().addEventListener(userID.toString(),listener,false,0,false);
      }
      
      public static function removeActionListener(userID:uint, listener:Function) : void
      {
         getInstance().removeEventListener(userID.toString(),listener,false);
      }
      
      public static function dispatchAction(userID:uint, actionType:String, data:Object) : void
      {
         getInstance().dispatchEvent(new NonoActionEvent(userID.toString(),actionType,data));
      }
      
      public static function hasActionListener(userID:uint) : Boolean
      {
         return getInstance().hasEventListener(userID.toString());
      }
   }
}

