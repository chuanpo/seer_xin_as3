package com.robot.core.manager
{
   import com.robot.core.CommandID;
   import com.robot.core.event.RelationEvent;
   import com.robot.core.info.UserInfo;
   import com.robot.core.info.relation.OnLineInfo;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.net.SharedObject;
   import flash.utils.ByteArray;
   import flash.utils.IDataInput;
   import org.taomee.ds.HashMap;
   import org.taomee.ds.HashSet;
   import org.taomee.events.SocketEvent;
   
   public class RelationManager
   {
      private static var _friendList:HashMap;
      
      private static var _blackList:HashMap;
      
      private static var _friendOnLineLength:uint;
      
      private static var _so:SharedObject;
      
      private static var _relSO:SharedObject;
      
      private static var _soFriendTimePokeSet:HashSet;
      
      private static var instance:EventDispatcher;
      
      private static const SO_FRIEND:String = "friend";
      
      private static const SO_BLACK:String = "black";
      
      private static var _allowAdd:Boolean = true;
      
      private static var _isFriendInfo:Boolean = true;
      
      private static var _isBlackInfo:Boolean = true;
      
      public function RelationManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         _so = SOManager.getUser_Info();
         if(_so.data.hasOwnProperty("allowAdd"))
         {
            _allowAdd = _so.data.allowAdd;
         }
      }
      
      public static function get F_MAX() : int
      {
         if(MainManager.actorInfo == null)
         {
            return 100;
         }
         if(Boolean(MainManager.actorInfo.vip))
         {
            return 200;
         }
         return 100;
      }
      
      public static function get allowAdd() : Boolean
      {
         return _allowAdd;
      }
      
      public static function set allowAdd(b:Boolean) : void
      {
         _allowAdd = b;
         _so = SOManager.getUser_Info();
         _so.data.allowAdd = b;
         SOManager.flush(_so);
      }
      
      public static function getFriendInfos(prior:Boolean = true) : Array
      {
         var arr:Array = _friendList.getValues();
         if(prior)
         {
            arr.forEach(function(item:UserInfo, index:int, array:Array):void
            {
               item.priorLevel = 0;
               if(Boolean(item.vip))
               {
                  item.priorLevel += 2;
               }
               if(item.teacherID == MainManager.actorID)
               {
                  item.priorLevel += 1;
               }
               if(item.studentID == MainManager.actorID)
               {
                  item.priorLevel += 1;
               }
               if(Boolean(item.serverID))
               {
                  item.priorLevel += 3;
               }
            });
            arr.sortOn("priorLevel",Array.DESCENDING | Array.NUMERIC);
         }
         return arr;
      }
      
      public static function get friendIDs() : Array
      {
         return _friendList.getKeys();
      }
      
      public static function get blackInfos() : Array
      {
         return _blackList.getValues();
      }
      
      public static function get blackIDs() : Array
      {
         return _blackList.getKeys();
      }
      
      public static function get friendLength() : int
      {
         return _friendList.length;
      }
      
      public static function get blackLength() : int
      {
         return _blackList.length;
      }
      
      public static function get friendOnLineLength() : int
      {
         return _friendOnLineLength;
      }
      
      public static function init(data:IDataInput) : void
      {
         var rel:UserInfo = null;
         var rel2:UserInfo = null;
         _friendList = new HashMap();
         var length:int = data.readUnsignedInt();
         for(var i:int = 0; i < length; i++)
         {
            rel = new UserInfo();
            rel.userID = data.readUnsignedInt();
            rel.timePoke = data.readUnsignedInt();
            _friendList.add(rel.userID,rel);
         }
         _blackList = new HashMap();
         length = 0;
         for(var k:int = 0; k < length; k++)
         {
            rel2 = new UserInfo();
            rel2.userID = data.readUnsignedInt();
            _blackList.add(rel2.userID,rel2);
         }
         soInit();
      }
      
      private static function soInit() : void
      {
         var arr:Array = null;
         var farr:Array = null;
         var info:UserInfo = null;
         var has:Boolean = false;
         var o:Object = null;
         _relSO = SOManager.getUser_Relation();
         if(_relSO.data.hasOwnProperty(SO_FRIEND))
         {
            _soFriendTimePokeSet = new HashSet();
            arr = _relSO.data[SO_FRIEND];
            farr = _friendList.getValues();
            for each(info in farr)
            {
               has = false;
               for each(o in arr)
               {
                  if(info.userID == o.userID)
                  {
                     has = true;
                     if(info.timePoke > o.timePoke)
                     {
                        _soFriendTimePokeSet.add(info);
                     }
                     info.hasSimpleInfo = true;
                     info.nick = o.nick;
                     info.color = o.color;
                     info.texture = o.texture;
                     info.vip = o.vip;
                     info.status = o.status;
                     info.mapID = o.mapID;
                     info.isCanBeTeacher = o.isCanBeTeacher;
                     info.teacherID = o.teacherID;
                     info.studentID = o.studentID;
                     info.graduationCount = o.graduationCount;
                     info.clothes = o.clothes.slice();
                     break;
                  }
               }
               if(!has)
               {
                  _soFriendTimePokeSet.add(info);
               }
            }
         }
      }
      
      public static function isFriend(userID:uint) : Boolean
      {
         return _friendList.containsKey(userID);
      }
      
      public static function isBlack(userID:uint) : Boolean
      {
         return _blackList.containsKey(userID);
      }
      
      public static function getFriendInfo(userID:uint) : UserInfo
      {
         return _friendList.getValue(userID) as UserInfo;
      }
      
      public static function getBlackInfo(userID:uint) : UserInfo
      {
         return _blackList.getValue(userID) as UserInfo;
      }
      
      public static function addFriend(userID:uint) : void
      {
         if(MainManager.actorID == userID)
         {
            Alarm.show("不能把自己添加为好友！");
            return;
         }
         if(friendLength >= F_MAX)
         {
            Alarm.show("好友达到上限！");
            return;
         }
         if(_friendList.containsKey(userID))
         {
            Alarm.show("好友已经存在！");
            return;
         }
         SocketConnection.send(CommandID.FRIEND_ADD,userID);
      }
      
      public static function addFriendInfo(info:UserInfo) : void
      {
         if(MainManager.actorID == info.userID)
         {
            return;
         }
         if(friendLength >= F_MAX)
         {
            return;
         }
         if(_friendList.containsKey(info.userID))
         {
            return;
         }
         if(_blackList.remove(info.userID))
         {
            dispatchEvent(new RelationEvent(RelationEvent.BLACK_REMOVE,info.userID));
         }
         _friendList.add(info.userID,info);
         dispatchEvent(new RelationEvent(RelationEvent.FRIEND_ADD,info.userID));
      }
      
      public static function removeFriend(userID:uint) : void
      {
         if(!_friendList.containsKey(userID))
         {
            return;
         }
         SocketConnection.addCmdListener(CommandID.FRIEND_REMOVE,function(e:SocketEvent):void
         {
            if(_friendList.remove(userID))
            {
               dispatchEvent(new RelationEvent(RelationEvent.FRIEND_REMOVE,userID));
            }
            SocketConnection.removeCmdListener(CommandID.FRIEND_REMOVE,arguments.callee);
         });
         SocketConnection.send(CommandID.FRIEND_REMOVE,userID);
      }
      
      public static function addBlack(userID:uint) : void
      {
         if(MainManager.actorID == userID)
         {
            Alarm.show("不能把自己添加进黑名单！");
            return;
         }
         if(_blackList.containsKey(userID))
         {
            Alarm.show("用户已经存在于黑名单！");
            return;
         }
         SocketConnection.addCmdListener(CommandID.BLACK_ADD,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.BLACK_ADD,arguments.callee);
            var by:ByteArray = e.data as ByteArray;
            var userID:uint = by.readUnsignedInt();
            var rel:UserInfo = new UserInfo();
            rel.userID = userID;
            rel.timePoke = 0;
            if(_friendList.remove(userID))
            {
               dispatchEvent(new RelationEvent(RelationEvent.FRIEND_REMOVE,userID));
            }
            _blackList.add(userID,rel);
            dispatchEvent(new RelationEvent(RelationEvent.BLACK_ADD,userID));
            upDateInfo(userID);
         });
         SocketConnection.send(CommandID.BLACK_ADD,userID);
      }
      
      public static function addBlackInfo(info:UserInfo) : void
      {
         if(MainManager.actorID == info.userID)
         {
            return;
         }
         if(_blackList.containsKey(info.userID))
         {
            return;
         }
         if(_friendList.remove(info.userID))
         {
            dispatchEvent(new RelationEvent(RelationEvent.FRIEND_REMOVE,info.userID));
         }
         _blackList.add(info.userID,info);
         dispatchEvent(new RelationEvent(RelationEvent.BLACK_ADD,info.userID));
      }
      
      public static function removeBlack(userID:uint) : void
      {
         if(!_blackList.containsKey(userID))
         {
            return;
         }
         SocketConnection.addCmdListener(CommandID.BLACK_REMOVE,function(e:SocketEvent):void
         {
            if(_blackList.remove(userID))
            {
               dispatchEvent(new RelationEvent(RelationEvent.BLACK_REMOVE,userID));
            }
            SocketConnection.removeCmdListener(CommandID.BLACK_REMOVE,arguments.callee);
         });
         SocketConnection.send(CommandID.BLACK_REMOVE,userID);
      }
      
      public static function answerFriend(userID:uint, accept:Boolean) : void
      {
         SocketConnection.send(CommandID.FRIEND_ANSWER,userID,uint(accept));
      }
      
      public static function setOnLineFriend() : void
      {
         var k:int;
         var info:UserInfo = null;
         var arr:Array = _friendList.getKeys();
         var arrLen:int = int(arr.length);
         for(k = 0; k < arrLen; k++)
         {
            info = _friendList.getValue(arr[k]) as UserInfo;
            info.serverID = 0;
         }
         UserInfoManager.seeOnLine(arr,function(data:Array):void
         {
            var oli:OnLineInfo = null;
            var info:UserInfo = null;
            _friendOnLineLength = data.length;
            if(_friendOnLineLength == 0)
            {
               dispatchEvent(new RelationEvent(RelationEvent.FRIEND_UPDATE_ONLINE));
               setFriendInfo();
               return;
            }
            for(var i:int = 0; i < _friendOnLineLength; i++)
            {
               oli = data[i] as OnLineInfo;
               info = _friendList.getValue(oli.userID) as UserInfo;
               if(Boolean(info))
               {
                  info.mapID = oli.mapID;
                  info.serverID = oli.serverID;
               }
            }
            dispatchEvent(new RelationEvent(RelationEvent.FRIEND_UPDATE_ONLINE));
            setFriendInfo();
         });
      }
      
      public static function setFriendInfo() : void
      {
         var _fInfos:Array = null;
         var _fKeyLen:int = 0;
         var loopInfo:Function = function(i:int):void
         {
            if(i == _fKeyLen)
            {
               dispatchEvent(new RelationEvent(RelationEvent.UPDATE_INFO));
               _fInfos = null;
               _fKeyLen = NaN;
               if(Boolean(_relSO))
               {
                  _relSO.data[SO_FRIEND] = _friendList.getValues();
                  SOManager.flush(_relSO);
               }
               return;
            }
            UserInfoManager.upDateSimpleInfo(_fInfos[i],function():void
            {
               ++i;
               loopInfo(i);
            });
         };
         if(!_isFriendInfo)
         {
            return;
         }
         _isFriendInfo = false;
         if(_soFriendTimePokeSet == null)
         {
            _fInfos = _friendList.getValues();
         }
         else
         {
            _fInfos = _soFriendTimePokeSet.toArray();
         }
         _fKeyLen = int(_fInfos.length);
         if(_fKeyLen == 0)
         {
            return;
         }
         loopInfo(0);
      }
      
      public static function setBlackInfo() : void
      {
         var _fInfos:Array = null;
         var _fKeyLen:int = 0;
         var loopInfo:Function = function(i:int):void
         {
            if(i == _fKeyLen)
            {
               dispatchEvent(new RelationEvent(RelationEvent.UPDATE_INFO));
               _fInfos = null;
               _fKeyLen = NaN;
               return;
            }
            UserInfoManager.upDateSimpleInfo(_fInfos[i],function():void
            {
               ++i;
               loopInfo(i);
            });
         };
         if(!_isBlackInfo)
         {
            return;
         }
         _isBlackInfo = false;
         _fInfos = _blackList.getValues();
         _fKeyLen = int(_fInfos.length);
         loopInfo(0);
      }
      
      public static function upDateInfo(id:uint) : void
      {
         var rel:UserInfo = null;
         rel = _friendList.getValue(id) as UserInfo;
         if(rel == null)
         {
            rel = _blackList.getValue(id) as UserInfo;
         }
         if(Boolean(rel))
         {
            UserInfoManager.upDateSimpleInfo(rel,function():void
            {
               dispatchEvent(new RelationEvent(RelationEvent.UPDATE_INFO,rel.userID));
            });
         }
      }
      
      public static function upDateInfoForSimpleInfo(info:UserInfo) : void
      {
         var rel:UserInfo = _friendList.getValue(info.userID) as UserInfo;
         if(rel == null)
         {
            rel = _blackList.getValue(info.userID) as UserInfo;
         }
         if(Boolean(rel))
         {
            rel.hasSimpleInfo = true;
            rel.nick = info.nick;
            rel.color = info.color;
            rel.texture = info.texture;
            rel.vip = info.vip;
            rel.status = info.status;
            rel.mapID = info.mapID;
            rel.isCanBeTeacher = info.isCanBeTeacher;
            rel.teacherID = info.teacherID;
            rel.studentID = info.studentID;
            rel.graduationCount = info.graduationCount;
            rel.clothes = info.clothes.slice();
            dispatchEvent(new RelationEvent(RelationEvent.UPDATE_INFO,rel.userID));
         }
      }
      
      private static function getInstance() : EventDispatcher
      {
         if(instance == null)
         {
            instance = new EventDispatcher();
         }
         return instance;
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

