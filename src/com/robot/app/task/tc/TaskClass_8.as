package com.robot.app.task.tc
{
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.info.FitmentInfo;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.FitmentManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.TextFormatUtil;
   
   public class TaskClass_8
   {
      public function TaskClass_8(info:NoviceFinishInfo)
      {
         var _info:FitmentInfo = null;
         super();
         TasksManager.setTaskStatus(8,TasksManager.COMPLETE);
         var id:uint = uint(info.monBallList[0].itemID);
         if(id.toString().charAt(0) == "5")
         {
            _info = new FitmentInfo();
            _info.id = id;
            FitmentManager.addInStorage(_info);
            Alarm.show("1个" + TextFormatUtil.getRedTxt(ItemXMLInfo.getName(id)) + "已经放入你的仓库。");
         }
      }
   }
}

