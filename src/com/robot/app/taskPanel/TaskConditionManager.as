package com.robot.app.taskPanel
{
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.core.config.xml.TaskConditionListInfo;
   import com.robot.core.config.xml.TaskConditionXMLInfo;
   import com.robot.core.config.xml.TasksXMLInfo;
   
   public class TaskConditionManager
   {
      public static const NPC_CLICK:uint = 0;
      
      public static const BEFOR_ACCEPT:uint = 1;
      
      public function TaskConditionManager()
      {
         super();
      }
      
      public static function getConditionStep(id:uint) : uint
      {
         return TaskConditionXMLInfo.getConditionStep(id);
      }
      
      public static function conditionTask(id:uint, npc:String) : Boolean
      {
         var i:TaskConditionListInfo = null;
         if(!TasksXMLInfo.getIsCondition(id))
         {
            return true;
         }
         var array:Array = TaskConditionXMLInfo.getConditionList(id);
         for each(i in array)
         {
            if(!i.getClass()[i.fun]())
            {
               NpcTipDialog.show(i.error,null,npc);
               return false;
            }
         }
         return true;
      }
   }
}

