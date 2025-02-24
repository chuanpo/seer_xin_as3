package com.robot.core.info
{
   import com.robot.core.config.xml.TasksXMLInfo;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.mode.NpcModel;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import org.taomee.ds.HashMap;
   
   [Event(name="showYellowExcal",type="com.robot.core.taskSys.TaskInfo")]
   [Event(name="showBlueQuestion",type="com.robot.core.taskSys.TaskInfo")]
   [Event(name="showYellowQuestion",type="com.robot.core.taskSys.TaskInfo")]
   public class NpcTaskInfo extends EventDispatcher
   {
      public static const SHOW_YELLOW_QUESTION:String = "showYellowQuestion";
      
      public static const SHOW_BLUE_QUESTION:String = "showBlueQuestion";
      
      public static const SHOW_YELLOW_EXCAL:String = "showYellowExcal";
      
      private var tasks:Array = [];
      
      private var _acceptList:Array = [];
      
      private var endIDs:Array = [];
      
      private var proIDs:Array = [];
      
      private var canCompleteIDs:Array = [];
      
      private var model:NpcModel;
      
      private var alAcceptIDs:Array = [];
      
      private var alAcceptIndex:uint;
      
      private var _isRelate:Boolean;
      
      private var _relateIDs:HashMap = new HashMap();
      
      private var queueNum:uint = 0;
      
      private var isQueue:Boolean = false;
      
      public function NpcTaskInfo(bindIDs:Array, endIDs:Array, proIDs:Array, model:NpcModel)
      {
         super();
         this.model = model;
         this.tasks = bindIDs.slice();
         this.endIDs = endIDs.slice();
         this.proIDs = proIDs.slice();
         this.alAcceptIndex = 0;
         this.canCompleteIDs = [];
      }
      
      public function refresh() : void
      {
         trace(">>>>>>>>>>>> npc refresh");
         ++this.queueNum;
         this.checkQueue();
      }
      
      private function checkQueue() : void
      {
         if(this.queueNum > 0 && !this.isQueue)
         {
            this.isQueue = true;
            --this.queueNum;
            trace(">>>>>>>>>>>> queue start");
            this.alAcceptIndex = 0;
            this.canCompleteIDs = [];
            this._acceptList = [];
            this.alAcceptIDs = [];
            this._relateIDs = new HashMap();
            this.checkTaskStatus();
         }
      }
      
      public function destroy() : void
      {
         this.model = null;
      }
      
      public function checkTaskStatus() : void
      {
         var i:uint = 0;
         var index:int = 0;
         this.initAcceptList();
         this._isRelate = false;
         if(this.proIDs.indexOf(0) != -1 && TasksManager.getTaskStatus(4) != TasksManager.COMPLETE)
         {
            this._relateIDs.add(4,4);
            this._isRelate = true;
         }
         else
         {
            for(i = 1; i < TasksManager.taskList.length + 1; i++)
            {
               if(TasksManager.getTaskStatus(i) == TasksManager.ALR_ACCEPT)
               {
                  index = int(this.proIDs.indexOf(i));
                  if(index != -1 || i <= 4)
                  {
                     this._relateIDs.add(i,i);
                     this._isRelate = true;
                  }
               }
            }
         }
         for each(i in this.tasks)
         {
            if(TasksManager.getTaskStatus(i) == TasksManager.COMPLETE)
            {
               index = int(this.tasks.indexOf(i));
               if(index != -1)
               {
                  this.tasks.splice(index,1);
               }
            }
         }
         for each(i in this.endIDs)
         {
            if(TasksManager.getTaskStatus(i) == TasksManager.ALR_ACCEPT)
            {
               this.alAcceptIDs.push(i);
            }
         }
         if(this.alAcceptIDs.length > 0)
         {
            this.checkAlrAcceptProStatus();
         }
         else
         {
            if(this._acceptList.length > 0)
            {
               this.showYellowExcalMark();
            }
            this.isQueue = false;
            this.checkQueue();
            trace(">>>>>>>>>>>> queue finish");
         }
      }
      
      private function checkAlrAcceptProStatus() : void
      {
         if(this.alAcceptIndex == this.alAcceptIDs.length)
         {
            this.onCheckAlrAcceptTask();
            this.isQueue = false;
            this.checkQueue();
            trace(">>>>>>>>>>>> queue finish");
            return;
         }
         var id:uint = uint(this.alAcceptIDs[this.alAcceptIndex]);
         TasksManager.getProStatusList(id,this.onGetBuff);
      }
      
      private function onGetBuff(array:Array) : void
      {
         var i:Boolean = false;
         var id:uint = uint(this.alAcceptIDs[this.alAcceptIndex]);
         array.pop();
         var b:Boolean = true;
         for each(i in array)
         {
            if(i == false)
            {
               b = false;
               break;
            }
         }
         if(b && id != 25)
         {
            this.canCompleteIDs.push(id);
         }
         ++this.alAcceptIndex;
         this.checkAlrAcceptProStatus();
      }
      
      private function onCheckAlrAcceptTask() : void
      {
         if(this.canCompleteIDs.length > 0)
         {
            this.showYellowQuestionMark();
         }
         else
         {
            this.showBlueQuestionMark();
         }
      }
      
      private function initAcceptList() : void
      {
         var i:uint = 0;
         var array:Array = null;
         var b:Boolean = false;
         var j:uint = 0;
         this._acceptList = [];
         for each(i in this.tasks)
         {
            if(TasksManager.getTaskStatus(i) != TasksManager.COMPLETE)
            {
               array = TasksXMLInfo.getParent(i);
               b = true;
               for each(j in array)
               {
                  if(TasksManager.getTaskStatus(j) != TasksManager.COMPLETE)
                  {
                     b = false;
                     break;
                  }
               }
               if(b)
               {
                  this._acceptList.push(i);
               }
            }
         }
      }
      
      private function getNpcIndex(id:uint) : uint
      {
         var index:uint = 0;
         switch(id)
         {
            case 1:
               index = 0;
               break;
            case 2:
               index = 5;
               break;
            case 3:
               index = 2;
               break;
            case 4:
               index = 6;
               break;
            case 5:
               index = 1;
               break;
            case 6:
               index = 4;
               break;
            case 8:
               index = 7;
               break;
            case 10:
               index = 3;
               break;
            default:
               index = 9;
         }
         return index;
      }
      
      private function showYellowExcalMark() : void
      {
         trace("-------------------Task Info::yellow excal mark");
         if(!this.isQueue || this.queueNum == 0)
         {
            dispatchEvent(new Event(SHOW_YELLOW_EXCAL));
         }
      }
      
      private function showYellowQuestionMark() : void
      {
         trace("-------------------Task Info::yellow question mark");
         if(!this.isQueue || this.queueNum == 0)
         {
            dispatchEvent(new Event(SHOW_YELLOW_QUESTION));
         }
      }
      
      private function showBlueQuestionMark() : void
      {
         trace("-------------------Task Info::blue question mark");
         if(!this.isQueue || this.queueNum == 0)
         {
            dispatchEvent(new Event(SHOW_BLUE_QUESTION));
         }
      }
      
      public function get taskIDList() : Array
      {
         return this.tasks;
      }
      
      public function get acceptList() : Array
      {
         var i:uint = 0;
         var showArray:Array = this._acceptList.slice();
         for each(i in this.proIDs)
         {
            if(TasksManager.getTaskStatus(i) == TasksManager.ALR_ACCEPT)
            {
               if(i == 1 || i == 2 || i == 3 || i == 4)
               {
                  i = 4;
               }
               if(showArray.indexOf(i) == -1)
               {
                  showArray.push(i);
               }
            }
         }
         return showArray;
      }
      
      public function get proList() : Array
      {
         return this.proIDs;
      }
      
      public function get completeList() : Array
      {
         return this.canCompleteIDs;
      }
      
      public function get alreadAcceptList() : Array
      {
         return this.alAcceptIDs;
      }
      
      public function get isRelateTask() : Boolean
      {
         return this._isRelate;
      }
      
      public function get relateIDs() : HashMap
      {
         return this._relateIDs;
      }
   }
}

