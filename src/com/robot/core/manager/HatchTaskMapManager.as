package com.robot.core.manager
{
   import com.robot.core.config.xml.HatchTaskXMLInfo;
   import com.robot.core.event.MapEvent;
   import com.robot.core.manager.HatchTask.HatchTaskInfo;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   import org.taomee.ds.HashMap;
   
   public class HatchTaskMapManager
   {
      private static var mapItemHash:HashMap = new HashMap();
      
      private static var soulBeadStatusMap:HashMap = new HashMap();
      
      getMapItems();
      
      public function HatchTaskMapManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         setTimeout(function():void
         {
            HatchTaskManager.getTaskStatusList(function(map:HashMap):void
            {
               soulBeadStatusMap = map;
               cutIsTaskMap();
            });
         },1000);
      }
      
      public static function getSoulBeadStatusMap(map:HashMap) : void
      {
         soulBeadStatusMap = map;
      }
      
      public static function mapSoulBeadTaskDo(info:HatchTaskInfo, pro:uint) : void
      {
         var name:String = null;
         var taskMC:MovieClip = null;
         if(Boolean(info))
         {
            if(!info.statusList[pro])
            {
               name = HatchTaskXMLInfo.getProMCName(info.itemID,pro);
               taskMC = MapManager.currentMap.controlLevel[name] as MovieClip;
               if(Boolean(taskMC))
               {
                  taskMC.buttonMode = true;
                  taskMC.addEventListener(MouseEvent.CLICK,finishHatchTask(info.obtainTime,info.itemID,pro));
               }
            }
         }
      }
      
      private static function getMapItems() : void
      {
         var info:HatchTaskInfo = null;
         var id:uint = 0;
         var mapIdArr:Array = null;
         var arr:Array = soulBeadStatusMap.getValues();
         for each(info in arr)
         {
            id = info.itemID;
            mapIdArr = HatchTaskXMLInfo.getTaskMapList(id);
            mapItemHash.add(id,mapIdArr);
         }
      }
      
      public static function cutIsTaskMap() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_COMPLETE,function(evt:MapEvent):void
         {
            var mapItemID:uint = 0;
            var info:HatchTaskInfo = null;
            var proArr:Array = null;
            var pro:uint = 0;
            var mapID:uint = evt.mapModel.id;
            var mapItemList:Array = HatchTaskXMLInfo.getMapSoulBeadList(mapID);
            if(mapItemList.length > 0)
            {
               for each(mapItemID in mapItemList)
               {
                  for each(info in soulBeadStatusMap.getValues())
                  {
                     if(info.itemID == mapItemID)
                     {
                        proArr = HatchTaskXMLInfo.getMapPro(info.itemID,mapID);
                        for each(pro in proArr)
                        {
                           if(!HatchTaskManager.getTaskProStatus(info.obtainTime,pro))
                           {
                              mapSoulBeadTaskDo(info,pro);
                           }
                        }
                     }
                  }
               }
            }
         });
      }
      
      private static function finishHatchTask(obtainTime:uint, id:uint, pro:uint) : Function
      {
         var func:Function = function(evt:MouseEvent):void
         {
            var mc:MovieClip = null;
            var playMC:MovieClip = null;
            mc = evt.currentTarget as MovieClip;
            playMC = mc["mc"];
            if(playMC == null)
            {
               mc.buttonMode = false;
               mc.mouseEnabled = false;
               mc.mouseChildren = false;
               mc.removeEventListener(MouseEvent.CLICK,finishHatchTask);
            }
            playMC.gotoAndPlay(2);
            playMC.addEventListener(Event.ENTER_FRAME,function(evt:Event):void
            {
               if(playMC.currentFrame == playMC.totalFrames)
               {
                  playMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  HatchTaskManager.complete(obtainTime,id,pro,function(b:Boolean):void
                  {
                     var proDes:String = null;
                     if(b)
                     {
                        Alarm.show("元神珠已经吸收了足够的精华能量，现在可以放入元神转化仪中转化了。");
                     }
                     else
                     {
                        proDes = HatchTaskXMLInfo.getProDes(id,pro);
                        Alarm.show(proDes);
                     }
                  });
                  playMC.gotoAndStop(1);
                  mc.buttonMode = false;
                  mc.mouseEnabled = false;
                  mc.mouseChildren = false;
                  mc.removeEventListener(MouseEvent.CLICK,finishHatchTask);
               }
            });
         };
         return func;
      }
   }
}

