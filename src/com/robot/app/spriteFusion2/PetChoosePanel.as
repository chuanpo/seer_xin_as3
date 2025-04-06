package com.robot.app.spriteFusion2
{
   import com.robot.app.petbag.ui.PetBagListItem;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.event.PetEvent;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.app.spriteFusion2.SpriteFusionPanel2;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.taomee.effect.ColorFilter;
   import org.taomee.events.DynamicEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   import flash.system.ApplicationDomain;
   import flash.system.ApplicationDomain;
   
   public class PetChoosePanel extends Sprite
   {
      public static const MAIN_PET_CHOOSE:String = "Main_Pet_Choose";

      public static const SUB_PET_CHOOSE:String = "Sub_Pet_Choose";

      private static const LIST_LENGTH:int = 6;
      
      private var _listCon:Sprite;
      
      private var _chooseBtn:SimpleButton;
      
      private var _dragBtn:SimpleButton;
      
      private var _isMaster:Boolean = false;
      
      private var _chosPetIDArr:Array = [];
      
      private var _closeBtn:SimpleButton;
      
      private var _mainUI:Sprite;
      
      private var _curretItem:PetBagListItem;
      
      private var _app:ApplicationDomain;


      public function PetChoosePanel(app:ApplicationDomain)
      {
         super();
         this._app = app;
         setup();
      }
      
      public function hide() : void
      {
         removeEvent();
         DisplayUtil.removeForParent(this);
      }
      
      public function setup() : void
      {
         var _loc1_:PetBagListItem = null;
         _mainUI = new (this._app.getDefinition("PetChoose_Panel") as Class)() as Sprite;
         _chooseBtn = _mainUI["chooseBtn"];
         _closeBtn = _mainUI["closeBtn"];
         _dragBtn = _mainUI["dragBtn"];
         addChild(_mainUI);
         _listCon = new Sprite();
         _listCon.x = 30;
         _listCon.y = 70;
         addChild(_listCon);
         var _loc2_:int = 0;
         while(_loc2_ < LIST_LENGTH)
         {
            _loc1_ = new PetBagListItem();
            _loc1_.y = (_loc1_.height + 6) * int(_loc2_ / 2);
            _loc1_.x = (_loc1_.width + 6) * (_loc2_ % 2);
            _listCon.addChild(_loc1_);
            _loc2_++;
         }
      }
      
      public function init(param1:Object = null) : void
      {
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         hide();
      }
      
      private function hasChosPet(param1:DynamicEvent) : void
      {
         EventManager.removeEventListener(SpriteFusionPanel2.HAS_CHOS_PET,hasChosPet);
         _chosPetIDArr = param1.paramObject as Array;
         reItem();
      }
      
      private function unEableChoose(param1:PetBagListItem) : void
      {
         param1.filters = [ColorFilter.setGrayscale()];
         param1.mouseEnabled = false;
         param1.buttonMode = false;
         param1.removeEventListener(MouseEvent.CLICK,onItemClick);
      }
      
      private function onItemClick(param1:MouseEvent) : void
      {
         if(_curretItem)
         {
            _curretItem.isSelect = false;
            _curretItem = null;
         }
         _curretItem = param1.currentTarget as PetBagListItem;
         _curretItem.isSelect = true;
      }
      
      private function onUpDate(param1:PetEvent) : void
      {
         reItem();
         EventManager.addEventListener(SpriteFusionPanel2.HAS_CHOS_PET,hasChosPet);
      }
      
      private function onChoosePet(param1:MouseEvent) : void
      {
         if(_curretItem == null)
         {
            Alarm.show("请选择你的精灵噢!");
            return;
         }
         EventManager.dispatchEvent(new DynamicEvent(this._isMaster ? MAIN_PET_CHOOSE : SUB_PET_CHOOSE,_curretItem.info));
         hide();
      }
      
      private function reItem() : void
      {
         var _loc1_:PetBagListItem = null;
         var _loc2_:PetInfo = null;
         var _loc3_:PetBagListItem = null;
         _curretItem = null;
         var _loc4_:int = 0;
         while(_loc4_ < LIST_LENGTH)
         {
            _loc1_ = _listCon.getChildAt(_loc4_) as PetBagListItem;
            _loc1_.mouseEnabled = false;
            _loc1_.hide();
            _loc1_.removeEventListener(MouseEvent.CLICK,onItemClick);
            _loc4_++;
         }
         var _loc5_:Array = PetManager.infos;
         var _loc6_:int = Math.min(LIST_LENGTH,_loc5_.length);
         var _loc7_:int = 0;
         while(_loc7_ < _loc6_)
         {
            _loc2_ = _loc5_[_loc7_] as PetInfo;
            _loc3_ = _listCon.getChildAt(_loc7_) as PetBagListItem;
            _loc3_.show(_loc2_);
            _loc3_.name = _loc2_.id.toString();
            _loc3_.filters = [];
            _loc3_.buttonMode = true;
            _loc3_.mouseEnabled = true;
            _loc3_.addEventListener(MouseEvent.CLICK,onItemClick);
            if(_isMaster)
            {
               if(!PetXMLInfo.isLarge(_loc3_.info.id))
               {
                  unEableChoose(_loc3_);
               }
            }
            else if(_chosPetIDArr[0] != null && PetXMLInfo.getPetClass(_loc3_.info.id) != PetXMLInfo.getPetClass((_chosPetIDArr[0] as PetInfo).id)
               && (PetXMLInfo.getPetClass(_loc3_.info.id) != 29))
            {
               unEableChoose(_loc3_);
            }else if(_chosPetIDArr[0] == null)
            {
               unEableChoose(_loc3_);
            }
            
            if(_chosPetIDArr[0] != null && _loc3_.info.catchTime == (_chosPetIDArr[0] as PetInfo).catchTime)
            {
               unEableChoose(_loc3_);
            }else if(_chosPetIDArr[1] != null && _loc3_.info.catchTime == (_chosPetIDArr[1] as PetInfo).catchTime)
            {
               unEableChoose(_loc3_);
            }
            _loc7_++;
         }
      }
      
      private function onDragUp(param1:MouseEvent) : void
      {
         stopDrag();
      }
      
      private function onDragDown(param1:MouseEvent) : void
      {
         startDrag();
      }
      
      private function removeEvent() : void
      {
         _chooseBtn.removeEventListener(MouseEvent.CLICK,onChoosePet);
         _closeBtn.removeEventListener(MouseEvent.CLICK,onClose);
         _dragBtn.removeEventListener(MouseEvent.MOUSE_DOWN,onDragDown);
         _dragBtn.removeEventListener(MouseEvent.MOUSE_UP,onDragUp);
         PetManager.removeEventListener(PetEvent.UPDATE_INFO,onUpDate);
      }
      
      private function addEvent() : void
      {
         _chooseBtn.addEventListener(MouseEvent.CLICK,onChoosePet);
         _closeBtn.addEventListener(MouseEvent.CLICK,onClose);
         _dragBtn.addEventListener(MouseEvent.MOUSE_DOWN,onDragDown);
         _dragBtn.addEventListener(MouseEvent.MOUSE_UP,onDragUp);
         PetManager.addEventListener(PetEvent.UPDATE_INFO,onUpDate);
      }
      
      public function destroy() : void
      {
         hide();
         _listCon = null;
         _chooseBtn = null;
         _mainUI = null;
         _curretItem = null;
         _dragBtn = null;
         _closeBtn = null;
      }
      
      public function show(param1:Boolean) : void
      {
         _isMaster = param1;
         LevelManager.appLevel.addChild(this);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         addEvent();
         PetManager.upDate();
      }
   }
}

