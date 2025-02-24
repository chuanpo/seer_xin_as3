package com.robot.app.task.tc
{
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.ItemInBagAlert;
   
   public class TaskClass_306
   {
      public function TaskClass_306(info:NoviceFinishInfo)
      {
         var i:Object = null;
         var name:String = null;
         super();
         TasksManager.setTaskStatus(306,TasksManager.COMPLETE);
         for each(i in info.monBallList)
         {
            name = ItemXMLInfo.getName(i.itemID);
            ItemInBagAlert.show(i.itemID,i.itemCnt + "个<font color=\'#ff0000\'>" + name + "</font>已经放入你的储存箱中！");
         }
      }
   }
}

