package com.robot.app.emotion
{
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UIManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.PopUpManager;
   import org.taomee.utils.DisplayUtil;
   
   public class EmotionPanel extends Sprite
   {
      private var _panel:Sprite;
      
      public function EmotionPanel()
      {
         var i:int = 0;
         var item:EmotionListItem = null;
         super();
         this._panel = UIManager.getSprite("Panel_Background_4");
         this._panel.mouseChildren = false;
         this._panel.mouseEnabled = false;
         this._panel.cacheAsBitmap = true;
         this._panel.width = 152;
         this._panel.height = 224;
         this._panel.alpha = 0.6;
         addChild(this._panel);
         for(i = 0; i < 23; i++)
         {
            item = new EmotionListItem(i);
            item.x = 6 + (item.width + 2) * int(i % 4);
            item.y = 4 + (item.height + 2) * int(i / 4);
            addChild(item);
            item.addEventListener(MouseEvent.CLICK,this.onItemClick);
         }
      }
      
      public function show(btn:DisplayObject) : void
      {
         PopUpManager.showForDisplayObject(this,btn,PopUpManager.TOP_LEFT,true,new Point((width + btn.width) / 2,0));
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this);
      }
      
      private function onItemClick(e:MouseEvent) : void
      {
         var item:EmotionListItem = e.currentTarget as EmotionListItem;
         MainManager.actorModel.chatAction("$" + item.id);
         this.hide();
      }
   }
}

