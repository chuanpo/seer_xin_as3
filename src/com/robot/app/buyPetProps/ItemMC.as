package com.robot.app.buyPetProps
{
	import flash.display.MovieClip;
	import flash.text.TextField;
	import flash.display.SimpleButton;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import gs.plugins.VisiblePlugin;
	import com.robot.core.config.xml.ItemXMLInfo;
	import flash.ui.Mouse;
	import flash.events.MouseEvent;
	import com.robot.core.config.xml.GoldProductXMLInfo;
	import org.taomee.manager.ResourceManager;
	import com.robot.core.net.SocketConnection;
	import flash.geom.Point;
	import com.robot.core.CommandID;
	import com.robot.core.info.userItem.SingleItemInfo;
	import com.robot.core.ui.itemTip.ItemInfoTip;
	
	public class ItemMC{
		
		private var _itemMC:MovieClip;

      	private var _bgMC:MovieClip;
      
      	private var _buyItemBtn:SimpleButton;
		
		private var _itemNameText:TextField;
		
		private var _itemPriceText:TextField;

		private var _seerCoinMC:MovieClip;

		private var _glodCoinMC:MovieClip;

		private var price:Number=999999999;
		
		private var icon:Sprite = new Sprite();

		private var itemID:int = 0;

		private var isGoldCoinItem:Boolean = false;

		private var _parent:BuyPetPropsPanel;

		private var singleItemInfo:SingleItemInfo = new SingleItemInfo();
		public function ItemMC(parent:BuyPetPropsPanel,count:int)
		{
			super();
			this._parent = parent;
			this._itemMC =  new (parent.app.getDefinition("itemMC") as Class)() as MovieClip;
			this._itemMC.x = 85 + (100 * (count % 5));
         	this._itemMC.y = 67 + (115 * int(count / 5));
			this._itemMC.name = "itemMC_" + count.toString();
			this._bgMC = this._itemMC["bgMC"] as MovieClip;
			this._bgMC.addEventListener(MouseEvent.ROLL_OVER,showTip);
			this._bgMC.addEventListener(MouseEvent.ROLL_OUT,hideTip);			
			this._itemNameText = this._itemMC["itemNameTxet"] as TextField;
			this._itemPriceText = this._itemMC["itemPriceText"] as TextField;
			this._seerCoinMC = this._itemMC["seerCoinMC"] as MovieClip;
			this._glodCoinMC = this._itemMC["goldCoinMC"] as MovieClip;
			this._buyItemBtn = this._itemMC["buyItemBtn"] as SimpleButton;
			this._buyItemBtn.addEventListener(MouseEvent.CLICK,onClickBuyBtn);
			this._glodCoinMC.visible = false;
			this._bgMC.addChild(this.icon);
			this.icon.mouseEnabled = false;
         	this.icon.mouseChildren = false;
		}
		private function showTip(e:MouseEvent):void
		{
			ItemInfoTip.show(singleItemInfo)
		}
		private function hideTip(e:MouseEvent):void
		{
			ItemInfoTip.hide()
		}
		public function setup(itemId:int):void
		{
			this.itemID = itemId;
			this.singleItemInfo.itemID = itemId;
			this.isGoldCoinItem = ItemXMLInfo.getPrice(this.itemID) == 999999999 || ItemXMLInfo.getPrice(this.itemID) == 0;
			this._seerCoinMC.visible = !this.isGoldCoinItem;
			this._glodCoinMC.visible = this.isGoldCoinItem;
			this._itemNameText.text = ItemXMLInfo.getName(itemID);
			this.price = this.isGoldCoinItem ? Number(GoldProductXMLInfo.getPriceByItemID(this.itemID)) : Number(ItemXMLInfo.getPrice(itemID));
			this._itemPriceText.text = this.price.toString();
			// if(this.icon.getChildByName("icon"))
			// {
			// 	this.icon.removeChild(this.icon.getChildByName("icon"));
			// }
			while (icon.numChildren > 0) {
        		icon.removeChildAt(0);
    		}
			var onLoadIcon:Function = function(o:DisplayObject):void
            {
				// o.name="icon";
               	icon.addChild(o);
            };
			ResourceManager.getResource(ItemXMLInfo.getIconURL(this.itemID),onLoadIcon);
		}
		public function onClickBuyBtn(e:MouseEvent):void
		{
			if(this.isGoldCoinItem)
            {
               	_parent.goldCoinItemID = this.itemID;
				SocketConnection.send(CommandID.GOLD_CHECK_REMAIN);
            }else
            {
                var onGetIcon:Function = function(o:DisplayObject):void
				{
					_parent.showTipPanel(itemID,o as MovieClip,new Point(182,45));
				};
				ResourceManager.getResource(ItemXMLInfo.getIconURL(this.itemID),onGetIcon);
            }
		}
		public function get itemMC():MovieClip
		{
			return this._itemMC;
		}

		public function set visible(flag:Boolean):void
		{
			this._itemMC.visible = flag;
		}
		public function get name():String
		{
			return this._itemMC.name;
		}
	}
}
