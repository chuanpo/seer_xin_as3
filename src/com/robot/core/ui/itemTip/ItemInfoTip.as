package com.robot.core.ui.itemTip
{
   import com.robot.core.config.xml.ItemTipXMLInfo;
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.info.userItem.SingleItemInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import org.taomee.component.UIComponent;
   import org.taomee.component.bgFill.SoildFillStyle;
   import org.taomee.component.containers.Canvas;
   import org.taomee.component.containers.HBox;
   import org.taomee.component.containers.VBox;
   import org.taomee.component.control.MLabel;
   import org.taomee.component.control.MLoadPane;
   import org.taomee.component.control.MText;
   import org.taomee.component.layout.CenterLayout;
   import org.taomee.component.layout.FitSizeLayout;
   import org.taomee.component.layout.FlowLayout;
   import org.taomee.utils.DisplayUtil;
   
   public class ItemInfoTip
   {
      private static var tipMC:Canvas;
      
      private static var box:HBox;
      
      private static var txtBox:VBox;
      
      private static var iconPanel:MLoadPane;
      
      private static var _info:SingleItemInfo;
      
      public function ItemInfoTip()
      {
         super();
      }
      
      public static function show(info:SingleItemInfo, bCloth:Boolean = false, container:DisplayObjectContainer = null) : void
      {
         _info = info;
         if(!tipMC)
         {
            tipMC = new Canvas();
            tipMC.layout = new CenterLayout();
            tipMC.bgFillStyle = new SoildFillStyle(0,0.8,20,20);
            box = new HBox(10);
            box.valign = FlowLayout.TOP;
            iconPanel = new MLoadPane(null,MLoadPane.FIT_HEIGHT);
            iconPanel.setSizeWH(80,80);
            txtBox = new VBox();
         }
         txtBox.removeAll();
         iconPanel.setIcon(ItemXMLInfo.getIconURL(info.itemID,info.itemLevel));
         var a:UIComponent = getTitleBox();
         var b:UIComponent = getPetBox();
         var c:UIComponent = getTeamPKBox();
         var d:UIComponent = getDesBox();
         txtBox.appendAll(a,b,c,d);
         txtBox.setSizeWH(160,a.height + b.height + c.height + d.height + 3 * box.gap);
         box.appendAll(iconPanel,txtBox);
         box.setSizeWH(160 + 80 + box.gap,Math.max(txtBox.height,iconPanel.height));
         tipMC.setSizeWH(box.width + 20,box.height + 20);
         tipMC.append(box);
         if(Boolean(container))
         {
            container.addChild(tipMC);
         }
         else
         {
            LevelManager.appLevel.addChild(tipMC);
         }
         tipMC.addEventListener(Event.ENTER_FRAME,enterFrameHandler);
      }
      
      public static function hide() : void
      {
         if(Boolean(tipMC))
         {
            tipMC.removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
            DisplayUtil.removeForParent(tipMC);
         }
      }
      
      private static function enterFrameHandler(event:Event) : void
      {
         if(MainManager.getStage().mouseX + tipMC.width + 20 >= MainManager.getStageWidth())
         {
            tipMC.x = MainManager.getStageWidth() - tipMC.width - 10;
         }
         else
         {
            tipMC.x = MainManager.getStage().mouseX + 10;
         }
         if(MainManager.getStage().mouseY + tipMC.height + 20 >= MainManager.getStageHeight())
         {
            tipMC.y = MainManager.getStageHeight() - tipMC.height - 10;
         }
         else
         {
            tipMC.y = MainManager.getStage().mouseY + 20;
         }
      }
      
      private static function getTitleBox() : HBox
      {
         var box:HBox = new HBox();
         var label:MLabel = new MLabel();
         label.fontSize = 14;
         var name:String = ItemXMLInfo.getName(_info.itemID);
         var color:String = ItemTipXMLInfo.getItemColor(_info.itemID);
         label.htmlText = "<font color=\'" + color + "\'>" + name + "</font>";
         label.width = 160;
         label.blod = true;
         box.setSizeWH(160,label.height);
         box.append(label);
         return box;
      }
      
      private static function getPetBox() : Canvas
      {
         var txt:MText = null;
         var str:String = ItemTipXMLInfo.getPetDes(_info.itemID,_info.itemLevel);
         var box:Canvas = new Canvas();
         box.layout = new FitSizeLayout();
         if(str != "")
         {
            txt = new MText();
            txt.fontSize = 12;
            txt.width = 160;
            txt.selectable = false;
            txt.textColor = 16776960;
            txt.text = "精灵属性：\r" + str;
            box.setSizeWH(160,txt.textField.height);
            box.append(txt);
         }
         return box;
      }
      
      private static function getTeamPKBox() : Canvas
      {
         var txt:MText = null;
         var str:String = ItemTipXMLInfo.getTeamPKDes(_info.itemID,_info.itemLevel);
         var box:Canvas = new Canvas();
         box.layout = new FitSizeLayout();
         if(str != "")
         {
            txt = new MText();
            txt.fontSize = 12;
            txt.width = 160;
            txt.selectable = false;
            txt.textColor = 16777215;
            txt.text = "要塞保卫战：\r" + str;
            box.setSizeWH(160,txt.textField.height);
            box.append(txt);
         }
         return box;
      }
      
      private static function getDesBox() : Canvas
      {
         var txt:MText = null;
         var str:String = ItemTipXMLInfo.getItemDes(_info.itemID);
         var box:Canvas = new Canvas();
         box.layout = new FitSizeLayout();
         if(str != "")
         {
            txt = new MText();
            txt.fontSize = 12;
            txt.width = 160;
            txt.selectable = false;
            txt.textColor = 10092288;
            txt.text = "用途：\r" + str;
            box.setSizeWH(160,txt.textField.height);
            box.append(txt);
         }
         return box;
      }
   }
}

