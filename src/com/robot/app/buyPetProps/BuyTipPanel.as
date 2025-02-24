package com.robot.app.buyPetProps
{
   import com.robot.app.buyItem.ItemAction;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.Loader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.text.TextField;
   import flash.text.TextFieldType;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class BuyTipPanel
   {
      private static var okBtn:SimpleButton;
      
      private static var cancelBtn:SimpleButton;
      
      private static var preBtn:SimpleButton;
      
      private static var nextBtn:SimpleButton;
      
      private static var numTxt:TextField;
      
      private static var itemId:uint;
      
      private static var mianMc:MovieClip;
      
      private static var itemName:String;
      
      private static var itemPrice:uint;
      
      private static var iconLoader:Loader;
      
      private static var sigInfo:SingleItemInfo;
      
      private static var _listPet:ListPetProps;
      
      private static var dragMC:SimpleButton;
      
      private static var curPropsCount:uint = 0;
      
      public function BuyTipPanel()
      {
         super();
      }
      
      public static function initPanel(mc:MovieClip, _itemId:uint, iconMC:MovieClip, point:Point, listPet:ListPetProps) : void
      {
         itemName = ItemXMLInfo.getName(_itemId);
         itemPrice = ItemXMLInfo.getPrice(_itemId);
         okBtn = mc["okBtn"];
         cancelBtn = mc["cancelBtn"];
         preBtn = mc["preBtn"];
         nextBtn = mc["nextBtn"];
         numTxt = mc["numTxt"];
         dragMC = mc["dragMC"];
         dragMC.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            mc.startDrag();
         });
         dragMC.addEventListener(MouseEvent.MOUSE_UP,function():void
         {
            mc.stopDrag();
         });
         numTxt.text = "1";
         mc["propTxt"].text = "    1个" + itemName + "需花费" + itemPrice.toString() + "赛尔豆，你现在拥有" + MainManager.actorInfo.coins + "赛尔豆，要确认购买吗？";
         numTxt.addEventListener(Event.CHANGE,onChangeTxt);
         okBtn.addEventListener(MouseEvent.CLICK,onBuy);
         cancelBtn.addEventListener(MouseEvent.CLICK,onExit);
         preBtn.addEventListener(MouseEvent.CLICK,onPre);
         nextBtn.addEventListener(MouseEvent.CLICK,onNext);
         itemId = _itemId;
         mianMc = mc;
         iconMC.x = point.x;
         iconMC.y = point.y;
         mianMc.addChild(iconMC);
         LevelManager.closeMouseEvent();
         LevelManager.topLevel.addChild(mianMc);
         DisplayUtil.align(mianMc,null,AlignType.MIDDLE_CENTER);
         sigInfo = ItemManager.getCollectionInfo(_itemId);
         if(Boolean(sigInfo))
         {
            curPropsCount = sigInfo.itemNum;
         }
         _listPet = listPet;
      }
      
      private static function onChangeTxt(e:Event) : void
      {
         var count:uint = uint(numTxt.text);
         if(count > 99 - curPropsCount)
         {
            Alarm.show("你输入物品个数不正确",okFun);
            numTxt.text = "1";
            return;
         }
         if(count > Math.floor(MainManager.actorInfo.coins / itemPrice))
         {
            Alarm.show("你的赛尔豆不足",okFun);
            numTxt.type = TextFieldType.DYNAMIC;
            numTxt.text = Math.floor(MainManager.actorInfo.coins / itemPrice).toString();
         }
         mianMc["propTxt"].text = "    " + uint(numTxt.text) + "个" + itemName + "需花费" + itemPrice * uint(numTxt.text) + "赛尔豆，你现在拥有" + MainManager.actorInfo.coins + "赛尔豆，要确认购买吗？";
      }
      
      private static function okFun() : void
      {
         numTxt.type = TextFieldType.INPUT;
         LevelManager.closeMouseEvent();
      }
      
      private static function onBuy(e:MouseEvent) : void
      {
         var count:uint = uint(numTxt.text);
         if(count > Math.floor(MainManager.actorInfo.coins / itemPrice))
         {
            Alarm.show("你的赛尔豆不足");
            return;
         }
         ItemAction.buyItem(itemId,false,count);
         remove();
      }
      
      private static function remove() : void
      {
         DisplayUtil.removeForParent(mianMc);
         LevelManager.openMouseEvent();
         _listPet.destroy();
      }
      
      private static function onExit(e:MouseEvent) : void
      {
         remove();
      }
      
      private static function onPre(e:MouseEvent) : void
      {
         changeNum("0");
      }
      
      private static function changeNum(str:String) : void
      {
         var count:uint = uint(numTxt.text);
         if(str == "0" && count <= uint(MainManager.actorInfo.coins / itemPrice) && count > 1)
         {
            count -= 1;
         }
         else if(str == "1" && count < uint(MainManager.actorInfo.coins / itemPrice) && count >= 1 && count < 99 - curPropsCount)
         {
            count += 1;
         }
         numTxt.text = count.toString();
         mianMc["propTxt"].text = "    " + count + "个" + itemName + "需花费" + itemPrice * count + "赛尔豆，你现在拥有" + MainManager.actorInfo.coins + "赛尔豆，要确认购买吗？";
      }
      
      private static function onNext(e:MouseEvent) : void
      {
         changeNum("1");
      }
   }
}

