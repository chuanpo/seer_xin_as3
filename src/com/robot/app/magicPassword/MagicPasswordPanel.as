package com.robot.app.magicPassword
{
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MainManager;
   import com.robot.core.newloader.MCLoader;
   import com.robot.core.ui.alert.Alarm;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import org.taomee.utils.AlignType;
   import org.taomee.utils.DisplayUtil;
   
   public class MagicPasswordPanel extends Sprite
   {
      private var uiLoader:MCLoader;
      
      private const url:String = "resource/magicPassword/magicPassword.swf";
      
      private var app:ApplicationDomain;
      
      private var main_ui:Sprite;
      
      private var pass_txt:TextField;
      
      private var send_btn:SimpleButton;
      
      private var close_btn:SimpleButton;
      
      private var bg:Sprite;
      
      public function MagicPasswordPanel()
      {
         super();
      }
      
      public function show() : void
      {
         if(this.main_ui != null && Boolean(DisplayUtil.hasParent(this.main_ui)))
         {
            return;
         }
         if(this.main_ui != null && DisplayUtil.hasParent(this.main_ui) == false)
         {
            this.destroy();
         }
         this.loaderUI();
      }
      
      private function loaderUI() : void
      {
         this.uiLoader = new MCLoader(this.url,LevelManager.appLevel,1,"正在打开分子密码");
         this.uiLoader.addEventListener(MCLoadEvent.SUCCESS,this.onLoadUISuccessHandler);
         this.uiLoader.doLoad();
      }
      
      private function onLoadUISuccessHandler(event:MCLoadEvent) : void
      {
         this.uiLoader.removeEventListener(MCLoadEvent.SUCCESS,this.onLoadUISuccessHandler);
         this.app = event.getApplicationDomain();
         this.main_ui = new (this.app.getDefinition("MagicPassword_MC") as Class)() as Sprite;
         LevelManager.appLevel.addChild(this.main_ui);
         DisplayUtil.align(this.main_ui,null,AlignType.MIDDLE_CENTER);
         this.main_ui["msg_txt"].text = "    欢迎你勇敢的" + MainManager.actorInfo.nick + "，我是博士设计的原型赛尔—代号π，专门负责分析各种分子频谱。我拥有庞大的数据库，输入分子密码，你就知道它是什么东西咯！";
         this.pass_txt = this.main_ui["pass_txt"];
         this.send_btn = this.main_ui["send_btn"];
         this.close_btn = this.main_ui["close_btn"];
         this.bg = this.main_ui["bg"];
         this.pass_txt.restrict = "0-9 a-z A-Z";
         this.pass_txt.maxChars = 16;
         this.pass_txt.text = "";
         this.configSendBtn();
         this.configCloseBtn();
         this.configBg();
      }
      
      private function configSendBtn(b1:Boolean = true) : void
      {
         if(b1)
         {
            this.send_btn.addEventListener(MouseEvent.CLICK,this.onSendBtnClickHandler);
         }
         else
         {
            this.send_btn.removeEventListener(MouseEvent.CLICK,this.onSendBtnClickHandler);
         }
      }
      
      private function onSendBtnClickHandler(event:MouseEvent) : void
      {
         if(this.pass_txt.text == "")
         {
            Alarm.show("你还没有输入分子密码哦");
         }
         else
         {
            if(this.pass_txt.text.length != this.pass_txt.maxChars)
            {
               Alarm.show("你输入的分子密码太短");
               return;
            }
            MagicPasswordModel.send(this.pass_txt.text);
            this.destroy();
         }
      }
      
      private function configCloseBtn(b1:Boolean = true) : void
      {
         if(b1)
         {
            this.close_btn.addEventListener(MouseEvent.CLICK,this.onCloseBtnClickHandler);
         }
         else
         {
            this.close_btn.removeEventListener(MouseEvent.CLICK,this.onCloseBtnClickHandler);
         }
      }
      
      private function onCloseBtnClickHandler(event:MouseEvent) : void
      {
         this.destroy();
      }
      
      private function configBg(b1:Boolean = true) : void
      {
         this.bg.buttonMode = b1;
         if(b1)
         {
            this.bg.addEventListener(MouseEvent.MOUSE_DOWN,this.onBgMouseDownHandler);
         }
         else
         {
            this.bg.removeEventListener(MouseEvent.MOUSE_DOWN,this.onBgMouseDownHandler);
         }
      }
      
      private function onBgMouseDownHandler(event:MouseEvent) : void
      {
         this.main_ui.startDrag();
         LevelManager.stage.addEventListener(MouseEvent.MOUSE_UP,this.onUpHandler);
      }
      
      private function onUpHandler(event:MouseEvent) : void
      {
         LevelManager.stage.removeEventListener(MouseEvent.MOUSE_UP,this.onUpHandler);
         this.main_ui.stopDrag();
      }
      
      public function destroy() : void
      {
         this.configSendBtn(false);
         this.configCloseBtn(false);
         this.configBg(false);
         this.pass_txt.text = "";
         DisplayUtil.removeForParent(this.main_ui);
         this.close_btn = null;
         this.send_btn = null;
         this.pass_txt = null;
         this.bg = null;
         this.main_ui = null;
         this.uiLoader.clear();
         this.uiLoader = null;
      }
      
      public function hasChineseChar(char:String) : Boolean
      {
         if(char == null)
         {
            return false;
         }
         char = this.trim(char);
         var pattern:RegExp = /[^\x00-\xff]/;
         var result:Object = pattern.exec(char);
         if(result == null)
         {
            return false;
         }
         return true;
      }
      
      public function trim(char:String) : String
      {
         if(char == null)
         {
            return null;
         }
         return this.rtrim(this.ltrim(char));
      }
      
      public function ltrim(char:String) : String
      {
         if(char == null)
         {
            return null;
         }
         var pattern:RegExp = /^\s*/;
         return char.replace(pattern,"");
      }
      
      public function rtrim(char:String) : String
      {
         if(char == null)
         {
            return null;
         }
         var pattern:RegExp = /\s*$/;
         return char.replace(pattern,"");
      }
   }
}

