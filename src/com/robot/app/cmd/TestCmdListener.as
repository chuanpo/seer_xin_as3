package com.robot.app.cmd
{
   import com.robot.core.CommandID;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.net.SocketConnection;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   
   public class TestCmdListener extends BaseBeanController
   {
      public function TestCmdListener()
      {
         super();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.TEST,this.onTest);
         finish();
      }
      
      private function onTest(e:SocketEvent) : void
      {
         var data:ByteArray = e.data as ByteArray;
         var id:uint = data.readUnsignedInt();
      }
   }
}

