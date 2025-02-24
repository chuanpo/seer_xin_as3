package com.robot.core.manager
{
   import com.robot.core.CommandID;
   import com.robot.core.SoundManager;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.event.GamePlatformEvent;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.event.MapEvent;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import org.taomee.events.SocketEvent;
   
   public class GamePlatformManager
   {
      private static var currentGame:AppModel;
      
      private static var _name:String;
      
      private static var paramObj:Object;
      
      private static var _instance:EventDispatcher;
      
      private static var currentName:String = "";
      
      private static var _isOnline:Boolean = false;
      
      private static var isConnecting:Boolean = false;
      
      public function GamePlatformManager()
      {
         super();
      }
      
      private static function setup() : void
      {
         MapManager.addEventListener(MapEvent.MAP_SWITCH_OPEN,onSwitchOpen);
      }
      
      public static function win() : void
      {
         dispatchEvent(new GamePlatformEvent(GamePlatformEvent.GAME_WIN));
      }
      
      public static function lost() : void
      {
         dispatchEvent(new GamePlatformEvent(GamePlatformEvent.GAME_LOST));
      }
      
      private static function onSwitchOpen(event:MapEvent) : void
      {
         if(Boolean(currentGame))
         {
            currentGame.destroy();
            currentGame = null;
         }
      }
      
      public static function join(name:String, isNet:Boolean = true, gameID:uint = 1, obj:Object = null) : void
      {
         if(_isOnline)
         {
            throw new Error("游戏平台中已经有游戏在运行，不能再次加入");
         }
         if(isConnecting)
         {
            Alarm.show("正在连接游戏平台，不能重复发送连接申请");
            return;
         }
         _name = name;
         paramObj = obj;
         if(isNet)
         {
            isConnecting = true;
            SocketConnection.addCmdListener(CommandID.JOIN_GAME,onJoin);
            SocketConnection.send(CommandID.JOIN_GAME,gameID);
         }
         else
         {
            _isOnline = false;
            loadGame();
         }
      }
      
      public static function gameOver(percent:uint = 0, score:uint = 0) : void
      {
         trace("游戏结束",percent,score);
         SoundManager.playSound();
         if(_isOnline)
         {
            SocketConnection.addCmdListener(CommandID.GAME_OVER,gameOverHander);
            SocketConnection.send(CommandID.GAME_OVER,percent,score);
         }
      }
      
      private static function gameOverHander(event:SocketEvent) : void
      {
         _isOnline = false;
      }
      
      private static function onJoin(event:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.JOIN_GAME,onJoin);
         _isOnline = true;
         isConnecting = false;
         loadGame();
      }
      
      private static function loadGame() : void
      {
         if(_name == currentName)
         {
            if(!currentGame)
            {
               currentGame = new AppModel(ClientConfig.getGameModule(_name),"正在进入游戏……");
               currentGame.appLoader.addEventListener(MCLoadEvent.CLOSE,onCloseLoading);
               currentGame.setup();
               currentGame.init(paramObj);
            }
            currentGame.show();
            SoundManager.stopSound();
         }
         else
         {
            if(Boolean(currentGame))
            {
               currentGame.appLoader.removeEventListener(MCLoadEvent.CLOSE,onCloseLoading);
               currentGame.destroy();
            }
            currentGame = new AppModel(ClientConfig.getGameModule(_name),"正在进入游戏……");
            currentGame.setup();
            currentGame.init(paramObj);
            currentGame.show();
            SoundManager.stopSound();
         }
         currentName = _name;
      }
      
      private static function onCloseLoading(event:MCLoadEvent) : void
      {
         if(_isOnline)
         {
            SocketConnection.send(CommandID.GAME_OVER,0,0);
         }
         SoundManager.playSound();
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

