package com.robot.app.bag
{
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.info.userItem.SingleItemInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.text.TextField;
   import org.taomee.effect.ColorFilter;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.DisplayUtil;
   
   public class BagListItem extends Sprite
   {
      private var _info:SingleItemInfo;
      
      private var _obj:DisplayObject;
      
      private var _con:Sprite;
      
      private var _txt:TextField;
      
      private var _hasPrev:Boolean;
      
      public function BagListItem(bgui:Sprite)
      {
         super();
         mouseChildren = false;
         addChild(bgui);
         this._con = bgui["mc"];
         this._txt = bgui["num_txt"];
      }
      
      public function setInfo(i:SingleItemInfo, hasPrev:Boolean = false) : void
      {
         if(Boolean(this._info))
         {
            ResourceManager.cancel(ItemXMLInfo.getIconURL(this._info.itemID,this._info.itemLevel),this.onLoad);
         }
         this._info = i;
         this._hasPrev = hasPrev;
         if(this._info.itemNum > 1)
         {
            this._txt.text = this._info.itemNum.toString();
         }
         if(this._info.leftTime == 0)
         {
            this._con.filters = [ColorFilter.setGrayscale()];
         }
         if(Boolean(this._obj))
         {
            DisplayUtil.removeForParent(this._obj);
            this._obj = null;
         }
         ResourceManager.getResource(ItemXMLInfo.getIconURL(this._info.itemID,this._info.itemLevel),this.onLoad);
      }
      
      public function get info() : SingleItemInfo
      {
         return this._info;
      }
      
      public function set text(v:String) : void
      {
         this._txt.text = v;
      }
      
      public function clear() : void
      {
         if(Boolean(this._info))
         {
            ResourceManager.cancel(ItemXMLInfo.getIconURL(this._info.itemID,this._info.itemLevel),this.onLoad);
         }
         this._info = null;
         if(Boolean(this._obj))
         {
            DisplayUtil.removeForParent(this._obj);
            this._obj = null;
         }
         this._con.filters = [];
         this._txt.text = "";
      }
      
      private function onLoad(o:DisplayObject) : void
      {
         this._obj = o;
         this._con.addChild(this._obj);
         if(this._info.itemNum == 0)
         {
            DisplayUtil.FillColor(this._obj,3355443);
            this._txt.text = "0";
         }
         else if(BagShowType.currType == BagShowType.SUIT)
         {
            if(this._hasPrev)
            {
               this._obj.alpha = 0.4;
               this._txt.text = "0";
            }
            else
            {
               this._txt.text = "1";
            }
         }
      }
   }
}

