package com.robot.core.manager.mail
{
   import com.robot.core.CommandID;
   import com.robot.core.cmd.MailCmdListener;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.MailEvent;
   import com.robot.core.event.RobotEvent;
   import com.robot.core.info.mail.MailListInfo;
   import com.robot.core.info.mail.SingleMailInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.loading.loadingstyle.ILoadingStyle;
   import com.robot.core.ui.loading.loadingstyle.MailLoadingStyle;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.utils.ByteArray;
   import org.taomee.component.control.MLabel;
   import org.taomee.ds.HashMap;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ToolTipManager;
   
   public class MailManager
   {
      public static var total:uint;
      
      private static var unReadCount:uint;
      
      private static var unreadTxt:MLabel;
      
      private static var icon:InteractiveObject;
      
      private static var panel:AppModel;
      
      private static var loadingView:ILoadingStyle;
      
      private static var delArray:Array;
      
      private static var _instance:EventDispatcher;
      
      private static var _hashMap:HashMap = new HashMap();
      
      private static var sysMailMap:HashMap = new HashMap();
      
      public function MailManager()
      {
         super();
      }
      
      public static function setup() : void
      {
         EventManager.addEventListener(RobotEvent.BEAN_COMPLETE,onBeanComplete);
         addEventListener(MailEvent.MAIL_DELETE,onDelete);
         addEventListener(MailEvent.MAIL_CLEAR,onClear);
      }
      
      private static function onBeanComplete(event:Event) : void
      {
         getUnRead();
      }
      
      public static function getNew() : void
      {
         getUnRead();
      }
      
      public static function showIcon() : void
      {
         icon = TaskIconManager.getIcon("mail_icon");
         icon.x = 112;
         icon.y = 24;
         LevelManager.iconLevel.addChild(icon);
         ToolTipManager.add(icon,"星际邮件");
         icon.addEventListener(MouseEvent.CLICK,showMail);
         unreadTxt = new MLabel();
         unreadTxt.mouseEnabled = false;
         unreadTxt.mouseChildren = false;
         unreadTxt.width = 50;
         unreadTxt.blod = true;
         unreadTxt.fontSize = 14;
         unreadTxt.text = "";
         unreadTxt.textColor = 13311;
         unreadTxt.filters = [new GlowFilter(16777215,1,2,2,20)];
         unreadTxt.x = icon.x + 6;
         unreadTxt.y = icon.height + icon.y - 18;
         LevelManager.iconLevel.addChild(unreadTxt);
      }
      
      private static function showMail(event:MouseEvent) : void
      {
         if(!panel)
         {
            panel = new AppModel(ClientConfig.getAppModule("MailBox"),"正在打开邮箱");
            panel.loadingView = new MailLoadingStyle(LevelManager.appLevel);
            panel.setup();
         }
         panel.show();
      }
      
      public static function getUnRead() : void
      {
         SocketConnection.addCmdListener(CommandID.MAIL_GET_UNREAD,onGetUnRead);
         SocketConnection.send(CommandID.MAIL_GET_UNREAD);
      }
      
      private static function onGetUnRead(event:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.MAIL_GET_UNREAD,onGetUnRead);
         var data:ByteArray = event.data as ByteArray;
         unReadCount = data.readUnsignedInt();
         if(unReadCount > 0)
         {
            unreadTxt.text = unReadCount.toString();
         }
         else
         {
            unreadTxt.text = "";
         }
      }
      
      public static function sendMail(template:uint, mailContent:String, reciverList:Array) : void
      {
         var i:uint = 0;
         var by:ByteArray = new ByteArray();
         by.writeUTFBytes(mailContent + "0");
         if(by.length > 150)
         {
            Alarm.show("你输入的邮件内容过长");
            return;
         }
         if(reciverList.length > 10)
         {
            Alarm.show("最多只能同时给10个人发送邮件哦！");
            return;
         }
         var recvBy:ByteArray = new ByteArray();
         for each(i in reciverList)
         {
            recvBy.writeUnsignedInt(i);
         }
         SocketConnection.send(CommandID.MAIL_SEND,template,by.length,by,reciverList.length,recvBy);
      }
      
      public static function getMailContent(id:uint, fun:Function) : void
      {
         SocketConnection.addCmdListener(CommandID.MAIL_GET_CONTENT,function(event:SocketEvent):void
         {
            var info:SingleMailInfo = null;
            SocketConnection.removeCmdListener(CommandID.MAIL_GET_CONTENT,arguments.callee);
            var data:ByteArray = event.data as ByteArray;
            var id:uint = data.readUnsignedInt();
            var template:uint = data.readUnsignedInt();
            var time:uint = data.readUnsignedInt();
            var fromID:uint = data.readUnsignedInt();
            var fromNick:String = data.readUTFBytes(16);
            var readed:Boolean = data.readUnsignedInt() == 1;
            var len:uint = data.readUnsignedInt();
            var content:String = data.readUTFBytes(len);
            if(_hashMap.containsKey(id))
            {
               info = _hashMap.getValue(id);
            }
            else
            {
               info = new SingleMailInfo();
               _hashMap.add(id,info);
            }
            info.template = template;
            info.time = time;
            info.fromID = fromID;
            info.fromNick = fromNick;
            info.readed = readed;
            info.content = content;
            if(fun != null)
            {
               fun(info);
            }
         });
         SocketConnection.send(CommandID.MAIL_GET_CONTENT,id);
      }
      
      public static function setReaded(array:Array) : void
      {
         var i:uint = 0;
         if(array.length == 0)
         {
            return;
         }
         var by:ByteArray = new ByteArray();
         for each(i in array)
         {
            by.writeUnsignedInt(i);
         }
         SocketConnection.send(CommandID.MAIL_SET_READED,array.length,by);
      }
      
      public static function delMail(array:Array) : void
      {
         var i:uint = 0;
         if(array.length == 0)
         {
            return;
         }
         delArray = array.slice();
         var by:ByteArray = new ByteArray();
         for each(i in array)
         {
            by.writeUnsignedInt(i);
         }
         SocketConnection.send(CommandID.MAIL_DELETE,array.length,by);
      }
      
      public static function delAllMail() : void
      {
         SocketConnection.send(CommandID.MAIL_DEL_ALL);
      }
      
      public static function getMailList(start:uint = 1) : void
      {
         SocketConnection.addCmdListener(CommandID.MAIL_GET_LIST,onMailList);
         SocketConnection.send(CommandID.MAIL_GET_LIST,start);
      }
      
      private static function onMailList(event:SocketEvent) : void
      {
         var i:SingleMailInfo = null;
         var info:MailListInfo = event.data as MailListInfo;
         total = info.total;
         for each(i in info.mailList)
         {
            _hashMap.add(i.id,i);
         }
         if(info.total > _hashMap.length)
         {
            getMailList(_hashMap.length + 1);
         }
         else
         {
            dispatchEvent(new MailEvent(MailEvent.MAIL_LIST));
         }
      }
      
      public static function getMailInfos() : Array
      {
         return _hashMap.getValues().sortOn("time",Array.NUMERIC | Array.DESCENDING);
      }
      
      public static function getMailIDs() : Array
      {
         return _hashMap.getKeys();
      }
      
      public static function getSingleMail(id:uint) : SingleMailInfo
      {
         return _hashMap.getValue(id);
      }
      
      private static function onDelete(event:MailEvent) : void
      {
         var i:uint = 0;
         for each(i in delArray)
         {
            _hashMap.remove(i);
         }
         dispatchEvent(new MailEvent(MailEvent.MAIL_LIST));
      }
      
      private static function onClear(event:MailEvent) : void
      {
         _hashMap.clear();
         dispatchEvent(new MailEvent(MailEvent.MAIL_LIST));
      }
      
      public static function addSysMail(id:uint) : void
      {
         sysMailMap.add(id,id);
      }
      
      public static function delSysMail() : void
      {
         MailCmdListener.isShowTip = false;
         var ids:Array = sysMailMap.getKeys();
         delMail(ids);
         sysMailMap.clear();
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
         getInstance().dispatchEvent(event);
      }
      
      public static function hasEventListener(type:String) : Boolean
      {
         return getInstance().hasEventListener(type);
      }
   }
}

