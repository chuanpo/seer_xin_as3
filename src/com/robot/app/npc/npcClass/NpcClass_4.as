package com.robot.app.npc.npcClass
{
   import com.robot.core.event.NpcEvent;
   import com.robot.core.mode.NpcModel;
   import com.robot.core.npc.INpc;
   import com.robot.core.npc.NpcInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import com.robot.app.task.control.TaskController_42;
   import com.robot.core.manager.TasksManager;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   
   public class NpcClass_4 implements INpc
   {
      private var _curNpcModel:NpcModel;
      
      public function NpcClass_4(info:NpcInfo, mc:DisplayObject)
      {
         super();
         this._curNpcModel = new NpcModel(info,mc as Sprite);
         this._curNpcModel.addEventListener(NpcEvent.NPC_CLICK,this.onClickNpc);
      }
      
      private function onClickNpc(e:NpcEvent) : void
      {
         this._curNpcModel.refreshTask();
         if(e.taskID == 42)
         {
            TasksManager.getProStatusList(42,function(arr:Array):void{
               if(Boolean(arr[4]) && !arr[5]){
                  NpcTipDialog.show('天啊……原来赫尔卡星历史书上记载的"西塔"和"奇塔"就是你设计出来的？这真是太棒了！看来我给你的这份礼物你真是当之无愧啊！',function():void{
                     TasksManager.complete(TaskController_42.TASK_ID,5,null)
                  },NpcTipDialog.IRIS)
               }
            })
         }
      }
      
      public function destroy() : void
      {
         if(Boolean(this._curNpcModel))
         {
            this._curNpcModel.removeEventListener(NpcEvent.NPC_CLICK,this.onClickNpc);
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

