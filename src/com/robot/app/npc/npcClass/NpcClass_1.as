package com.robot.app.npc.npcClass
{
   import com.robot.app.task.noviceGuide.TalkShiper;
   import com.robot.app.task.publicizeenvoy.PublicizeEnvoyDialog;
   import com.robot.core.event.NpcEvent;
   import com.robot.core.manager.NpcTaskManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.mode.NpcModel;
   import com.robot.core.npc.INpc;
   import com.robot.core.npc.NpcInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.utils.getDefinitionByName;
   
   public class NpcClass_1 implements INpc
   {
      private var _curNpcModel:NpcModel;
      
      public function NpcClass_1(info:NpcInfo, mc:DisplayObject)
      {
         super();
         this._curNpcModel = new NpcModel(info,mc as Sprite);
         this._curNpcModel.addEventListener(NpcEvent.NPC_CLICK,this.onNpcClick);
         this._curNpcModel.addEventListener(NpcEvent.TASK_WITHOUT_DES,this.onTaskWithoutDes);
         NpcTaskManager.addTaskListener(50001,this.onTaskHandler);
      }
      
      private function onTaskWithoutDes(e:NpcEvent) : void
      {
         var id:uint = uint(e.taskID);
         var cla:* = getDefinitionByName("com.robot.app.task.control.TaskController_" + id) as Class;
         cla.start();
      }
      
      private function onNpcClick(e:NpcEvent) : void
      {
         this._curNpcModel.refreshTask();
         TalkShiper.start(e.taskID);
      }
      
      private function onTaskHandler(event:Event) : void
      {
         if(TasksManager.getTaskStatus(25) != TasksManager.ALR_ACCEPT)
         {
            PublicizeEnvoyDialog.getInstance().show();
            return;
         }
         TasksManager.getProStatusList(25,function(arr:Array):void
         {
            var b1:Boolean = Boolean(TasksManager.isComNoviceTask());
            var b2:Boolean = TasksManager.getTaskStatus(4) == TasksManager.COMPLETE;
            var b3:Boolean = TasksManager.getTaskStatus(94) == TasksManager.COMPLETE;
            var b5:Boolean = TasksManager.getTaskStatus(19) == TasksManager.COMPLETE;
            if(b1 && b2 && b3 && b5)
            {
               TasksManager.complete(25,5);
            }
            else
            {
               PublicizeEnvoyDialog.getInstance().show();
            }
         });
      }
      
      public function destroy() : void
      {
         if(Boolean(this._curNpcModel))
         {
            this._curNpcModel.addEventListener(NpcEvent.NPC_CLICK,this.onNpcClick);
            this._curNpcModel.destroy();
            this._curNpcModel = null;
         }
      }
      
      public function get npc() : NpcModel
      {
         return this._curNpcModel;
      }
   }
}

