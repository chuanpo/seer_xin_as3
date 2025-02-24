package com.robot.app.darkPortal
{
   import com.robot.app.fightLevel.FightPetBagController;
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.manager.MapManager;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.ByteArray;
   import flash.utils.setTimeout;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.ToolTipManager;
   
   public class DarkPortalModel
   {
      private static var _curBossId:uint;
      
      private static var _curDoor:uint;
      
      private static var _doorHanlder:Function;
      
      private static var _fiSucHandler:Function;
      
      private static var _panel:AppModel;
      
      private static var _curFun:Function;
      
      private static var _petBtn:SimpleButton;
      
      public static var doorIndex:uint = 0;
      
      public function DarkPortalModel()
      {
         super();
      }
      
      public static function get curDoor() : uint
      {
         return _curDoor;
      }
      
      public static function set curDoor(id:uint) : void
      {
         _curDoor = id;
      }
      
      public static function get curBossId() : uint
      {
         return _curBossId;
      }
      
      public static function set curBossId(id:uint) : void
      {
         _curBossId = id;
      }
      
      public static function enterDarkProtal(doorId:uint, func:Function = null, door:uint = 0) : void
      {
         doorIndex = door;
         _curDoor = doorId;
         _doorHanlder = func;
         SocketConnection.addCmdListener(CommandID.OPEN_DARKPORTAL,onSucHandler);
         SocketConnection.send(CommandID.OPEN_DARKPORTAL,doorId);
      }
      
      private static function onSucHandler(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.OPEN_DARKPORTAL,onSucHandler);
         var by:ByteArray = e.data as ByteArray;
         var id:uint = by.readUnsignedInt();
         _curBossId = id;
         if(_doorHanlder != null)
         {
            _doorHanlder();
            _doorHanlder = null;
         }
         enterMap();
      }
      
      public static function enterMap() : void
      {
         var map:uint = 502;
         var door:uint = uint(_curDoor + 1);
         if(door > 6)
         {
            if(door % 6 == 0)
            {
               map += door / 6;
            }
            else
            {
               map += uint(door / 6) + 1;
            }
         }
         else
         {
            map++;
         }
         MapManager.changeLocalMap(map);
      }
      
      public static function fightDarkProtal(func:Function = null) : void
      {
         _fiSucHandler = func;
         SocketConnection.addCmdListener(CommandID.FIGHT_DARKPORTAL,onFiHandler);
         SocketConnection.send(CommandID.FIGHT_DARKPORTAL);
      }
      
      private static function onFiHandler(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.FIGHT_DARKPORTAL,onFiHandler);
         if(_fiSucHandler != null)
         {
            _fiSucHandler();
            _fiSucHandler = null;
         }
      }
      
      public static function leaveDarkProtal(func:Function = null) : void
      {
         SocketConnection.addCmdListener(CommandID.LEAVE_DARKPORTAL,function(e:SocketEvent):void
         {
            SocketConnection.removeCmdListener(CommandID.LEAVE_DARKPORTAL,arguments.callee);
            if(func != null)
            {
               func();
            }
            MapManager.changeMap(110);
         });
         SocketConnection.send(CommandID.LEAVE_DARKPORTAL);
      }
      
      public static function showDoor(index:uint, onCloseFun:Function = null) : void
      {
         destroyPanel();
         _curFun = onCloseFun;
         _panel = new AppModel(ClientConfig.getAppModule("DarkDoorChoicePanel_" + index),"正在打开暗黑之门");
         _panel.setup();
         _panel.sharedEvents.addEventListener(Event.CLOSE,onCloseHandler);
         _panel.show();
      }
      
      private static function onCloseHandler(e:Event) : void
      {
         if(_curFun != null)
         {
            _curFun();
            _curFun = null;
         }
      }
      
      public static function destroyPanel() : void
      {
         if(Boolean(_panel))
         {
            _panel.sharedEvents.removeEventListener(Event.CLOSE,onCloseHandler);
            _panel.destroy();
            _panel = null;
         }
      }
      
      public static function destroy() : void
      {
         destroyPanel();
         SocketConnection.removeCmdListener(CommandID.OPEN_DARKPORTAL,onSucHandler);
         SocketConnection.removeCmdListener(CommandID.FIGHT_DARKPORTAL,onFiHandler);
         onCloseHandler(null);
      }
      
      public static function showPetEnrichBlood() : void
      {
         setTimeout(function():void
         {
            _petBtn = MapManager.currentMap.controlLevel["petMc"];
            _petBtn.addEventListener(MouseEvent.CLICK,onClickHandler);
            ToolTipManager.add(_petBtn,"精灵背包");
         },200);
      }
      
      private static function onClickHandler(e:MouseEvent) : void
      {
         FightPetBagController.show();
      }
      
      public static function des() : void
      {
         if(Boolean(_petBtn))
         {
            ToolTipManager.remove(_petBtn);
            _petBtn.addEventListener(MouseEvent.CLICK,onClickHandler);
            _petBtn = null;
         }
         FightPetBagController.destroy();
      }
   }
}

