package com.robot.core.ui.alert
{
   import com.robot.core.config.xml.ItemXMLInfo;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.UIManager;
   import flash.display.DisplayObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class ItemInBagAlert
   {
      public function ItemInBagAlert()
      {
         super();
      }
      
      public static function show(id:uint, str:String, applyFun:Function = null, isMouse:Boolean = false) : Sprite
      {
         var bgmc:Sprite;
         var txt:TextField;
         var sprite:Sprite = null;
         var icon:Sprite = null;
         var applyBtn:SimpleButton = null;
         var apply:Function = null;
         var onLoadIcon:Function = null;
         apply = function(event:MouseEvent):void
         {
            LevelManager.openMouseEvent();
            if(applyFun != null)
            {
               applyFun();
            }
            applyBtn.removeEventListener(MouseEvent.CLICK,apply);
            DisplayUtil.removeForParent(sprite);
         };
         onLoadIcon = function(o:DisplayObject):void
         {
            icon.addChild(o);
         };
         sprite = UIManager.getSprite("TaskItemAlarmMC");
         icon = new Sprite();
         icon.y = 70;
         icon.x = 70;
         sprite.addChild(icon);
         bgmc = sprite["bgMc"];
         bgmc.addEventListener(MouseEvent.MOUSE_DOWN,function():void
         {
            sprite.startDrag();
         });
         bgmc.addEventListener(MouseEvent.MOUSE_UP,function():void
         {
            sprite.stopDrag();
         });
         LevelManager.topLevel.addChild(sprite);
         DisplayUtil.align(sprite,null,AlignType.MIDDLE_CENTER);
         if(!isMouse)
         {
            LevelManager.closeMouseEvent();
         }
         txt = sprite["txt"];
         txt.htmlText = str;
         applyBtn = sprite["applyBtn"];
         applyBtn.addEventListener(MouseEvent.CLICK,apply);
         ResourceManager.getResource(ItemXMLInfo.getIconURL(id),onLoadIcon);
         return sprite;
      }
   }
}

