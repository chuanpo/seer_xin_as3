package com.robot.core.ui.nono
{
   import com.robot.core.manager.NonoManager;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.DisplayObject;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import org.taomee.manager.ResourceManager;
   import org.taomee.manager.ToolTipManager;
   import org.taomee.utils.DisplayUtil;
   import org.taomee.utils.Utils;
   
   public class NonoShortcutKeyItem extends Sprite
   {
      private var _id:String;
      
      private var _icon:SimpleButton;
      
      private var _handler:Function;
      
      private var _tips:String;
      
      public function NonoShortcutKeyItem()
      {
         super();
      }
      
      public function setInfo(id:String, tip:String, func:Function = null) : void
      {
         if(this._id != "")
         {
            ResourceManager.cancel("resource/nono/shortcutKey" + this._id + ".swf",this.onComHandler);
         }
         if(Boolean(this._icon))
         {
            ToolTipManager.remove(this._icon);
            this._icon.removeEventListener(MouseEvent.CLICK,this.onIconClickHandler);
            DisplayUtil.removeForParent(this._icon);
            this._icon = null;
         }
         this._id = id;
         this._tips = tip;
         this._handler = func;
         ResourceManager.getResource("resource/nono/shortcutKey/" + this._id + ".swf",this.onComHandler);
      }
      
      private function onComHandler(mc:DisplayObject) : void
      {
         if(Boolean(mc))
         {
            this._icon = mc as SimpleButton;
            this.addChild(this._icon);
            this._icon.x = this._icon.width / 2;
            this._icon.y = this._icon.height / 2;
            ToolTipManager.add(this._icon,this._tips);
            this._icon.addEventListener(MouseEvent.CLICK,this.onIconClickHandler);
         }
      }
      
      private function onIconClickHandler(e:MouseEvent) : void
      {
         var cls:Class = null;
         if(uint(this._id) == 2)
         {
            if(Boolean(NonoManager.info.func[4]) || NonoManager.info.superNono)
            {
               if(this._handler != null)
               {
                  this._handler();
               }
            }
            else
            {
               Alarm.show("你的NoNo还没有开通这个功能哦!");
            }
         }
         else if(this._handler != null)
         {
            this._handler();
         }
         try
         {
            cls = Utils.getClass("com.robot.app.nono.featureApp.App_" + this._id);
            if(Boolean(cls))
            {
               new cls(uint(this._id));
            }
         }
         catch(e:Error)
         {
            trace("error==" + e.message);
         }
      }
      
      public function destroy() : void
      {
         if(this._id != "")
         {
            ResourceManager.cancel("resource/nono/shortcutKey/" + this._id + ".swf",this.onComHandler);
         }
         if(Boolean(this._icon))
         {
            ToolTipManager.remove(this._icon);
            this._icon.removeEventListener(MouseEvent.CLICK,this.onIconClickHandler);
            DisplayUtil.removeForParent(this._icon);
            this._icon = null;
         }
      }
   }
}

