package com.robot.app.buyPetProps
{
   import com.robot.core.CommandID;
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.info.FitmentInfo;
   import com.robot.core.manager.FitmentManager;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.system.ApplicationDomain;
   import flash.utils.ByteArray;
   import org.taomee.ds.HashMap;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   import com.robot.core.config.xml.ItemXMLInfo;
   import flash.geom.Rectangle;
   import flash.display.DisplayObject;
   import flash.text.TextField;
   import com.robot.core.config.xml.GoldProductXMLInfo;
   import org.taomee.manager.ResourceManager;
   import com.robot.core.utils.TextFormatUtil;
   import com.robot.core.ui.alert.Alert;
   import com.robot.core.ui.alert.ItemInBagAlert;
   import com.robot.core.ui.alert.IconAlert;
   import flash.utils.setTimeout;
   
   public class BuyPetPropsPanel extends Sprite
   {
      private static var propsHashMap:HashMap;
      
      private var PATH:String = "resource/module/petProps/buyPetProps.swf?20250323-1";
      
      public var app:ApplicationDomain;
      
      private var mc:MovieClip;
      
      private var tipMc:MovieClip;
      
      private var _pageText:TextField;

      private var _preBtn:SimpleButton;

      private var _nextBtn:SimpleButton;

      public var goldCoinItemID:Number=0;

      private var iconHashMap:HashMap = new HashMap();

      private var itemArray:Array = [300001,300002,300003,300004,300006,300009,300011,300012,300013,300014,300015,300016,300017,300018,300019,
               300024,300025,300026,300027,300028,300029,300030,300031,300032,300033,300034,300035,300036,300037,300038,
               300039,300040,300041,300042,300043,300044,300045,300046,300047,300048,300049,300050,100266,100267,100268,400054];
      
      private var curPage:int = 0;

      private var totalPage:int = 1;

      private var itemMCHashMap:HashMap = new HashMap();

      private var isLoadingItem:Boolean = false;

      public function BuyPetPropsPanel()
      {
         super();
      }
      
      public function show() : void
      {
         var loader:MCLoader = null;
         if(!this.mc)
         {
            loader = new MCLoader(this.PATH,this,1,"正在打开精灵道具列表");
            loader.addEventListener(MCLoadEvent.SUCCESS,this.onLoad);
            loader.doLoad();
         }
         else
         {
            DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
            LevelManager.closeMouseEvent();
            LevelManager.appLevel.addChild(this);
         }
         SocketConnection.addCmdListener(CommandID.GOLD_CHECK_REMAIN,onCheckGold);
      }
      
      private function onLoad(event:MCLoadEvent) : void
      {
         this.app = event.getApplicationDomain();
         this.mc = new (this.app.getDefinition("petPropsPanel") as Class)() as MovieClip;
         this.tipMc = new (this.app.getDefinition("buyTipPanel") as Class)() as MovieClip;
         this._pageText = this.mc["pageText"] as TextField;
         this._preBtn = this.mc["preBtn"] as SimpleButton;
         this._nextBtn = this.mc["nextBtn"] as SimpleButton;
         this.totalPage = (int(this.itemArray.length / 15) + 1)
         this._pageText.text =  "1/" + totalPage.toString();
         this._nextBtn.addEventListener(MouseEvent.CLICK,nextPage);
         this._preBtn.addEventListener(MouseEvent.CLICK,prePage);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         LevelManager.appLevel.addChild(this);
         var closeBtn:SimpleButton = this.mc["exitBtn"];
         closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         addChild(this.mc);
         DisplayUtil.align(this,null,AlignType.MIDDLE_CENTER);
         LevelManager.closeMouseEvent();
         LevelManager.appLevel.addChild(this);
         setupItemMC();
         setTimeout(function():void{
            showPage(0);
         },100)
      }

      private function setupItemMC():void
      {
         for(var i:int = 0;i < 15;i++)
         {
            var itemMC:ItemMC = new ItemMC(this,i);
            this.itemMCHashMap.add("itemMC_" + i.toString(),itemMC);
            this.mc.addChild(itemMC.itemMC);
         }
      }
      private function showPage(pageNum:int):void
      {
         var startNum:int = pageNum * 15;
         var endNum:int = (pageNum + 1) * 15;
         if(endNum > this.itemArray.length)endNum = this.itemArray.length;
         var total:int = endNum - startNum;
         var curNum:int = 0;
         for each(var item:ItemMC in this.itemMCHashMap.getValues())
         {
            item.visible = false;
         }
         
         for(var i:int = startNum ; i <endNum;i++)
         {
            (this.itemMCHashMap.getValue("itemMC_" + curNum.toString()) as ItemMC).setup(itemArray[i]);
            (this.itemMCHashMap.getValue("itemMC_" + curNum.toString()) as ItemMC).visible = true;
            curNum++
         }
      }

      private function nextPage(e:MouseEvent):void
      {
         this.curPage += 1;
         if(this.curPage >= this.totalPage) this.curPage = this.totalPage - 1;
         this._pageText.text =  (this.curPage + 1) + "/" + totalPage.toString();
         this.showPage(this.curPage);
      }
      private function prePage(e:MouseEvent):void
      {
         this.curPage -= 1;
         if(this.curPage < 0) this.curPage = 0;
         this._pageText.text = (this.curPage + 1)+ "/" + totalPage.toString();
         this.showPage(this.curPage);
      }
      
      
      private function getCover(e:MouseEvent) : void
      {
         SocketConnection.addCmdListener(CommandID.BUY_FITMENT,this.onBuyFitment);
         SocketConnection.send(CommandID.BUY_FITMENT,500502,1);
      }
      
      private function onBuyFitment(e:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.BUY_FITMENT,this.onBuyFitment);
         var by:ByteArray = e.data as ByteArray;
         var coins:uint = by.readUnsignedInt();
         var id:uint = by.readUnsignedInt();
         var num:uint = by.readUnsignedInt();
         MainManager.actorInfo.coins = coins;
         var info:FitmentInfo = new FitmentInfo();
         info.id = id;
         FitmentManager.addInStorage(info);
         Alarm.show("精灵恢复仓已经放入你的基地仓库");
      }
      
      public function showTipPanel(id:uint, icMC:MovieClip, point:Point) : void
      {
         if(MainManager.actorInfo.coins < Number(ItemXMLInfo.getPrice(id)))
         {
            Alarm.show("你的赛尔豆不足");
            return;
         }
         new ListPetProps(this.tipMc,id,icMC,point);
      }
      
      private function closeHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this);
         LevelManager.openMouseEvent();
         SocketConnection.removeCmdListener(CommandID.GOLD_CHECK_REMAIN,onCheckGold);
      }


      private function onCheckGold(event:SocketEvent) : void
      {
         var num:Number = (event.data as ByteArray).readUnsignedInt() / 100;
         var name:String = GoldProductXMLInfo.getNameByItemID(goldCoinItemID);
         var price:Number = Number(GoldProductXMLInfo.getPriceByItemID(goldCoinItemID));
         if(price > num)
         {
            Alarm.show("目前你拥有" + TextFormatUtil.getRedTxt(num.toString()) + "金豆，无法购买"+ TextFormatUtil.getRedTxt(price.toString()) + "金豆的商品！");
         }else
         {
            Alert.show(TextFormatUtil.getRedTxt(name) + "需要花费" + TextFormatUtil.getRedTxt(price.toString()) + "金豆，" + "目前你拥有" + TextFormatUtil.getRedTxt(num.toString()) + "金豆，要确认购买吗？",function():void
               {
                  var by1:ByteArray = new ByteArray();
                  by1.writeShort(1);
                  var productID:Number = Number(GoldProductXMLInfo.getProductByItemId(goldCoinItemID));
                  SocketConnection.addCmdListener(CommandID.GOLD_BUY_PRODUCT,onBuyGoldItem);
                  SocketConnection.send(CommandID.GOLD_BUY_PRODUCT,productID,by1);
               });
         }
         
      }

      private function onBuyGoldItem(event:SocketEvent) : void
      {
         SocketConnection.removeCmdListener(CommandID.GOLD_BUY_PRODUCT,onBuyGoldItem);
         var name:String = null;
         // var data:GoldBuyProductInfo = event.data as GoldBuyProductInfo;
         name = ItemXMLInfo.getName(goldCoinItemID);
         if(goldCoinItemID > 500000)
         {
            IconAlert.show("恭喜你购买成功，" + TextFormatUtil.getRedTxt(name) + "已经放入你的基地仓库中",goldCoinItemID);
         }
         else
         {
            ItemInBagAlert.show(goldCoinItemID,"恭喜你购买成功，" + TextFormatUtil.getRedTxt(name) + "已经放入你的储存箱中");
         }
      }
   }
}

