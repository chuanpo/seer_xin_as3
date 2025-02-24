package com.robot.app.task.noviceGuide
{
   import com.robot.core.CommandID;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.net.SocketConnection;
   import flash.events.Event;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class NoviceSubmit
   {
      public static var taskOutInfo:NoviceFinishInfo;
      
      private static var _outId:uint;
      
      private static var _taskId:uint;
      
      public static const SUBMIT_TASK_OK:String = "submit_task_ok";
      
      public function NoviceSubmit()
      {
         super();
      }
      
      public static function set outId(_outid:uint) : void
      {
         _outId = _outid;
      }
      
      public static function set taskId(tskId:uint) : void
      {
         _taskId = tskId;
      }
      
      public static function submitTask() : void
      {
         SocketConnection.addCmdListener(CommandID.COMPLETE_TASK,onComplete);
         SocketConnection.send(CommandID.COMPLETE_TASK,_taskId,_outId);
      }
      
      private static function onComplete(e:SocketEvent) : void
      {
         taskOutInfo = e.data as NoviceFinishInfo;
         SocketConnection.removeCmdListener(CommandID.COMPLETE_TASK,onComplete);
         EventManager.dispatchEvent(new Event(SUBMIT_TASK_OK));
      }
   }
}

