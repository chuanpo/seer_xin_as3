package com.robot.core.pet
{
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.info.RoomPetInfo;
   import com.robot.core.manager.bean.BaseBeanController;
   import com.robot.core.mode.AppModel;
   import com.robot.core.net.SocketConnection;
   import org.taomee.events.SocketEvent;
   
   public class PetInfoController extends BaseBeanController
   {
      private static var _petInfoApp:AppModel;
      
      private static var _roomPetInfoPanel:AppModel;
      
      public static var _isRoom:Boolean = false;
      
      public function PetInfoController()
      {
         super();
      }
      
      public static function getInfo(type:Boolean, userId:uint, cap:uint) : void
      {
         _isRoom = type;
         SocketConnection.send(CommandID.PET_ROOM_INFO,userId,cap);
      }
      
      public static function showPetInfoPanel(info:RoomPetInfo) : void
      {
         if(!_petInfoApp)
         {
            _petInfoApp = new AppModel(ClientConfig.getAppModule("PetSimpleInfoPanel"),"正在打开精灵信息");
            _petInfoApp.setup();
         }
         _petInfoApp.init(info);
         _petInfoApp.show();
      }
      
      public static function showRoomInfoPanel(info:RoomPetInfo) : void
      {
         if(!_roomPetInfoPanel)
         {
            _roomPetInfoPanel = new AppModel(ClientConfig.getAppModule("RoomPetInfoPanel"),"正在打开精灵信息");
            _roomPetInfoPanel.setup();
         }
         _roomPetInfoPanel.init(info);
         _roomPetInfoPanel.show();
      }
      
      override public function start() : void
      {
         SocketConnection.addCmdListener(CommandID.PET_ROOM_INFO,this.onInfoHandler);
         finish();
      }
      
      private function onInfoHandler(e:SocketEvent) : void
      {
         var info:RoomPetInfo = e.data as RoomPetInfo;
         if(_isRoom)
         {
            if(Boolean(_petInfoApp))
            {
               _petInfoApp.destroy();
               _petInfoApp = null;
            }
            showRoomInfoPanel(info);
         }
         else
         {
            if(Boolean(_roomPetInfoPanel))
            {
               _roomPetInfoPanel.destroy();
               _roomPetInfoPanel = null;
            }
            showPetInfoPanel(info);
         }
      }
   }
}

