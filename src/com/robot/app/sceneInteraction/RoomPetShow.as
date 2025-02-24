package com.robot.app.sceneInteraction
{
   import com.robot.core.event.PetEvent;
   import com.robot.core.info.pet.PetListInfo;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.mode.AppModel;
   import com.robot.core.mode.RoomPetModel;
   import com.robot.core.pet.PetInfoController;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import org.taomee.ds.HashMap;
   
   public class RoomPetShow
   {
      private var _petMap:HashMap = new HashMap();
      
      private var _allowLen:int = 0;
      
      private var _allowArr:Array;
      
      private var _appModel:AppModel;
      
      public function RoomPetShow(userID:uint)
      {
         super();
         this._allowArr = MapManager.currentMap.allowData;
         this._allowLen = this._allowArr.length;
         RoomPetManager.getInstance().addEventListener(PetEvent.ROOM_PET_LIST,this.onList);
         RoomPetManager.getInstance().addEventListener(PetEvent.ROOM_PET_SHOW,this.onShow);
         RoomPetManager.getInstance().getShowList(userID);
         PetManager.addEventListener(PetEvent.STORAGE_REMOVED,this.onRemoveStorage);
      }
      
      public function destroy() : void
      {
         PetManager.removeEventListener(PetEvent.STORAGE_REMOVED,this.onRemoveStorage);
         RoomPetManager.getInstance().removeEventListener(PetEvent.ROOM_PET_LIST,this.onList);
         RoomPetManager.getInstance().removeEventListener(PetEvent.ROOM_PET_SHOW,this.onShow);
         this._petMap.eachKey(function(key:uint):void
         {
            var model:RoomPetModel = _petMap.remove(key);
            model.destroy();
            model = null;
         });
         this._petMap = null;
         RoomPetManager.destroy();
         if(Boolean(this._appModel))
         {
            this._appModel.destroy();
         }
      }
      
      private function update() : void
      {
         var arr:Array;
         var info:PetListInfo = null;
         var pm:RoomPetModel = null;
         this._petMap.eachKey(function(key:uint):void
         {
            var model:RoomPetModel = null;
            if(!RoomPetManager.getInstance().contains(key))
            {
               model = _petMap.remove(key);
               model.destroy();
               model = null;
            }
         });
         arr = RoomPetManager.getInstance().getInfos();
         for each(info in arr)
         {
            if(!this._petMap.containsKey(info.catchTime))
            {
               pm = new RoomPetModel(info);
               this._petMap.add(info.catchTime,pm);
               pm.show(this._allowArr[int(Math.random() * this._allowLen)]);
               pm.addEventListener(MouseEvent.CLICK,this.onClick);
            }
         }
      }
      
      private function onList(e:Event) : void
      {
         RoomPetManager.getInstance().removeEventListener(PetEvent.ROOM_PET_LIST,this.onList);
         this.update();
      }
      
      private function onShow(e:Event) : void
      {
         this.update();
      }
      
      private function onClick(e:MouseEvent) : void
      {
         var pm:RoomPetModel = e.currentTarget as RoomPetModel;
         PetInfoController.getInfo(true,MainManager.actorInfo.mapID,pm.info.catchTime);
      }
      
      private function onRemoveStorage(e:PetEvent) : void
      {
         RoomPetManager.getInstance().removePet(e.catchTime());
      }
   }
}

