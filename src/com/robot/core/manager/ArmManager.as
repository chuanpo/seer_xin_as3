package com.robot.core.manager
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.MapXMLInfo;
   import com.robot.core.event.ArmEvent;
   import com.robot.core.info.team.ArmInfo;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.utils.DragTargetType;
   import com.robot.core.utils.SolidType;
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.DepthManager;
   import org.taomee.utils.DisplayUtil;
   
   public class ArmManager
   {
      public static var isChange:Boolean;
      
      public static var isChangeForUpgrade:Boolean;
      
      public static var storagePanel:Sprite;
      
      public static var teamID:uint;
      
      public static var headquartersID:uint;
      
      private static var _sprite:Sprite;
      
      private static var _info:ArmInfo;
      
      private static var _parent:DisplayObjectContainer;
      
      private static var _type:int;
      
      private static var _offp:Point;
      
      private static var _flomc:DisplayObject;
      
      private static var _isMove:Boolean;
      
      private static var _instance:EventDispatcher;
      
      private static var _isArrlowInMap:Boolean = true;
      
      private static var _usedList:Array = [];
      
      private static var _allMap:HashMap = new HashMap();
      
      private static var _upUsedList:Array = [];
      
      private static var _upAllMap:HashMap = new HashMap();
      
      public function ArmManager()
      {
         super();
      }
      
      public static function getMax() : uint
      {
         return 15;
      }
      
      public static function get dragInMapEnabled() : Boolean
      {
         if(_upUsedList.length < getMax())
         {
            return true;
         }
         return false;
      }
      
      public static function doDrag(obj:Sprite, info:ArmInfo, par:DisplayObjectContainer, type:int, offp:Point = null) : void
      {
         _sprite = obj;
         _sprite.mouseEnabled = false;
         _sprite.mouseChildren = false;
         _info = info;
         _parent = par;
         _type = type;
         if(Boolean(offp))
         {
            _offp = offp;
         }
         else
         {
            _offp = new Point();
         }
         var p:Point = DisplayUtil.localToLocal(_sprite,MainManager.getStage());
         _sprite.x = p.x;
         _sprite.y = p.y;
         MainManager.getStage().addChild(_sprite);
         MainManager.getStage().addEventListener(MouseEvent.MOUSE_UP,onUp);
         MainManager.getStage().addEventListener(MouseEvent.MOUSE_MOVE,onMove);
         var spRect:Rectangle = _sprite.getRect(_sprite);
         _sprite.startDrag(false,new Rectangle(-spRect.x,-spRect.y,MainManager.getStageWidth() - spRect.width,MainManager.getStageHeight() - spRect.height));
         _isMove = false;
         if(Boolean(MapManager.currentMap.animatorLevel))
         {
            _flomc = MapManager.currentMap.animatorLevel.getChildByName("floMC");
         }
      }
      
      public static function setIsChange(i:ArmInfo = null) : void
      {
         if(i == null)
         {
            i = _info;
         }
         if(i.buyTime == 0)
         {
            isChange = true;
         }
         else
         {
            isChangeForUpgrade = true;
         }
      }
      
      public static function saveInfo() : void
      {
         var item:ArmInfo = null;
         var len:int = 0;
         var byData:ByteArray = null;
         var uplen:int = 0;
         var upData:ByteArray = null;
         if(isChange)
         {
            isChange = false;
            len = int(_usedList.length);
            byData = new ByteArray();
            byData.writeUnsignedInt(len);
            for each(item in _usedList)
            {
               byData.writeUnsignedInt(item.id);
               byData.writeUnsignedInt(item.pos.x);
               byData.writeUnsignedInt(item.pos.y);
               byData.writeUnsignedInt(item.dir);
               byData.writeUnsignedInt(item.status);
            }
            SocketConnection.send(CommandID.ARM_SET_INFO,byData);
         }
         item = null;
         if(isChangeForUpgrade)
         {
            isChangeForUpgrade = false;
            uplen = _upUsedList.length - 1;
            upData = new ByteArray();
            upData.writeUnsignedInt(uplen);
            for each(item in _upUsedList)
            {
               if(item.id != 1)
               {
                  upData.writeUnsignedInt(item.id);
                  upData.writeUnsignedInt(item.buyTime);
                  upData.writeUnsignedInt(item.pos.x);
                  upData.writeUnsignedInt(item.pos.y);
                  upData.writeUnsignedInt(item.dir);
                  upData.writeUnsignedInt(item.status);
               }
            }
            SocketConnection.send(CommandID.ARM_UP_SET_INFO,upData);
         }
      }
      
      private static function onMove(e:MouseEvent) : void
      {
         _isMove = true;
         var p:Point = new Point(DisplayObject(e.currentTarget).mouseX,DisplayObject(e.currentTarget).mouseY);
         p = p.subtract(_offp);
         if(storagePanel.hitTestPoint(p.x,p.y))
         {
            _sprite.alpha = 1;
         }
         else if(_flomc.hitTestPoint(p.x,p.y,true))
         {
            _isArrlowInMap = true;
            _sprite.alpha = 1;
         }
         else
         {
            _isArrlowInMap = false;
            _sprite.alpha = 0.4;
         }
      }
      
      private static function onUp(e:MouseEvent) : void
      {
         MainManager.getStage().removeEventListener(MouseEvent.MOUSE_UP,onUp);
         MainManager.getStage().removeEventListener(MouseEvent.MOUSE_MOVE,onMove);
         var p:Point = new Point(DisplayObject(e.currentTarget).mouseX,DisplayObject(e.currentTarget).mouseY);
         p = p.subtract(_offp);
         _sprite.stopDrag();
         if(storagePanel.hitTestPoint(p.x,p.y))
         {
            dragInStorage();
         }
         else if(MapManager.currentMap.root.hitTestPoint(p.x,p.y))
         {
            if(_isArrlowInMap)
            {
               dragInMap(p);
            }
            else
            {
               dragInNo();
            }
         }
         else
         {
            dragInNo();
         }
         _sprite = null;
         _parent = null;
         _info = null;
      }
      
      private static function dragInMap(p:Point) : void
      {
         setIsChange();
         if(_type == DragTargetType.MAP)
         {
            _info.pos = p;
            _sprite.x = 0;
            _sprite.y = 0;
            _sprite.mouseEnabled = true;
            _sprite.mouseChildren = true;
            _parent.x = p.x;
            _parent.y = p.y;
            _parent.addChild(_sprite);
            DepthManager.swapDepth(_parent,_parent.y);
         }
         else
         {
            _info.pos = p;
            addInMap(_info);
            if(_type == DragTargetType.STORAGE)
            {
               DisplayUtil.removeForParent(_sprite);
               removeInStorage(_info);
            }
         }
      }
      
      private static function dragInStorage() : void
      {
         if(_type == DragTargetType.STORAGE)
         {
            if(_isMove)
            {
               DisplayUtil.removeForParent(_sprite);
               dispatchEvent(new ArmEvent(ArmEvent.ADD_TO_STORAGE,_info));
            }
            else
            {
               setIsChange();
               if(_info.type == SolidType.PUT)
               {
                  _info.pos = MapXMLInfo.getRoomDefaultFloPos(MapManager.styleID);
               }
               else if(_info.type == SolidType.HANG)
               {
                  _info.pos = MapXMLInfo.getRoomDefaultWapPos(MapManager.styleID);
               }
               else
               {
                  _info.pos = MainManager.getStageCenterPoint();
               }
               addInMap(_info);
               removeInStorage(_info);
               DisplayUtil.removeForParent(_sprite);
            }
         }
         else
         {
            addInStorage(_info);
            if(_type == DragTargetType.MAP)
            {
               setIsChange();
               DisplayUtil.removeForParent(_sprite);
               removeInMap(_info);
            }
         }
      }
      
      private static function dragInNo() : void
      {
         if(_type == DragTargetType.STORAGE)
         {
            DisplayUtil.removeForParent(_sprite);
            return;
         }
         _sprite.alpha = 1;
         _sprite.x = 0;
         _sprite.y = 0;
         _sprite.mouseEnabled = true;
         _parent.addChild(_sprite);
      }
      
      public static function getUsedInfoForServer(tID:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.ARM_GET_USED_INFO,function(e:SocketEvent):void
         {
            var info:ArmInfo = null;
            var finfo:ArmInfo = null;
            SocketConnection.removeCmdListener(CommandID.ARM_GET_USED_INFO,arguments.callee);
            var isHasFrame:Boolean = false;
            _usedList = [];
            var data:ByteArray = e.data as ByteArray;
            teamID = data.readUnsignedInt();
            headquartersID = data.readUnsignedInt();
            var len:uint = data.readUnsignedInt();
            for(var i:int = 0; i < len; i++)
            {
               info = new ArmInfo();
               ArmInfo.setFor2941(info,data);
               if(info.type == SolidType.FRAME)
               {
                  MapManager.styleID = info.id;
                  isHasFrame = true;
               }
               else
               {
                  _usedList.push(info);
               }
            }
            if(!isHasFrame)
            {
               finfo = new ArmInfo();
               MapManager.styleID = MapManager.defaultArmStyleID;
               finfo.id = MapManager.styleID;
               _usedList.push(finfo);
            }
            dispatchEvent(new ArmEvent(ArmEvent.USED_LIST,null));
         });
         SocketConnection.send(CommandID.ARM_GET_USED_INFO,tID);
      }
      
      public static function getUsedInfoForServer_Up(tID:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.ARM_UP_GET_USED_INFO,function(e:SocketEvent):void
         {
            var info:ArmInfo = null;
            SocketConnection.removeCmdListener(CommandID.ARM_UP_GET_USED_INFO,arguments.callee);
            _upUsedList = [];
            var data:ByteArray = e.data as ByteArray;
            teamID = data.readUnsignedInt();
            var len:uint = data.readUnsignedInt();
            for(var i:int = 0; i < len; i++)
            {
               info = new ArmInfo();
               ArmInfo.setFor2967_2965(info,data);
               info.isUsed = true;
               _upUsedList.push(info);
            }
            dispatchEvent(new ArmEvent(ArmEvent.UP_USED_LIST,null));
         });
         SocketConnection.send(CommandID.ARM_UP_GET_USED_INFO,tID);
      }
      
      public static function addInMap(i:ArmInfo) : void
      {
         var info:ArmInfo = i.clone();
         if(info.buyTime == 0)
         {
            _usedList.push(info);
         }
         else
         {
            info.isUsed = true;
            _upUsedList.push(info);
         }
         dispatchEvent(new ArmEvent(ArmEvent.ADD_TO_MAP,info));
      }
      
      public static function removeInMap(i:ArmInfo) : void
      {
         var index:int = 0;
         if(i.buyTime == 0)
         {
            index = int(_usedList.indexOf(i));
            if(index != -1)
            {
               _usedList.splice(index,1);
               dispatchEvent(new ArmEvent(ArmEvent.REMOVE_TO_MAP,i));
            }
         }
         else
         {
            index = int(_upUsedList.indexOf(i));
            if(index != -1)
            {
               _upUsedList.splice(index,1);
               dispatchEvent(new ArmEvent(ArmEvent.REMOVE_TO_MAP,i));
            }
         }
      }
      
      public static function removeAllInMap() : void
      {
         var f:ArmInfo = null;
         var uh:ArmInfo = null;
         _usedList.forEach(function(item:ArmInfo, index:int, array:Array):void
         {
            var info:ArmInfo = null;
            if(item.type == SolidType.FRAME)
            {
               f = item;
            }
            else
            {
               info = _allMap.getValue(item.id);
               if(Boolean(info))
               {
                  ++info.unUsedCount;
               }
               else
               {
                  item.allCount = 1;
                  _allMap.add(item.id,item);
               }
            }
         });
         if(Boolean(f))
         {
            _usedList = [f];
         }
         _upUsedList.forEach(function(item:ArmInfo, index:int, array:Array):void
         {
            if(item.type == SolidType.HEAD)
            {
               uh = item;
            }
            else
            {
               item.isUsed = false;
               _upAllMap.add(item.buyTime,item);
            }
         });
         if(Boolean(uh))
         {
            _upUsedList = [uh];
         }
         dispatchEvent(new ArmEvent(ArmEvent.REMOVE_ALL_TO_MAP,null));
         dispatchEvent(new ArmEvent(ArmEvent.ADD_TO_STORAGE,null));
      }
      
      public static function getUsedList() : Array
      {
         return _usedList;
      }
      
      public static function getUsedList_Up() : Array
      {
         return _upUsedList;
      }
      
      public static function containsUsed(id:uint) : Boolean
      {
         var item:ArmInfo = null;
         for each(item in _usedList)
         {
            if(id == item.id)
            {
               return true;
            }
         }
         item = null;
         for each(item in _upUsedList)
         {
            if(id == item.id)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function getAllInfoForServer(tid:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.ARM_GET_ALL_INFO,function(e:SocketEvent):void
         {
            var info:ArmInfo = null;
            SocketConnection.removeCmdListener(CommandID.ARM_GET_ALL_INFO,arguments.callee);
            _allMap.clear();
            var by:ByteArray = e.data as ByteArray;
            teamID = by.readUnsignedInt();
            var len:int = int(by.readUnsignedInt());
            for(var i:int = 0; i < len; i++)
            {
               info = new ArmInfo();
               ArmInfo.setFor2942(info,by);
               _allMap.add(info.id,info);
            }
            dispatchEvent(new ArmEvent(ArmEvent.ALL_LIST,null));
         });
         SocketConnection.send(CommandID.ARM_GET_ALL_INFO,tid);
      }
      
      public static function getAllInfoForServer_Up(tid:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.ARM_UP_GET_ALL_INFO,function(e:SocketEvent):void
         {
            var info:ArmInfo = null;
            SocketConnection.removeCmdListener(CommandID.ARM_UP_GET_ALL_INFO,arguments.callee);
            _upAllMap.clear();
            var by:ByteArray = e.data as ByteArray;
            teamID = by.readUnsignedInt();
            var len:int = int(by.readUnsignedInt());
            for(var i:int = 0; i < len; i++)
            {
               info = new ArmInfo();
               ArmInfo.setFor2966(info,by);
               _upAllMap.add(info.buyTime,info);
            }
            dispatchEvent(new ArmEvent(ArmEvent.UP_ALL_LIST,null));
         });
         SocketConnection.send(CommandID.ARM_UP_GET_ALL_INFO,tid);
      }
      
      public static function addInStorage(i:ArmInfo) : void
      {
         var info:ArmInfo = null;
         if(i.buyTime == 0)
         {
            info = _allMap.getValue(i.id);
            if(Boolean(info))
            {
               ++info.unUsedCount;
               dispatchEvent(new ArmEvent(ArmEvent.ADD_TO_STORAGE,info));
            }
            else
            {
               i.allCount = 1;
               _allMap.add(i.id,i);
               dispatchEvent(new ArmEvent(ArmEvent.ADD_TO_STORAGE,i));
            }
         }
         else
         {
            i.isUsed = false;
            _upAllMap.add(i.buyTime,i);
            dispatchEvent(new ArmEvent(ArmEvent.ADD_TO_STORAGE,i));
         }
      }
      
      public static function removeInStorage(i:ArmInfo) : void
      {
         var info:ArmInfo = null;
         if(i.buyTime == 0)
         {
            info = _allMap.getValue(i.id);
            if(Boolean(info))
            {
               if(info.unUsedCount > 1)
               {
                  --info.allCount;
               }
               else
               {
                  _allMap.remove(info.id);
               }
               dispatchEvent(new ArmEvent(ArmEvent.REMOVE_TO_STORAGE,info));
            }
         }
         else if(_upAllMap.remove(i.buyTime))
         {
            dispatchEvent(new ArmEvent(ArmEvent.REMOVE_TO_STORAGE,i));
         }
      }
      
      public static function getAllList() : Array
      {
         return _allMap.getValues().concat(_upAllMap.getValues());
      }
      
      public static function getUnUsedList() : Array
      {
         var arr:Array = null;
         arr = [];
         _allMap.eachValue(function(i:ArmInfo):void
         {
            if(i.unUsedCount > 0)
            {
               arr.push(i);
            }
         });
         _upAllMap.eachValue(function(i:ArmInfo):void
         {
            if(!i.isUsed)
            {
               arr.push(i);
            }
         });
         return arr;
      }
      
      public static function getUsedListForAll() : Array
      {
         var arr:Array = null;
         arr = [];
         _allMap.eachValue(function(i:ArmInfo):void
         {
            if(i.usedCount > 0)
            {
               arr.push(i);
            }
         });
         return arr;
      }
      
      public static function getUnUsedListForType(t:uint) : Array
      {
         var arr:Array = null;
         arr = [];
         if(t == SolidType.FRAME || t == SolidType.PUT)
         {
            _allMap.eachValue(function(i:ArmInfo):void
            {
               if(i.unUsedCount > 0)
               {
                  if(i.type == t)
                  {
                     arr.push(i);
                  }
               }
            });
         }
         else
         {
            _upAllMap.eachValue(function(i:ArmInfo):void
            {
               if(i.type == t)
               {
                  if(!i.isUsed)
                  {
                     arr.push(i);
                  }
               }
            });
         }
         return arr;
      }
      
      public static function containsStorage(id:uint) : Boolean
      {
         var info:ArmInfo = _allMap.getValue(id);
         if(Boolean(info))
         {
            if(info.unUsedCount > 0)
            {
               return true;
            }
         }
         info = null;
         var arr:Array = _upAllMap.getValues();
         for each(info in arr)
         {
            if(info.id == id)
            {
               if(!info.isUsed)
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function containsAll(id:uint) : Boolean
      {
         var arr:Array = null;
         var info:ArmInfo = null;
         if(_allMap.containsKey(id))
         {
            return true;
         }
         arr = _upAllMap.getValues();
         for each(info in arr)
         {
            if(info.id == id)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function destroy() : void
      {
         _sprite = null;
         _parent = null;
         _info = null;
         storagePanel = null;
         _flomc = null;
      }
      
      public static function getContributeBounds(func:Function = null) : void
      {
         SocketConnection.addCmdListener(CommandID.Get_CONTRIBUTE_BOUNDS,function(e:SocketEvent):void
         {
            var coin:uint = 0;
            var ex:uint = 0;
            SocketConnection.removeCmdListener(CommandID.Get_CONTRIBUTE_BOUNDS,arguments.callee);
            var by:ByteArray = e.data as ByteArray;
            var time:uint = by.readUnsignedInt();
            if(time > 0)
            {
               by.readUnsignedInt();
               coin = by.readUnsignedInt();
               ex = by.readUnsignedInt();
               MainManager.actorInfo.teamInfo.canExContribution -= time * 10;
               if(MainManager.actorInfo.teamInfo.canExContribution < 0)
               {
                  MainManager.actorInfo.teamInfo.canExContribution = 0;
               }
               MainManager.actorInfo.coins += coin;
               if(func != null)
               {
                  func();
               }
               Alarm.show("祝贺你领取到了战队贡献奖励：\n" + ex + "积累经验\n" + coin + "赛尔豆\n你的功绩将会在战队成员间传诵！");
            }
         });
         SocketConnection.send(CommandID.Get_CONTRIBUTE_BOUNDS);
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(_instance == null)
         {
            _instance = new EventDispatcher();
         }
         return _instance;
      }
      
      public static function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         getInstance().addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public static function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         getInstance().removeEventListener(type,listener,useCapture);
      }
      
      public static function dispatchEvent(event:Event) : void
      {
         if(hasEventListener(event.type))
         {
            getInstance().dispatchEvent(event);
         }
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return getInstance().hasEventListener(type);
      }
      
      public static function willTrigger(type:String) : Boolean
      {
         return getInstance().willTrigger(type);
      }
   }
}

