package com.robot.core
{
   import com.robot.core.config.ClientConfig;
   import com.robot.core.manager.MainManager;
   import flash.events.Event;
   import flash.net.URLLoader;
   import flash.net.URLRequest;
   import flash.net.URLRequestMethod;
   import flash.net.URLVariables;
   import flash.system.Capabilities;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ResourceManager;
   
   public class ErrorReport
   {
      public static const PATH:String = "http://114.80.98.38/cgi-bin/stat/seer-err-report.cgi";
      
      public static const MIMI_LOGIN_ERROR:uint = 1;
      
      public static const EMAIL_LOGIN_ERROR:uint = 2;
      
      public static const GET_SERVER_LIST_ERROR:uint = 3;
      
      public static const LOGIN_ONLINE_ERROR:uint = 4;
      
      public static const REGISTE_ERROR:uint = 5;
      
      public static const CREATE_SEER_ERROR:uint = 6;
      
      public static const LOGIN_HOME_ONLINE_ERROR:uint = 7;
      
      public static const SOCKET_CLOSE_ERROR:uint = 8;
      
      public static const RESOURCE_MANAGER_ERROR:uint = 9;
      
      public static const RESOURCE_REFLECT_ERROR:uint = 10;
      
      setup();
      
      public function ErrorReport()
      {
         super();
      }
      
      private static function setup() : void
      {
         EventManager.addEventListener(ResourceManager.RESOUCE_REFLECT_ERROR,function(e:Event):void
         {
            sendError(RESOURCE_REFLECT_ERROR);
         });
         EventManager.addEventListener(ResourceManager.RESOUCE_ERROR,function(e:Event):void
         {
            sendError(RESOURCE_MANAGER_ERROR);
         });
      }
      
      public static function sendError(type:uint) : void
      {
         var urlloader:URLLoader = new URLLoader();
         var urlvars:URLVariables = new URLVariables();
         var date:Date = new Date();
         urlvars.date = date.getFullYear() + "/" + (date.getMonth() + 1) + "/" + date.getDate() + "/" + date.getHours() + ":" + date.getMinutes();
         urlvars.serverIP = getIP(type);
         urlvars.serverPort = getPort(type);
         urlvars.version = ClientConfig.uiVersion;
         urlvars.id = MainManager.actorID;
         if(Boolean(MainManager.actorModel))
         {
            urlvars.x = MainManager.actorModel.x;
            urlvars.y = MainManager.actorModel.y;
         }
         else
         {
            urlvars.x = 0;
            urlvars.y = 0;
         }
         if(Boolean(MainManager.actorInfo))
         {
            urlvars.mapID = MainManager.actorInfo.mapID;
         }
         else
         {
            urlvars.mapID = 0;
         }
         urlvars.serverID = MainManager.serverID;
         urlvars.playerType = Capabilities.playerType;
         urlvars.playerVersion = Capabilities.version;
         urlvars.isDebugger = Capabilities.isDebugger;
         urlvars.os = Capabilities.os;
         urlvars.language = Capabilities.language;
         var req:URLRequest = new URLRequest(PATH + "?folder=" + type);
         req.method = URLRequestMethod.POST;
         req.data = urlvars;
         urlloader.load(req);
      }
      
      private static function getIP(type:uint) : String
      {
         var str:String = null;
         if(type == MIMI_LOGIN_ERROR || type == EMAIL_LOGIN_ERROR)
         {
            str = ClientConfig.ID_IP;
         }
         else if(type == GET_SERVER_LIST_ERROR || type == CREATE_SEER_ERROR)
         {
            str = ClientConfig.SUB_SERVER_IP;
         }
         return str;
      }
      
      private static function getPort(type:uint) : uint
      {
         var i:int = 0;
         if(type == MIMI_LOGIN_ERROR || type == EMAIL_LOGIN_ERROR)
         {
            i = int(ClientConfig.ID_PORT);
         }
         else if(type == GET_SERVER_LIST_ERROR || type == CREATE_SEER_ERROR)
         {
            i = int(ClientConfig.SUB_SERVER_PORT);
         }
         return i;
      }
   }
}

