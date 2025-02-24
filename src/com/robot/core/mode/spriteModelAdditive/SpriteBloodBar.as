package com.robot.core.mode.spriteModelAdditive
{
   import com.robot.core.mode.SpriteModel;
   import flash.display.MovieClip;
   import flash.filters.GlowFilter;
   import flash.geom.Rectangle;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.setTimeout;
   import gs.TweenLite;
   import org.taomee.utils.DisplayUtil;
   
   public class SpriteBloodBar implements ISpriteModelAdditive
   {
      private var _model:SpriteModel;
      
      private var barMC:MovieClip;
      
      private var tf:TextFormat;
      
      public function SpriteBloodBar(mc:MovieClip)
      {
         super();
         this.barMC = mc;
         this.tf = new TextFormat();
         this.tf.size = 16;
         this.tf.font = "Tahoma";
         this.tf.color = 16711680;
         this.tf.bold = true;
      }
      
      public function init() : void
      {
      }
      
      public function setHp(hp:uint, maxHp:uint, damage:uint = 0) : void
      {
         var txt:TextField = null;
         var p:Number = hp / maxHp;
         var mc:MovieClip = this.barMC["barMC"];
         var num:uint = mc.totalFrames - Math.floor(mc.totalFrames * p);
         if(num == 0)
         {
            num = 1;
         }
         mc.gotoAndStop(num);
         if(damage > 0)
         {
            txt = new TextField();
            txt.autoSize = TextFieldAutoSize.LEFT;
            txt.textColor = 16711680;
            txt.filters = [new GlowFilter(16777215,1,2,2,5)];
            txt.text = "-" + damage;
            txt.setTextFormat(this.tf);
            txt.x = -txt.width / 2;
            txt.y = -this._model.height / 2;
            TweenLite.to(txt,0.5,{"y":txt.y - 20});
            this._model.addChild(txt);
            setTimeout(function():void
            {
               DisplayUtil.removeForParent(txt);
            },2000);
         }
      }
      
      public function get model() : SpriteModel
      {
         return this._model;
      }
      
      public function set model(i:SpriteModel) : void
      {
         this._model = i;
      }
      
      public function show() : void
      {
         var rect:Rectangle = this._model.getRect(this._model);
         this.barMC.x = this._model.width + rect.x + 10;
         this._model.addChild(this.barMC);
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this.barMC);
      }
      
      public function destroy() : void
      {
         this.hide();
         this.barMC = null;
         this._model = null;
      }
   }
}

