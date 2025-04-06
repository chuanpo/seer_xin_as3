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
   
   public class BtnItem extends Sprite
   {
      private var _info:BtnInfo;
      
      private var _mc:MovieClip;
      
      private var _icon:Sprite;
      
      public var type:uint;
      
      public function BtnItem(app:ApplicationDomain)
      {
         super();
         // _mc = new BtnItemBg();
         _mc = new (app.getDefinition("BtnItemBg") as Class)() as MovieClip;;
         _mc.gotoAndStop(1);
         this.addChild(_mc);
         _icon = new Sprite();
         this.addChild(_icon);
      }
      
      public function get info() : BtnInfo
      {
         return _info;
      }
      
      public function get mc() : MovieClip
      {
         return _mc;
      }
      
      public function set info(param1:BtnInfo) : void
      {
         var i:BtnInfo = param1;
         _info = i;
         if(i)
         {
            ResourceManager.getResource(ItemXMLInfo.getIconURL(i.itemInfo.itemID),function(param1:MovieClip):void
            {
               DisplayUtil.removeAllChild(_icon);
               _icon.addChild(param1);
               param1.scaleX = 0.85;
               param1.scaleY = 0.85;
               // ToolTipManager.add(_icon,ItemXMLInfo.getName(i.itemInfo.itemID));
               _icon.addEventListener(MouseEvent.ROLL_OVER,function():void
               {
                  ItemInfoTip.show(i.itemInfo);
               });
			      _icon.addEventListener(MouseEvent.ROLL_OUT,function():void
               {
                  ItemInfoTip.hide();
               });	
            });
         }
      }

   }
}

