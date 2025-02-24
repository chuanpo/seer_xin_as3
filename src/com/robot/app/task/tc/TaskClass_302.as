package com.robot.app.task.tc
{
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.TasksManager;
   import flash.display.DisplayObjectContainer;
   
   public class TaskClass_302
   {
      public function TaskClass_302(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(302,TasksManager.COMPLETE);
         NpcTipDialog.show("你获得了黑晶矿,快去背包看看吧!",null,"",0,null,LevelManager.iconLevel as DisplayObjectContainer);
      }
   }
}

