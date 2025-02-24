package com.robot.app.sceneInteraction
{
   import com.robot.core.CommandID;
   import com.robot.core.event.PetEvent;
   import com.robot.core.info.pet.PetListInfo;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import flash.events.EventDispatcher;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   import org.taomee.events.SocketEvent;
   
   public class RoomPetManager extends EventDispatcher
   {
      private static var _instance:RoomPetManager;
      
      private var _petMap:HashMap = new HashMap();
      
      private var _isget:Boolean;
      
      public function RoomPetManager()
      {
         super();
      }
      
      public static function getInstance() : RoomPetManager
      {
         if(_instance == null)
         {
            _instance = new RoomPetManager();
         }
         return _instance;
      }
      
      public static function destroy() : void
      {
         if(Boolean(_instance))
         {
            _instance.destroy();
            _instance = null;
         }
      }
      
      public function getShowList(userID:uint) : void
      {
         if(this._isget)
         {
            dispatchEvent(new PetEvent(PetEvent.ROOM_PET_LIST,0));
            return;
         }
         SocketConnection.addCmdListener(CommandID.PET_ROOM_LIST,this.onList);
         SocketConnection.addCmdListener(CommandID.PET_ROOM_SHOW,this.onList);
         SocketConnection.send(CommandID.PET_ROOM_LIST,userID);
      }
      
      public function getInfos() : Array
      {
         return this._petMap.getValues();
      }
      
      public function showOrHide(i:PetListInfo, flag:Boolean) : void
      {
         var info:PetListInfo = null;
         if(flag)
         {
            if(this._petMap.length == 5)
            {
               Alarm.show("你已经有5个精灵在展示，再添加的话，精灵会觉得很拥挤哦");
               return;
            }
            this._petMap.add(i.catchTime,i);
         }
         else if(!this._petMap.remove(i.catchTime))
         {
            return;
         }
         var arr:Array = this._petMap.getValues();
         if(arr.length == 0)
         {
            SocketConnection.send(CommandID.PET_ROOM_SHOW,0);
            return;
         }
         var data:ByteArray = new ByteArray();
         for each(info in arr)
         {
            data.writeUnsignedInt(info.catchTime);
            data.writeUnsignedInt(info.id);
         }
         SocketConnection.send(CommandID.PET_ROOM_SHOW,this._petMap.length,data);
      }
      
      public function removePet(catchTime:uint) : void
      {
         if(Boolean(this._petMap.remove(catchTime)))
         {
            dispatchEvent(new PetEvent(PetEvent.ROOM_PET_SHOW,0));
         }
      }
      
      public function contains(ct:uint) : Boolean
      {
         return this._petMap.containsKey(ct);
      }
      
      public function destroy() : void
      {
         SocketConnection.removeCmdListener(CommandID.PET_ROOM_LIST,this.onList);
         SocketConnection.removeCmdListener(CommandID.PET_ROOM_SHOW,this.onList);
         this._petMap = null;
      }
      
      private function onList(e:SocketEvent) : void
      {
         var info:PetListInfo = null;
         this._petMap.clear();
         var data:ByteArray = e.data as ByteArray;
         var len:uint = data.readUnsignedInt();
         for(var i:int = 0; i < len; i++)
         {
            info = new PetListInfo(data);
            this._petMap.add(info.catchTime,info);
         }
         if(e.headInfo.cmdID == CommandID.PET_ROOM_LIST)
         {
            this._isget = true;
            SocketConnection.removeCmdListener(CommandID.PET_ROOM_LIST,this.onList);
            dispatchEvent(new PetEvent(PetEvent.ROOM_PET_LIST,0));
         }
         else
         {
            dispatchEvent(new PetEvent(PetEvent.ROOM_PET_SHOW,0));
         }
      }
   }
}

