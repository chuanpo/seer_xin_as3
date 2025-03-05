package com.robot.core.manager
{
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.mode.BasePeoleModel;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import org.taomee.ds.HashMap;
   import org.taomee.utils.DisplayUtil;
   
   public class UserManager
   {
      private static var instance:EventDispatcher;
      
      private static var _listDic:HashMap = new HashMap();

      public static var _hideOtherUserModelFlag:Boolean = false;
      
      public function UserManager()
      {
         super();
      }
      
      public static function get length() : int
      {
         return _listDic.length;
      }
      
      public static function addUser(id:uint, userModel:BasePeoleModel) : BasePeoleModel
      {
         return _listDic.add(id,userModel);
      }
      
      public static function removeUser(id:uint) : BasePeoleModel
      {
         return _listDic.remove(id);
      }
      
      public static function getUserModel(id:uint) : BasePeoleModel
      {
         if(id == MainManager.actorID)
         {
            return MainManager.actorModel;
         }
         return _listDic.getValue(id);
      }
      
      public static function clear() : void
      {
         var i:Sprite = null;
         for each(i in getUserModelList())
         {
            DisplayUtil.removeForParent(i);
         }
         _listDic.clear();
      }
      
      public static function getUserIDList() : Array
      {
         return _listDic.getKeys();
      }
      
      public static function getUserModelList() : Array
      {
         return _listDic.getValues();
      }
      
      public static function contains(id:uint) : Boolean
      {
         return _listDic.containsKey(id);
      }
      
      public static function getInstance() : EventDispatcher
      {
         if(instance == null)
         {
            instance = new EventDispatcher();
         }
         return instance;
      }
      
      public static function addActionListener(userID:uint, listener:Function) : void
      {
         getInstance().addEventListener(userID.toString(),listener,false,0,false);
      }
      
      public static function removeActionListener(userID:uint, listener:Function) : void
      {
         getInstance().removeEventListener(userID.toString(),listener,false);
      }
      
      public static function dispatchAction(userID:uint, actionType:String, data:Object) : void
      {
         if(hasActionListener(userID))
         {
            getInstance().dispatchEvent(new PeopleActionEvent(userID.toString(),actionType,data));
         }
      }
      
      public static function hasActionListener(userID:uint) : Boolean
      {
         return getInstance().hasEventListener(userID.toString());
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

