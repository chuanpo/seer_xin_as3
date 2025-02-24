package com.robot.app.task.taskProStep
{
   import com.robot.app.fightNote.FightInviteManager;
   import com.robot.app.task.control.TasksController;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.app.tasksRecord.TasksRecordConfig;
   import com.robot.core.animate.AnimateManager;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.GamePlatformEvent;
   import com.robot.core.event.MapEvent;
   import com.robot.core.event.PetFightEvent;
   import com.robot.core.info.fightInfo.attack.FightOverInfo;
   import com.robot.core.manager.GamePlatformManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.map.config.MapProcessConfig;
   import com.robot.core.mode.AppModel;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.MouseEvent;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import org.taomee.ds.HashMap;
   import org.taomee.events.DynamicEvent;
   import org.taomee.manager.EventManager;
   
   public class TaskStepManager
   {
      private static var panel:AppModel;
      
      public static var taskStepMap:HashMap = new HashMap();
      
      public static var stepMap:HashMap = new HashMap();
      
      public static var optionID:uint = 0;
      
      private static var taskList:Array = [];
      
      private static var PATH:String = "resource/task/xml/task_";
      
      private static var taskCnt:uint = 0;
      
      private static var taskMapList:Array = [];
      
      private static var count:uint = 0;
      
      private static var isNowAccept:Boolean = false;
      
      public function TaskStepManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         var id:uint = 0;
         var i:uint = 0;
         var taskArr:Array = [];
         for each(id in TasksRecordConfig.getAllTasksId())
         {
            if(!TasksRecordConfig.getTaskOffLineForId(id))
            {
               taskArr.push(id);
            }
         }
         for each(i in taskArr)
         {
            if(TasksManager.getTaskStatus(i) == TasksManager.ALR_ACCEPT)
            {
               loadTaskStepXml(i);
               taskList.push(i);
            }
         }
      }
      
      public static function addTaskStepMap(taskID:uint, stepXML:XML) : void
      {
         taskStepMap.add(taskID,stepXML);
      }
      
      public static function removeTaskStepMap(taskID:uint) : void
      {
         taskStepMap.remove(taskID);
      }
      
      public static function loadTaskStepXml(taskID:uint, isNowAcpt:Boolean = false) : void
      {
         var url:String = PATH + taskID + ".xml";
         var req:URLRequest = new URLRequest(url);
         var urlLoader:URLLoader = new URLLoader();
         urlLoader.addEventListener(Event.COMPLETE,onLoadedXML(taskID));
         urlLoader.addEventListener(IOErrorEvent.IO_ERROR,onIOError);
         urlLoader.load(req);
         isNowAccept = isNowAcpt;
      }
      
      private static function onLoadedXML(taskID:uint) : Function
      {
         var func:Function = function(evt:Event):void
         {
            var loader:URLLoader = evt.currentTarget as URLLoader;
            var xml:XML = XML(loader.data);
            if(!taskStepMap.containsKey(taskID))
            {
               taskStepMap.add(taskID,xml);
            }
            ++taskCnt;
            if(isNowAccept)
            {
               setupTask();
            }
            else if(taskCnt == taskList.length)
            {
               setupTask();
               taskCnt = 0;
            }
         };
         return func;
      }
      
      private static function onIOError(evt:IOErrorEvent) : void
      {
         throw new Error(evt.text);
      }
      
      private static function setupTask() : void
      {
         var tasksArr:Array = null;
         var index:uint = 0;
         var addTaskStepInfo:Function = function(id:uint):void
         {
            TasksManager.getProStatusList(id,function(arr:Array):void
            {
               var i:uint = 0;
               var mapID:uint = 0;
               var stepXml:XML = null;
               var info:TaskStepInfo = null;
               while(i < arr.length)
               {
                  if(arr[i] == false)
                  {
                     TaskStepXMLInfo.setup(taskStepMap.getValue(id));
                     mapID = TaskStepXMLInfo.getProMapID(i);
                     stepXml = TaskStepXMLInfo.getStepXML(i,0);
                     info = new TaskStepInfo(id,i,mapID,stepXml);
                     if(!stepMap.containsKey(id))
                     {
                        stepMap.add(id,info);
                     }
                     ++count;
                     if(count == taskList.length)
                     {
                        MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,onChangeMap);
                        count = 0;
                     }
                     ++index;
                     if(index == tasksArr.length)
                     {
                        return;
                     }
                     addTaskStepInfo(tasksArr[index]);
                     if(mapID == 0 || stepXml == null)
                     {
                        trace(id + "号任务第" + i + "步配置有错误,请检查!");
                     }
                     break;
                  }
                  i++;
               }
            });
         };
         tasksArr = taskStepMap.getKeys();
         index = 0;
         if(taskStepMap.length > 0)
         {
            addTaskStepInfo(tasksArr[index]);
         }
      }
      
      private static function onChangeMap(evt:MapEvent) : void
      {
         var info:TaskStepInfo = null;
         var curtMapID:uint = uint(evt.mapModel.id);
         for each(info in stepMap.getValues())
         {
            if(curtMapID == info.mapID)
            {
               startDoTask(info);
            }
         }
      }
      
      public static function doTaskProStep(taskID:uint, pro:uint, step:uint) : void
      {
         TaskStepXMLInfo.setup(taskStepMap.getValue(taskID));
         var mapID:uint = TaskStepXMLInfo.getProMapID(pro);
         var stepXml:XML = TaskStepXMLInfo.getStepXML(pro,step);
         var info:TaskStepInfo = new TaskStepInfo(taskID,pro,mapID,stepXml);
         startDoTask(info);
      }
      
      private static function startDoTask(info:TaskStepInfo) : void
      {
         TaskStepXMLInfo.setup(taskStepMap.getValue(info.taskID));
         var stepXml:XML = TaskStepXMLInfo.getStepXML(info.pro,info.stepID);
         trace(stepXml.toXMLString());
         switch(info.stepType)
         {
            case 0:
               chooseOptions(info);
               break;
            case 1:
               talkWithNpc(info);
               break;
            case 2:
               playSceenMovie(info);
               break;
            case 3:
               playFullMovie(info);
               break;
            case 4:
               game(info);
               break;
            case 5:
               fight(info);
               break;
            case 6:
               showPanel(info);
               break;
            case 7:
               mcAction(info);
         }
      }
      
      private static function chooseOptions(info:TaskStepInfo) : void
      {
         TaskStepXMLInfo.setup(taskStepMap.getValue(info.taskID));
         var optionCnt:uint = TaskStepXMLInfo.getStepOptionCnt(info.pro,info.stepID);
         var optionGoto:Array = TaskStepXMLInfo.getStepOptionGoto(info.pro,info.stepID,optionID);
         var optionDes:String = TaskStepXMLInfo.getStepOptionDes(info.pro,info.stepID,optionID);
         var pro:uint = uint(optionGoto[0]);
         var step:uint = uint(optionGoto[1]);
         var xml:XML = TaskStepXMLInfo.getStepXML(pro,step);
         var mapID:uint = TaskStepXMLInfo.getProMapID(pro);
         var i:TaskStepInfo = new TaskStepInfo(info.taskID,pro,mapID,xml);
         startDoTask(i);
      }
      
      private static function talkWithNpc(info:TaskStepInfo) : void
      {
         var talkMcName:String;
         var talkMc:MovieClip;
         var npcName:String = null;
         var array:Array = null;
         var func:String = null;
         var showStep:Function = function():void
         {
            var reg:RegExp = null;
            var str:String = null;
            var npcStr:String = null;
            var tempstr:String = null;
            if(array.length > 1)
            {
               reg = /&[a-zA-Z][a-zA-Z0-9_]*&/;
               str = array.shift().toString();
               if(str.search(reg) != -1)
               {
                  npcStr = str.match(reg)[0].toString();
                  tempstr = str.replace(reg,"");
                  NpcTipDialog.show(tempstr,function():void
                  {
                     showStep();
                  },npcStr.substring(1,npcStr.length - 1));
               }
               else
               {
                  NpcTipDialog.show(str,function():void
                  {
                     showStep();
                  },npcName);
               }
            }
            else
            {
               NpcTipDialog.show(array.shift().toString(),function():void
               {
                  checkStep(info,func);
               },npcName);
            }
         };
         TaskStepXMLInfo.setup(taskStepMap.getValue(info.taskID));
         npcName = TaskStepXMLInfo.getStepTalkNpc(info.pro,info.stepID);
         talkMcName = TaskStepXMLInfo.getStepTalkMC(info.pro,info.stepID);
         talkMc = MapManager.currentMap.depthLevel.getChildByName(talkMcName) as MovieClip;
         array = TaskStepXMLInfo.getStepTalkDes(info.pro,info.stepID).split("$$");
         func = TaskStepXMLInfo.getStepTalkFunc(info.pro,info.stepID);
         if(Boolean(talkMc))
         {
            talkMc.buttonMode = true;
            talkMc.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent):void
            {
               showStep();
            });
         }
         else
         {
            showStep();
         }
      }
      
      private static function playSceenMovie(info:TaskStepInfo) : void
      {
         var sparkMC:MovieClip = null;
         var sceneMC:MovieClip = null;
         var frame:uint = 0;
         var childMcName:String = null;
         var func:String = null;
         var next:Function = function():void
         {
            checkStep(info,func);
         };
         TaskStepXMLInfo.setup(taskStepMap.getValue(info.taskID));
         sparkMC = MapManager.currentMap.controlLevel.getChildByName(TaskStepXMLInfo.getStepSmSparkMC(info.pro,info.stepID)) as MovieClip;
         sceneMC = MapManager.currentMap.animatorLevel.getChildByName(TaskStepXMLInfo.getStepSmPlaySceenMC(info.pro,info.stepID)) as MovieClip;
         frame = TaskStepXMLInfo.getStepSmPlayMcFrame(info.pro,info.stepID);
         childMcName = TaskStepXMLInfo.getStepSmPlayMcChild(info.pro,info.stepID);
         func = TaskStepXMLInfo.getStepSmFunc(info.pro,info.stepID);
         if(Boolean(sparkMC))
         {
            sparkMC.buttonMode = true;
            sparkMC.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent):void
            {
               sparkMC.buttonMode = false;
               sparkMC.removeEventListener(MouseEvent.CLICK,arguments.callee);
               if(sceneMC != null && frame != 0)
               {
                  AnimateManager.playMcAnimate(sceneMC,frame,childMcName,function():void
                  {
                     next();
                  });
               }
            });
         }
         else if(sceneMC != null && frame != 0)
         {
            if(childMcName != "" && childMcName != null)
            {
               AnimateManager.playMcAnimate(sceneMC,frame,childMcName,function():void
               {
                  next();
               });
            }
            else
            {
               sceneMC.gotoAndStop(frame);
               next();
            }
         }
      }
      
      private static function playFullMovie(info:TaskStepInfo) : void
      {
         var sparkMC:MovieClip;
         var swfUrl:String = null;
         var func:String = null;
         var playMC:Function = function():void
         {
            AnimateManager.playFullScreenAnimate(swfUrl,function():void
            {
               checkStep(info,func);
            });
         };
         TaskStepXMLInfo.setup(taskStepMap.getValue(info.taskID));
         sparkMC = MapManager.currentMap.controlLevel.getChildByName(TaskStepXMLInfo.getStepSmSparkMC(info.pro,info.stepID)) as MovieClip;
         swfUrl = TaskStepXMLInfo.getStepFullMovieUrl(info.pro,info.stepID);
         func = TaskStepXMLInfo.getStepFmFunc(info.pro,info.stepID);
         if(Boolean(sparkMC))
         {
            sparkMC.buttonMode = true;
            sparkMC.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent):void
            {
               playMC();
            });
         }
         else
         {
            playMC();
         }
      }
      
      private static function game(info:TaskStepInfo) : void
      {
         var sparkMC:MovieClip = null;
         var gameUrl:String = null;
         var gamePassFunc:String = null;
         var gameLossFunc:String = null;
         var playGame:Function = function():void
         {
            GamePlatformManager.join(gameUrl,false);
            GamePlatformManager.addEventListener(GamePlatformEvent.GAME_WIN,function(evt:GamePlatformEvent):void
            {
               GamePlatformManager.removeEventListener(GamePlatformEvent.GAME_WIN,arguments.callee);
               try
               {
                  MapProcessConfig.currentProcessInstance[gamePassFunc]();
               }
               catch(e:Error)
               {
                  throw new Error("找不到函数!");
               }
            });
            GamePlatformManager.addEventListener(GamePlatformEvent.GAME_LOST,function(evt:GamePlatformEvent):void
            {
               GamePlatformManager.removeEventListener(GamePlatformEvent.GAME_LOST,arguments.callee);
               try
               {
                  MapProcessConfig.currentProcessInstance[gameLossFunc]();
               }
               catch(e:Error)
               {
                  throw new Error("找不到函数!");
               }
            });
         };
         TaskStepXMLInfo.setup(taskStepMap.getValue(info.taskID));
         sparkMC = MapManager.currentMap.controlLevel.getChildByName(TaskStepXMLInfo.getStepGmSparkMC(info.pro,info.stepID)) as MovieClip;
         gameUrl = TaskStepXMLInfo.getStepGameUrl(info.pro,info.stepID);
         gamePassFunc = TaskStepXMLInfo.getStepGamePassFunc(info.pro,info.stepID);
         gameLossFunc = TaskStepXMLInfo.getStepGameLossFunc(info.pro,info.stepID);
         if(Boolean(sparkMC))
         {
            sparkMC.buttonMode = true;
            sparkMC.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent):void
            {
               sparkMC.buttonMode = false;
               sparkMC.removeEventListener(MouseEvent.CLICK,arguments.callee);
               playGame();
            });
         }
         else
         {
            playGame();
         }
      }
      
      private static function fight(info:TaskStepInfo) : void
      {
         var sparkMC:MovieClip;
         var bossName:String = null;
         var bossID:uint = 0;
         var fightSucsFunc:String = null;
         var fightLossFunc:String = null;
         var fightBoss:Function = function():void
         {
            FightInviteManager.fightWithBoss(bossName,bossID);
            EventManager.addEventListener(PetFightEvent.FIGHT_RESULT,function(evt:PetFightEvent):void
            {
               var fightData:FightOverInfo;
               EventManager.removeEventListener(PetFightEvent.FIGHT_CLOSE,arguments.callee);
               fightData = evt.dataObj["data"];
               if(fightData.winnerID == MainManager.actorInfo.userID)
               {
                  try
                  {
                     MapProcessConfig.currentProcessInstance[fightSucsFunc]();
                  }
                  catch(e:Error)
                  {
                     throw new Error("找不到函数!");
                  }
               }
               else
               {
                  try
                  {
                     MapProcessConfig.currentProcessInstance[fightLossFunc]();
                  }
                  catch(e:Error)
                  {
                     throw new Error("找不到函数!");
                  }
               }
            });
         };
         TaskStepXMLInfo.setup(taskStepMap.getValue(info.taskID));
         sparkMC = MapManager.currentMap.controlLevel.getChildByName(TaskStepXMLInfo.getStepFtSparkMC(info.pro,info.stepID)) as MovieClip;
         bossName = TaskStepXMLInfo.getStepFtBossName(info.pro,info.stepID);
         bossID = TaskStepXMLInfo.getStepFtBossID(info.pro,info.stepID);
         fightSucsFunc = TaskStepXMLInfo.getStepFtSuccessFunc(info.pro,info.stepID);
         fightLossFunc = TaskStepXMLInfo.getStepFtLossFunc(info.pro,info.stepID);
      }
      
      private static function showPanel(info:TaskStepInfo) : void
      {
         var sparkMC:MovieClip = null;
         var className:String = null;
         var func:String = null;
         var show:Function = function():void
         {
            var showComplete:Function = null;
            var showPause:Function = null;
            showComplete = function(evt:DynamicEvent):void
            {
               EventManager.removeEventListener(TasksController.TASKPANEL_SHOW_COMPLETE,showComplete);
               checkStep(info,func);
            };
            showPause = function(evt:DynamicEvent):void
            {
               EventManager.removeEventListener(TasksController.TASKPANEL_SHOW_PAUSE,showPause);
               doTaskProStep(info.taskID,info.pro,info.stepID);
            };
            if(Boolean(panel))
            {
               panel.destroy();
               panel = null;
            }
            panel = new AppModel(ClientConfig.getTaskModule(className),"正在加载面板");
            panel.setup();
            panel.show();
            EventManager.removeEventListener(TasksController.TASKPANEL_SHOW_COMPLETE,showComplete);
            EventManager.removeEventListener(TasksController.TASKPANEL_SHOW_PAUSE,showPause);
            EventManager.addEventListener(TasksController.TASKPANEL_SHOW_COMPLETE,showComplete);
            EventManager.addEventListener(TasksController.TASKPANEL_SHOW_PAUSE,showPause);
         };
         TaskStepXMLInfo.setup(taskStepMap.getValue(info.taskID));
         sparkMC = MapManager.currentMap.controlLevel.getChildByName(TaskStepXMLInfo.getStepPanelSparkMC(info.pro,info.stepID)) as MovieClip;
         className = TaskStepXMLInfo.getStepPanelClass(info.pro,info.stepID);
         func = TaskStepXMLInfo.getStepPanelFunc(info.pro,info.stepID);
         if(Boolean(sparkMC))
         {
            sparkMC.buttonMode = true;
            sparkMC.addEventListener(MouseEvent.CLICK,function(evt:MouseEvent):void
            {
               sparkMC.buttonMode = false;
               sparkMC.removeEventListener(MouseEvent.CLICK,arguments.callee);
               show();
            });
         }
         else
         {
            show();
         }
      }
      
      private static function mcAction(info:TaskStepInfo) : void
      {
         var mc:MovieClip = null;
         TaskStepXMLInfo.setup(taskStepMap.getValue(info.taskID));
         var type:uint = TaskStepXMLInfo.getStepMcType(info.pro,info.stepID);
         var name:String = TaskStepXMLInfo.getStepMcName(info.pro,info.stepID);
         var frame:uint = TaskStepXMLInfo.getStepMcFrame(info.pro,info.stepID);
         var func:String = TaskStepXMLInfo.getStepMcFunc(info.pro,info.stepID);
         switch(type)
         {
            case 0:
               break;
            case 1:
               mc = MapManager.currentMap.animatorLevel.getChildByName(name) as MovieClip;
               break;
            case 2:
               mc = MapManager.currentMap.controlLevel.getChildByName(name) as MovieClip;
               break;
            case 3:
               mc = MapManager.currentMap.depthLevel.getChildByName(name) as MovieClip;
               break;
            case 4:
               mc = MapManager.currentMap.btnLevel.getChildByName(name) as MovieClip;
               break;
            case 5:
               mc = MapManager.currentMap.spaceLevel.getChildByName(name) as MovieClip;
               break;
            case 6:
               mc = MapManager.currentMap.topLevel.getChildByName(name) as MovieClip;
         }
         if(Boolean(mc))
         {
            mc.visible = TaskStepXMLInfo.getStepMcVisible(info.pro,info.stepID);
            if(mc.visible)
            {
               mc.gotoAndStop(frame);
            }
         }
         checkStep(info,func);
      }
      
      private static function checkStep(info:TaskStepInfo, func:String = "") : void
      {
         var isCompletePro:Boolean;
         var taskPanelClose:Function = null;
         taskPanelClose = function(evt:Event):void
         {
            EventManager.removeEventListener(TasksController.TASKPANEL_CLOSE,taskPanelClose);
            nextStep(info);
         };
         TaskStepXMLInfo.setup(taskStepMap.getValue(info.taskID));
         isCompletePro = TaskStepXMLInfo.getStepIsComplete(info.pro,info.stepID);
         if(isCompletePro)
         {
            TasksManager.complete(info.taskID,info.pro,function(b:Boolean):void
            {
               var mapID:uint = 0;
               var stepXml:XML = null;
               var info:TaskStepInfo = null;
               if(b)
               {
                  EventManager.removeEventListener(TasksController.TASKPANEL_CLOSE,taskPanelClose);
                  EventManager.addEventListener(TasksController.TASKPANEL_CLOSE,taskPanelClose);
                  mapID = TaskStepXMLInfo.getProMapID(info.pro + 1);
                  stepXml = TaskStepXMLInfo.getStepXML(info.pro + 1,0);
                  info = new TaskStepInfo(info.taskID,info.pro + 1,mapID,stepXml);
                  stepMap.add(info.taskID,info);
               }
            },true);
         }
         else if(func != "" && func != null)
         {
            try
            {
               MapProcessConfig.currentProcessInstance[func]();
            }
            catch(e:Error)
            {
               throw new Error("找不到函数!");
            }
         }
         else
         {
            nextStep(info);
         }
      }
      
      private static function nextStep(info:TaskStepInfo) : void
      {
         var j:uint = 0;
         TaskStepXMLInfo.setup(taskStepMap.getValue(info.taskID));
         var isCompletePro:Boolean = TaskStepXMLInfo.getStepIsComplete(info.pro,info.stepID);
         var goto1:Array = TaskStepXMLInfo.getStepGoto(info.pro,info.stepID);
         var pro:uint = uint(goto1[0]);
         var step:uint = uint(goto1[1]);
         var xml:XML = TaskStepXMLInfo.getStepXML(pro,step);
         var mapID:uint = TaskStepXMLInfo.getProMapID(pro);
         var i:TaskStepInfo = new TaskStepInfo(info.taskID,pro,mapID,xml);
         if(info.pro == TaskStepXMLInfo.proCnt - 1 && isCompletePro)
         {
            if(info.pro == pro && info.stepID == step)
            {
               stepMap.remove(info.taskID);
               taskStepMap.remove(info.taskID);
               for(j = 0; j < taskList.length; j++)
               {
                  if(info.taskID == taskList[j])
                  {
                     taskList.splice(j,1);
                  }
               }
            }
         }
         else
         {
            startDoTask(i);
         }
      }
   }
}

