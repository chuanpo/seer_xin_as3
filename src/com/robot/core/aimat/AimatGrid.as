package com.robot.core.aimat
{
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.manager.ItemManager;
   import com.robot.core.manager.UIManager;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   import org.taomee.component.control.MLoadPane;
   import org.taomee.manager.ResourceManager;
   import org.taomee.manager.ToolTipManager;
   
   public class AimatGrid extends Sprite
   {
      public static const CLICK:String = "click";
      
      private var btn:SimpleButton;
      
      private var _itemID:uint = 0;
      
      private var txt:TextField;
      
      private var tf:TextFormat;
      
      private var loadPanel:MLoadPane;
      
      public function AimatGrid()
      {
         super();
         this.tf = new TextFormat();
         this.tf.font = "Arial";
         this.tf.bold = true;
         this.tf.color = 0;
         this.tf.align = TextFormatAlign.RIGHT;
         this.btn = UIManager.getButton("ui_throwGridBtn");
         addChild(this.btn);
         this.btn.addEventListener(MouseEvent.CLICK,this.clickHandler);
         this.loadPanel = new MLoadPane();
         this.loadPanel.x = this.loadPanel.y = 5;
         this.loadPanel.setSizeWH(this.width - 10,this.height - 10);
         addChild(this.loadPanel);
         this.loadPanel.mouseChildren = this.loadPanel.mouseEnabled = false;
         this.txt = new TextField();
         this.txt.selectable = false;
         this.txt.mouseEnabled = false;
         this.txt.width = 25;
         this.txt.height = 18;
         addChild(this.txt);
         this.txt.x = 6;
         this.txt.y = 16;
         this.mouseEnabled = false;
         this.mouseChildren = false;
      }
      
      public function empty() : void
      {
         this.mouseChildren = false;
         this.loadPanel.unload();
         this.txt.text = "";
      }
      
      public function set itemID(i:uint) : void
      {
         var mc:MovieClip = null;
         this._itemID = i;
         if(this._itemID == 0)
         {
            mc = UIManager.getMovieClip("ui_aimat_icon");
            if(mc.width > mc.height)
            {
               this.loadPanel.fitType = MLoadPane.FIT_WIDTH;
            }
            else
            {
               this.loadPanel.fitType = MLoadPane.FIT_HEIGHT;
            }
            this.loadPanel.setIcon(mc);
         }
         else
         {
            ResourceManager.getResource(ItemXMLInfo.getIconURL(this._itemID),this.onLoadIcon);
            this.txt.text = ItemManager.getThrowInfo(this._itemID).itemNum.toString();
            this.txt.setTextFormat(this.tf);
         }
         this.mouseChildren = true;
      }
      
      public function get itemID() : uint
      {
         return this._itemID;
      }
      
      private function onLoadIcon(o:MovieClip) : void
      {
         if(o.width > o.height)
         {
            this.loadPanel.fitType = MLoadPane.FIT_WIDTH;
         }
         else
         {
            this.loadPanel.fitType = MLoadPane.FIT_HEIGHT;
         }
         this.loadPanel.setIcon(o);
         ToolTipManager.add(this,ItemXMLInfo.getName(this._itemID));
      }
      
      private function clickHandler(event:MouseEvent) : void
      {
         AimatController.start(this._itemID);
         dispatchEvent(new Event(CLICK));
      }
   }
}

