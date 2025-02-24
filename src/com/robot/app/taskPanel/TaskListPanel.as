package com.robot.app.taskPanel
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.TasksXMLInfo;
   import com.robot.core.event.NpcEvent;
   import com.robot.core.info.NpcTaskInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.NpcTaskManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.mode.NpcModel;
   import com.robot.core.npc.NPC;
   import com.robot.core.npc.NpcController;
   import com.robot.core.npc.NpcDialog;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.DisplayObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class TaskListPanel extends Sprite
   {
      private static const PATH:String = "com.robot.app.task.control";
      
      private var _info:NpcTaskInfo;
      
      private var npcType:String;
      
      private var bgMC:Sprite;
      
      private var closeBtn:SimpleButton;
      
      private var itemContainer:Sprite;
      
      private var npcIcon:Sprite;
      
      private var listArray:Array = [];
      
      private var npcModel:NpcModel;
      
      public function TaskListPanel()
      {
         super();
         this.bgMC = new ui_TaskListPanel();
         addChild(this.bgMC);
         this.closeBtn = this.bgMC["closeBtn"];
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         this.npcIcon = new Sprite();
         this.npcIcon.x = 37;
         this.npcIcon.y = 65;
         this.itemContainer = new Sprite();
         this.itemContainer.x = 170;
         this.itemContainer.y = 78;
         this.bgMC.addChild(this.itemContainer);
         this.bgMC.addChild(this.npcIcon);
      }
      
      public function show() : void
      {
         if(this._info.acceptList.length == 1)
         {
            return;
         }
         LevelManager.appLevel.addChild(this);
      }
      
      public function setInfo(model:NpcModel) : void
      {
         var count:uint;
         var item:TaskListItem = null;
         var i:uint = 0;
         var proStr:String = null;
         var arr:Array = null;
         this.npcModel = model;
         this._info = model.taskInfo;
         this.npcType = model.type;
         if(this._info.acceptList.length == 1)
         {
            item = new TaskListItem(this._info.acceptList[0]);
            if(Boolean(this._info.relateIDs.containsKey(item.id)) || item.id == 4)
            {
               this.npcModel.dispatchEvent(new NpcEvent(NpcEvent.NPC_CLICK,this.npcModel,item.id));
            }
            else if(item.status == TasksManager.ALR_ACCEPT)
            {
               proStr = TasksXMLInfo.getProDes(item.id);
               arr = this.getNpcDialogArr(proStr);
               NpcDialog.show(NpcController.curNpc.npc.id,arr[0],arr[1]);
            }
            else if(TasksXMLInfo.getIsCondition(item.id))
            {
               if(TaskConditionManager.getConditionStep(item.id) == TaskConditionManager.NPC_CLICK)
               {
                  if(TaskConditionManager.conditionTask(item.id,this.npcModel.type))
                  {
                     this.showTaskDes(item.id);
                  }
               }
               else
               {
                  this.showTaskDes(item.id);
               }
            }
            else
            {
               this.showTaskDes(item.id);
            }
            return;
         }
         this.clearOld();
         DisplayUtil.removeAllChild(this.itemContainer);
         DisplayUtil.removeAllChild(this.npcIcon);
         ResourceManager.getResource(ClientConfig.getNpcSwfPath(model.type),function(o:DisplayObject):void
         {
            o.scaleY = 0.6;
            o.scaleX = 0.6;
            npcIcon.addChild(o);
         },"npc");
         this.bgMC["npcNameTxt"].text = model.name;
         count = 0;
         for each(i in this._info.acceptList)
         {
            item = new TaskListItem(i);
            item.buttonMode = true;
            item.y = (item.height + 5) * count;
            item.addEventListener(MouseEvent.CLICK,this.showTaskAlert);
            this.itemContainer.addChild(item);
            this.listArray.push(item);
            count++;
         }
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this);
      }
      
      private function showTaskAlert(event:MouseEvent) : void
      {
         var proStr:String = null;
         var arr:Array = null;
         var item:TaskListItem = event.currentTarget as TaskListItem;
         this.hide();
         if(Boolean(this._info.relateIDs.containsKey(item.id)) || item.id == 4)
         {
            this.npcModel.dispatchEvent(new NpcEvent(NpcEvent.NPC_CLICK,this.npcModel,item.id));
         }
         else if(item.status == TasksManager.ALR_ACCEPT)
         {
            proStr = TasksXMLInfo.getProDes(item.id);
            arr = this.getNpcDialogArr(proStr);
            NpcDialog.show(NpcController.curNpc.npc.id,arr[0],arr[1]);
         }
         else if(TasksXMLInfo.getIsCondition(item.id))
         {
            if(TaskConditionManager.getConditionStep(item.id) == TaskConditionManager.NPC_CLICK)
            {
               if(TaskConditionManager.conditionTask(item.id,this.npcModel.type))
               {
                  this.showTaskDes(item.id);
               }
            }
            else
            {
               this.showTaskDes(item.id);
            }
         }
         else
         {
            this.showTaskDes(item.id);
         }
      }
      
      private function closeHandler(event:MouseEvent) : void
      {
         this.hide();
      }
      
      private function clearOld() : void
      {
         var i:TaskListItem = null;
         for each(i in this.listArray)
         {
            i.removeEventListener(MouseEvent.CLICK,this.showTaskAlert);
         }
         this.listArray = [];
      }
      
      private function showTaskDes(id:uint) : void
      {
         var name:String;
         var array:Array = null;
         var showStep:Function = function():void
         {
            var reg:RegExp = null;
            var str:String = null;
            var npcID:uint = 0;
            var arr:Array = null;
            var npcStr:String = null;
            var eArr:Array = null;
            if(array.length > 1)
            {
               reg = /&[0-9]*&/;
               str = array.shift().toString();
               npcID = uint(NPC.SHIPER);
               if(str.search(reg) != -1)
               {
                  npcStr = str.match(reg)[0];
                  npcID = uint(npcStr.substring(1,npcStr.length - 1));
                  str = str.replace(reg,"");
               }
               else
               {
                  npcID = uint(NpcController.curNpc.npc.id);
               }
               arr = getNpcDialogArr(str);
               NpcDialog.show(npcID,arr[0],arr[1],[function():void
               {
                  showStep();
               }]);
            }
            else
            {
               eArr = getNpcDialogArr(array.shift().toString());
               NpcDialog.show(NpcController.curNpc.npc.id,eArr[0],eArr[1],[function():void
               {
                  if(checkCondition(id))
                  {
                     TasksManager.accept(id,function(b:Boolean):void
                     {
                        var cls:* = undefined;
                        if(b)
                        {
                           TasksManager.setTaskStatus(id,TasksManager.ALR_ACCEPT);
                           NpcController.refreshTaskInfo();
                           cls = getDefinitionByName(PATH + "::TaskController_" + id);
                           cls.start();
                        }
                        else
                        {
                           Alarm.show("接受任务失败，请稍后再试！");
                        }
                     });
                  }
               }]);
            }
         };
         if(TasksXMLInfo.getEspecial(id))
         {
            NpcTaskManager.dispatchEvent(new Event(id.toString()));
            return;
         }
         name = TasksXMLInfo.getName(id);
         array = TasksXMLInfo.getTaskDes(id).split("$$");
         if(TasksXMLInfo.getTaskDes(id) == "")
         {
            this.npcModel.dispatchEvent(new NpcEvent(NpcEvent.TASK_WITHOUT_DES,this.npcModel,id));
            return;
         }
         showStep();
      }
      
      private function getNpcDialogArr(s:String) : Array
      {
         var a:Array = s.split("@");
         var dialogArr:Array = [];
         var questionArr:Array = [];
         dialogArr.push(a[0]);
         questionArr.push(a[1]);
         if(Boolean(a[2]))
         {
            questionArr.push(a[2]);
         }
         return [dialogArr,questionArr];
      }
      
      private function checkCondition(id:uint) : Boolean
      {
         if(TasksXMLInfo.getIsCondition(id))
         {
            if(TaskConditionManager.getConditionStep(id) == TaskConditionManager.BEFOR_ACCEPT)
            {
               return TaskConditionManager.conditionTask(id,this.npcModel.type);
            }
            return true;
         }
         return true;
      }
   }
}

