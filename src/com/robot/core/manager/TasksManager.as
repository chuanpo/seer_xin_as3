package com.robot.core.manager
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.TasksXMLInfo;
   import com.robot.core.event.TaskEvent;
   import com.robot.core.info.task.TaskBufInfo;
   import com.robot.core.info.task.novice.NoviceFinishInfo;
   import com.robot.core.manager.task.TaskInfo;
   import com.robot.core.manager.task.TaskType;
   import com.robot.core.net.SocketLoader;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import flash.utils.getDefinitionByName;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.Utils;
   
   public class TasksManager
   {
      private static var _instance:EventDispatcher;
      
      public static const PATH:String = "com.robot.app.task.tc.TaskClass_";
      
      public static const UN_ACCEPT:uint = 0;
      
      public static const ALR_ACCEPT:uint = 1;
      
      public static const COMPLETE:uint = 3;
      
      public static var taskList:Array = [];
      
      private static var bShowPanel:Boolean = false;
      
      public function TasksManager()
      {
         super();
      }
      
      public static function isParentAccept(id:uint, event:Function) : void
      {
         var pid:uint = 0;
         var pid2:uint = 0;
         var arr:Array = TasksXMLInfo.getParent(id);
         var len:int = int(arr.length);
         if(len == 0)
         {
            event(true);
            return;
         }
         if(TasksXMLInfo.isMat(id))
         {
            for each(pid in arr)
            {
               switch(getTaskStatus(pid))
               {
                  case UN_ACCEPT:
                  case ALR_ACCEPT:
                     event(false);
                     return;
               }
            }
            event(true);
            return;
         }
         for each(pid2 in arr)
         {
            if(getTaskStatus(pid2) == 3)
            {
               event(true);
               return;
            }
         }
         event(false);
      }
      
      private static function getTypeCmd(taskID:uint, arr:Array) : uint
      {
         var tType:uint = TasksXMLInfo.getType(taskID);
         if(tType == TaskType.NORMAL)
         {
            return arr[0];
         }
         if(tType == TaskType.DAILY)
         {
            return arr[1];
         }
         throw new TypeError("任务ID为：" + taskID.toString() + " 的任务类型不正确");
      }
      
      public static function accept(id:uint, event:Function = null) : void
      {
         switch(getTaskStatus(id))
         {
            case UN_ACCEPT:
               isParentAccept(id,function(b:Boolean):void
               {
                  var cmd:uint = 0;
                  var sl:SocketLoader = null;
                  if(b)
                  {
                     cmd = getTypeCmd(id,[CommandID.ACCEPT_TASK,CommandID.ACCEPT_DAILY_TASK]);
                     sl = new SocketLoader(cmd);
                     sl.extData = new TaskInfo(id,0,event);
                     sl.addEventListener(SocketEvent.COMPLETE,onAcceptServer);
                     sl.load(id);
                     return;
                  }
                  if(event != null)
                  {
                     event(false);
                  }
                  dispatchEvent(TaskEvent.ACCEPT,id,0,false);
               });
               return;
            case ALR_ACCEPT:
            case 2:
               isParentAccept(id,function(b:Boolean):void
               {
                  var cmd:uint = 0;
                  var sl:SocketLoader = null;
                  if(b)
                  {
                     cmd = getTypeCmd(id,[CommandID.ACCEPT_TASK,CommandID.ACCEPT_DAILY_TASK]);
                     sl = new SocketLoader(cmd);
                     sl.extData = new TaskInfo(id,0,event);
                     sl.addEventListener(SocketEvent.COMPLETE,onAcceptServer);
                     sl.load(id);
                     return;
                  }
                  if(event != null)
                  {
                     event(false);
                  }
                  dispatchEvent(TaskEvent.ACCEPT,id,0,false);
               });
               return;
            case COMPLETE:
               if(event != null)
               {
                  event(false);
               }
               dispatchEvent(TaskEvent.ACCEPT,id,0,false);
               return;
            default:
               return;
         }
      }
      
      private static function onAcceptServer(e:SocketEvent) : void
      {
         var sl:SocketLoader = e.target as SocketLoader;
         var tInfo:TaskInfo = sl.extData as TaskInfo;
         sl.removeEventListener(SocketEvent.COMPLETE,onAcceptServer);
         sl.destroy();
         setTaskStatus(tInfo.id,ALR_ACCEPT);
         if(tInfo.callback != null)
         {
            tInfo.callback(true);
         }
         dispatchEvent(TaskEvent.ACCEPT,tInfo.id,tInfo.pro,true);
      }
      
      public static function complete(id:uint, pro:uint, event:Function = null, bShowpanel:Boolean = false, outType:uint = 1) : void
      {
         var proLen:int = 0;
         var cmd:uint = 0;
         var sl:SocketLoader = null;
         var tInfo:TaskInfo = null;
         bShowPanel = bShowpanel;
         if(TasksXMLInfo.isDir(id))
         {
            isParentAccept(id,function(b:Boolean):void
            {
               if(b)
               {
                  sendCompleteTask(id,pro,outType,event);
                  return;
               }
               if(event != null)
               {
                  event(false);
               }
               dispatchEvent(TaskEvent.COMPLETE,id,pro,false);
            });
            return;
         }
         switch(getTaskStatus(id))
         {
            case UN_ACCEPT:
               if(event != null)
               {
                  event(false);
               }
               dispatchEvent(TaskEvent.COMPLETE,id,pro,false);
               return;
            case ALR_ACCEPT:
               proLen = TasksXMLInfo.getTaskPorCount(id);
               if(proLen <= 1)
               {
                  sendCompleteTask(id,pro,outType,event);
                  return;
               }
               if(pro >= proLen)
               {
                  pro = uint(proLen - 1);
               }
               cmd = getTypeCmd(id,[CommandID.GET_TASK_BUF,CommandID.GET_DAILY_TASK_BUF]);
               sl = new SocketLoader(cmd);
               tInfo = new TaskInfo(id,pro,event);
               tInfo.outType = outType;
               sl.extData = tInfo;
               sl.addEventListener(SocketEvent.COMPLETE,onGetCompServer);
               sl.load(id);
               return;
               break;
            case COMPLETE:
               if(event != null)
               {
                  event(false);
               }
               dispatchEvent(TaskEvent.COMPLETE,id,pro,false);
               return;
            default:
               return;
         }
      }
      
      private static function onGetCompServer(e:SocketEvent) : void
      {
         var k:int = 0;
         var pid:uint = 0;
         var pid2:uint = 0;
         var sl:SocketLoader = e.target as SocketLoader;
         var tInfo:TaskInfo = sl.extData as TaskInfo;
         var id:uint = tInfo.id;
         var pro:uint = tInfo.pro;
         var outType:uint = tInfo.outType;
         sl.removeEventListener(SocketEvent.COMPLETE,onGetCompServer);
         sl.destroy();
         var info:TaskBufInfo = e.data as TaskBufInfo;
         var epro:uint = pro;
         info.buf.position = pro;
         if(info.buf.readBoolean())
         {
            if(tInfo.callback != null)
            {
               tInfo.callback(false);
            }
            dispatchEvent(TaskEvent.COMPLETE,info.taskId,pro,false);
            return;
         }
         var porCount:int = TasksXMLInfo.getTaskPorCount(id);
         var isAllCom:Boolean = true;
         for(var j:int = 0; j < porCount; j++)
         {
            if(j != pro)
            {
               info.buf.position = j;
               if(!info.buf.readBoolean())
               {
                  isAllCom = false;
                  break;
               }
            }
         }
         if(TasksXMLInfo.isEnd(id))
         {
            if(epro == porCount - 1)
            {
               isAllCom = true;
            }
         }
         if(isAllCom)
         {
            sendCompleteTask(id,pro,outType,tInfo.callback);
            return;
         }
         var isCanPro:Boolean = true;
         var arr:Array = TasksXMLInfo.getProParent(id,pro);
         var len:int = int(arr.length);
         if(len == 0)
         {
            if(!TasksXMLInfo.isProMat(id,pro))
            {
               sendCompletePro(id,pro,info.buf,tInfo.callback);
               return;
            }
            for(k = 0; k < pro; k++)
            {
               info.buf.position = k;
               if(!info.buf.readBoolean())
               {
                  isCanPro = false;
                  break;
               }
            }
         }
         else if(TasksXMLInfo.isProMat(id,pro))
         {
            for each(pid in arr)
            {
               info.buf.position = pid;
               if(!info.buf.readBoolean())
               {
                  isCanPro = false;
                  break;
               }
            }
         }
         else
         {
            isCanPro = false;
            for each(pid2 in arr)
            {
               info.buf.position = pid2;
               if(info.buf.readBoolean())
               {
                  isCanPro = true;
                  break;
               }
            }
         }
         if(isCanPro)
         {
            sendCompletePro(id,pro,info.buf,tInfo.callback);
         }
         else
         {
            if(tInfo.callback != null)
            {
               tInfo.callback(false);
            }
            dispatchEvent(TaskEvent.COMPLETE,id,pro,false);
         }
      }
      
      public static function quit(id:uint, event:Function = null) : void
      {
         var cmd:uint = 0;
         var sl:SocketLoader = null;
         if(getTaskStatus(id) == 1)
         {
            cmd = getTypeCmd(id,[CommandID.DELETE_TASK,CommandID.DELETE_DAILY_TASK]);
            sl = new SocketLoader(cmd);
            sl.extData = new TaskInfo(id,0,event);
            sl.addEventListener(SocketEvent.COMPLETE,onQuitServer);
            sl.load(id);
            return;
         }
         if(event != null)
         {
            event(false);
         }
         dispatchEvent(TaskEvent.QUIT,id,0,false);
      }
      
      private static function onQuitServer(e:SocketEvent) : void
      {
         var sl:SocketLoader = e.target as SocketLoader;
         var tInfo:TaskInfo = sl.extData as TaskInfo;
         sl.removeEventListener(SocketEvent.COMPLETE,onQuitServer);
         sl.destroy();
         setTaskStatus(tInfo.id,UN_ACCEPT);
         if(tInfo.callback != null)
         {
            tInfo.callback(true);
         }
         dispatchEvent(TaskEvent.QUIT,tInfo.id,tInfo.pro,true);
      }
      
      public static function getTaskStatus(id:uint) : uint
      {
         if(id < 1)
         {
            id = 1;
         }
         return taskList[id - 1];
      }
      
      public static function setTaskStatus(id:uint, status:uint) : void
      {
         taskList[id - 1] = status;
      }
      
      public static function getProStatus(id:uint, pro:uint, event:Function = null) : void
      {
         var state:uint = getTaskStatus(id);
         if(state == UN_ACCEPT || state == COMPLETE)
         {
            if(event != null)
            {
               event(false);
            }
            dispatchEvent(TaskEvent.GET_PRO_STATUS,id,pro,false);
            return;
         }
         var cmd:uint = getTypeCmd(id,[CommandID.GET_TASK_BUF,CommandID.GET_DAILY_TASK_BUF]);
         var sl:SocketLoader = new SocketLoader(cmd);
         sl.extData = new TaskInfo(id,pro,event);
         sl.addEventListener(SocketEvent.COMPLETE,onGetProServer);
         sl.load(id);
      }
      
      private static function onGetProServer(e:SocketEvent) : void
      {
         var sl:SocketLoader = e.target as SocketLoader;
         var tInfo:TaskInfo = sl.extData as TaskInfo;
         sl.removeEventListener(SocketEvent.COMPLETE,onGetProServer);
         sl.destroy();
         var info:TaskBufInfo = e.data as TaskBufInfo;
         info.buf.position = tInfo.pro;
         var b:Boolean = info.buf.readBoolean();
         if(tInfo.callback != null)
         {
            tInfo.callback(b);
         }
         dispatchEvent(TaskEvent.GET_PRO_STATUS,tInfo.id,tInfo.pro,b);
      }
      
      public static function setProStatus(id:uint, pro:uint, status:Boolean, event:Function = null) : void
      {
         var state:uint = getTaskStatus(id);
         if(state == UN_ACCEPT)
         {
            if(event != null)
            {
               event(false);
            }
            dispatchEvent(TaskEvent.SET_PRO_STATUS,id,pro,false);
            return;
         }
         var cmd:uint = getTypeCmd(id,[CommandID.GET_TASK_BUF,CommandID.GET_DAILY_TASK_BUF]);
         var sl:SocketLoader = new SocketLoader(cmd);
         var tInfo:TaskInfo = new TaskInfo(id,pro,event);
         tInfo.status = status;
         sl.extData = tInfo;
         sl.addEventListener(SocketEvent.COMPLETE,onSetProServer);
         sl.load(id);
      }
      
      private static function onSetProServer(e:SocketEvent) : void
      {
         var sl:SocketLoader = e.target as SocketLoader;
         var tInfo:TaskInfo = sl.extData as TaskInfo;
         sl.removeEventListener(SocketEvent.COMPLETE,onSetProServer);
         sl.destroy();
         var info:TaskBufInfo = e.data as TaskBufInfo;
         sendCompletePro(tInfo.id,tInfo.pro,info.buf,tInfo.callback,tInfo.status,false);
      }
      
      public static function getProStatusList(id:uint, event:Function = null) : void
      {
         var state:uint = getTaskStatus(id);
         if(state == UN_ACCEPT)
         {
            if(event != null)
            {
               event([]);
            }
            dispatchEvent(TaskEvent.GET_PRO_STATUS_LIST,id,0,false);
            return;
         }
         var cmd:uint = getTypeCmd(id,[CommandID.GET_TASK_BUF,CommandID.GET_DAILY_TASK_BUF]);
         var sl:SocketLoader = new SocketLoader(cmd);
         sl.extData = new TaskInfo(id,0,event);
         sl.addEventListener(SocketEvent.COMPLETE,onGetProListServer);
         sl.load(id);
      }
      
      private static function onGetProListServer(e:SocketEvent) : void
      {
         var sl:SocketLoader = e.target as SocketLoader;
         var tInfo:TaskInfo = sl.extData as TaskInfo;
         sl.removeEventListener(SocketEvent.COMPLETE,onGetProListServer);
         sl.destroy();
         var info:TaskBufInfo = e.data as TaskBufInfo;
         var arr:Array = [];
         var len:int = TasksXMLInfo.getTaskPorCount(info.taskId);
         for(var i:int = 0; i < len; i++)
         {
            info.buf.position = i;
            arr[i] = info.buf.readBoolean();
         }
         if(tInfo.callback != null)
         {
            tInfo.callback(arr);
         }
         dispatchEvent(TaskEvent.GET_PRO_STATUS_LIST,tInfo.id,tInfo.pro,true,arr);
      }
      
      private static function sendCompleteTask(id:uint, pro:uint, outType:uint, event:Function) : void
      {
         var cmd:uint = getTypeCmd(id,[CommandID.COMPLETE_TASK,CommandID.COMPLETE_DAILY_TASK]);
         var sl:SocketLoader = new SocketLoader(cmd);
         var tInfo:TaskInfo = new TaskInfo(id,pro,event);
         tInfo.outType = outType;
         sl.extData = tInfo;
         sl.addEventListener(SocketEvent.COMPLETE,onCompleteTaskServer);
         sl.load(id,outType);
      }
      
      private static function onCompleteTaskServer(e:SocketEvent) : void
      {
         var sl:SocketLoader = e.target as SocketLoader;
         var tInfo:TaskInfo = sl.extData as TaskInfo;
         sl.removeEventListener(SocketEvent.COMPLETE,onCompleteTaskServer);
         sl.destroy();
         var info:NoviceFinishInfo = e.data as NoviceFinishInfo;
         setTaskStatus(info.taskID,COMPLETE);
         if(tInfo.callback != null)
         {
            tInfo.callback(true);
         }
         dispatchEvent(TaskEvent.COMPLETE,tInfo.id,tInfo.pro,true);
      }
      
      private static function sendCompletePro(id:uint, pro:uint, buf:ByteArray, event:Function = null, status:Boolean = true, isCom:Boolean = true) : void
      {
         buf.position = pro;
         buf.writeBoolean(status);
         var cmd:uint = getTypeCmd(id,[CommandID.ADD_TASK_BUF,CommandID.ADD_DAILY_TASK_BUF]);
         var sl:SocketLoader = new SocketLoader(cmd);
         var tInfo:TaskInfo = new TaskInfo(id,pro,event);
         tInfo.status = status;
         tInfo.isComplete = isCom;
         sl.extData = tInfo;
         sl.addEventListener(SocketEvent.COMPLETE,onCompleteProServer);
         sl.load(id,buf);
      }
      
      private static function onCompleteProServer(e:SocketEvent) : void
      {
         var cla:Class = null;
         var p:String = null;
         var cl:Object = null;
         var sl:SocketLoader = e.target as SocketLoader;
         var tInfo:TaskInfo = sl.extData as TaskInfo;
         sl.removeEventListener(SocketEvent.COMPLETE,onCompleteProServer);
         sl.destroy();
         if(tInfo.callback != null)
         {
            tInfo.callback(true);
         }
         if(tInfo.isComplete)
         {
            dispatchEvent(TaskEvent.COMPLETE,tInfo.id,tInfo.pro,true);
            cla = Utils.getClass(PATH + tInfo.id.toString() + "_" + tInfo.pro.toString());
            if(Boolean(cla))
            {
               new cla();
            }
         }
         else
         {
            dispatchEvent(TaskEvent.SET_PRO_STATUS,tInfo.id,tInfo.pro,true);
         }
         if(bShowPanel)
         {
            try
            {
               p = "com.robot.app.task.control.TaskController_" + tInfo.id;
               cl = getDefinitionByName(p) as Class;
               cl.showPanel();
               bShowPanel = false;
            }
            catch(e:Error)
            {
               trace("error==/==" + e.message);
            }
         }
      }
      
      public static function isComNoviceTask() : Boolean
      {
         var b1:Boolean = false;
         if(MainManager.checkIsNovice())
         {
            if(TasksManager.getTaskStatus(88) == TasksManager.COMPLETE)
            {
               b1 = true;
            }
         }
         else if(TasksManager.getTaskStatus(4) == TasksManager.COMPLETE)
         {
            b1 = true;
         }
         return b1;
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(_instance == null)
         {
            _instance = new EventDispatcher();
         }
         return _instance;
      }
      
      public static function addListener(actType:String, id:uint, pro:uint, listener:Function) : void
      {
         if(getTaskStatus(id) == COMPLETE)
         {
            return;
         }
         getInstance().addEventListener(actType + "_" + id.toString() + "_" + pro.toString(),listener);
      }
      
      public static function removeListener(actType:String, id:uint, pro:uint, listener:Function) : void
      {
         getInstance().removeEventListener(actType + "_" + id.toString() + "_" + pro.toString(),listener);
      }
      
      public static function dispatchEvent(actType:String, id:uint, pro:uint, flag:Boolean, data:Array = null) : void
      {
         if(hasListener(actType,id,pro))
         {
            getInstance().dispatchEvent(new TaskEvent(actType,id,pro,flag,data));
         }
      }
      
      public static function hasListener(actType:String, id:uint, pro:uint) : Boolean
      {
         return getInstance().hasEventListener(actType + "_" + id.toString() + "_" + pro.toString());
      }
   }
}

