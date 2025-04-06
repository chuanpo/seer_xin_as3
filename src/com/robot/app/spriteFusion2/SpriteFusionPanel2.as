package com.robot.app.spriteFusion2
{
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.NatureXMLInfo;
   import com.robot.core.config.xml.PetXMLInfo;
   import com.robot.core.event.ItemEvent;
   import com.robot.core.info.pet.PetFusionInfo;
   import com.robot.core.info.pet.PetInfo;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.HatchTask.HatchTaskInfo;
   import com.robot.core.manager.HatchTaskManager;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.PetManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.Alert;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import com.robot.app.spriteFusion2.BtnInfo;
   import com.robot.app.spriteFusion2.BtnItem;
   import com.robot.app.spriteFusion2.ElementItem;
   import com.robot.app.spriteFusion2.ElementItemInfo;
   import com.robot.app.spriteFusion2.PetChoosePanel;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.setTimeout;
   import org.taomee.ds.HashMap;
   import org.taomee.events.DynamicEvent;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ResourceManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.module.IModule;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   import com.robot.core.info.pet.PetEffectInfo;
   import com.robot.core.config.xml.PetEffectXMLInfo;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.event.MCLoadEvent;
   import flash.system.ApplicationDomain;
   import flash.filters.ColorMatrixFilter;
   import com.robot.core.config.xml.ShinyXMLInfo;
   import flash.filters.GlowFilter;
   
   public class SpriteFusionPanel2 extends Sprite
   {
      public static const HAS_CHOS_PET:String = "Has_Chos_Pet";
      
      private var PATH:String = "module/com/robot/module/app/SpriteFusionPanel2.swf";

      public var app:ApplicationDomain;

      private var _subSpriteChosBtn:MovieClip;
      
      private var _itemArr:Array = [];
      
      private var _hasCohere:Boolean = false;
      
      private var _arrowHeadMC:MovieClip;
      
      private var _itemHash:HashMap;
      
      private var _nextBtn:SimpleButton;
      
      private var _mainUI:MovieClip;
      
      private var _currentPageData:Array = [];
      
      private var _fusionBtn:MovieClip;
      
      private var _bStart:Boolean = false;
      
      private var _enhanceMC:MovieClip;
      
      private var _mainSpriteChosBtn:MovieClip;
      
      private var _subSpriteInfoTxt:TextField;
      
      private var _len:uint = 12;
      
      private var _eleItemPointArr:Array = [[4,-33],[272,-33],[-6,5],[281,5],[-3,45],[279,45],[11,83],[264,83],[34,116],[241,116],[64,143],[211,143]];
      
      private var _currentItem:ElementItem;
      
      private var _btnPointArr:Array = [[250,232],[211,272],[250,312],[289,272]];
      
      private var _totalPage:uint;
      
      private var _page:int = 1;
      
      private var _fusionData:Array = [0,0,0,0,0,0];
      
      private var _itemInfoArr:Array = [];
      
      private var _btnArr:Array = [];
      
      private var _closeBtn:SimpleButton;
      
      private var _mainSpriteInfoTxt:TextField;
      
      private var _itemContainer:MovieClip;
      
      private var _fusionResultMC:MovieClip;
      
      private var _animateMC:MovieClip;
      
      
      private var _currentBtn:BtnItem;
      
      private var _chosPetArr:Array = [null,null];
      
      private var _masterInfo:PetInfo;
      
      private var _subInfo:PetInfo;
      
      private var _prevBtn:SimpleButton;
      
      private var _petChosPanel:PetChoosePanel;

      protected var filte:GlowFilter = new GlowFilter(3355443,0.9,3,3,3.1);
      
      public function SpriteFusionPanel2()
      {
         super();
      }
      
      public function destroy() : void
      {
         var _loc1_:BtnItem = null;
         var _loc2_:ElementItem = null;
         ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,addItem);
         EventManager.removeEventListener(PetChoosePanel.SUB_PET_CHOOSE,getSubSpriteData);
         EventManager.removeEventListener(PetChoosePanel.MAIN_PET_CHOOSE,getMainSpriteData);
         SocketConnection.removeCmdListener(CommandID.XIN_FUSION,onGetPet);
         for each(_loc1_ in _btnArr)
         {
            if(_loc1_)
            {
               _loc1_.removeEventListener(MouseEvent.CLICK,onChosBtnType);
               _loc1_ = null;
            }
         }
         for each(_loc2_ in _itemArr)
         {
            if(_loc2_)
            {
               _loc2_.removeEventListener(MouseEvent.CLICK,onChooseItem);
               _loc2_ = null;
            }
         }
         if(_mainUI)
         {
            DisplayUtil.removeAllChild(_mainUI);
            DisplayUtil.removeForParent(_mainUI);
         }
         _mainUI = null;
         _closeBtn = null;
         _mainSpriteInfoTxt = null;
         _subSpriteInfoTxt = null;
         _mainSpriteChosBtn = null;
         _subSpriteChosBtn = null;
         _fusionBtn = null;
         _itemContainer = null;
         _petChosPanel = null;
         _currentBtn = null;
         _currentItem = null;
      }
      
      private function onChooseItem(param1:MouseEvent) : void
      {
         var _loc2_:BtnInfo = null;
         var _loc3_:BtnItem = null;
         var _loc4_:ElementItem = param1.currentTarget as ElementItem;
         _loc4_.mc.gotoAndStop(2);
         if(_currentItem)
         {
            _currentItem.mc.gotoAndStop(1);
         }
         _currentItem = null;
         _currentItem = _loc4_;
         if(_currentBtn)
         {
            if(!_bStart)
            {
               for each(_loc3_ in _btnArr)
               {
                  _loc3_.visible = true;
                  _loc3_.mc.gotoAndStop(1);
               }
               _bStart = true;
            }
            _loc2_ = new BtnInfo();
            _loc2_.item = _loc4_;
            _loc2_.itemInfo = _loc4_.info.info;
            _currentBtn.info = _loc2_;
            _currentBtn.mc.gotoAndStop(2);
         }
         switch(_currentBtn.type)
         {
            case 0:
               _fusionData[2] = _currentBtn.info.itemInfo.itemID;
               break;
            case 1:
               _fusionData[3] = _currentBtn.info.itemInfo.itemID;
               break;
            case 2:
               _fusionData[4] = _currentBtn.info.itemInfo.itemID;
               break;
            case 3:
               _fusionData[5] = _currentBtn.info.itemInfo.itemID;
         }
         upDateInfo(_page);
         checkData();
      }
      
      private function onChosBtnType(param1:MouseEvent) : void
      {
         var btn:BtnItem = null;
         var evt:MouseEvent = param1;
         btn = null;
         btn = evt.currentTarget as BtnItem;
         if(_currentBtn)
         {
            _currentBtn.mc.gotoAndStop(1);
         }
         btn.mc.gotoAndStop(2);
         _currentBtn = null;
         _currentBtn = btn;
         if(!_bStart)
         {
            if(_animateMC == null)
            {
               return;
            }
            btn.mouseChildren = false;
            btn.mouseEnabled = false;
            _animateMC.visible = true;
            _animateMC.gotoAndPlay(2);
            _animateMC.addEventListener(Event.ENTER_FRAME,function(param1:Event):void
            {
               if(_animateMC.currentFrame == _animateMC.totalFrames)
               {
                  _animateMC.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  DisplayUtil.removeForParent(_animateMC);
                  _animateMC = null;
                  _itemContainer.visible = true;
                  btn.mouseChildren = true;
                  btn.mouseEnabled = true;
               }
            });
         }
      }
      
      public function init(param1:Object = null) : void
      {
      }
      
      private function upDateInfo(param1:uint) : void
      {
         var _loc2_:ElementItemInfo = null;
         var _loc3_:Array = null;
         var _loc4_:uint = 0;
         var _loc5_:uint = 0;
         for each(_loc2_ in _itemInfoArr)
         {
            _loc2_.num = _itemHash.getValue(_loc2_.info.itemID);
            _loc4_ = 0;
            _loc5_ = 2;
            while(_loc5_ < 6)
            {
               if(_loc2_.info.itemID == _fusionData[_loc5_])
               {
                  _loc4_++;
               }
               _loc5_++;
            }
            _loc2_.num = _loc2_.info.itemNum - _loc4_;
         }
         _loc3_ = _itemInfoArr.slice(_len * (_page - 1),_len * _page);
         _currentPageData = _loc3_;
         upDateItem(_currentPageData);
      }
      
      public function hide() : void
      {
      }
      
      private function addItem(param1:ItemEvent) : void
      {
         var _loc2_:SingleItemInfo = null;
         var _loc3_:ElementItemInfo = null;
         ItemManager.removeEventListener(ItemEvent.COLLECTION_LIST,addItem);
         var _loc4_:Array = ItemManager.getCollectionInfos();
         for each(_loc2_ in _loc4_)
         {
            if(_loc2_.itemID >= 400001 && _loc2_.itemID <= 400049)
            {
               _loc3_ = new ElementItemInfo();
               _loc3_.info = _loc2_;
               _loc3_.num = _loc2_.itemNum;
               _itemHash.add(_loc2_.itemID,_loc3_.num);
               _itemInfoArr.push(_loc3_);
            }
            // if(_loc2_.itemID == 300043)
            // {
            //    _hasEnhance = true;
            //    _enhanceMC["mc"].visible = true;
            // }
            // if(_loc2_.itemID == 300044)
            // {
            //    _hasCohere = true;
            //    _cohereMC["mc"].visible = true;
            // }
         }
         if(_itemInfoArr.length > _len)
         {
            _nextBtn.visible = true;
         }
         _totalPage = Math.ceil(_itemInfoArr.length / _len);
         upDateInfo(_page);
      }
      
      private function onClose(param1:MouseEvent) : void
      {
         DisplayUtil.removeForParent(_mainUI);
      }
      
      private function onNext(param1:MouseEvent) : void
      {
         _prevBtn.visible = true;
         ++_page;
         if(_page == _totalPage)
         {
            _nextBtn.visible = false;
         }
         upDateInfo(_page);
      }
      
      private function onChosMainSprite(param1:MouseEvent) : void
      {
         showPetChosPanel(true);
         EventManager.addEventListener(PetChoosePanel.MAIN_PET_CHOOSE,getMainSpriteData);
      }
      
      private function onChosSubSprite(param1:MouseEvent) : void
      {
         showPetChosPanel(false);
         EventManager.addEventListener(PetChoosePanel.SUB_PET_CHOOSE,getSubSpriteData);
      }
      
      public function setup(event:MCLoadEvent) : void
      {
         var _loc1_:ElementItem = null;
         var _loc2_:BtnItem = null;
         this.app = event.getApplicationDomain();
         this._mainUI = new (this.app.getDefinition("UI_SpriteFusion") as Class)() as MovieClip;
         // _mainUI = new UI_SpriteFusion();
         LevelManager.appLevel.addChild(_mainUI);
         _mainUI.x = 205;
         _mainUI.y = 48;
         ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,addItem);
         ItemManager.getCollection();
         _closeBtn = _mainUI["closeBtn"];
         _closeBtn.addEventListener(MouseEvent.CLICK,onClose);
         _arrowHeadMC = _mainUI["arrowHeadMC"];
         _arrowHeadMC.visible = false;
         _mainSpriteInfoTxt = _mainUI["mainSpriteInfoTxt"];
         _mainSpriteInfoTxt.visible = false;
         _mainSpriteInfoTxt.mouseEnabled = false;
         _subSpriteInfoTxt = _mainUI["subSpriteInfoTxt"];
         _subSpriteInfoTxt.visible = false;
         _subSpriteInfoTxt.mouseEnabled = false;
         _mainSpriteChosBtn = _mainUI["mainSpriteChosBtn"];
         _mainSpriteChosBtn["bg"].gotoAndStop(1);
         _mainSpriteChosBtn.buttonMode = true;
         _mainSpriteChosBtn.addEventListener(MouseEvent.CLICK,onChosMainSprite);
         ToolTipManager.add(_mainSpriteChosBtn,"只有最高阶段的精灵才能作为主融合精灵");
         _subSpriteChosBtn = _mainUI["subSpriteChosBtn"];
         _subSpriteChosBtn["bg"].gotoAndStop(2);
         ToolTipManager.add(_subSpriteChosBtn,"只有同类型的精灵以及尼尔才能够作为副融合精灵");
         _itemContainer = _mainUI["itemContainer"];
         _itemContainer.visible = false;
         _itemHash = new HashMap();
         var _loc3_:uint = 0;
         try
         {
            while(_loc3_ < _eleItemPointArr.length)
            {
               _loc1_ = new ElementItem(this.app);
               _itemContainer.addChild(_loc1_);
               _loc1_.x = _eleItemPointArr[_loc3_][0];
               _loc1_.y = _eleItemPointArr[_loc3_][1];
               _loc1_.name = "eleItem_" + _loc3_;
               _loc1_.type = _loc3_;
               _itemArr.push(_loc1_);
               _loc3_++;
            }
            var _loc4_:uint = 0;
            while(_loc4_ < _btnPointArr.length)
            {
               _loc2_ = new BtnItem(this.app);
               _loc2_.x = _btnPointArr[_loc4_][0];
               _loc2_.y = _btnPointArr[_loc4_][1];
               _loc2_.name = "btn_" + _loc4_;
               _loc2_.type = _loc4_;
               _mainUI.addChild(_loc2_);
               _btnArr.push(_loc2_);
               _loc2_.visible = false;
               _loc2_.buttonMode = true;
               _loc2_.addEventListener(MouseEvent.CLICK,onChosBtnType);
               _loc4_++;
            }
            _prevBtn = _mainUI["prevBtn"];
            _prevBtn.visible = false;
            _prevBtn.addEventListener(MouseEvent.CLICK,onPrev);
            _nextBtn = _mainUI["nextBtn"];
            _nextBtn.visible = false;
            _nextBtn.addEventListener(MouseEvent.CLICK,onNext);
            _animateMC = _mainUI["animateMC"];
            _animateMC.mouseEnabled = false;
            _animateMC.mouseChildren = false;
            _animateMC.gotoAndStop(1);
            _animateMC.visible = false;
            _fusionResultMC = new (this.app.getDefinition("FusionResultMC") as Class)() as MovieClip;
            _fusionResultMC["mc"].gotoAndStop(1);
            _fusionResultMC["panel"].gotoAndStop(1);
            _fusionBtn = _mainUI["fusionBtn"];
            _fusionBtn.gotoAndStop(2);
            _petChosPanel = new PetChoosePanel(this.app);
         }
         catch (error:Error)
         {
            Alarm.show(error);
         }
      }
      
      private function onSpriteFusion(param1:MouseEvent) : void
      {
         var evt:MouseEvent = param1;
         Alert.show("精灵融合会消耗精灵的元神，融合成功时，主副精灵会转化成一个元神珠，如果失败，副融合精灵的等级会降低5级，你确定要花费<font color=\'#ff0000\'>1000赛尔豆</font>进行融合吗？",function():void
         {
            _fusionBtn.buttonMode = false;
            _fusionBtn.removeEventListener(MouseEvent.CLICK,onSpriteFusion);
            DisplayUtil.removeForParent(_mainUI);
            SocketConnection.addCmdListener(CommandID.XIN_FUSION,onGetPet);
            SocketConnection.send(CommandID.XIN_FUSION,_fusionData[0],_fusionData[1],_fusionData[2],_fusionData[3],_fusionData[4],_fusionData[5],0,0);
            // Alarm.show("_fusionData[0]:"+ _fusionData[0]+",_fusionData[1]:"+ _fusionData[1]+",_fusionData[2]:"+ _fusionData[2]+
            //    ",_fusionData[3]:"+ _fusionData[3]+",_fusionData[4]:"+ _fusionData[4]+",_fusionData[5]:"+ _fusionData[5]+"")
         });
      }
      
      private function upDateItem(param1:Array) : void
      {
         var _loc2_:ElementItem = null;
         var _loc3_:uint = 0;
         var _loc4_:ElementItemInfo = null;
         var _loc5_:String = null;
         var _loc6_:ElementItem = null;
         for each(_loc2_ in _itemArr)
         {
            _loc2_.info = null;
         }
         _loc3_ = 0;
         while(_loc3_ < param1.length)
         {
            _loc4_ = param1[_loc3_];
            _loc5_ = "eleItem_" + _loc3_;
            _loc6_ = _itemContainer.getChildByName(_loc5_) as ElementItem;
            if(_loc6_)
            {
               _loc6_.info = _loc4_;
               _loc6_.buttonMode = true;
               _loc6_.addEventListener(MouseEvent.CLICK,onChooseItem);
            }
            _loc3_++;
         }
      }
      
      private function onPrev(param1:MouseEvent) : void
      {
         _nextBtn.visible = true;
         --_page;
         if(_page <= 1)
         {
            _prevBtn.visible = false;
         }
         upDateInfo(_page);
      }
      
      private function onGetPet(param1:SocketEvent) : void
      {
         var info:PetFusionInfo = null;
         var evt:SocketEvent = param1;
         info = null;
         SocketConnection.removeCmdListener(CommandID.XIN_FUSION,onGetPet);
         info = evt.data as PetFusionInfo;
         LevelManager.appLevel.addChild(_fusionResultMC);
         DisplayUtil.align(_fusionResultMC,null,AlignType.BOTTOM_CENTER);
         _fusionResultMC["mc"].gotoAndPlay(2);
         _fusionResultMC["mc"].addEventListener(Event.ENTER_FRAME,function(param1:Event):void
         {
            var evt:Event = param1;
            var i:HatchTaskInfo = null;
            if(_fusionResultMC["mc"].currentFrame == _fusionResultMC["mc"].totalFrames)
            {
               _fusionResultMC["mc"].removeEventListener(Event.ENTER_FRAME,arguments.callee);
               DisplayUtil.removeForParent(_fusionResultMC["mc"]);
               if(info.obtainTime == 0)
               {
                  _fusionResultMC["panel"].gotoAndStop(3);
                  setTimeout(function():void
                  {
                     var _loc1_:uint = 0;
                     DisplayUtil.removeForParent(_fusionResultMC);
                     _fusionResultMC = null;
                     if(info.costItemFlag == 1)
                     {
                        Alarm.show("一枚<font color=\'#ff0000\'>元神凝聚制剂</font>已经被消耗掉了！");
                        return;
                     }
                     if(_subInfo)
                     {
                        _loc1_ = uint(_subInfo.level);
                        if(_loc1_ > 5)
                        {
                           Alarm.show("很遗憾，这次融合没有成功，元神的损耗使你的<font color=\'#ff0000\'>" + PetXMLInfo.getName(_subInfo.id) + "</font>等级降低了5级!");
                        }
                        else
                        {
                           Alarm.show("很遗憾，这次融合没有成功，元神的损耗使你的<font color=\'#ff0000\'>" + PetXMLInfo.getName(_subInfo.id) + "</font>等级降低到了1级!");
                        }
                        return;
                     }
                     Alarm.show("很遗憾，这次融合没有成功，元神的损耗使你的副融合精灵等级降低了5级!");
                  },3000);
               }
               else
               {
                  _fusionResultMC["panel"].gotoAndStop(2);
                  setTimeout(function():void
                  {
                     var url:String = "resource/soulBead/icon/" + info.soulID + ".swf";
                     ResourceManager.getResource(url,function(param1:MovieClip):void
                     {
                        if(param1)
                        {
                           _fusionResultMC.addChild(param1);
                           param1.scaleX = 1.5;
                           param1.scaleY = 1.5;
                           param1.x = 170;
                           param1.y = 266;
                        }
                     });
                  },1000);
                  setTimeout(function():void
                  {
                     DisplayUtil.removeAllChild(_fusionResultMC);
                     DisplayUtil.removeForParent(_fusionResultMC);
                     ItemInBagAlert.show(info.soulID,"恭喜你获得精灵<font color=\'#ff0000\'>元神珠</font>。当<font color=\'#ff0000\'>元神珠</font>吸收到相应的星球能量后就能进行元神赋形了！",function():void
                     {
                        if(info.costItemFlag == 1)
                        {
                           Alarm.show("一枚<font color=\'#ff0000\'>强固精华合剂</font>已经被消耗掉了！");
                        }
                        else
                        {
                           PetManager.deletePet(_fusionData[1]);
                        }
                     });
                  },3000);
                  PetManager.deletePet(_fusionData[0]);
                  HatchTaskManager.setTaskProStatus(info.obtainTime,0,false);
                  i = new HatchTaskInfo(info.obtainTime,info.soulID,[]);
                  HatchTaskManager.addHeadStatus(info.obtainTime,i);
                  ++MainManager.actorInfo.fuseTimes;
               }
            }
         });
         PetManager.setDefault(info.starterCpTm,false);
         destroy();
      }
      
      private function getSubSpriteData(param1:DynamicEvent) : void
      {
         var info:PetInfo = null;
         var btnItem:BtnItem = null;
         var evt:DynamicEvent = param1;
         _subSpriteChosBtn["bg"].gotoAndStop(2);
         _arrowHeadMC.visible = true;
         btnItem = _mainUI.getChildByName("btn_0") as BtnItem;
         btnItem.visible = true;
         btnItem.mc.gotoAndStop(1);
         EventManager.removeEventListener(PetChoosePanel.SUB_PET_CHOOSE,getSubSpriteData);
         info = evt.paramObject as PetInfo;
         if(info)
         {
            if(PetXMLInfo.getPetClass(info.id) == 29)
            {
               Alarm.show("测试期间尼尔暂时不可作为融合材料！");
               return;
            }
            _subInfo = info;
            _chosPetArr[1] = info;
            EventManager.dispatchEvent(new DynamicEvent(HAS_CHOS_PET,_chosPetArr));
            _subSpriteInfoTxt.visible = true;
            var effectInfo:PetEffectInfo = info.effectList[0];
            _subSpriteInfoTxt.htmlText = "名称:" + PetXMLInfo.getName(info.id) + "\r" + "属性:" + PetXMLInfo.getTypeCN(info.id) + "\r" + "等级:" + info.level + "\r" + "性格:" + NatureXMLInfo.getName(info.nature)
               + "\r" + "个体:" + info.dv + (!Boolean(effectInfo) ? "" : ("\r" + "特性:" + PetEffectXMLInfo.getEffect(effectInfo.effectID,effectInfo.args,effectInfo.itemId)));
            _fusionData[1] = info.catchTime;
            ResourceManager.getResource(ClientConfig.getPetSwfPath(info.skinID == 0 ? info.id:info.skinID),function(param1:MovieClip):void
            {
               var m:MovieClip = param1;
               m.gotoAndStop("rightdown");
               m.addEventListener(Event.ENTER_FRAME,function():void
               {
                  var _loc2_:MovieClip = m.getChildAt(0) as MovieClip;
                  if(_loc2_)
                  {
                     _loc2_.gotoAndStop(1);
                     m.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  }
               });
               DisplayUtil.stopAllMovieClip(m);
               m.scaleX = 3;
               m.scaleY = 3;
               DisplayUtil.removeAllChild(_subSpriteChosBtn["sprite"]);
               _subSpriteChosBtn["sprite"].addChild(m);
               _subSpriteChosBtn["mc"].visible = false;
               if(info.shiny != 0){
                  var matrix:ColorMatrixFilter = null;
                  var argArray:Array = ShinyXMLInfo.getShinyArray(info.id);
                  matrix = new ColorMatrixFilter(argArray);
                  var glow:GlowFilter = null;
                  var glowArray:Array = ShinyXMLInfo.getGlowArray(info.id);
                  glow = new GlowFilter(uint(glowArray[0]),int(glowArray[1]),int(glowArray[2]),int(glowArray[3]),int(glowArray[4]));
                  m.filters = [ filte,glow,matrix ]
               }
            },"pet");
         }
         checkData();
      }
      
      private function getMainSpriteData(param1:DynamicEvent) : void
      {
         var info:PetInfo = null;
         var evt:DynamicEvent = param1;
         _mainSpriteChosBtn["bg"].gotoAndStop(2);
         _subSpriteChosBtn["bg"].gotoAndStop(1);
         _subSpriteChosBtn.buttonMode = true;
         _subSpriteChosBtn.addEventListener(MouseEvent.CLICK,onChosSubSprite);
         EventManager.removeEventListener(PetChoosePanel.MAIN_PET_CHOOSE,getMainSpriteData);
         info = evt.paramObject as PetInfo;
         if(info)
         {
            if(_chosPetArr[1] != null && PetXMLInfo.getPetClass(info.id) != PetXMLInfo.getPetClass((_chosPetArr[1] as PetInfo).id)
               && (PetXMLInfo.getPetClass((_chosPetArr[1] as PetInfo).id) != 29))
            {
               Alarm.show("主副精灵必须为同一种类型的精灵！");
               return;
            }
            _masterInfo = info;
            _chosPetArr[0] = info;
            EventManager.dispatchEvent(new DynamicEvent(HAS_CHOS_PET,_chosPetArr));
            _mainSpriteInfoTxt.visible = true;
            var effectInfo:PetEffectInfo = info.effectList[0];
            _mainSpriteInfoTxt.htmlText = "名称:" + PetXMLInfo.getName(info.id) + "\r" + "属性:" + PetXMLInfo.getTypeCN(info.id) + "\r" + "等级:" + info.level + "\r" + "性格:" + NatureXMLInfo.getName(info.nature)
               + "\r" + "个体:" + info.dv + (!Boolean(effectInfo) ? "" : ("\r" + "特性:" + PetEffectXMLInfo.getEffect(effectInfo.effectID,effectInfo.args,effectInfo.itemId)));
            
            _fusionData[0] = info.catchTime;
            ResourceManager.getResource(ClientConfig.getPetSwfPath(info.skinID == 0 ? info.id:info.skinID),function(param1:MovieClip):void
            {
               var m:MovieClip = param1;
               m.gotoAndStop("rightdown");
               m.addEventListener(Event.ENTER_FRAME,function():void
               {
                  var _loc2_:MovieClip = m.getChildAt(0) as MovieClip;
                  if(_loc2_)
                  {
                     _loc2_.gotoAndStop(1);
                     m.removeEventListener(Event.ENTER_FRAME,arguments.callee);
                  }
               });
               DisplayUtil.stopAllMovieClip(m);
               m.scaleX = 3;
               m.scaleY = 3;
               DisplayUtil.removeAllChild(_mainSpriteChosBtn["sprite"]);
               _mainSpriteChosBtn["sprite"].addChild(m);
               _mainSpriteChosBtn["mc"].visible = false;
               if(info.shiny != 0){
                  var matrix:ColorMatrixFilter = null;
                  var argArray:Array = ShinyXMLInfo.getShinyArray(info.id);
                  matrix = new ColorMatrixFilter(argArray);
                  var glow:GlowFilter = null;
                  var glowArray:Array = ShinyXMLInfo.getGlowArray(info.id);
                  glow = new GlowFilter(uint(glowArray[0]),int(glowArray[1]),int(glowArray[2]),int(glowArray[3]),int(glowArray[4]));
                  m.filters = [ filte,glow,matrix ]
               }
            },"pet");
         }
         checkData();
      }
      
      private function showPetChosPanel(param1:Boolean) : void
      {
         _petChosPanel.show(param1);
         LevelManager.appLevel.addChild(_petChosPanel);
         DisplayUtil.align(_petChosPanel,null,AlignType.MIDDLE_RIGHT);
      }
      
      private function checkData() : void
      {
         var _loc1_:uint = 0;
         for each(_loc1_ in _fusionData)
         {
            if(_loc1_ == 0)
            {
               return;
            }
         }
         _fusionBtn.buttonMode = true;
         _fusionBtn.gotoAndStop(1);
         _fusionBtn.addEventListener(MouseEvent.CLICK,onSpriteFusion);
      }
      
      public function show() : void
      {
         var loader:MCLoader = null;
         if(!this._mainUI)
         {
            loader = new MCLoader(this.PATH,this,1,"正在打开基因重组");
            loader.addEventListener(MCLoadEvent.SUCCESS,this.setup);
            loader.doLoad();
         }
         else
         {
            LevelManager.appLevel.addChild(_mainUI);
            _mainUI.x = 205;
            _mainUI.y = 48;
            ItemManager.addEventListener(ItemEvent.COLLECTION_LIST,addItem);
            ItemManager.getCollection();
         }
      }
   }
}

