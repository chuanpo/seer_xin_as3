package com.robot.app.task.tc
{
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import com.robot.core.utils.TextFormatUtil;
   
   public class TaskClass_310
   {
      public function TaskClass_310(info:NoviceFinishInfo)
      {
         super();
         TasksManager.setTaskStatus(310,TasksManager.COMPLETE);
         var id:uint = uint(info.monBallList[0].itemID);
         var name:String = ItemXMLInfo.getName(id);
         ItemInBagAlert.show(id,"1个" + TextFormatUtil.getRedTxt(name) + "已经放入你的储存箱");
      }
   }
}

