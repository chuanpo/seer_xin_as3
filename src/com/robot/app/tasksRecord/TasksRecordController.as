package com.robot.app.tasksRecord
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.TasksRecordEvent;
   import com.robot.core.manager.SOManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.mode.AppModel;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   import flash.net.SharedObject;
   import org.taomee.ds.HashMap;
   import org.taomee.manager.ToolTipManager;
   
   public class TasksRecordController
   {
      private static var _allIdA:Array;
      
      private static var _icon:MovieClip;
      
      private static var _so:SharedObject;
      
      private static var _taskMainPanel:AppModel;
      
      private static var _normalMap:HashMap = new HashMap();
      
      private static var _superMap:HashMap = new HashMap();
      
      private static var _specialSupMap:HashMap = new HashMap();
      
      private static var _specialNorMap:HashMap = new HashMap();
      
      public function TasksRecordController()
      {
         super();
      }
      
      public static function setup() : void
      {
         _allIdA = TasksRecordConfig.getAllTasksId();
         makeData();
         addIcon();
      }
      
      private static function onHideHandler(e:TasksRecordEvent) : void
      {
         if(Boolean(_taskMainPanel))
         {
            _taskMainPanel.hide();
         }
      }
      
      private static function onTaskIntroductionHandler(e:TasksRecordEvent) : void
      {
         if(Boolean(_taskMainPanel))
         {
            _taskMainPanel.hide();
         }
      }
      
      private static function onTasksListHandler(e:TasksRecordEvent) : void
      {
         showListPanel();
      }
      
      private static function makeData() : void
      {
         var taskInfo:TaskRecordInfo = null;
         var tt1:uint = 0;
         var tt:uint = 0;
         _specialSupMap = new HashMap();
         _specialNorMap = new HashMap();
         _superMap = new HashMap();
         _normalMap = new HashMap();
         for(var i1:int = 0; i1 < _allIdA.length; i1++)
         {
            taskInfo = new TaskRecordInfo(_allIdA[i1]);
            if(taskInfo.type == 1)
            {
               if(taskInfo.offLine)
               {
                  _specialSupMap.add(taskInfo.onlineData,taskInfo);
                  if(taskInfo.isVip == false)
                  {
                     _specialNorMap.add(taskInfo.onlineData,taskInfo);
                  }
               }
               else
               {
                  tt1 = TasksRecordConfig.getParentId(taskInfo.taskId);
                  if(tt1 != 0)
                  {
                     if(TasksManager.getTaskStatus(TasksRecordConfig.getParentId(taskInfo.taskId)) == TasksManager.COMPLETE)
                     {
                        _specialSupMap.add(taskInfo.onlineData,taskInfo);
                        if(taskInfo.isVip == false)
                        {
                           _specialNorMap.add(taskInfo.onlineData,taskInfo);
                        }
                     }
                  }
                  else
                  {
                     _specialSupMap.add(taskInfo.onlineData,taskInfo);
                     if(taskInfo.isVip == false)
                     {
                        _specialNorMap.add(taskInfo.onlineData,taskInfo);
                     }
                  }
               }
            }
            else if(taskInfo.offLine)
            {
               _superMap.add(taskInfo.onlineData,taskInfo);
               if(taskInfo.isVip == false)
               {
                  _normalMap.add(taskInfo.onlineData,taskInfo);
               }
            }
            else
            {
               tt = TasksRecordConfig.getParentId(taskInfo.taskId);
               if(tt != 0)
               {
                  if(TasksManager.getTaskStatus(tt) == TasksManager.COMPLETE)
                  {
                     _superMap.add(taskInfo.onlineData,taskInfo);
                     if(taskInfo.isVip == false)
                     {
                        _normalMap.add(taskInfo.onlineData,taskInfo);
                     }
                  }
               }
               else
               {
                  _superMap.add(taskInfo.onlineData,taskInfo);
                  if(taskInfo.isVip == false)
                  {
                     _normalMap.add(taskInfo.onlineData,taskInfo);
                  }
               }
            }
         }
      }
      
      public static function get normalMap() : HashMap
      {
         makeData();
         return _normalMap;
      }
      
      public static function get superMap() : HashMap
      {
         makeData();
         return _superMap;
      }
      
      public static function get specialSupMap() : HashMap
      {
         makeData();
         return _specialSupMap;
      }
      
      public static function get specialNorMap() : HashMap
      {
         makeData();
         return _specialNorMap;
      }
      
      public static function addIcon() : void
      {
         _icon = TaskIconManager.getIcon("TaskMainIcon") as MovieClip;
         _so = SOManager.getUserSO(SOManager.TASK_RECORD);
         if(!_so.data.hasOwnProperty("isShow"))
         {
            _so.data["isShow"] = false;
            SOManager.flush(_so);
         }
         else if(_so.data["isShow"] == true)
         {
            _icon["mc"].gotoAndStop(1);
            _icon["mc"].visible = false;
         }
         TaskIconManager.addIcon(_icon);
         ToolTipManager.add(_icon,"赛尔任务档案");
         _icon.addEventListener(MouseEvent.CLICK,onIconClickHandler);
      }
      
      private static function onIconClickHandler(e:MouseEvent) : void
      {
         if(!TasksManager.isComNoviceTask())
         {
            Alarm.show("您还没有做完新船员任务，快去" + TextFormatUtil.getRedTxt("机械室") + "找" + TextFormatUtil.getRedTxt("茜茜吧！"));
         }
         else
         {
            _so.data["isShow"] = true;
            SOManager.flush(_so);
            _icon["mc"].gotoAndStop(1);
            _icon["mc"].visible = false;
            showListPanel();
         }
      }
      
      public static function showListPanel() : void
      {
         if(!_taskMainPanel)
         {
            _taskMainPanel = new AppModel(ClientConfig.getAppModule("TasksRecordPanel"),"正在打开");
            _taskMainPanel.setup();
         }
         _taskMainPanel.show();
      }
   }
}

