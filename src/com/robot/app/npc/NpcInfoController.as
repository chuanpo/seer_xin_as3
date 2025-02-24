package com.robot.app.npc
{
   import com.robot.app.taskPanel.TaskPanelController;
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.TasksXMLInfo;
   import com.robot.core.event.NpcEvent;
   import com.robot.core.info.NpcTaskInfo;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.mode.NpcModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.npc.NpcController;
   import com.robot.core.npc.NpcDialog;
   import com.robot.core.ui.alert.Alarm;
   import flash.utils.ByteArray;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   
   public class NpcInfoController extends BaseBeanController
   {
      public function NpcInfoController()
      {
         super();
      }
      
      private static function onDelTask(event:SocketEvent) : void
      {
         var id:uint = (event.data as ByteArray).readUnsignedInt();
         TasksManager.setTaskStatus(id,TasksManager.UN_ACCEPT);
         NpcController.refreshTaskInfo();
      }
      
      private static function onAddBuf(event:SocketEvent) : void
      {
         NpcController.refreshTaskInfo();
      }
      
      private static function onCompTask(event:SocketEvent) : void
      {
         var info:NoviceFinishInfo = event.data as NoviceFinishInfo;
         TasksManager.setTaskStatus(info.taskID,TasksManager.COMPLETE);
         NpcController.refreshTaskInfo();
      }
      
      override public function start() : void
      {
         EventManager.addEventListener(NpcEvent.SHOW_TASK_LIST,this.npcClickHandler);
         EventManager.addEventListener(NpcEvent.COMPLETE_TASK,this.completeTaskHandler);
         SocketConnection.addCmdListener(CommandID.ADD_TASK_BUF,onAddBuf);
         SocketConnection.addCmdListener(CommandID.COMPLETE_TASK,onCompTask);
         SocketConnection.addCmdListener(CommandID.DELETE_TASK,onDelTask);
         finish();
      }
      
      private function npcClickHandler(event:NpcEvent) : void
      {
         var model:NpcModel = event.model;
         var info:NpcTaskInfo = model.taskInfo;
         if(model.taskInfo.acceptList.length > 0)
         {
            trace("显示任务列表");
            TaskPanelController.show(model);
         }
         else if(model.des != "")
         {
            NpcDialog.show(model.npcInfo.npcId,[model.des],model.npcInfo.questionA);
         }
         else
         {
            model.dispatchEvent(new NpcEvent(NpcEvent.NPC_CLICK,model));
         }
      }
      
      private function completeTaskHandler(event:NpcEvent) : void
      {
         var model:NpcModel = null;
         var id:uint = 0;
         trace("先完成任务");
         model = event.model;
         if(model.taskInfo.completeList.length > 0)
         {
            id = uint(model.taskInfo.completeList.slice().shift());
            trace(TasksXMLInfo.getTaskPorCount(id) - 1);
            TasksManager.complete(id,TasksXMLInfo.getTaskPorCount(id) - 1,function(b:Boolean):void
            {
               if(b)
               {
                  TasksManager.setTaskStatus(id,TasksManager.COMPLETE);
                  model.refreshTask();
               }
               else
               {
                  Alarm.show("提交任务失败，请稍后再试");
               }
            });
         }
      }
   }
}

