package com.robot.app.task.noviceGuide
{
   import com.robot.core.CommandID;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.net.SocketConnection;
   
   public class SelectPet
   {
      private static var curPetId:uint;
      
      private static var bSend:Boolean = false;
      
      public function SelectPet()
      {
         super();
      }
      
      public static function checkStatus(petId:uint) : void
      {
         if(TasksManager.getTaskStatus(2) == TasksManager.COMPLETE)
         {
            return;
         }
         curPetId = petId;
         okFun();
      }
      
      private static function okFun() : void
      {
         if(bSend)
         {
            return;
         }
         SocketConnection.send(CommandID.COMPLETE_TASK,2,curPetId);
         bSend = true;
      }
   }
}

