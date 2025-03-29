package com.robot.app.petbag.ui
{
   import com.robot.app.petbag.petPropsBag.PetBagModel;
   import com.robot.app.petbag.petPropsBag.ui.PetPropsPanel;
   import com.robot.app.picturebook.PictureBookController;
   import com.robot.core.event.PetEvent;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.manager.PetManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.uic.UIPanel;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   import com.robot.core.config.xml.PetBookXMLInfo;
   
   public class PetBagPanel extends UIPanel
   {
      private static const LIST_LENGTH:int = 6;
      
      private var _listCon:Sprite;
      
      private var _followBtn:MovieClip;
      
      private var _defaultBtn:SimpleButton;
      
      private var _storageBtn:SimpleButton;
      
      private var _pictureBookBtn:SimpleButton;
      
      private var _cureBtn:SimpleButton;
      
      private var _itemBtn:SimpleButton;
      
      private var _infoMc:PetDataPanel;
      
      private var _petPropsPanel:PetPropsPanel;
      
      private var _petBagModel:PetBagModel;
      
      private var _listData:Array;
      
      private var _curretItem:PetBagListItem;
      
      private var _arrowMc:MovieClip;
      
      private var _maskMc:Sprite;
      
      public function PetBagPanel()
      {
         var item:PetBagListItem = null;
         super(UIManager.getSprite("PetBagMc"));
         this._followBtn = _mainUI["followBtn"];
         this._defaultBtn = _mainUI["defaultBtn"];
         this._storageBtn = _mainUI["storageBtn"];
         this._pictureBookBtn = _mainUI["pictureBookBtn"];
         this._cureBtn = _mainUI["cureBtn"];
         this._itemBtn = _mainUI["itemBtn"];
         addChild(_mainUI);
         this._followBtn.gotoAndStop(1);
         this._listCon = new Sprite();
         this._listCon.x = 30;
         this._listCon.y = 70;
         addChild(this._listCon);
         for(var i:int = 0; i < LIST_LENGTH; i++)
         {
            item = new PetBagListItem();
            item.y = (item.height + 6) * int(i / 2);
            item.x = (item.width + 6) * (i % 2);
            this._listCon.addChild(item);
         }
         this._infoMc = new PetDataPanel(_mainUI["infoMc"]);
         this._petPropsPanel = new PetPropsPanel(_mainUI["itemMC"]);
         var closeBtn:SimpleButton = _mainUI["itemMC"]["closeBtn"];
         closeBtn.addEventListener(MouseEvent.CLICK,this.showInfoPanel);
      }
      
      public function show() : void
      {
         this.showInfoPanel(null);
         _show();
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         PetManager.upDate();
      }
      
      override public function hide() : void
      {
         super.hide();
         this.openEvent();
         this._infoMc.hide();
         this._curretItem = null;
      }
      
      override public function destroy() : void
      {
         super.destroy();
         this._infoMc = null;
         this._listCon = null;
         this._curretItem = null;
         this._followBtn = null;
         this._defaultBtn = null;
         this._storageBtn = null;
         this._pictureBookBtn = null;
         this._arrowMc = null;
      }
      
      override protected function addEvent() : void
      {
         super.addEvent();
         this._followBtn.addEventListener(MouseEvent.CLICK,this.onFollow);
         this._defaultBtn.addEventListener(MouseEvent.CLICK,this.onDefault);
         this._storageBtn.addEventListener(MouseEvent.CLICK,this.onStorage);
         this._pictureBookBtn.addEventListener(MouseEvent.CLICK,this.onBook);
         this._cureBtn.addEventListener(MouseEvent.CLICK,this.onCure);
         this._itemBtn.addEventListener(MouseEvent.CLICK,this.onItemBag);
         PetManager.addEventListener(PetEvent.SET_DEFAULT,this.onUpDate);
         PetManager.addEventListener(PetEvent.UPDATE_INFO,this.onUpDate);
         PetManager.addEventListener(PetEvent.ADDED,this.onUpDate);
         PetManager.addEventListener(PetEvent.REMOVED,this.onUpDate);
         PetManager.addEventListener(PetEvent.CURE_ONE_COMPLETE,this.onUpDate);
         ToolTipManager.add(this._followBtn,"身边跟随");
         ToolTipManager.add(this._storageBtn,"放回仓库");
         ToolTipManager.add(this._pictureBookBtn,"精灵图鉴");
         ToolTipManager.add(this._cureBtn,"精灵恢复");
         ToolTipManager.add(this._itemBtn,"道具");
      }
      
      override protected function removeEvent() : void
      {
         super.removeEvent();
         this._followBtn.removeEventListener(MouseEvent.CLICK,this.onFollow);
         this._defaultBtn.removeEventListener(MouseEvent.CLICK,this.onDefault);
         this._storageBtn.removeEventListener(MouseEvent.CLICK,this.onStorage);
         this._pictureBookBtn.removeEventListener(MouseEvent.CLICK,this.onBook);
         this._cureBtn.removeEventListener(MouseEvent.CLICK,this.onCure);
         this._itemBtn.removeEventListener(MouseEvent.CLICK,this.onItemBag);
         PetManager.removeEventListener(PetEvent.SET_DEFAULT,this.onUpDate);
         PetManager.removeEventListener(PetEvent.UPDATE_INFO,this.onUpDate);
         PetManager.removeEventListener(PetEvent.ADDED,this.onUpDate);
         PetManager.removeEventListener(PetEvent.REMOVED,this.onUpDate);
         PetManager.removeEventListener(PetEvent.CURE_ONE_COMPLETE,this.onUpDate);
         ToolTipManager.remove(this._followBtn);
         ToolTipManager.remove(this._storageBtn);
         ToolTipManager.remove(this._defaultBtn);
         ToolTipManager.remove(this._pictureBookBtn);
         ToolTipManager.remove(this._cureBtn);
         ToolTipManager.remove(this._itemBtn);
      }
      
      public function refreshItem() : void
      {
         var dis:PetBagListItem = null;
         var info:PetInfo = null;
         var item:PetBagListItem = null;
         for(var k:int = 0; k < LIST_LENGTH; k++)
         {
            dis = this._listCon.getChildAt(k) as PetBagListItem;
            dis.mouseEnabled = false;
            dis.hide();
            dis.removeEventListener(MouseEvent.CLICK,this.onItemClick);
         }
         var _listData:Array = PetManager.infos;
         _listData.sortOn("isDefault",Array.DESCENDING);
         var len:int = Math.min(LIST_LENGTH,PetManager.length);
         for(var i:int = 0; i < len; i++)
         {
            info = _listData[i] as PetInfo;
            item = this._listCon.getChildAt(i) as PetBagListItem;
            item.show(info);
            item.name = info.id.toString();
            item.mouseEnabled = true;
            item.addEventListener(MouseEvent.CLICK,this.onItemClick);
         }
         if(len == 0)
         {
            this._followBtn.alpha = 0.4;
            this._followBtn.mouseEnabled = false;
            this._defaultBtn.alpha = 0.4;
            this._defaultBtn.mouseEnabled = false;
            this._storageBtn.alpha = 0.4;
            this._storageBtn.mouseEnabled = false;
            this._cureBtn.alpha = 0.4;
            this._cureBtn.mouseEnabled = false;
            this._itemBtn.alpha = 0.4;
            this._itemBtn.mouseEnabled = false;
            this._infoMc.clearInfo();
            return;
         }
         this._followBtn.alpha = 1;
         this._followBtn.mouseEnabled = true;
         this._defaultBtn.alpha = 1;
         this._defaultBtn.mouseEnabled = true;
         this._storageBtn.alpha = 1;
         this._storageBtn.mouseEnabled = true;
         this._cureBtn.alpha = 1;
         this._cureBtn.mouseEnabled = true;
         this._itemBtn.alpha = 1;
         this._itemBtn.mouseEnabled = true;
         if(!this._curretItem)
         {
            this._curretItem = this._listCon.getChildAt(0) as PetBagListItem;
            this._curretItem.setDefault(true);
         }
         else
         {
            (this._listCon.getChildAt(0) as PetBagListItem).setDefault(true);
         }
         this.setSelect(this._curretItem);
      }
      
      private function setSelect(mc:PetBagListItem) : void
      {
         if(Boolean(this._curretItem))
         {
            this._curretItem.isSelect = false;
         }
         if(mc.info.catchTime == PetManager.defaultTime)
         {
            this._defaultBtn.alpha = 0.4;
            ToolTipManager.remove(this._defaultBtn);
            this._defaultBtn.removeEventListener(MouseEvent.CLICK,this.onDefault);
         }
         else
         {
            this._defaultBtn.alpha = 1;
            ToolTipManager.add(this._defaultBtn,"设为首选");
            this._defaultBtn.addEventListener(MouseEvent.CLICK,this.onDefault);
         }
         this._curretItem = mc;
         this._curretItem.isSelect = true;
         this._infoMc.show(this._curretItem.info);
         this._petPropsPanel.getPetInfo(this._curretItem.info);
         this.upDateBtnState();
      }
      
      private function upDateBtnState() : void
      {
         if(Boolean(PetManager.showInfo))
         {
            if(this._curretItem.info.catchTime == PetManager.showInfo.catchTime)
            {
               this._followBtn.gotoAndStop(2);
               ToolTipManager.add(this._followBtn,"放入包内");
            }
            else
            {
               this._followBtn.gotoAndStop(1);
               ToolTipManager.add(this._followBtn,"身边跟随");
            }
         }
         else
         {
            this._followBtn.gotoAndStop(1);
            ToolTipManager.add(this._followBtn,"身边跟随");
         }
      }
      
      private function onItemClick(e:MouseEvent) : void
      {
         var item:PetBagListItem = e.currentTarget as PetBagListItem;
         this.setSelect(item);
      }
      
      private function onFollow(e:MouseEvent) : void
      {
         if(PetManager.length == 0)
         {
            Alarm.show("你还没有赛尔精灵");
            return;
         }
         PetManager.showPet(this._curretItem.info.catchTime);
         if(this._followBtn.currentFrame == 1)
         {
            this._followBtn.gotoAndStop(2);
            ToolTipManager.add(this._followBtn,"放入包内");
            this.hide();
         }
         else
         {
            this._followBtn.gotoAndStop(1);
            ToolTipManager.add(this._followBtn,"身边跟随");
         }
      }
      
      private function onDefault(e:MouseEvent) : void
      {
         PetManager.setDefault(this._curretItem.info.catchTime);
      }
      
      private function onStorage(e:MouseEvent) : void
      {
         if(Boolean(this._curretItem))
         {
            PetManager.bagToInStorage(this._curretItem.info.catchTime);
         }
      }
      
      private function onBook(e:MouseEvent) : void
      {
         if(!PetBookXMLInfo.isSetup)
         {
            PetBookXMLInfo.setup(PictureBookController.show);
         }else
         {
            PictureBookController.show();
         }
      }
      
      private function onItemBag(evt:MouseEvent) : void
      {
         this._infoMc.hide();
         this._petPropsPanel = new PetPropsPanel(_mainUI["itemMC"]);
         this._petBagModel = new PetBagModel(this._petPropsPanel);
         (_mainUI["itemMC"] as MovieClip).visible = true;
         this.setSelect(this._curretItem);
      }
      
      private function showInfoPanel(evt:MouseEvent) : void
      {
         (_mainUI["infoMc"] as MovieClip).visible = true;
         (_mainUI["itemMC"] as MovieClip).visible = false;
      }
      
      private function onCure(e:MouseEvent) : void
      {
         if(Boolean(this._curretItem))
         {
            PetManager.cure(this._curretItem.info.catchTime);
         }
      }
      
      private function onUpDate(e:PetEvent) : void
      {
         this.refreshItem();
      }
      
      public function closeEvent() : void
      {
         this._maskMc = new Sprite();
         this._maskMc.alpha = 0;
         this._maskMc.graphics.lineStyle(1,0);
         this._maskMc.graphics.beginFill(0);
         this._maskMc.graphics.drawRect(0,0,this.width,this.height);
         this._maskMc.graphics.endFill();
         this.addChild(this._maskMc);
         this.addChild(closeBtn);
         this._arrowMc = TaskIconManager.getIcon("Arrows_MC") as MovieClip;
         this.addChild(this._arrowMc);
         this._arrowMc.x = closeBtn.x;
         this._arrowMc.y = closeBtn.y + closeBtn.height + 5;
         MovieClip(this._arrowMc["mc"]).rotation = -180;
         MovieClip(this._arrowMc["mc"]).play();
      }
      
      public function openEvent() : void
      {
         if(Boolean(this._maskMc))
         {
            DisplayUtil.removeForParent(this._maskMc);
            this._maskMc = null;
         }
         if(Boolean(this._arrowMc))
         {
            DisplayUtil.removeForParent(this._arrowMc);
         }
      }
      
      public function get curretItem() : PetBagListItem
      {
         return this._curretItem;
      }
   }
}

