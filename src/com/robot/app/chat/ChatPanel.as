package com.robot.app.chat
{
   import com.robot.core.event.ChatEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MessageManager;
   import com.robot.core.manager.UIManager;
   import com.robot.core.uic.TextScrollBar;
   import com.robot.core.utils.TextFormatUtil;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.text.TextField;
   import gs.TweenLite;
   import gs.easing.Back;
   import org.taomee.utils.DisplayUtil;
   
   public class ChatPanel extends Sprite
   {
      private var _mainUI:Sprite;
      
      private var _barBall:Sprite;
      
      private var _barBg:Sprite;
      
      private var _txt:TextField;
      
      private var _jianBtn:SimpleButton;
      
      private var _tsb:TextScrollBar;
      
      public function ChatPanel()
      {
         super();
         this._mainUI = UIManager.getSprite("ChatMc");
         this._barBall = this._mainUI["barBall"];
         this._barBg = this._mainUI["barBg"];
         this._txt = this._mainUI["txt"];
         this._jianBtn = this._mainUI["jianBtn"];
         addChild(this._mainUI);
         x = 314;
         this._tsb = new TextScrollBar(this._mainUI,this._txt,this._mainUI["upBtn"],this._mainUI["downBtn"]);
         MessageManager.addEventListener(ChatEvent.CHAT_COM,this.onChat);
         this._jianBtn.addEventListener(MouseEvent.CLICK,this.onClick);
      }
      
      public function show() : void
      {
         y = 508;
         LevelManager.toolsLevel.addChildAt(this,0);
         TweenLite.to(this,0.6,{
            "y":y - height + 82,
            "ease":Back.easeOut
         });
      }
      
      public function hide() : void
      {
         TweenLite.to(this,0.6,{
            "y":512,
            "ease":Back.easeOut,
            "onComplete":this.onFinishTween
         });
      }
      
      private function onChat(e:ChatEvent) : void
      {
         var msg:String = e.info.msg;
         if(msg.substr(0,1) == "#")
         {
            if(UIManager.hasDefinition("e" + msg.substring(1,msg.length)))
            {
               return;
            }
         }
         TextFormatUtil.appSenderFormatText(this._txt,e.info.senderNickName + ": ",false);
         TextFormatUtil.appDefaultFormatText(this._txt,msg + "\n",0);
         this._tsb.checkScroll();
      }
      
      private function onClick(e:MouseEvent) : void
      {
         this.hide();
      }
      
      private function onFinishTween() : void
      {
         dispatchEvent(new Event(Event.CLOSE));
         DisplayUtil.removeForParent(this);
      }
   }
}

