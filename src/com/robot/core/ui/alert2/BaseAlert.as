package com.robot.core.ui.alert2
{
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.manager.alert.AlertInfo;
   import com.robot.core.ui.alert.IAlert;
   import flash.display.DisplayObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.MouseEvent;
   import flash.events.TextEvent;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFormatAlign;
   import org.taomee.manager.ResourceManager;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class BaseAlert extends EventDispatcher implements IAlert
   {
      protected var _info:AlertInfo;
      
      protected var _sprite:Sprite;
      
      protected var _txt:TextField;
      
      protected var _icon:Sprite;
      
      protected var _applyBtn:SimpleButton;
      
      protected var _bgmc:Sprite;
      
      protected var _iconOfftX:Number = 0;
      
      protected var _iconOfftY:Number = 0;
      
      protected var _iconName:String;
      
      public function BaseAlert(info:AlertInfo, classname:String, iconName:String = "item")
      {
         super();
         this._info = info;
         this._iconName = iconName;
         this._sprite = UIManager.getSprite(classname);
         this._bgmc = this._sprite["bgMc"];
         this._applyBtn = this._sprite["applyBtn"];
         this._txt = this._sprite["txt"];
         this._txt.autoSize = TextFormatAlign.CENTER;
         this._txt.width = 265;
         this._txt.htmlText = this._info.str;
         if(this._info.iconURL == "" || this._info.iconURL == null)
         {
            DisplayUtil.align(this._txt,new Rectangle(40,60,265,90),AlignType.MIDDLE_CENTER);
         }
         else
         {
            DisplayUtil.align(this._txt,new Rectangle(40,60,265,90),AlignType.BOTTOM_CENTER);
         }
      }
      
      public function get info() : AlertInfo
      {
         return this._info;
      }
      
      public function get content() : Sprite
      {
         return this._sprite;
      }
      
      public function show() : void
      {
         if(Boolean(this._info.parant))
         {
            this._info.parant.addChild(this._sprite);
         }
         else
         {
            LevelManager.topLevel.addChild(this._sprite);
         }
         DisplayUtil.align(this._sprite,null,AlignType.MIDDLE_CENTER);
         this._bgmc.addEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this._bgmc.addEventListener(MouseEvent.MOUSE_DOWN,this.onDragUp);
         this._applyBtn.addEventListener(MouseEvent.CLICK,this.onApply);
         if(this._info.disMouse)
         {
            LevelManager.closeMouseEvent();
         }
         if(this._info.linkFun != null)
         {
            this._txt.addEventListener(TextEvent.LINK,this.onLink);
         }
         if(this._info.iconURL != "" || this._info.iconURL != null)
         {
            ResourceManager.getResource(this._info.iconURL,this.onLoadIcon,this._iconName);
         }
      }
      
      public function hide() : void
      {
         if(this._info.iconURL != "" || this._info.iconURL != null)
         {
            ResourceManager.cancel(this._info.iconURL,this.onLoadIcon);
         }
         this._bgmc.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDragDown);
         this._bgmc.removeEventListener(MouseEvent.MOUSE_DOWN,this.onDragUp);
         this._applyBtn.removeEventListener(MouseEvent.CLICK,this.onApply);
         this._txt.removeEventListener(TextEvent.LINK,this.onLink);
         DisplayUtil.removeForParent(this._sprite);
      }
      
      public function destroy() : void
      {
         this.hide();
         this._info = null;
         this._sprite = null;
         this._bgmc = null;
         this._applyBtn = null;
         this._txt = null;
         this._icon = null;
      }
      
      protected function onDragDown(e:MouseEvent) : void
      {
         this._sprite.startDrag();
      }
      
      protected function onDragUp(e:MouseEvent) : void
      {
         this._sprite.stopDrag();
      }
      
      protected function onApply(e:MouseEvent) : void
      {
         LevelManager.openMouseEvent();
         if(this._info.applyFun != null)
         {
            this._info.applyFun();
         }
         this.hide();
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      protected function onCancel(e:MouseEvent) : void
      {
         LevelManager.openMouseEvent();
         if(this._info.cancelFun != null)
         {
            this._info.cancelFun();
         }
         this.hide();
         dispatchEvent(new Event(Event.CLOSE));
      }
      
      protected function onLink(e:TextEvent) : void
      {
         e.stopImmediatePropagation();
         if(this._info.linkFun != null)
         {
            this._info.linkFun(e);
         }
      }
      
      protected function onLoadIcon(o:DisplayObject) : void
      {
         this._icon = o as Sprite;
         this._icon.mouseChildren = false;
         this._icon.mouseEnabled = false;
         this._sprite.addChild(this._icon);
         DisplayUtil.align(this._icon,new Rectangle(40 + this._iconOfftX,60 + this._iconOfftY,265,90),AlignType.TOP_CENTER);
         if(this._iconName != "item")
         {
            DisplayUtil.stopAllMovieClip(this._icon);
            this._icon.x = 100;
            this._icon.y = 100;
         }
      }
   }
}

