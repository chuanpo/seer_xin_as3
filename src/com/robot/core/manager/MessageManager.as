package com.robot.core.manager
{
   import com.robot.core.CommandID;
   import com.robot.core.event.ChatEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.ChatInfo;
   import com.robot.core.info.InformInfo;
   import com.robot.core.info.TeamChatInfo;
   import com.robot.core.info.team.TeamInformInfo;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import org.taomee.ds.HashMap;
   
   public class MessageManager
   {
      private static var instance:EventDispatcher;
      
      public static const SYS_TYPE:uint = 1;
      
      public static const TEAM_TYPE:uint = 2;
      
      public static const TEAM_CHAT_TYPE:uint = 3;
      
      private static const MAX:int = 300;
      
      private static var _userMap:HashMap = new HashMap();
      
      private static var _unReadList:Array = [];
      
      private static var teamAddInfoMap:HashMap = new HashMap();
      
      public static var inviteJoinTeamMap:HashMap = new HashMap();
      
      public static var friendAddInfoMap:HashMap = new HashMap();
      
      public static var friendAnswerInfoMap:HashMap = new HashMap();
      
      public static var friendRemoveInfoMap:HashMap = new HashMap();
      
      public function MessageManager()
      {
         super();
      }
      
      public static function addChatInfo(info:ChatInfo) : void
      {
         if(RelationManager.isBlack(info.senderID))
         {
            return;
         }
         var estr:String = ChatEvent.TALK + info.talkID.toString();
         if(hasEventListener(estr))
         {
            dispatchEvent(new ChatEvent(estr,info));
         }
         else
         {
            _unReadList.push({
               "_id":info.talkID,
               "_info":info
            });
            dispatchEvent(new RobotEvent(RobotEvent.MESSAGE));
         }
         var arr:Array = _userMap.getValue(info.talkID);
         if(arr == null)
         {
            arr = [];
            _userMap.add(info.talkID,arr);
         }
         arr.push(info);
         if(arr.length > MAX)
         {
            arr.shift();
         }
      }
      
      public static function addInformInfo(info:InformInfo) : void
      {
         if(info.type == CommandID.FRIEND_ADD)
         {
            if(RelationManager.friendLength >= RelationManager.F_MAX)
            {
               return;
            }
            if(friendAddInfoMap.containsKey(info.userID))
            {
               dispatchEvent(new RobotEvent(RobotEvent.ADD_FRIEND_MSG));
               return;
            }
            friendAddInfoMap.add(info.userID,info);
            dispatchEvent(new RobotEvent(RobotEvent.ADD_FRIEND_MSG));
            return;
         }
         if(info.type == CommandID.TEAM_ADD)
         {
            if(teamAddInfoMap.containsKey(info.userID))
            {
               return;
            }
            teamAddInfoMap.add(info.userID,info);
         }
         _unReadList.push({
            "_id":SYS_TYPE,
            "_info":info
         });
         dispatchEvent(new RobotEvent(RobotEvent.MESSAGE));
      }
      
      public static function addTeamInformInfo(info:TeamInformInfo) : void
      {
         if(info.type == CommandID.TEAM_INVITE_TO_JOIN)
         {
            inviteJoinTeamMap.add(info.userID,info);
            dispatchEvent(new RobotEvent(RobotEvent.ADD_TEAM_MSG));
            return;
         }
         _unReadList.push({
            "_id":TEAM_TYPE,
            "_info":info
         });
         dispatchEvent(new RobotEvent(RobotEvent.MESSAGE));
      }
      
      public static function addTeamChatInfo(info:TeamChatInfo) : void
      {
         var i:Object = null;
         var b:Boolean = false;
         for each(i in _unReadList)
         {
            if(i._id == TEAM_CHAT_TYPE)
            {
               b = true;
               break;
            }
         }
         if(!b)
         {
            _unReadList.push({
               "_id":TEAM_CHAT_TYPE,
               "_info":info
            });
            dispatchEvent(new RobotEvent(RobotEvent.MESSAGE));
         }
      }
      
      public static function removeUnUserID(userID:uint) : void
      {
         _unReadList = _unReadList.filter(function(item:Object, index:int, array:Array):Boolean
         {
            if(item._id == userID)
            {
               return false;
            }
            return true;
         });
      }
      
      public static function getChatInfo(userID:uint) : Array
      {
         return _userMap.getValue(userID);
      }
      
      public static function getInformInfo() : InformInfo
      {
         var info:InformInfo = null;
         var len:int = int(_unReadList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(_unReadList[i]._id == SYS_TYPE)
            {
               info = _unReadList[i]._info;
               _unReadList.splice(i,1);
               if(info.type == CommandID.TEAM_ADD)
               {
                  if(teamAddInfoMap.containsKey(info.userID))
                  {
                     teamAddInfoMap.remove(info.userID);
                  }
               }
               else if(info.type == CommandID.FRIEND_ADD)
               {
                  if(friendAddInfoMap.containsKey(info.userID))
                  {
                     friendAddInfoMap.remove(info.userID);
                  }
               }
               return info;
            }
         }
         return null;
      }
      
      public static function getInviteJoinTeamInfo(userID:uint) : TeamInformInfo
      {
         if(inviteJoinTeamMap.containsKey(userID))
         {
            return inviteJoinTeamMap.getValue(userID);
         }
         return null;
      }
      
      public static function removeAddFridInfo(id:uint) : void
      {
         if(friendAddInfoMap.containsKey(id))
         {
            friendAddInfoMap.remove(id);
         }
      }
      
      public static function removeInviteJoinTeamInfo(id:uint) : void
      {
         if(inviteJoinTeamMap.containsKey(id))
         {
            inviteJoinTeamMap.remove(id);
         }
      }
      
      public static function getTeamInformInfo() : TeamInformInfo
      {
         var info:TeamInformInfo = null;
         var len:int = int(_unReadList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(_unReadList[i]._id == TEAM_TYPE)
            {
               info = _unReadList[i]._info;
               _unReadList.splice(i,1);
               return info;
            }
         }
         return null;
      }
      
      public static function getTeamChatInfo() : TeamChatInfo
      {
         var info:TeamChatInfo = null;
         var len:int = int(_unReadList.length);
         for(var i:int = 0; i < len; i++)
         {
            if(_unReadList[i]._id == TEAM_CHAT_TYPE)
            {
               info = _unReadList[i]._info;
               _unReadList.splice(i,1);
               return info;
            }
         }
         return null;
      }
      
      public static function getFristUnReadID() : uint
      {
         if(_unReadList.length > 0)
         {
            return _unReadList[0]._id;
         }
         return 0;
      }
      
      public static function unReadLength() : int
      {
         return _unReadList.length;
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
         getInstance().dispatchEvent(event);
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

