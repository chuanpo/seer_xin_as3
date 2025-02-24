package com.robot.app.buyPetProps
{
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.event.ItemEvent;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.geom.Point;
   
   public class ListPetProps
   {
      private var _mc:MovieClip;
      
      private var _itemID:uint;
      
      private var _iconMC:MovieClip;
      
      private var _point:Point;
      
      public function ListPetProps(mc:MovieClip, _itemId:uint, iconMC:MovieClip, point:Point)
      {
         super();
         this._mc = mc;
         this._itemID = _itemId;
         this._iconMC = iconMC;
         this._point = point;
         ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,this.onList);
         ItemManager.upDateCollection(_itemId);
      }
      
      public function destroy() : void
      {
         ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,this.onList);
      }
      
      private function onList(e:Event) : void
      {
         ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,this.onList);
         var sigInfo:SingleItemInfo = ItemManager.getCollectionInfo(this._itemID);
         var itemName:String = ItemXMLInfo.getName(this._itemID);
         if(Boolean(sigInfo))
         {
            if(sigInfo.itemNum == 99)
            {
               Alarm.show("你已经拥有了99个" + itemName);
               return;
            }
         }
         BuyTipPanel.initPanel(this._mc,this._itemID,this._iconMC,this._point,this);
      }
   }
}

