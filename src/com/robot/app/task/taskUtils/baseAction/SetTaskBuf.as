package com.robot.app.task.taskUtils.baseAction
{
   import com.robot.core.CommandID;
   import com.robot.core.net.SocketConnection;
   import flash.events.Event;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class SetTaskBuf
   {
      private static var _buf:String;
      
      private static var _taskId:uint;
      
      public static const SET_BUF_OK:String = "set_buf_ok";
      
      public function SetTaskBuf()
      {
         super();
      }
      
      public static function setBuf() : void
      {
         var bufArr:ByteArray = new ByteArray();
         bufArr.writeUTFBytes(_buf);
         bufArr.length = 100;
         SocketConnection.addCmdListener(CommandID.ADD_TASK_BUF,onAddBuf);
         SocketConnection.send(CommandID.ADD_TASK_BUF,_taskId,bufArr);
      }
      
      private static function onAddBuf(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.ADD_TASK_BUF,onAddBuf);
         EventManager.dispatchEvent(new Event(SET_BUF_OK));
      }
      
      public static function set taskId(tskId:uint) : void
      {
         _taskId = tskId;
      }
      
      public static function set buf(buffer:String) : void
      {
         _buf = buffer;
      }
      
      public static function get bufValue() : String
      {
         return _buf;
      }
   }
}

