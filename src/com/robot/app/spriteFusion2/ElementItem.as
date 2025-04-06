package com.robot.app.spriteFusion2
{
   import com.robot.core.config.xml.ItemXMLInfo;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import org.taomee.manager.ResourceManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   import flash.system.ApplicationDomain;
   import flash.events.MouseEvent;
   import com.robot.core.ui.itemTip.ItemInfoTip;
   
   public class ElementItem extends Sprite
   {
      private var _info:ElementItemInfo;
      
      private var _mc:MovieClip;
      
      private var _icon:Sprite;
      
      public var type:uint;
      
      public function ElementItem(app:ApplicationDomain)
      {
         super();
         _mc = new (app.getDefinition("ElementItemBg") as Class)() as MovieClip; 
         // new ElementItemBg();
         _mc.gotoAndStop(1);
         this.addChild(_mc);
         _icon = _mc["icon"];
      }
      
      public function setNum(param1:int) : void
      {
         if(param1 <= 0)
         {
            setVisibel(false);
         }
         else
         {
            setVisibel(true);
         }
         _mc["cntTxt"].text = param1;
      }
      
      public function get info() : ElementItemInfo
      {
         return _info;
      }
      
      public function get mc() : MovieClip
      {
         return _mc;
      }
      
      public function set info(param1:ElementItemInfo) : void
      {
         var i:ElementItemInfo = param1;
         _info = i;
         if(i)
         {
            ResourceManager.getResource(ItemXMLInfo.getIconURL(i.info.itemID),function(param1:MovieClip):void
            {
               DisplayUtil.removeAllChild(_icon);
               _icon.addChild(param1);
               param1.scaleX = 0.75;
               param1.scaleY = 0.75;
               // ToolTipManager.add(_icon,ItemXMLInfo.getName(i.info.itemID));
               _icon.addEventListener(MouseEvent.ROLL_OVER,function():void
               {
                  ItemInfoTip.show(i.info);
               });
			      _icon.addEventListener(MouseEvent.ROLL_OUT,function():void
               {
                  ItemInfoTip.hide();
               });	
               setNum(i.num);
            });
         }
         else
         {
            DisplayUtil.removeAllChild(_icon);
            setVisibel(false);
         }
      }
      
      private function setVisibel(param1:Boolean) : void
      {
         if(!param1)
         {
            _icon.visible = false;
            _mc["cntTxt"].visible = false;
            this.buttonMode = false;
            this.mouseEnabled = false;
            this.mouseChildren = false;
         }
         else
         {
            _icon.visible = true;
            _mc["cntTxt"].visible = true;
            this.buttonMode = true;
            this.mouseEnabled = true;
            this.mouseChildren = true;
         }
      }
   }
}

