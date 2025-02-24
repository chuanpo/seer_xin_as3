package com.robot.core.manager
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.HatchTaskXMLInfo;
   import com.robot.core.info.HatchTask.HatchTaskBufInfo;
   import com.robot.core.manager.HatchTask.HatchTaskInfo;
   import com.robot.core.net.SocketConnection;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   import org.taomee.events.SocketEvent;
   
   public class HatchTaskManager
   {
      private static var _instance:EventDispatcher;
      
      private static var _beadMap:HashMap = new HashMap();
      
      private static var _taskMap:HashMap = new HashMap();
      
      private static var b:Boolean = true;
      
      public function HatchTaskManager()
      {
         super();
      }
      
      public static function getTaskStatusList(func:Function) : void
      {
         var ts:Array = null;
         getSoulBeadList(function(arr:Array):void
         {
            var upLoop:Function = function(i:int):void
            {
               var catchTime:uint;
               if(i == ts.length)
               {
                  if(func != null)
                  {
                     func(_beadMap);
                  }
                  ts = null;
                  b = true;
                  return;
               }
               catchTime = uint(ts[i][0]);
               SocketConnection.addCmdListener(CommandID.GET_SOUL_BEAD_BUF,function(e:SocketEvent):void
               {
                  var j:uint = 0;
                  var status:Boolean = false;
                  SocketConnection.removeCmdListener(CommandID.GET_SOUL_BEAD_BUF,arguments.callee);
                  var info:HatchTaskBufInfo = e.data as HatchTaskBufInfo;
                  var obtainTime:uint = info.obtainTm;
                  var buf:ByteArray = info.buf;
                  for(var a:Array = []; j < 10; )
                  {
                     status = Boolean(buf.readBoolean());
                     a.push(status);
                     j++;
                  }
                  var hatchTaskInfo:HatchTaskInfo = new HatchTaskInfo(obtainTime,ts[i][1],a,func);
                  var len:uint = uint(HatchTaskXMLInfo.getTaskProCount(ts[i][1]));
                  var count:uint = 0;
                  for(var k:uint = 0; k < len; k++)
                  {
                     if(a[k] == true)
                     {
                        count++;
                     }
                  }
                  if(count == len)
                  {
                     hatchTaskInfo.isComplete = true;
                  }
                  _beadMap.add(obtainTime,hatchTaskInfo);
                  ++i;
                  upLoop(i);
               });
               SocketConnection.send(CommandID.GET_SOUL_BEAD_BUF,catchTime);
            };
            if(!b)
            {
               return;
            }
            b = false;
            ts = arr;
            if(ts == null)
            {
               return;
            }
            upLoop(0);
         });
      }
      
      public static function getSoulBeadList(func:Function) : void
      {
         var arr:Array = null;
         arr = [];
         SocketConnection.addCmdListener(CommandID.GET_SOUL_BEAD_List,function(evt:SocketEvent):void
         {
            var obtainTime:uint = 0;
            var itemID:uint = 0;
            SocketConnection.removeCmdListener(CommandID.GET_SOUL_BEAD_List,arguments.callee);
            var by:ByteArray = evt.data as ByteArray;
            var cnt:uint = by.readUnsignedInt();
            for(var i:uint = 0; i < cnt; i++)
            {
               obtainTime = by.readUnsignedInt();
               itemID = by.readUnsignedInt();
               arr.push([obtainTime,itemID]);
            }
            func(arr);
         });
         SocketConnection.send(CommandID.GET_SOUL_BEAD_List);
      }
      
      public static function complete(obtainTm:uint, id:uint, pro:uint, event:Function = null) : void
      {
         var arr:Array = null;
         var info:HatchTaskInfo = null;
         var proCnt:uint = 0;
         var i:uint = 0;
         var hi:HatchTaskInfo = _beadMap.getValue(obtainTm);
         arr = hi.statusList;
         info = new HatchTaskInfo(obtainTm,id,arr,event);
         if(HatchTaskXMLInfo.isDir(id))
         {
            proCnt = uint(HatchTaskXMLInfo.getTaskProCount(id));
            for(i = 0; i < proCnt; i++)
            {
               setTaskProStatus(obtainTm,proCnt,true,function(b:Boolean):void
               {
                  arr.push(b);
                  info.isComplete = true;
                  _beadMap.add(obtainTm,info);
                  event(info.isComplete);
               });
            }
         }
         else
         {
            setTaskProStatus(obtainTm,pro,true,function(b:Boolean):void
            {
               arr[pro] = b;
               var a:HatchTaskInfo = info;
               _beadMap.add(obtainTm,info);
               var len:uint = uint(HatchTaskXMLInfo.getTaskProCount(id));
               for(var i:uint = 0; i < len; i++)
               {
                  if(HatchTaskManager.getTaskList(obtainTm)[i] != true)
                  {
                     event(info.isComplete);
                     return;
                  }
               }
               info.isComplete = true;
               _beadMap.add(obtainTm,info);
               event(info.isComplete);
            });
         }
      }
      
      public static function getTaskProStatus(obtainTime:uint, pro:uint) : Boolean
      {
         var info:HatchTaskInfo = _beadMap.getValue(obtainTime);
         return info.statusList[pro];
      }
      
      public static function setTaskProStatus(obtainTime:uint, pro:uint, status:Boolean, func:Function = null) : void
      {
         SocketConnection.addCmdListener(CommandID.GET_SOUL_BEAD_BUF,function(e:SocketEvent):void
         {
            var info:HatchTaskBufInfo;
            var obtainTime:uint;
            var buf:ByteArray;
            var sts:Boolean;
            SocketConnection.removeCmdListener(CommandID.GET_SOUL_BEAD_BUF,arguments.callee);
            info = e.data as HatchTaskBufInfo;
            obtainTime = info.obtainTm;
            buf = info.buf;
            sts = buf.readBoolean();
            buf.position = pro;
            buf.writeBoolean(status);
            buf.length = 10;
            SocketConnection.addCmdListener(CommandID.SET_SOUL_BEAD_BUF,function(evt:SocketEvent):void
            {
               SocketConnection.removeCmdListener(CommandID.SET_SOUL_BEAD_BUF,arguments.callee);
               if(func != null)
               {
                  func(status);
               }
            });
            SocketConnection.send(CommandID.SET_SOUL_BEAD_BUF,obtainTime,buf);
         });
         SocketConnection.send(CommandID.GET_SOUL_BEAD_BUF,obtainTime);
      }
      
      public static function getProStatus(obtainTime:uint, pro:uint, func:Function = null) : void
      {
         SocketConnection.addCmdListener(CommandID.GET_SOUL_BEAD_BUF,function(e:SocketEvent):void
         {
            var status:Boolean = false;
            SocketConnection.removeCmdListener(CommandID.GET_SOUL_BEAD_BUF,arguments.callee);
            var info:HatchTaskBufInfo = e.data as HatchTaskBufInfo;
            var obtainTime:uint = info.obtainTm;
            var buf:ByteArray = info.buf;
            buf.position = pro;
            status = buf.readBoolean();
            if(func != null)
            {
               func(status);
            }
         });
         SocketConnection.send(CommandID.GET_SOUL_BEAD_BUF,obtainTime);
      }
      
      public static function get beadMap() : HashMap
      {
         return _beadMap;
      }
      
      public static function addHeadStatus(obtainTime:uint, info:HatchTaskInfo) : void
      {
         _beadMap.add(obtainTime,info);
         HatchTaskMapManager.getSoulBeadStatusMap(_beadMap);
      }
      
      public static function removeHeadStatus(obtainTime:uint) : void
      {
         _beadMap.remove(obtainTime);
         HatchTaskMapManager.getSoulBeadStatusMap(_beadMap);
      }
      
      public static function getTaskList(obtainTime:uint) : Array
      {
         var info:HatchTaskInfo = _beadMap.getValue(obtainTime);
         return info.statusList;
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
         getInstance().addEventListener(actType + "_" + id.toString() + "_" + pro.toString(),listener);
      }
      
      public static function removeListener(actType:String, id:uint, pro:uint, listener:Function) : void
      {
         getInstance().removeEventListener(actType + "_" + id.toString() + "_" + pro.toString(),listener);
      }
      
      public static function dispatchEvent(actType:String, id:uint, pro:uint, data:Array = null) : void
      {
      }
      
      public static function hasListener(actType:String, id:uint, pro:uint) : Boolean
      {
         return getInstance().hasEventListener(actType + "_" + id.toString() + "_" + pro.toString());
      }
   }
}

