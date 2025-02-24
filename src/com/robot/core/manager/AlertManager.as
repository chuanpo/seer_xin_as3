package com.robot.core.manager
{
   import com.robot.core.manager.alert.AlertInfo;
   import com.robot.core.manager.alert.AlertType;
   import com.robot.core.ui.alert.IAlert;
   import com.robot.core.ui.alert2.Alarm;
   import com.robot.core.ui.alert2.Alert;
   import com.robot.core.ui.alert2.Answer;
   import com.robot.core.ui.alert2.ItemInBagAlarm;
   import com.robot.core.ui.alert2.PetInBagAlarm;
   import com.robot.core.ui.alert2.PetInStorageAlarm;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   
   public class AlertManager
   {
      private static var _currAlert:IAlert;
      
      private static var _list:Array = [];
      
      public function AlertManager()
      {
         super();
      }
      
      public static function show(type:String, str:String, iconURL:String = "", parant:DisplayObjectContainer = null, applyFun:Function = null, cancelFun:Function = null, linkFun:Function = null, disMouse:Boolean = true, isGC:Boolean = true, isBreak:Boolean = false) : void
      {
         var info:AlertInfo = null;
         info = new AlertInfo();
         info.type = type;
         info.str = str;
         info.iconURL = iconURL;
         info.parant = parant;
         info.applyFun = applyFun;
         info.cancelFun = cancelFun;
         info.linkFun = linkFun;
         info.disMouse = disMouse;
         info.isGC = isGC;
         info.isBreak = isBreak;
         _list.push(info);
         nextShow();
      }
      
      public static function showSimpleAlarm(str:String, applyFun:Function = null) : void
      {
         show(AlertType.ALARM,str,"",null,applyFun);
      }
      
      public static function showSimpleAlert(str:String, applyFun:Function = null, cancelFun:Function = null) : void
      {
         show(AlertType.ALERT,str,"",null,applyFun,cancelFun);
      }
      
      public static function showSimpleAnswer(str:String, applyFun:Function = null, cancelFun:Function = null) : void
      {
         show(AlertType.ANSWER,str,"",null,applyFun,cancelFun);
      }
      
      public static function showForInfo(info:AlertInfo) : void
      {
         _list.push(info);
         nextShow();
      }
      
      public static function nextShow() : void
      {
         var info:AlertInfo = null;
         if(_list.length == 0)
         {
            return;
         }
         if(_currAlert == null)
         {
            info = _list.shift() as AlertInfo;
            switch(info.type)
            {
               case AlertType.ALARM:
                  _currAlert = new Alarm(info);
                  break;
               case AlertType.ALERT:
                  _currAlert = new Alert(info);
                  break;
               case AlertType.ANSWER:
                  _currAlert = new Answer(info);
                  break;
               case AlertType.ITEM_IN_BAG_ALARM:
                  _currAlert = new ItemInBagAlarm(info);
                  break;
               case AlertType.ITEM_IN_STORAGE_ALARM:
                  break;
               case AlertType.PET_IN_BAG_ALARM:
                  _currAlert = new PetInBagAlarm(info);
                  break;
               case AlertType.PET_IN_STORAGE_ALARM:
                  _currAlert = new PetInStorageAlarm(info);
            }
            _currAlert.addEventListener(Event.CLOSE,onClose);
            _currAlert.show();
         }
      }
      
      public static function destroy() : void
      {
         if(Boolean(_currAlert))
         {
            if(_currAlert.info.isGC)
            {
               _currAlert.removeEventListener(Event.CLOSE,onClose);
               _currAlert.destroy();
               _currAlert = null;
            }
         }
         _list = _list.filter(function(item:AlertInfo, index:int, array:Array):Boolean
         {
            if(item.isGC)
            {
               return false;
            }
            return true;
         });
      }
      
      private static function onClose(e:Event) : void
      {
         var isBreak:Boolean = Boolean(_currAlert.info.isBreak);
         _currAlert.removeEventListener(Event.CLOSE,onClose);
         _currAlert.destroy();
         _currAlert = null;
         if(!isBreak)
         {
            nextShow();
         }
      }
   }
}

