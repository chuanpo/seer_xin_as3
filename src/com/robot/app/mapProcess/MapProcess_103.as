package com.robot.app.mapProcess
{
   import com.robot.app.buyItem.ItemAction;
   import com.robot.app.energy.ore.DayOreCount;
   import com.robot.app.equipStrengthen.EquipStrengthenController;
   import com.robot.core.CommandID;
   import com.robot.core.config.ClientConfig;
   import com.robot.core.manager.SOManager;
   import com.robot.core.manager.book.BookId;
   import com.robot.core.manager.book.BookManager;
   import com.robot.core.manager.map.config.BaseMapProcess;
   import com.robot.core.mode.AppModel;
   import com.robot.core.mode.NpcModel;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.net.SharedObject;
   import flash.utils.Timer;
   import org.taomee.events.SocketEvent;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   
   public class MapProcess_103 extends BaseMapProcess
   {
      private var eggApp:AppModel;
      
      private var npcModel:NpcModel;
      
      private var timer:Timer;
      
      private var npcDialog:MovieClip;
      
      private var conVertDialog:MovieClip;
      
      private var boxMC:SimpleButton;
      
      private var bookMC:SimpleButton;
      
      private var bookBtn:MovieClip;
      
      private var _elietCoinBtn:SimpleButton;
      
      private var _aliceMc:MovieClip;
      
      private var _shopSo:SharedObject;
      
      private var appModel:AppModel;
      
      private var _so:SharedObject;
      
      public function MapProcess_103()
      {
         super();
      }
      
      override protected function init() : void
      {
         this.boxMC = conLevel["box"];
         ToolTipManager.add(this.boxMC,"赛尔金豆");
         this.boxMC.visible = false;
         this.bookMC = conLevel["bookbox"];
         this.bookMC.visible = false;
         this.bookMC.addEventListener(MouseEvent.CLICK,this.onBookBoxClickHandler);
         ToolTipManager.add(this.bookMC,"宇宙购物指南");
         this._elietCoinBtn = conLevel["elietCoinBtn"];
         this._elietCoinBtn.visible = false;
         ToolTipManager.add(this._elietCoinBtn,"米币精品手册 ");
         this._elietCoinBtn.addEventListener(MouseEvent.CLICK,this.clickElietCoinHandler);
         this.bookBtn = btnLevel["book"];
         this.bookBtn.visible = false;
         this.bookBtn.addEventListener(MouseEvent.CLICK,this.showBookHandler);
         ToolTipManager.add(btnLevel["book"],"宇宙购物指南");
         this._so = SOManager.getUserSO(SOManager.READEDSHOPINGBOOK);
         if(!this._so.data.hasOwnProperty("isShow"))
         {
            this._so.data["isShow"] = false;
            SOManager.flush(this._so);
         }
         else if(this._so.data["isShow"] == true)
         {
            this.bookBtn["mc"].gotoAndStop(1);
            this.bookBtn["mc"].visible = false;
         }
         this.initShop();
      }
      
      private function clickElietCoinHandler(e:MouseEvent) : void
      {
         BookManager.show(BookId.BOOK_0);
      }
      
      public function onEquipHandler() : void
      {
         EquipStrengthenController.start();
      }
      
      private function initShop() : void
      {
         this._shopSo = SOManager.getUserSO(SOManager.Is_Readed_ShopingBook);
         this.conLevel["shopMc"].addEventListener(MouseEvent.CLICK,this.onShopHandler);
         ToolTipManager.add(conLevel["shopMc"],"赛尔典藏手册");
      }
      
      private function onShopHandler(e:MouseEvent) : void
      {
         BookManager.show(BookId.BOOK_4);
      }
      
      private function showBookHandler(e:MouseEvent) : void
      {
         this._so.data["isShow"] = true;
         SOManager.flush(this._so);
         this.bookBtn["mc"].gotoAndStop(1);
         this.bookBtn["mc"].visible = false;
         this.showBook();
      }
      
      private function showBook() : void
      {
         BookManager.show(BookId.BOOK_3);
      }
      
      private function onBookBoxClickHandler(e:MouseEvent) : void
      {
         this.showBook();
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.TALK_CATE,this.onTalk2);
         SocketConnection.send(CommandID.TALK_CATE,1003);
      }
      
      private function onTalk2(event:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TALK_CATE,this.onTalk2);
         DisplayUtil.removeForParent(conLevel["btn"]);
         Alarm.show("恭喜你获得" + TextFormatUtil.getRedTxt("10000点积累经验") + "，已经存入你的经验分配器中。快回基地看看吧");
      }
      
      private function onCount2(event:Event) : void
      {
         if(DayOreCount.oreCount >= 1)
         {
            DisplayUtil.removeForParent(conLevel["btn"]);
         }
      }
      
      override public function destroy() : void
      {
         ItemAction.desBuyPanel();
         EquipStrengthenController.destory();
         BookManager.destroy();
         if(Boolean(this.eggApp))
         {
            this.eggApp = null;
         }
         if(Boolean(this._so))
         {
            this._so = null;
         }
      }
      
      public function onEggHandler() : void
      {
         if(!this.eggApp)
         {
            this.eggApp = new AppModel(ClientConfig.getGameModule("EggMechineGame"),"正在打开扭蛋机");
         }
         this.eggApp.show();
      }
      
      public function buyItem() : void
      {
         var or:DayOreCount = new DayOreCount();
         or.addEventListener(DayOreCount.countOK,this.onCount);
         or.sendToServer(2051);
      }
      
      private function onCount(event:Event) : void
      {
         if(DayOreCount.oreCount >= 1)
         {
            Alarm.show("你今天已经领取过了");
         }
         else
         {
            SocketConnection.addCmdListener(CommandID.TALK_CATE,this.onTalk);
            SocketConnection.send(CommandID.TALK_CATE,2051);
         }
      }
      
      private function onTalk(event:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.TALK_CATE,this.onTalk);
         ItemInBagAlert.show(400501,"2个<font color=\'#ff0000\'>神奇扭蛋牌</font>已经放入你的储存箱中！");
      }
   }
}

