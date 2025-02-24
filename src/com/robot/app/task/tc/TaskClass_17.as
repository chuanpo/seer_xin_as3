package com.robot.app.task.tc
{
   import com.robot.app.task.collectionExercise.CollectionExercise;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import com.robot.core.utils.TextFormatUtil;
   
   public class TaskClass_17
   {
      public function TaskClass_17(info:NoviceFinishInfo)
      {
         var i:Object = null;
         var id:uint = 0;
         var count:uint = 0;
         var name:String = null;
         super();
         TasksManager.setTaskStatus(CollectionExercise.TASK_ID,TasksManager.COMPLETE);
         CollectionExercise.delIcon();
         MainManager.actorInfo.coins += 2000;
         for each(i in info.monBallList)
         {
            id = uint(i["itemID"]);
            count = uint(i["itemCnt"]);
            name = ItemXMLInfo.getName(id);
            ItemInBagAlert.show(id,count + "个" + TextFormatUtil.getRedTxt(name) + "已经放入你的储存箱中！");
         }
      }
   }
}

