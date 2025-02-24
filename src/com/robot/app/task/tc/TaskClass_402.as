package com.robot.app.task.tc
{
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   
   public class TaskClass_402
   {
      public function TaskClass_402(info:NoviceFinishInfo)
      {
         super();
         trace("monkey kongfu complete");
         TasksManager.setTaskStatus(402,TasksManager.COMPLETE);
         NpcTipDialog.show("哈哈，恭喜你，你帮助小火猴通过了考验。他渐渐学会控制自己，以后的进步会更快了。" + "2000点<font color=\'#ff0000\'>积累经验</font>已存入你的经验分配器中。",null,NpcTipDialog.GUARD);
      }
   }
}

