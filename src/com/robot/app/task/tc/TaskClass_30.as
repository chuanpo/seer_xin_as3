package com.robot.app.task.tc
{
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.Alarm;
   
   public class TaskClass_30
   {
      public function TaskClass_30(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(30,TasksManager.COMPLETE);
         NpcTipDialog.show("答的不错，NoNo交给你我很放心。这些是给你的奖励！",function():void
         {
            var i:Object = null;
            var name:String = null;
            for each(i in info.monBallList)
            {
               name = ItemXMLInfo.getName(i.itemID);
               Alarm.show("恭喜你获得了" + i.itemCnt + "个<font color=\'#ff0000\'>" + name + "</font>");
            }
         },NpcTipDialog.SHAWN);
      }
   }
}

