package com.robot.app.task.tc
{
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   
   public class TaskClass_403
   {
      public function TaskClass_403(info:NoviceFinishInfo)
      {
         super();
         trace("bubu daily task");
         TasksManager.setTaskStatus(403,TasksManager.COMPLETE);
         var count:uint = uint(info.monBallList[0]["itemCnt"]);
         var mc:String = NpcTipDialog.DOCTOR;
         NpcTipDialog.show("因为你和精灵的帮助，克洛斯花恢复了活力。奖励你<font color=\'#ff0000\'>" + count + "点</font>补充经验，快回基地打开<font color=\'#ff0000\'>经验分配器</font>看看吧。",null,mc);
      }
   }
}

