package com.robot.app.task.tc
{
   import com.robot.app.task.skeeClothTask.SkeeClothTaskController;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.Alarm;
   
   public class TaskClass_7
   {
      private var itemID:uint;
      
      public function TaskClass_7(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(7,TasksManager.COMPLETE);
         this.itemID = uint(info.monBallList[0]["itemID"]);
         SkeeClothTaskController.delIcon();
         Alarm.show("<font color=\'#ff0000\'>" + "防寒服" + "</font>套装已经放入你的储存箱！");
      }
      
      private function onClick() : void
      {
         SkeeClothTaskController.delIcon();
         var name:String = ItemXMLInfo.getName(this.itemID);
         Alarm.show("<font color=\'#ff0000\'>" + name + "</font>已经放入你的储存箱！");
      }
   }
}

