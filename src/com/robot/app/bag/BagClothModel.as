package com.robot.app.bag
{
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.config.xml.SuitXMLInfo;
   import com.robot.core.event.ItemEvent;
   import com.robot.core.info.item.ClothInfo;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.utils.ItemType;
   import flash.events.Event;
   import org.taomee.events.DynamicEvent;
   
   public class BagClothModel
   {
      private var _view:BagPanel;
      
      private var _itemList:Array;
      
      private var _filList:Array;
      
      private var totalPage:uint;
      
      private var currentPage:uint = 1;
      
      private var PET_NUM:uint = 12;
      
      public function BagClothModel(view:BagPanel)
      {
         super();
         this._view = view;
         this._view.addEventListener(Event.COMPLETE,this.onPanelComplete);
         this._view.addEventListener(Event.CLOSE,this.onPanelClose);
         this._view.addEventListener(BagPanel.NEXT_PAGE,this.nextHandler);
         this._view.addEventListener(BagPanel.PREV_PAGE,this.prevHandler);
         this._view.addEventListener(BagPanel.SHOW_CLOTH,this.onShowTab);
         this._view.addEventListener(BagPanel.SHOW_COLLECTION,this.onShowTab);
         this._view.addEventListener(BagPanel.SHOW_NONO,this.onShowTab);
         this._view.addEventListener(BagPanel.SHOW_SOULBEAD,this.onShowTab);
         this._view.addEventListener(BagTypeEvent.SELECT,this.onTypeSelect);
      }
      
      private function onPanelComplete(event:Event) : void
      {
         this.currentPage = 1;
         this.init();
         ItemManager.addEventListener(ItemEvent.CLOTH_LIST,this.onClothList);
         ItemManager.getCloth();
      }
      
      private function onPanelClose(event:Event) : void
      {
         this.currentPage = 1;
         this.clear();
      }
      
      private function init() : void
      {
         MainManager.actorModel.addEventListener(BagChangeClothAction.TAKE_OFF_CLOTH,this.actEventHandler);
         MainManager.actorModel.addEventListener(BagChangeClothAction.REPLACE_CLOTH,this.actEventHandler);
         MainManager.actorModel.addEventListener(BagChangeClothAction.USE_CLOTH,this.actEventHandler);
         MainManager.actorModel.addEventListener(BagChangeClothAction.CLOTH_CHANGE,this.onClothChange);
      }
      
      private function onShowTab(e:Event) : void
      {
         this._itemList = [];
         this._filList = [];
         switch(e.type)
         {
            case BagPanel.SHOW_CLOTH:
               ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,this.onCollectonList);
               ItemManager.removeEventListener(ItemEvent.SUPER_ITEM_LIST,this.onNoNoList);
               ItemManager.addEventListener(ItemEvent.CLOTH_LIST,this.onClothList);
               ItemManager.getCloth();
               break;
            case BagPanel.SHOW_COLLECTION:
               ItemManager.removeEventListener(ItemEvent.CLOTH_LIST,this.onClothList);
               ItemManager.removeEventListener(ItemEvent.SUPER_ITEM_LIST,this.onNoNoList);
               ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,this.onCollectonList);
               ItemManager.getCollection();
               break;
            case BagPanel.SHOW_NONO:
               ItemManager.removeEventListener(ItemEvent.CLOTH_LIST,this.onClothList);
               ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,this.onCollectonList);
               ItemManager.addEventListener(ItemEvent.SUPER_ITEM_LIST,this.onNoNoList);
               ItemManager.getSuper();
               break;
            case BagPanel.SHOW_SOULBEAD:
               ItemManager.removeEventListener(ItemEvent.CLOTH_LIST,this.onClothList);
               ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,this.onCollectonList);
               ItemManager.removeEventListener(ItemEvent.SUPER_ITEM_LIST,this.onNoNoList);
               ItemManager.addEventListener(ItemEvent.SOULBEAD_ITEM_LIST,this.onSoulBeadList);
               ItemManager.getSoulBead();
         }
      }
      
      private function getArray(arr:Array, page:uint = 1, perNum:uint = 12) : Array
      {
         var start:uint = (page - 1) * perNum;
         var end:uint = page * perNum;
         return arr.slice(start,end);
      }
      
      public function clear() : void
      {
         ItemManager.removeEventListener(ItemEvent.CLOTH_LIST,this.onClothList);
         ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,this.onCollectonList);
         ItemManager.removeEventListener(ItemEvent.SUPER_ITEM_LIST,this.onNoNoList);
         MainManager.actorModel.removeEventListener(BagChangeClothAction.TAKE_OFF_CLOTH,this.actEventHandler);
         MainManager.actorModel.removeEventListener(BagChangeClothAction.REPLACE_CLOTH,this.actEventHandler);
         MainManager.actorModel.removeEventListener(BagChangeClothAction.USE_CLOTH,this.actEventHandler);
         MainManager.actorModel.removeEventListener(BagChangeClothAction.CLOTH_CHANGE,this.onClothChange);
      }
      
      private function onClothList(e:Event) : void
      {
         var clothes:Array = MainManager.actorInfo.clothIDs;
         ItemManager.removeEventListener(ItemEvent.CLOTH_LIST,this.onClothList);
         this._itemList = ItemManager.getClothInfos();
         this._itemList = this._itemList.filter(function(item:SingleItemInfo, index:int, array:Array):Boolean
         {
            if(!ItemXMLInfo.getIsSuper(item.itemID))
            {
               return true;
            }
            return false;
         });
         this._filList = this._itemList.concat();
         this.showItem();
      }
      
      private function onCollectonList(e:Event) : void
      {
         ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,this.onCollectonList);
         this._itemList = ItemManager.getCollectionInfos();
         this._itemList = this._itemList.filter(function(item:SingleItemInfo, index:int, array:Array):Boolean
         {
            if(!ItemXMLInfo.getIsSuper(item.itemID))
            {
               return true;
            }
            return false;
         });
         this._filList = this._itemList.concat();
         this.totalPage = Math.ceil(this._filList.length / this.PET_NUM);
         if(this.totalPage == 0)
         {
            this.totalPage = 1;
         }
         this._view.setPageNum(1,this.totalPage);
         this._view.showItem(this.getArray(this._filList));
      }
      
      private function onNoNoList(e:Event) : void
      {
         var clothes:Array = null;
         clothes = MainManager.actorInfo.clothIDs;
         ItemManager.removeEventListener(ItemEvent.SUPER_ITEM_LIST,this.onNoNoList);
         this._itemList = ItemManager.getSuperInfos();
         this._itemList = this._itemList.filter(function(item:SingleItemInfo, index:int, array:Array):Boolean
         {
            if(Boolean(ItemXMLInfo.getIsSuper(item.itemID)) && clothes.indexOf(item.itemID) == -1)
            {
               return true;
            }
            return false;
         });
         this._filList = this._itemList.concat();
         this.showItem();
      }
      
      private function onSoulBeadList(evt:Event) : void
      {
         var info:SingleItemInfo = null;
         ItemManager.removeEventListener(ItemEvent.SOULBEAD_ITEM_LIST,this.onSoulBeadList);
         this._itemList = ItemManager.getSoulBeadInfos();
         for(var i:uint = 0; i < this._itemList.length; i++)
         {
            info = new SingleItemInfo();
            info.itemNum = 1;
            info.itemID = this._itemList[i].itemID;
            info.leftTime = 365 * 24 * 60 * 60;
            this._filList.push(info);
         }
         this.showItem();
      }
      
      private function showItem() : void
      {
         this.currentPage = 1;
         switch(BagPanel.currTab)
         {
            case BagTabType.CLOTH:
            case BagTabType.NONO:
               if(BagShowType.currType != BagShowType.SUIT && BagShowType.currType != BagShowType.ALL)
               {
                  this._filList = this._itemList.filter(function(item:SingleItemInfo, index:int, array:Array):Boolean
                  {
                     var indexTmp:* = undefined;
                     if(item.type == ItemType.CLOTH)
                     {
                        if(ClothInfo.getItemInfo(item.itemID).type == BagShowType.typeNameListEn[BagShowType.currType])
                        {
                           index = -1;
                           if(_view.bChangeClothes)
                           {
                              index = int(MainManager.actorInfo.clothIDs.indexOf(item.itemID));
                              _view.bChangeClothes = false;
                           }
                           indexTmp = _view.clothPrev.getClothArray().indexOf(item.itemID);
                           if(index == -1 && indexTmp == -1)
                           {
                              return true;
                           }
                        }
                     }
                     return false;
                  });
               }
               else
               {
                  this._filList = this._itemList.filter(function(item:SingleItemInfo, index:int, array:Array):Boolean
                  {
                     var indexTmp:* = undefined;
                     if(item.type == ItemType.CLOTH)
                     {
                        index = -1;
                        if(_view.bChangeClothes)
                        {
                           index = int(MainManager.actorInfo.clothIDs.indexOf(item.itemID));
                           _view.bChangeClothes = false;
                        }
                        indexTmp = _view.clothPrev.getClothIDs().indexOf(item.itemID);
                        if(index == -1 && indexTmp == -1)
                        {
                           return true;
                        }
                        return false;
                     }
                     return true;
                  });
               }
               break;
            case BagTabType.SOULBEAD:
               break;
            default:
               this._filList = this._itemList.concat();
         }
         this.totalPage = Math.ceil(this._filList.length / this.PET_NUM);
         if(this.totalPage == 0)
         {
            this.totalPage = 1;
         }
         this._view.setPageNum(1,this.totalPage);
         this._view.showItem(this.getArray(this._filList));
      }
      
      private function showSuit(arr:Array) : void
      {
         this.currentPage = 1;
         this.totalPage = Math.ceil(arr.length / this.PET_NUM);
         if(this.totalPage == 0)
         {
            this.totalPage = 1;
         }
         this._view.setPageNum(1,this.totalPage);
         arr = arr.slice(0,this.PET_NUM);
         arr = arr.map(function(item:uint, index:int, array:Array):SingleItemInfo
         {
            var info:* = undefined;
            for each(info in _itemList)
            {
               if(info.itemID == item)
               {
                  return info;
               }
            }
            info = new SingleItemInfo();
            info.itemID = item;
            return info;
         });
         this._view.showItem(arr);
      }
      
      private function nextHandler(event:Event) : void
      {
         if(this.currentPage < this.totalPage)
         {
            ++this.currentPage;
            this._view.showItem(this.getArray(this._filList,this.currentPage));
            this._view.setPageNum(this.currentPage,this.totalPage);
         }
      }
      
      private function prevHandler(event:Event) : void
      {
         if(this.currentPage > 1)
         {
            --this.currentPage;
            this._view.showItem(this.getArray(this._filList,this.currentPage));
            this._view.setPageNum(this.currentPage,this.totalPage);
         }
      }
      
      private function actEventHandler(event:DynamicEvent) : void
      {
         var id:uint = 0;
         var info:SingleItemInfo = null;
         var _index:int = 0;
         if(!this._filList)
         {
            return;
         }
         if(BagShowType.currType == BagShowType.ALL)
         {
            id = uint(event.paramObject);
            this._itemList.some(function(item:SingleItemInfo, index:int, array:Array):Boolean
            {
               if(item.itemID == id)
               {
                  info = item;
                  return true;
               }
               return false;
            });
            _index = -1;
            this._filList.some(function(item:SingleItemInfo, index:int, array:Array):Boolean
            {
               if(item.itemID == _view.clickItemID)
               {
                  _index = index;
                  return true;
               }
               return false;
            });
            switch(event.type)
            {
               case BagChangeClothAction.USE_CLOTH:
                  if(_index != -1)
                  {
                     this._filList.splice(_index,1);
                  }
                  break;
               case BagChangeClothAction.REPLACE_CLOTH:
                  if(_index != -1)
                  {
                     this._filList.splice(_index,1);
                     if(Boolean(info))
                     {
                        this._filList.unshift(info);
                     }
                  }
                  break;
               case BagChangeClothAction.TAKE_OFF_CLOTH:
                  if(id != 0)
                  {
                     if(Boolean(info))
                     {
                        this._filList.unshift(info);
                     }
                  }
            }
            this.totalPage = Math.ceil(this._filList.length / this.PET_NUM);
            if(this.totalPage == 0)
            {
               this.totalPage = 1;
            }
            if(this.currentPage > this.totalPage)
            {
               this.currentPage = this.totalPage;
            }
            this._view.setPageNum(this.currentPage,this.totalPage);
            if(BagPanel.currTab == BagTabType.COLLECTION)
            {
               this._view.goToCloth();
            }
            this._view.showItem(this.getArray(this._filList,this.currentPage));
         }
      }
      
      private function onClothChange(e:Event) : void
      {
         if(BagShowType.currType == BagShowType.SUIT)
         {
            this.showSuit(SuitXMLInfo.getClothsForItem(this._view.clickItemID));
         }
      }
      
      private function onTypeSelect(e:BagTypeEvent) : void
      {
         if(e.showType == BagShowType.SUIT)
         {
            this.showSuit(SuitXMLInfo.getCloths(e.suitID));
         }
         else
         {
            this.showItem();
         }
      }
   }
}

