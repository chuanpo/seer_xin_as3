package com.robot.core.manager
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   
   public class NpcTaskManager
   {
      private static var instance:EventDispatcher;
      
      private static var isSingle:Boolean = false;
      
      public function NpcTaskManager()
      {
         super();
         if(!isSingle)
         {
            throw new Error("NpcTaskManager为单例模式，不能直接创建");
         }
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(instance == null)
         {
            isSingle = true;
            instance = new EventDispatcher();
         }
         isSingle = false;
         return instance;
      }
      
      public static function addTaskListener(taskID:uint, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         getInstance().addEventListener(taskID.toString(),listener,useCapture,priority,useWeakReference);
      }
      
      public static function removeTaskListener(taskID:uint, listener:Function, useCapture:Boolean = false) : void
      {
         getInstance().removeEventListener(taskID.toString(),listener,useCapture);
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
      
      public static function willTrigger(type:String) : Boolean
      {
         return getInstance().willTrigger(type);
      }
   }
}

