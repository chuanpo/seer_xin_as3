package com.robot.app.bag
{
   import com.robot.app.action.ActorActionManager;
   import com.robot.app.team.TeamController;
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.config.xml.SuitXMLInfo;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.event.PeopleActionEvent;
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import com.robot.core.info.team.SimpleTeamInfo;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.TaskIconManager;
   import com.robot.core.manager.TasksManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.skeleton.ClothPreview;
   import com.robot.core.teamInstallation.TeamLogo;
   import com.robot.core.ui.itemTip.ItemInfoTip;
   import com.robot.core.utils.ItemType;
   import flash.display.DisplayObject;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import org.taomee.effect.ColorFilter;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.DepthManager;
   import org.taomee.manager.EventManager;
   import org.taomee.manager.ResourceManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.ArrayUtil;
   import org.taomee.utils.DisplayUtil;
   
   public class BagPanel extends Sprite
   {
      public static const PREV_PAGE:String = "prevPage";
      
      public static const NEXT_PAGE:String = "nextPage";
      
      public static const SHOW_CLOTH:String = "showCloth";
      
      public static const SHOW_COLLECTION:String = "showCollection";
      
      public static const SHOW_NONO:String = "showNoNo";
      
      public static const SHOW_SOULBEAD:String = "showSoulBead";
      
      public static var suitID:uint = 0;
      
      public static var currTab:uint = BagTabType.CLOTH;
      
      private var UI_PATH:String = "resource/module/bag/bagUI.swf";
      
      private var bagMC:MovieClip;
      
      private var closeBtn:SimpleButton;
      
      private var _dragBtn:SimpleButton;
      
      private var clothBtn:MovieClip;
      
      private var collectionBtn:MovieClip;
      
      private var nonoBtn:MovieClip;
      
      private var _typeBtn:MovieClip;
      
      private var _typeTxt:TextField;
      
      private var _typeJian:MovieClip;
      
      private var soulBeadBtn:MovieClip;
      
      private var _typePanel:BagTypePanel;
      
      public var clothPrev:BagClothPreview;
      
      private var _clickItemID:uint;
      
      private var app:ApplicationDomain;
      
      private var _listCon:Sprite;
      
      public var bChangeClothes:Boolean;
      
      private var _showMc:Sprite;
      
      private var instuctorLogo:MovieClip;
      
      private var logo:Sprite;
      
      private var logoCloth:TeamLogo;
      
      private var clothLight:MovieClip;
      
      private var qqMC:Sprite;
      
      private var changeNick:ChangeNickName;
      
      private var maskMc:Sprite;
      
      private var _arrowMc:MovieClip;
      
      public function BagPanel()
      {
         super();
         this.logo = new Sprite();
         this.logo.x = 27;
         this.logo.y = 95;
         this.logo.filters = [new GlowFilter(3355443,1,3,3,2)];
         this.logo.buttonMode = true;
         ToolTipManager.add(this.logo,"进入战队要塞");
      }
      
      public function show() : void
      {
         var loader:MCLoader = null;
         this.bChangeClothes = true;
         LevelManager.appLevel.addChild(this);
         if(!this.bagMC)
         {
            loader = new MCLoader(this.UI_PATH,LevelManager.appLevel,1,"正在打开储存箱");
            loader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadBagUI);
            loader.doLoad();
         }
         else
         {
            this.bagMC["nonoMc"].visible = false;
            this.init();
         }
      }
      
      public function hide() : void
      {
         DisplayUtil.removeAllChild(this.qqMC);
         currTab = BagTabType.CLOTH;
         this.changeNick.destory();
         this.changeNick = null;
         var oldStr:String = MainManager.actorClothStr;
         var array:Array = this.clothPrev.getClothArray();
         var str:String = this.clothPrev.getClothStr();
         if(str != oldStr && !ActorActionManager.isTransforming)
         {
            MainManager.actorModel.changeCloth(array);
            MainManager.actorInfo.clothes = array;
            EventManager.dispatchEvent(new Event(PeopleActionEvent.CLOTH_CHANGE));
         }
         if(Boolean(this._typePanel))
         {
            if(DisplayUtil.hasParent(this._typePanel))
            {
               this.onTypePanelHide();
            }
         }
         DisplayUtil.removeForParent(this,false);
         SocketConnection.removeCmdListener(CommandID.GOLD_ONLINE_CHECK_REMAIN,this.onGetGold);
      }
      
      public function showItem(data:Array) : void
      {
         var info:SingleItemInfo = null;
         var item:BagListItem = null;
         var hasPrev:Boolean = false;
         this.clearItemPanel();
         var len:int = int(data.length);
         for(var i:int = 0; i < len; i++)
         {
            info = data[i];
            item = this._listCon.getChildAt(i) as BagListItem;
            if(BagShowType.currType == BagShowType.SUIT)
            {
               if(!ItemManager.containsCloth(info.itemID))
               {
                  item.setInfo(info);
                  continue;
               }
            }
            hasPrev = false;
            if(BagShowType.currType == BagShowType.SUIT)
            {
               hasPrev = Boolean(ArrayUtil.arrayContainsValue(this.clothPrev.getClothArray(),info.itemID));
            }
            item.setInfo(info,hasPrev);
            if(!hasPrev)
            {
               if(info.leftTime != 0)
               {
                  if(info.type == ItemType.CLOTH)
                  {
                     item.buttonMode = true;
                     item.addEventListener(MouseEvent.CLICK,this.onChangeCloth);
                  }
               }
            }
            item.addEventListener(MouseEvent.ROLL_OVER,this.onShowItemInfo);
            item.addEventListener(MouseEvent.ROLL_OUT,this.onHideItemInfo);
         }
      }
      
      private function vipTabGrayscale() : Boolean
      {
         if(!MainManager.actorInfo.vip)
         {
            if(Boolean(this.nonoBtn))
            {
               this.nonoBtn.mouseEnabled = false;
               this.nonoBtn.filters = [ColorFilter.setGrayscale()];
               return true;
            }
         }
         return false;
      }
      
      private function init() : void
      {
         var level1:uint = 0;
         this.bagMC.addChild(this.logo);
         DisplayUtil.removeAllChild(this.logo);
         if(TasksManager.getTaskStatus(201) == TasksManager.COMPLETE)
         {
            this.bagMC.addChild(this.instuctorLogo);
            (this.instuctorLogo as MovieClip).gotoAndStop(1);
            if(MainManager.actorInfo.graduationCount >= 5)
            {
               level1 = uint(uint(MainManager.actorInfo.graduationCount / 5) + 1);
               if(level1 >= 5)
               {
                  (this.instuctorLogo as MovieClip).gotoAndStop(6);
               }
               else
               {
                  (this.instuctorLogo as MovieClip).gotoAndStop(level1);
               }
            }
         }
         if(MainManager.actorInfo.teamInfo.id != 0)
         {
            this.getTeamLogo();
         }
         if(Boolean(MainManager.actorInfo.vip))
         {
            this.bagMC["nonoMc"].visible = true;
            ToolTipManager.add(this.bagMC["nonoMc"],MainManager.actorInfo.vipLevel + "级超能NoNo");
            this.bagMC["nonoMc"]["vipStageMC"].gotoAndStop(MainManager.actorInfo.vipLevel);
         }
         this.goToCloth();
         this.clothPrev.changeColor(MainManager.actorInfo.color);
         this.clothPrev.showCloths(MainManager.actorInfo.clothes);
         this.clothPrev.showDoodle(MainManager.actorInfo.texture);
         this.clothBtn.addEventListener(MouseEvent.CLICK,this.showColth);
         this.clothBtn.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.clothBtn.addEventListener(MouseEvent.ROLL_OUT,this.onUp);
         this.collectionBtn.addEventListener(MouseEvent.CLICK,this.showPetThings);
         this.collectionBtn.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.collectionBtn.addEventListener(MouseEvent.ROLL_OUT,this.onUp);
         this.nonoBtn.addEventListener(MouseEvent.CLICK,this.onShowNoNo);
         this.nonoBtn.addEventListener(MouseEvent.ROLL_OVER,this.onOver);
         this.nonoBtn.addEventListener(MouseEvent.ROLL_OUT,this.onUp);
         this.soulBeadBtn.addEventListener(MouseEvent.CLICK,this.onShowSoulBead);
         this.soulBeadBtn.addEventListener(MouseEvent.ROLL_OVER,this.onSBOver);
         this.soulBeadBtn.addEventListener(MouseEvent.ROLL_OUT,this.onSBUp);
         dispatchEvent(new Event(Event.COMPLETE));
         this.changeNick = new ChangeNickName();
         this.changeNick.init(this.bagMC);
         this.bagMC["miId_txt"].text = "(" + MainManager.actorInfo.userID + ")";
         this.bagMC["money_txt"].text = MainManager.actorInfo.coins;
         ToolTipManager.add(this.bagMC["goldMC"],"赛尔金豆");
         ToolTipManager.add(this.bagMC["coinMC"],"赛尔豆");
         if(Boolean(this.logoCloth) && Boolean(MainManager.actorInfo.teamInfo.isShow))
         {
            addChild(this.logoCloth);
         }
         this.vipTabGrayscale();
         this.getGoldNum();
         this.showClothLight();
         EventManager.dispatchEvent(new Event(Event.COMPLETE));
      }
      
      private function showClothLight() : void
      {
         DisplayUtil.removeForParent(this.clothLight);
         var max:uint = uint(MainManager.actorInfo.clothMaxLevel);
         if(max > 1)
         {
            ResourceManager.getResource(ClientConfig.getClothLightUrl(max),this.onLoadLight);
            ResourceManager.getResource(ClientConfig.getClothCircleUrl(max),this.onLoadQQ);
         }
      }
      
      private function onLoadLight(o:DisplayObject) : void
      {
         this.clothLight = o as MovieClip;
         this.clothLight.scaleY = 3;
         this.clothLight.scaleX = 3;
         var rect:Rectangle = this._showMc.getRect(this._showMc);
         this.clothLight.x = rect.width / 2 + rect.x;
         this.clothLight.y = rect.height + rect.y;
         this._showMc.addChild(this.clothLight);
      }
      
      private function onLoadQQ(o:DisplayObject) : void
      {
         DisplayUtil.removeAllChild(this.qqMC);
         this.qqMC.addChild(o);
      }
      
      private function getGoldNum() : void
      {
         SocketConnection.addCmdListener(CommandID.GOLD_ONLINE_CHECK_REMAIN,this.onGetGold);
         SocketConnection.send(CommandID.GOLD_ONLINE_CHECK_REMAIN);
      }
      
      private function onGetGold(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GOLD_ONLINE_CHECK_REMAIN,this.onGetGold);
         var data:ByteArray = e.data as ByteArray;
         var num:Number = data.readUnsignedInt() / 100;
         this.bagMC["gold_txt"].text = num.toString();
      }
      
      private function onOver(e:MouseEvent) : void
      {
         (e.target as MovieClip).gotoAndStop(2);
      }
      
      private function onUp(e:MouseEvent) : void
      {
         if((e.target as MovieClip).currentFrame != 1)
         {
            (e.target as MovieClip).gotoAndStop(3);
         }
      }
      
      private function onSBOver(e:MouseEvent) : void
      {
         (e.target as MovieClip).gotoAndStop(2);
      }
      
      private function onSBUp(e:MouseEvent) : void
      {
         if((e.target as MovieClip).currentFrame != 1)
         {
            (e.target as MovieClip).gotoAndStop(3);
         }
      }
      
      private function showColth(e:MouseEvent) : void
      {
         this.goToCloth();
         dispatchEvent(new Event(SHOW_CLOTH));
      }
      
      public function goToCloth() : void
      {
         currTab = BagTabType.CLOTH;
         BagShowType.currType = BagShowType.ALL;
         this._typeJian.scaleY = 1;
         this._typeTxt.text = BagShowType.typeNameList[BagShowType.currType];
         this._typeBtn.visible = true;
         this._typeTxt.visible = true;
         this._typeJian.visible = true;
         this.clothBtn.gotoAndStop(1);
         this.clothBtn.mouseEnabled = false;
         this.clothBtn.mouseChildren = false;
         DepthManager.bringToTop(this.clothBtn);
         this.collectionBtn.mouseEnabled = true;
         this.collectionBtn.mouseChildren = true;
         this.collectionBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.collectionBtn);
         this.nonoBtn.mouseEnabled = true;
         this.nonoBtn.mouseChildren = true;
         this.nonoBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.nonoBtn);
         this.soulBeadBtn.mouseEnabled = true;
         this.soulBeadBtn.mouseChildren = true;
         this.soulBeadBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.soulBeadBtn);
      }
      
      private function showPetThings(e:MouseEvent) : void
      {
         currTab = BagTabType.COLLECTION;
         BagShowType.currType = BagShowType.ALL;
         BagShowType.currSuitID = 0;
         this._typeBtn.visible = false;
         this._typeTxt.visible = false;
         this._typeJian.visible = false;
         this.onTypePanelHide();
         this.collectionBtn.gotoAndStop(1);
         this.collectionBtn.mouseEnabled = false;
         this.collectionBtn.mouseChildren = false;
         DepthManager.bringToTop(this.collectionBtn);
         this.clothBtn.mouseEnabled = true;
         this.clothBtn.mouseChildren = true;
         this.clothBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.clothBtn);
         this.nonoBtn.mouseEnabled = true;
         this.nonoBtn.mouseChildren = true;
         this.nonoBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.nonoBtn);
         this.soulBeadBtn.mouseEnabled = true;
         this.soulBeadBtn.mouseChildren = true;
         this.soulBeadBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.soulBeadBtn);
         dispatchEvent(new Event(SHOW_COLLECTION));
      }
      
      private function onShowNoNo(e:MouseEvent) : void
      {
         if(this.vipTabGrayscale())
         {
            return;
         }
         currTab = BagTabType.NONO;
         BagShowType.currType = BagShowType.ALL;
         this._typeJian.scaleY = 1;
         this._typeTxt.text = BagShowType.typeNameList[BagShowType.currType];
         this._typeBtn.visible = true;
         this._typeTxt.visible = true;
         this._typeJian.visible = true;
         this.nonoBtn.mouseEnabled = false;
         this.nonoBtn.mouseChildren = false;
         this.nonoBtn.gotoAndStop(1);
         DepthManager.bringToTop(this.nonoBtn);
         this.collectionBtn.gotoAndStop(3);
         this.collectionBtn.mouseEnabled = true;
         this.collectionBtn.mouseChildren = true;
         DepthManager.bringToBottom(this.collectionBtn);
         this.clothBtn.mouseEnabled = true;
         this.clothBtn.mouseChildren = true;
         this.clothBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.clothBtn);
         this.soulBeadBtn.mouseEnabled = true;
         this.soulBeadBtn.mouseChildren = true;
         this.soulBeadBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.soulBeadBtn);
         dispatchEvent(new Event(SHOW_NONO));
      }
      
      private function onShowSoulBead(evt:MouseEvent) : void
      {
         currTab = BagTabType.SOULBEAD;
         BagShowType.currType = BagShowType.ALL;
         this._typeJian.scaleY = 1;
         this._typeTxt.text = BagShowType.typeNameList[BagShowType.currType];
         this._typeBtn.visible = false;
         this._typeTxt.visible = false;
         this._typeJian.visible = false;
         this.soulBeadBtn.mouseEnabled = false;
         this.soulBeadBtn.mouseChildren = false;
         this.soulBeadBtn.gotoAndStop(1);
         DepthManager.bringToTop(this.soulBeadBtn);
         this.nonoBtn.mouseEnabled = true;
         this.nonoBtn.mouseChildren = true;
         this.nonoBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.nonoBtn);
         this.collectionBtn.gotoAndStop(3);
         this.collectionBtn.mouseEnabled = true;
         this.collectionBtn.mouseChildren = true;
         DepthManager.bringToBottom(this.collectionBtn);
         this.clothBtn.mouseEnabled = true;
         this.clothBtn.mouseChildren = true;
         this.clothBtn.gotoAndStop(3);
         DepthManager.bringToBottom(this.clothBtn);
         dispatchEvent(new Event(SHOW_SOULBEAD));
      }
      
      private function onTypeClick(e:MouseEvent) : void
      {
         if(this._typePanel == null)
         {
            this._typePanel = new BagTypePanel(this.app);
            this._typePanel.addEventListener(BagTypeEvent.SELECT,this.onTypeSelect);
            this._typePanel.x = 350;
         }
         if(DisplayUtil.hasParent(this._typePanel))
         {
            this.onTypePanelHide();
         }
         else
         {
            addChild(this._typePanel);
            this._typePanel.setSelect(BagShowType.currType);
            this._typeJian.scaleY = -1;
         }
      }
      
      private function onTypeSelect(e:BagTypeEvent) : void
      {
         this.onTypePanelHide();
         BagShowType.currType = e.showType;
         BagShowType.currSuitID = e.suitID;
         this._typePanel.setSelect(BagShowType.currType);
         this._typeTxt.text = BagShowType.typeNameList[BagShowType.currType];
         dispatchEvent(new BagTypeEvent(BagTypeEvent.SELECT,e.showType,e.suitID));
      }
      
      private function onTypePanelHide() : void
      {
         if(Boolean(this._typePanel))
         {
            DisplayUtil.removeForParent(this._typePanel,false);
            this._typeJian.scaleY = 1;
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
      
      private function onLoadBagUI(event:MCLoadEvent) : void
      {
         this.app = event.getApplicationDomain();
         this.bagMC = new (this.app.getDefinition("BagPanel") as Class)() as MovieClip;
         this.bagMC["nonoMc"].visible = false;
         addChild(this.bagMC);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         this.instuctorLogo = UIManager.getMovieClip("Teacher_Icon");
         this.instuctorLogo.x = 37;
         this.instuctorLogo.y = 275;
         this._listCon = new Sprite();
         this._listCon.y = 20;
         this._listCon.x = 300;
         this.bagMC.addChild(this._listCon);
         this.closeBtn = this.bagMC["closeBtn"];
         this.closeBtn.addEventListener(MouseEvent.CLICK,this.onClose);
         this.createItemPanel();
         this._dragBtn = this.bagMC["dragBtn"];
         this._dragBtn.useHandCursor = false;
         this._dragBtn.addEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this._dragBtn.addEventListener(MouseEvent.MOUSE_UP,this.onDragUp);
         this.clothBtn = this.bagMC["clothBtn"];
         this.collectionBtn = this.bagMC["collectionBtn"];
         this.nonoBtn = this.bagMC["nonoBtn"];
         ToolTipManager.add(this.clothBtn,"装备部件");
         ToolTipManager.add(this.collectionBtn,"收藏物品");
         ToolTipManager.add(this.nonoBtn,"超能NoNo");
         this.soulBeadBtn = this.bagMC["soulBeadBtn"];
         ToolTipManager.add(this.soulBeadBtn,"精灵元神珠");
         var prevBtn:SimpleButton = this.bagMC["prev_btn"];
         var nextBtn:SimpleButton = this.bagMC["next_btn"];
         prevBtn.addEventListener(MouseEvent.CLICK,this.prevHandler);
         nextBtn.addEventListener(MouseEvent.CLICK,this.nextHandler);
         this._typeBtn = this.bagMC["typeBtn"];
         this._typeTxt = this.bagMC["typeTxt"];
         this._typeJian = this.bagMC["typeJian"];
         this._typeTxt.mouseEnabled = false;
         this._typeJian.mouseEnabled = false;
         this._typeBtn.addEventListener(MouseEvent.CLICK,this.onTypeClick);
         this._showMc = UIManager.getSprite("ComposeMC");
         this._showMc.scaleY = 0.9;
         this._showMc.scaleX = 0.9;
         this._showMc.x = 78;
         this._showMc.y = 122;
         this.bagMC.addChild(this._showMc);
         this.clothPrev = new BagClothPreview(this._showMc,null,ClothPreview.MODEL_SHOW);
         this.qqMC = new Sprite();
         this.qqMC.scaleX = 3.2;
         this.qqMC.scaleY = 1.6;
         var rect:Rectangle = this._showMc.getRect(this._showMc);
         this.qqMC.x = rect.width / 2 + rect.x;
         this.qqMC.y = rect.height + rect.y;
         this._showMc.addChildAt(this.qqMC,0);
         this.init();
      }
      
      private function createItemPanel() : void
      {
         var item:BagListItem = null;
         for(var i:int = 0; i < 12; i++)
         {
            item = new BagListItem(new (this.app.getDefinition("itemPanel") as Class)() as Sprite);
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
            item.removeEventListener(MouseEvent.CLICK,this.onChangeCloth);
            item.removeEventListener(MouseEvent.ROLL_OVER,this.onShowItemInfo);
            item.removeEventListener(MouseEvent.ROLL_OUT,this.onHideItemInfo);
            item.buttonMode = false;
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
      
      private function onChangeCloth(event:MouseEvent) : void
      {
         var arr:Array = null;
         var array:Array = null;
         var i:uint = 0;
         var item:BagListItem = event.currentTarget as BagListItem;
         if(item.info == null)
         {
            return;
         }
         ItemInfoTip.hide();
         this._clickItemID = item.info.itemID;
         if(BagShowType.currType == BagShowType.SUIT)
         {
            arr = SuitXMLInfo.getCloths(BagShowType.currSuitID).filter(function(item:uint, index:int, array:Array):Boolean
            {
               if(ItemManager.containsCloth(item))
               {
                  if(ItemManager.getClothInfo(item).leftTime == 0)
                  {
                     return false;
                  }
                  return true;
               }
               return false;
            });
            array = [];
            for each(i in arr)
            {
               array.push(new PeopleItemInfo(i));
            }
            this.clothPrev.showCloths(array);
         }
         else
         {
            this.clothPrev.showCloth(this._clickItemID,item.info.itemLevel);
         }
      }
      
      private function onClose(event:MouseEvent) : void
      {
         this.hide();
         this.openEvent();
         dispatchEvent(new Event(Event.CLOSE));
         EventManager.dispatchEvent(new Event(Event.CLOSE));
      }
      
      public function get clickItemID() : uint
      {
         return this._clickItemID;
      }
      
      public function setPageNum(current:uint, total:uint) : void
      {
         this.bagMC["page_txt"].text = current + "/" + total;
      }
      
      private function onDragDown(e:MouseEvent) : void
      {
         if(Boolean(parent))
         {
            parent.addChild(this);
         }
         startDrag();
      }
      
      private function onDragUp(e:MouseEvent) : void
      {
         stopDrag();
      }
      
      private function getTeamLogo() : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_GET_INFO,this.onGetInfo);
         SocketConnection.send(CommandID.TEAM_GET_INFO,MainManager.actorInfo.teamInfo.id);
      }
      
      private function onGetInfo(event:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TEAM_GET_INFO,this.onGetInfo);
         var info:SimpleTeamInfo = event.data as SimpleTeamInfo;
         var teamLogo:TeamLogo = new TeamLogo();
         teamLogo.info = info;
         teamLogo.scaleY = 0.8;
         teamLogo.scaleX = 0.8;
         this.logo.addChild(teamLogo);
         teamLogo.addEventListener(MouseEvent.CLICK,this.showTeamInfo);
         if(Boolean(this.logoCloth))
         {
            DisplayUtil.removeForParent(this.logoCloth);
            this.logoCloth.removeEventListener(MouseEvent.CLICK,this.removeLogo);
         }
         this.logoCloth = teamLogo.clone();
         this.logoCloth.addEventListener(MouseEvent.CLICK,this.removeLogo);
         this.checkLogoCloth();
      }
      
      private function removeLogo(event:MouseEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.TEAM_SHOW_LOGO,this.onTeamShowLogo);
         SocketConnection.send(CommandID.TEAM_SHOW_LOGO,0);
      }
      
      private function onTeamShowLogo(event:SocketEvent) : void
      {
         DisplayUtil.removeForParent(this.logoCloth);
      }
      
      private function showTeamInfo(event:MouseEvent) : void
      {
         var mc:TeamLogo = event.currentTarget as TeamLogo;
         TeamController.show(mc.teamID);
      }
      
      private function checkLogoCloth() : void
      {
         if(MainManager.actorInfo.teamInfo.isShow)
         {
            if(Boolean(this.logoCloth))
            {
               this.logoCloth.x = (270 - this.logoCloth.width) / 2;
               this.logoCloth.y = 80;
               addChild(this.logoCloth);
            }
         }
         else
         {
            DisplayUtil.removeForParent(this.logoCloth);
         }
      }
      
      public function closeEvent() : void
      {
         if(Boolean(this._typeBtn))
         {
            this._typeBtn.mouseChildren = false;
            this._typeBtn.mouseEnabled = false;
         }
         this.maskMc = new Sprite();
         this.maskMc.graphics.beginFill(0,1);
         this.maskMc.graphics.lineStyle(1,0);
         this.maskMc.graphics.drawRect(0,0,580,380);
         this.maskMc.graphics.endFill();
         this.maskMc.alpha = 0;
         this.bagMC.addChildAt(this.maskMc,this.bagMC.getChildIndex(this._showMc) + 1);
         this.bagMC.addChild(this.closeBtn);
         this._arrowMc = TaskIconManager.getIcon("Arrows_MC") as MovieClip;
         this.addChild(this._arrowMc);
         this._arrowMc.x = 220;
         this._arrowMc.y = 43;
         MovieClip(this._arrowMc["mc"]).rotation = -180;
         MovieClip(this._arrowMc["mc"]).play();
      }
      
      public function openEvent() : void
      {
         if(Boolean(this._typeBtn))
         {
            this._typeBtn.mouseChildren = true;
            this._typeBtn.mouseEnabled = true;
         }
         if(Boolean(this.maskMc))
         {
            this.maskMc.graphics.clear();
            DisplayUtil.removeForParent(this.maskMc);
            this.maskMc = null;
         }
         if(Boolean(this._arrowMc))
         {
            DisplayUtil.removeForParent(this._arrowMc);
            this._arrowMc = null;
         }
      }
   }
}

