package com.robot.app.im.talk
{
   import com.robot.app.emotion.EmotionListItem;
   import com.robot.core.manager.MainManager;
   import com.robot.core.manager.UIManager;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import org.taomee.manager.PopUpManager;
   import org.taomee.utils.DisplayUtil;
   
   public class TEmotionPanel extends Sprite
   {
      private var _panel:Sprite;
      
      private var _userID:uint;
      
      public function TEmotionPanel(userID:uint)
      {
         var item:EmotionListItem = null;
         super();
         this._userID = userID;
         this._panel = UIManager.getSprite("Panel_Background_4");
         this._panel.mouseChildren = false;
         this._panel.mouseEnabled = false;
         this._panel.cacheAsBitmap = true;
         this._panel.width = 299;
         this._panel.height = 118;
         this._panel.alpha = 0.6;
         addChild(this._panel);
         for(var i:int = 0; i < 23; i++)
         {
            item = new EmotionListItem(i);
            item.x = 6 + (item.width + 2) * int(i / 3);
            item.y = 6 + (item.height + 2) * int(i % 3);
            addChild(item);
            item.addEventListener(MouseEvent.CLICK,this.onItemClick);
         }
      }
      
      public function show(btn:DisplayObject) : void
      {
         PopUpManager.showForDisplayObject(this,btn,PopUpManager.TOP_RIGHT,true,new Point(-30,0));
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this);
      }
      
      private function onItemClick(e:MouseEvent) : void
      {
         var item:EmotionListItem = e.currentTarget as EmotionListItem;
         MainManager.actorModel.chatAction("#" + item.id,this._userID);
         this.hide();
      }
   }
}

