package com.robot.app.buyItem
{
   import com.adobe.crypto.MD5;
   import com.robot.app.bag.BagClothPreview;
   import com.robot.app.task.taskUtils.taskDialog.NpcTipDialog;
   import com.robot.app.vipSession.VipSession;
   import com.robot.core.CommandID;
   import com.robot.core.config.xml.GoldProductXMLInfo;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.config.xml.MoneyProductXMLInfo;
   import com.robot.core.info.clothInfo.PeopleItemInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.net.SocketConnection;
   import com.robot.core.skeleton.ClothPreview;
   import com.robot.core.ui.alert.Alarm;
   import com.robot.core.ui.alert.Alert;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.utils.ByteArray;
   import org.taomee.component.control.MLoadPane;
   import org.taomee.events.SocketEvent;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class ProductAction
   {
      public static var productID:uint;
      
      private static var count:uint;
      
      private static var closeBtn:SimpleButton;
      
      private static var okBtn:SimpleButton;
      
      private static var cancelBtn:SimpleButton;
      
      private static var pswTxt:TextField;
      
      private static var contentTxt:TextField;
      
      private static var panel:MovieClip;
      
      private static var loadPanel:MLoadPane;
      
      setup();
      
      public function ProductAction()
      {
         super();
      }
      
      private static function setup() : void
      {
         SocketConnection.addCmdListener(CommandID.GOLD_CHECK_REMAIN,onCheckGold);
         SocketConnection.addCmdListener(CommandID.MONEY_CHECK_PSW,onCheckPSW);
         SocketConnection.addCmdListener(CommandID.MONEY_CHECK_REMAIN,onCheckMoney);
      }
      
      public static function buyGoldProduct(proID:uint, cnt:uint = 1) : void
      {
         productID = proID;
         count = cnt;
         SocketConnection.send(CommandID.GOLD_CHECK_REMAIN);
      }
      
      private static function onCheckGold(event:SocketEvent) : void
      {
         var num:Number = (event.data as ByteArray).readUnsignedInt() / 100;
         var name:String = GoldProductXMLInfo.getNameByProID(productID);
         var price:Number = Number(GoldProductXMLInfo.getPriceByProID(productID));
         Alert.show(TextFormatUtil.getRedTxt(name) + "需要花费" + TextFormatUtil.getRedTxt(price.toString()) + "金豆，" + "目前你拥有" + TextFormatUtil.getRedTxt(num.toString()) + "金豆，要确认购买吗？",function():void
         {
            var by1:ByteArray = new ByteArray();
            by1.writeShort(count);
            SocketConnection.send(CommandID.GOLD_BUY_PRODUCT,productID,by1);
         });
      }
      
      public static function buyMoneyProduct(proID:uint, cnt:uint = 1) : void
      {
         if(proID == 200000 || proID == 200001 || proID == 200002)
         {
            if(!MainManager.actorInfo.vip)
            {
               NpcTipDialog.showAnswer("很抱歉哟，只有超能NoNo才能帮助金豆兑换。你想立刻拥有超能NoNo吗？",function():void
               {
                  var r:VipSession = new VipSession();
                  r.addEventListener(VipSession.GET_SESSION,function(event:Event):void
                  {
                  });
                  r.getSession();
               },null,NpcTipDialog.ROCKY);
               return;
            }
         }
         productID = proID;
         count = cnt;
         SocketConnection.send(CommandID.MONEY_CHECK_PSW);
      }
      
      private static function onCheckPSW(event:SocketEvent) : void
      {
         var num:uint = (event.data as ByteArray).readUnsignedInt();
         if(num == 1)
         {
            SocketConnection.send(CommandID.MONEY_CHECK_REMAIN);
         }
         else
         {
            Alert.show("你的米币账户设置还没有完成，需要购买米币商品必须输入<font color=\'#ff0000\'>米币账户支付密码</font>，确定现在去进行<font color=\'#ff0000\'>米币账户支付密码</font>的设置吗？",function():void
            {
               var r:VipSession = new VipSession();
               r.addEventListener(VipSession.GET_SESSION,function(event:Event):void
               {
               });
               r.getSession();
            });
         }
      }
      
      private static function onCheckMoney(event:SocketEvent) : void
      {
         var str:String = null;
         var _showMc:Sprite = null;
         var clothPrev:BagClothPreview = null;
         var arr:Array = null;
         var id:uint = 0;
         if(!panel)
         {
            panel = new ui_moneyBuyPanel();
            closeBtn = panel["closeBtn"];
            okBtn = panel["okBtn"];
            cancelBtn = panel["cancelBtn"];
            pswTxt = panel["txt"];
            contentTxt = panel["content_txt"];
            closeBtn.addEventListener(MouseEvent.CLICK,closePanel);
            cancelBtn.addEventListener(MouseEvent.CLICK,closePanel);
            okBtn.addEventListener(MouseEvent.CLICK,sendPassword);
            loadPanel = new MLoadPane(null,MLoadPane.FIT_HEIGHT);
            loadPanel.isMask = false;
            loadPanel.setSizeWH(84,84);
            loadPanel.x = 56;
            loadPanel.y = 105;
            panel.addChild(loadPanel);
            DisplayUtil.align(panel,null,AlignType.MIDDLE_CENTER);
         }
         var itemIDs:Array = MoneyProductXMLInfo.getItemIDs(productID);
         if(itemIDs.length == 1)
         {
            str = ItemXMLInfo.getIconURL(itemIDs[0]);
            loadPanel.setIcon(ItemXMLInfo.getIconURL(itemIDs[0]));
         }
         else
         {
            _showMc = UIManager.getSprite("ComposeMC");
            clothPrev = new BagClothPreview(_showMc,null,ClothPreview.MODEL_SHOW);
            arr = [];
            for each(id in itemIDs)
            {
               arr.push(new PeopleItemInfo(id));
            }
            clothPrev.changeCloth(arr);
            loadPanel.setIcon(_showMc);
         }
         pswTxt.text = "";
         var num:Number = (event.data as ByteArray).readUnsignedInt() / 100;
         var name:String = MoneyProductXMLInfo.getNameByProID(productID);
         var price:Number = Number(MoneyProductXMLInfo.getPriceByProID(productID));
         if(Boolean(MainManager.actorInfo.vip))
         {
            price *= MoneyProductXMLInfo.getVipByProID(productID);
         }
         if(price <= num)
         {
            contentTxt.htmlText = "你选择了" + TextFormatUtil.getRedTxt(name) + "需要花费" + TextFormatUtil.getRedTxt(price.toString()) + "米币，" + "目前你拥有" + TextFormatUtil.getRedTxt(num.toString()) + "米币，若确认购买该物品，请输入你的<font color=\'#ff0000\'>米币账户支付密码</font>：";
            LevelManager.appLevel.addChild(panel);
         }
         else
         {
            Alarm.show("你选择了" + TextFormatUtil.getRedTxt(name) + "需要花费" + TextFormatUtil.getRedTxt(price.toString()) + "米币，" + "目前你拥有" + TextFormatUtil.getRedTxt(num.toString()) + "米币，你的米币余额不足以购买此物品！");
         }
      }
      
      private static function closePanel(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(panel);
      }
      
      private static function sendPassword(event:MouseEvent) : void
      {
         if(pswTxt.text == "")
         {
            Alarm.show("请输入你的米币帐户密码！");
            return;
         }
         var by1:ByteArray = new ByteArray();
         by1.writeShort(count);
         var pswBy:ByteArray = new ByteArray();
         pswBy.writeUTFBytes(MD5.hash(pswTxt.text));
         pswBy.length = 32;
         SocketConnection.send(CommandID.MONEY_BUY_PRODUCT,productID,by1,pswBy);
         closePanel(null);
      }
   }
}

