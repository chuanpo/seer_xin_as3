package com.robot.core.ui.mapTip
{
   import com.robot.core.manager.UIManager;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import flash.text.TextFormatAlign;
   
   public class MapTipItem extends Sprite
   {
      private var tipMC:Sprite;
      
      private var icon:MovieClip;
      
      private var difIcon:MovieClip;
      
      private var titleTxt:TextField;
      
      private var desContainer:Sprite;
      
      private var _info:MapItemTipInfo;
      
      public function MapTipItem()
      {
         super();
         this.icon = UIManager.getMovieClip("MapTipIcon");
         this.difIcon = UIManager.getMovieClip("MapTipDifIcon");
         this.tipMC = new Sprite();
         this.addChild(this.tipMC);
      }
      
      public function set info(info:MapItemTipInfo) : void
      {
         this._info = info;
         this.setTitle(info);
         this.setDes(info);
         this.drawBg();
         if(info.type != 0)
         {
            this.icon.gotoAndStop(info.type);
         }
         this.icon.x = 2;
         this.tipMC.addChild(this.icon);
         this.tipMC.addChild(this.titleTxt);
         this.tipMC.addChild(this.desContainer);
         this.desContainer.x = 6;
         this.desContainer.y = this.titleTxt.height;
      }
      
      public function get info() : MapItemTipInfo
      {
         return this._info;
      }
      
      private function setTitle(info:MapItemTipInfo) : void
      {
         var format:TextFormat = new TextFormat();
         format.size = 14;
         if(info.type == 0)
         {
            this.icon.visible = false;
            format.align = TextFormatAlign.CENTER;
            format.color = 16776960;
            this.titleTxt = this.getTextField(format);
            this.titleTxt.x = (160 - this.titleTxt.width) / 2;
         }
         else
         {
            format.align = TextFormatAlign.LEFT;
            format.color = 16777215;
            this.titleTxt = this.getTextField(format);
            this.titleTxt.x = this.icon.width + 8;
         }
         this.titleTxt.htmlText = info.title;
      }
      
      private function setDes(info:MapItemTipInfo) : void
      {
         var difTxt:TextField = null;
         var levelTxt:TextField = null;
         var format:TextFormat = new TextFormat();
         format.size = 12;
         format.color = 16776960;
         if(info.type == 0)
         {
            this.desContainer = new Sprite();
            if(uint(info.content[0]) != 0)
            {
               difTxt = this.getTextField(format);
               difTxt.width = 40;
               difTxt.text = "难度:";
               this.difIcon.gotoAndStop(uint(info.content[0]));
            }
            if(info.content[1] != "")
            {
               levelTxt = this.getTextField(format);
               levelTxt.text = "适合等级:" + info.content[1];
               levelTxt.width = 120;
            }
            if(Boolean(difTxt))
            {
               this.desContainer.addChild(difTxt);
               this.desContainer.addChild(this.difIcon);
               this.difIcon.x = 30;
               this.difIcon.y = 2;
            }
            if(Boolean(levelTxt))
            {
               this.desContainer.addChild(levelTxt);
               levelTxt.y = 20;
            }
         }
         else
         {
            this.desContainer = this.getDesContainer(info);
         }
      }
      
      private function drawBg() : void
      {
         var h:Number = this.titleTxt.height + this.desContainer.height;
         this.tipMC.graphics.beginFill(73547,0.8);
         this.tipMC.graphics.drawRoundRect(0,0,160,h,10,10);
         this.tipMC.graphics.endFill();
      }
      
      private function getDesContainer(info:MapItemTipInfo) : Sprite
      {
         var str:String = null;
         var txt:TextField = null;
         var a:Array = null;
         var box:Sprite = new Sprite();
         var arr:Array = this._info.content;
         var format:TextFormat = new TextFormat();
         format.size = 12;
         format.color = 16777215;
         var count:uint = 1;
         for each(str in arr)
         {
            if(str != "")
            {
               txt = this.getTextField(format);
               if(str.indexOf("#") != -1)
               {
                  a = str.split("#");
                  str = a[1];
                  txt.htmlText = "<font color=\'#ff0000\'>" + "*" + str + "</font>";
               }
               else
               {
                  txt.htmlText = "*" + str;
               }
               if(info.type == 2)
               {
                  if(count > 1 && count % 2 == 0)
                  {
                     txt.x = 74;
                  }
                  else
                  {
                     txt.x = 0;
                  }
                  txt.y = (Math.ceil(count / 2) - 1) * txt.height;
               }
               else
               {
                  txt.y = txt.height * (count - 1);
               }
               box.addChild(txt);
               count++;
            }
         }
         return box;
      }
      
      private function getTextField(txtFormat:TextFormat) : TextField
      {
         var txt:TextField = new TextField();
         txt.width = 80;
         txt.height = 20;
         txt.selectable = false;
         txt.defaultTextFormat = txtFormat;
         return txt;
      }
   }
}

