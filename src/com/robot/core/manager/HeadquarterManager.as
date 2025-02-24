package com.robot.core.manager
{
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.MapXMLInfo;
   import com.robot.core.event.FitmentEvent;
   import com.robot.core.info.FitmentInfo;
   import com.robot.core.info.team.HeadquarterInfo;
   import com.robot.core.net.SocketConnection;
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
   
   public class HeadquarterManager
   {
      public static var isChange:Boolean;
      
      public static var storagePanel:Sprite;
      
      public static var teamID:uint;
      
      public static var headquartersID:uint;
      
      private static var _sprite:Sprite;
      
      private static var _info:FitmentInfo;
      
      private static var _parent:DisplayObjectContainer;
      
      private static var _type:int;
      
      private static var _offp:Point;
      
      private static var _wapmc:DisplayObject;
      
      private static var _flomc:DisplayObject;
      
      private static var _isMove:Boolean;
      
      private static var _instance:EventDispatcher;
      
      private static var usedList:Array = [];
      
      private static var storageMap:HashMap = new HashMap();
      
      private static var _isArrlowInMap:Boolean = true;
      
      public function HeadquarterManager()
      {
         super();
      }
      
      public static function doDrag(obj:Sprite, info:FitmentInfo, par:DisplayObjectContainer, type:int, offp:Point = null) : void
      {
         var p:Point = null;
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
         p = DisplayUtil.localToLocal(_sprite,MainManager.getStage());
         _sprite.x = p.x;
         _sprite.y = p.y;
         MainManager.getStage().addChild(_sprite);
         MainManager.getStage().addEventListener(MouseEvent.MOUSE_UP,onUp);
         MainManager.getStage().addEventListener(MouseEvent.MOUSE_MOVE,onMove);
         var spRect:Rectangle = _sprite.getRect(_sprite);
         _sprite.startDrag(false,new Rectangle(-spRect.x,-spRect.y,MainManager.getStageWidth() - spRect.width,MainManager.getStageHeight() - spRect.height));
         if(Boolean(MapManager.currentMap.animatorLevel))
         {
            _wapmc = MapManager.currentMap.animatorLevel.getChildByName("wapMC");
            _flomc = MapManager.currentMap.animatorLevel.getChildByName("floMC");
         }
         _isMove = false;
      }
      
      public static function saveInfo() : void
      {
         var item:FitmentInfo = null;
         if(!isChange)
         {
            return;
         }
         isChange = false;
         var len:int = int(usedList.length);
         var byData:ByteArray = new ByteArray();
         for each(item in usedList)
         {
            byData.writeUnsignedInt(item.id);
            byData.writeUnsignedInt(item.pos.x);
            byData.writeUnsignedInt(item.pos.y);
            byData.writeUnsignedInt(item.dir);
            byData.writeUnsignedInt(item.status);
         }
         SocketConnection.send(CommandID.HEAD_SET_INFO,len,byData);
      }
      
      public static function saveStyleType(info:FitmentInfo, event:Function) : void
      {
         var byData:ByteArray = new ByteArray();
         byData.writeUnsignedInt(headquartersID);
         byData.writeUnsignedInt(info.id);
         byData.writeUnsignedInt(info.pos.x);
         byData.writeUnsignedInt(info.pos.y);
         byData.writeUnsignedInt(info.dir);
         byData.writeUnsignedInt(info.status);
         SocketConnection.addCmdListener(CommandID.HEAD_SET_INFO,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.HEAD_SET_INFO,arguments.callee);
            event();
         });
         SocketConnection.send(CommandID.HEAD_SET_INFO,1,byData);
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
         else
         {
            if(_info.type == SolidType.PUT)
            {
               if(_flomc.hitTestPoint(p.x,p.y,true))
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
            if(_info.type == SolidType.HANG)
            {
               if(_wapmc.hitTestPoint(p.x,p.y,true))
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
         isChange = true;
         if(_type == DragTargetType.MAP)
         {
            if(_info.isFixed)
            {
               _info.pos = MapXMLInfo.getHeadPos(MapManager.styleID);
            }
            else
            {
               _info.pos = p;
            }
            _sprite.x = 0;
            _sprite.y = 0;
            _sprite.mouseEnabled = true;
            _sprite.mouseChildren = true;
            _parent.x = _info.pos.x;
            _parent.y = _info.pos.y;
            _parent.addChild(_sprite);
            DepthManager.swapDepth(_parent,_parent.y);
         }
         else
         {
            if(_info.isFixed)
            {
               _info.pos = MapXMLInfo.getHeadPos(MapManager.styleID);
            }
            else
            {
               _info.pos = p;
            }
            addInMap(_info);
            if(_type == DragTargetType.STORAGE)
            {
               DisplayUtil.removeForParent(_sprite);
               removeInStorage(_info.id);
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
               dispatchEvent(new FitmentEvent(FitmentEvent.ADD_TO_STORAGE,_info));
            }
            else
            {
               isChange = true;
               if(_info.isFixed)
               {
                  _info.pos = MapXMLInfo.getHeadPos(MapManager.styleID);
               }
               else if(_info.type == SolidType.PUT)
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
               removeInStorage(_info.id);
               DisplayUtil.removeForParent(_sprite);
            }
         }
         else
         {
            addInStorage(_info);
            if(_type == DragTargetType.MAP)
            {
               isChange = true;
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
            dispatchEvent(new FitmentEvent(FitmentEvent.ADD_TO_STORAGE,_info));
            return;
         }
         _sprite.alpha = 1;
         _sprite.x = 0;
         _sprite.y = 0;
         _sprite.mouseEnabled = true;
         _parent.addChild(_sprite);
      }
      
      public static function getUsedInfo(teamID:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.HEAD_GET_USED_INFO,function(e:SocketEvent):void
         {
            var info:HeadquarterInfo = null;
            var finfo:HeadquarterInfo = null;
            SocketConnection.removeCmdListener(CommandID.HEAD_GET_USED_INFO,arguments.callee);
            var isHasFrame:Boolean = false;
            usedList = [];
            var data:ByteArray = e.data as ByteArray;
            teamID = data.readUnsignedInt();
            headquartersID = data.readUnsignedInt();
            var len:uint = data.readUnsignedInt();
            for(var i:int = 0; i < len; i++)
            {
               info = new HeadquarterInfo();
               FitmentInfo.setFor10008(info,data);
               usedList.push(info);
               if(info.type == SolidType.FRAME)
               {
                  MapManager.styleID = info.id;
                  isHasFrame = true;
               }
            }
            if(!isHasFrame)
            {
               finfo = new HeadquarterInfo();
               MapManager.styleID = MapManager.defaultRoomStyleID;
               finfo.id = MapManager.defaultRoomStyleID;
               usedList.push(finfo);
            }
            dispatchEvent(new FitmentEvent(FitmentEvent.USED_LIST,null));
         });
         SocketConnection.send(CommandID.HEAD_GET_USED_INFO,teamID);
      }
      
      public static function addInMap(i:FitmentInfo) : void
      {
         var info:HeadquarterInfo = new HeadquarterInfo();
         info.id = i.id;
         info.pos = i.pos.clone();
         info.dir = i.dir;
         info.status = i.status;
         usedList.push(info);
         dispatchEvent(new FitmentEvent(FitmentEvent.ADD_TO_MAP,info));
      }
      
      public static function removeInMap(i:FitmentInfo) : void
      {
         var index:int = int(usedList.indexOf(i));
         if(index != -1)
         {
            usedList.splice(index,1);
            dispatchEvent(new FitmentEvent(FitmentEvent.REMOVE_TO_MAP,i));
         }
      }
      
      public static function removeAllInMap() : void
      {
         var f:FitmentInfo = null;
         usedList.forEach(function(item:FitmentInfo, index:int, array:Array):void
         {
            var info:FitmentInfo = null;
            if(item.type == SolidType.FRAME)
            {
               f = item;
            }
            else
            {
               info = storageMap.getValue(item.id);
               if(Boolean(info))
               {
                  ++info.unUsedCount;
               }
               else
               {
                  item.allCount = 1;
                  storageMap.add(item.id,item);
               }
            }
         });
         if(Boolean(f))
         {
            usedList = [f];
         }
         dispatchEvent(new FitmentEvent(FitmentEvent.REMOVE_ALL_TO_MAP,null));
         dispatchEvent(new FitmentEvent(FitmentEvent.ADD_TO_STORAGE,null));
      }
      
      public static function getUsedList() : Array
      {
         return usedList;
      }
      
      public static function containsUsed(id:uint) : Boolean
      {
         return usedList.some(function(item:FitmentInfo, index:int, array:Array):Boolean
         {
            if(id == item.id)
            {
               return true;
            }
            return false;
         });
      }
      
      public static function clearUsed() : void
      {
         usedList = [];
      }
      
      public static function getStorageInfo(teamID:uint) : void
      {
         SocketConnection.addCmdListener(CommandID.HEAD_GET_ALL_INFO,function(e:SocketEvent):void
         {
            var info:HeadquarterInfo = null;
            SocketConnection.removeCmdListener(CommandID.HEAD_GET_ALL_INFO,arguments.callee);
            storageMap.clear();
            var by:ByteArray = e.data as ByteArray;
            teamID = by.readUnsignedInt();
            var len:int = int(by.readUnsignedInt());
            for(var i:int = 0; i < len; i++)
            {
               info = new HeadquarterInfo();
               FitmentInfo.setFor10007(info,by);
               storageMap.add(info.id,info);
            }
            dispatchEvent(new FitmentEvent(FitmentEvent.STORAGE_LIST,null));
         });
         SocketConnection.send(CommandID.HEAD_GET_ALL_INFO,teamID);
      }
      
      public static function addInStorage(i:FitmentInfo) : void
      {
         var info:FitmentInfo = storageMap.getValue(i.id);
         if(Boolean(info))
         {
            ++info.unUsedCount;
            dispatchEvent(new FitmentEvent(FitmentEvent.ADD_TO_STORAGE,info));
         }
         else
         {
            i.allCount = 1;
            storageMap.add(i.id,i);
            dispatchEvent(new FitmentEvent(FitmentEvent.ADD_TO_STORAGE,i));
         }
      }
      
      public static function removeInStorage(id:uint) : void
      {
         var i:FitmentInfo = storageMap.getValue(id);
         if(Boolean(i))
         {
            if(i.unUsedCount > 1)
            {
               --i.allCount;
            }
            else
            {
               storageMap.remove(id);
            }
            dispatchEvent(new FitmentEvent(FitmentEvent.REMOVE_TO_STORAGE,i));
         }
      }
      
      public static function getAllList() : Array
      {
         return storageMap.getValues();
      }
      
      public static function getUnUsedList() : Array
      {
         var data:Array = storageMap.getValues();
         return data.filter(function(item:FitmentInfo, index:int, array:Array):Boolean
         {
            if(item.unUsedCount > 0)
            {
               return true;
            }
            return false;
         });
      }
      
      public static function getUsedListForAll() : Array
      {
         var data:Array = storageMap.getValues();
         return data.filter(function(item:FitmentInfo, index:int, array:Array):Boolean
         {
            if(item.usedCount > 0)
            {
               return true;
            }
            return false;
         });
      }
      
      public static function getUnUsedListForType(t:uint) : Array
      {
         var data:Array = storageMap.getValues();
         return data.filter(function(item:FitmentInfo, index:int, array:Array):Boolean
         {
            if(item.unUsedCount > 0)
            {
               if(item.type == t)
               {
                  return true;
               }
            }
            return false;
         });
      }
      
      public static function containsStorage(id:uint) : Boolean
      {
         var info:FitmentInfo = storageMap.getValue(id);
         if(Boolean(info))
         {
            if(info.unUsedCount > 0)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function containsAll(id:uint) : Boolean
      {
         return storageMap.containsKey(id);
      }
      
      public static function clearAll() : void
      {
         return storageMap.clear();
      }
      
      public static function destroy() : void
      {
         _sprite = null;
         _parent = null;
         _info = null;
         storagePanel = null;
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

