package com.robot.app.petbag.petPropsBag.ui
{
   import com.robot.app.bag.BagListItem;
   import com.robot.app.petbag.PetBagController;
   import com.robot.app.petbag.PetPropInfo;
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.Alert;
   import com.robot.core.ui.itemTip.ItemInfoTip;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.getDefinitionByName;
   import org.taomee.events.SocketEvent;
   
   public class PetPropsPanel extends Sprite
   {
      public static const PREV_PAGE:String = "prevPage";
      
      public static const NEXT_PAGE:String = "nextPage";
      
      public static const SHOW_COLLECTION:String = "showCollection";
      
      private var _clickItemID:uint;
      
      private var petPropsPanel:Sprite;
      
      private var _listCon:Sprite;
      
      private var _itemArr:Array = [];
      
      private var _currentBagItem:BagListItem;
      
      private var _petInfo:PetInfo;
      
      private var itemID:uint;
      
      private var itemName:String;
      
      private var _propInfo:PetPropInfo;
      
      public function PetPropsPanel(ui:Sprite)
      {
         super();
         this.petPropsPanel = ui;
         this.show();
         this.addEvent();
      }
      
      public function hide() : void
      {
         this.petPropsPanel.visible = false;
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      public function addEvent() : void
      {
      }
      
      public function showItem(data:Array) : void
      {
         var id:uint = 0;
         var item:BagListItem = null;
         var info:SingleItemInfo = null;
         var hasPrev:Boolean = false;
         this.clearItemPanel();
         var len:int = int(data.length);
         for(var i:int = 0; i < len; i++)
         {
            id = uint(data[i]);
            item = this._listCon.getChildAt(i) as BagListItem;
            info = ItemManager.getPetItemInfo(id);
            hasPrev = false;
            item.buttonMode = true;
            item.setInfo(info,hasPrev);
            item.addEventListener(MouseEvent.ROLL_OVER,this.onShowItemInfo);
            item.addEventListener(MouseEvent.ROLL_OUT,this.onHideItemInfo);
            item.addEventListener(MouseEvent.CLICK,this.onPetPropsUsed);
         }
      }
      
      public function show() : void
      {
         this._listCon = new Sprite();
         this._listCon.x = 50;
         this._listCon.y = 20;
         this.petPropsPanel.addChild(this._listCon);
         this.createItemPanel();
         var prevBtn:SimpleButton = this.petPropsPanel["prev_btn"];
         var nextBtn:SimpleButton = this.petPropsPanel["next_btn"];
         prevBtn.addEventListener(MouseEvent.CLICK,this.prevHandler);
         nextBtn.addEventListener(MouseEvent.CLICK,this.nextHandler);
      }
      
      private function createItemPanel() : void
      {
         var item:BagListItem = null;
         for(var i:int = 0; i < 12; i++)
         {
            item = new BagListItem(UIManager.getSprite("itemPanel"));
            item.x = (item.width + 10) * int(i % 3);
            item.y = (item.height + 10) * int(i / 3);
            this._listCon.addChild(item);
         }
      }
      
      private function clearItemPanel() : void
      {
         var item:BagListItem = null;
         var len:int = this._listCon.numChildren;
         for(var i:int = 0; i < len; i++)
         {
            item = this._listCon.getChildAt(i) as BagListItem;
            item.clear();
            item.removeEventListener(MouseEvent.ROLL_OVER,this.onShowItemInfo);
            item.removeEventListener(MouseEvent.ROLL_OUT,this.onHideItemInfo);
            item.removeEventListener(MouseEvent.CLICK,this.onPetPropsUsed);
            item.buttonMode = false;
         }
      }
      
      private function prevHandler(event:MouseEvent) : void
      {
         dispatchEvent(new Event(PREV_PAGE));
      }
      
      private function nextHandler(event:MouseEvent) : void
      {
         dispatchEvent(new Event(NEXT_PAGE));
      }
      
      public function setPageNum(current:uint, total:uint) : void
      {
         this.petPropsPanel["page_txt"].text = current + "/" + total;
      }
      
      public function onPetPropsUsed(evt:MouseEvent) : void
      {
         var str:String = null;
         if(this._petInfo == null)
         {
            Alarm.show("你要先选择一个精灵噢");
            return;
         }
         this._currentBagItem = evt.currentTarget as BagListItem;
         if(this._currentBagItem.info == null)
         {
            return;
         }
         this.itemID = this._currentBagItem.info.itemID;
         this.itemName = ItemXMLInfo.getName(this.itemID);
         if(this.itemID == 300028 || this.itemID == 300035)
         {
            str = "你确定要使用" + TextFormatUtil.getRedTxt(this.itemName) + "吗?";
         }
         else
         {
            str = "你确定要为你的<font color=\'#ff0000\'>" + PetXMLInfo.getName(this._petInfo.id) + "</font>使用" + TextFormatUtil.getRedTxt(this.itemName) + "吗?";
            PetManager.handleCatchTime = this._petInfo.catchTime;
         }
         this._propInfo = new PetPropInfo();
         this._propInfo.petInfo = this._petInfo;
         this._propInfo.itemId = this.itemID;
         this._propInfo.itemName = this.itemName;
         Alert.show(str,this.onsureHandler);
      }
      
      private function onsureHandler() : void
      {
         var obj:Object = null;
         try
         {
            SocketConnection.addCmdListener(CommandID.USE_PET_ITEM_OUT_OF_FIGHT,this.onUpDate);
            obj = getDefinitionByName("com.robot.app.petbag.petPropsBag.petPropClass.PetPropClass_" + this.itemID);
            if(Boolean(obj))
            {
               new obj(this._propInfo);
            }
         }
         catch(e:Error)
         {
         }
      }
      
      private function onUpDate(evt:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.USE_PET_ITEM_OUT_OF_FIGHT,this.onUpDate);
         this.hide();
         PetManager.upDate();
         if(this._currentBagItem.info.itemNum > 0)
         {
            --this._currentBagItem.info.itemNum;
         }
         this._currentBagItem.setInfo(this._currentBagItem.info);
         var id:uint = uint(this._currentBagItem.info.itemID);
         if(id == 300037 || id == 300038 || id == 300039 || id == 300040 || id == 300041 || id == 300042)
         {
            PetBagController.panel.curretItem.showClear();
         }
      }
      
      private function onShowItemInfo(event:MouseEvent) : void
      {
         var item:BagListItem = event.currentTarget as BagListItem;
         if(item.info == null)
         {
            return;
         }
         this._clickItemID = item.info.itemID;
         ItemInfoTip.show(item.info);
      }
      
      private function onHideItemInfo(event:MouseEvent) : void
      {
         ItemInfoTip.hide();
      }
      
      public function getPetInfo(info:PetInfo) : PetInfo
      {
         this._petInfo = info;
         return this._petInfo;
      }
      
      public function get clickItemID() : uint
      {
         return this._clickItemID;
      }
   }
}

