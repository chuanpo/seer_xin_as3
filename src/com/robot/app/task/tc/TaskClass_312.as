package com.robot.app.task.tc
{
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import com.robot.core.utils.TextFormatUtil;
   
   public class TaskClass_312
   {
      public function TaskClass_312(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(312,TasksManager.COMPLETE);
         ItemInBagAlert.show(400125,"1个" + TextFormatUtil.getRedTxt("奈尼芬多的精元") + "已经放入你的储存箱");
      }
   }
}

