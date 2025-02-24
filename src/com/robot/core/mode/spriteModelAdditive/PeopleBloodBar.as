package com.robot.core.mode.spriteModelAdditive
{
   import com.robot.core.mode.SpriteModel;
   import flash.display.Sprite;
   import flash.filters.GlowFilter;
   import flash.text.TextField;
   import flash.text.TextFieldAutoSize;
   import flash.text.TextFormat;
   import flash.utils.setTimeout;
   import gs.TweenLite;
   import org.taomee.utils.DisplayUtil;
   
   public class PeopleBloodBar extends Sprite
   {
      public static const BLUE:uint = 0;
      
      public static const RED:uint = 1;
      
      private var bar:Sprite;
      
      private var barBg:Sprite;
      
      private var _hp:uint;
      
      private var _maxHp:uint;
      
      private var tf:TextFormat;
      
      private var _model:SpriteModel;
      
      public function PeopleBloodBar()
      {
         super();
         this.barBg = new Sprite();
         this.barBg.graphics.lineStyle(1,0);
         this.barBg.graphics.beginFill(6710886,1);
         this.barBg.graphics.drawRect(0,0,50,6);
         this.bar = new Sprite();
         this.bar.graphics.beginFill(0,1);
         this.bar.graphics.drawRect(0,0,50,6);
         this.tf = new TextFormat();
         this.tf.size = 16;
         this.tf.font = "Tahoma";
         this.tf.color = 16711680;
         this.tf.bold = true;
      }
      
      public function destroy() : void
      {
         this._model = null;
      }
      
      public function set model(i:SpriteModel) : void
      {
         this._model = i;
      }
      
      public function get hp() : uint
      {
         return this._hp;
      }
      
      public function get maxHp() : uint
      {
         return this._maxHp;
      }
      
      public function set colorType(i:uint) : void
      {
         if(i == BLUE)
         {
            DisplayUtil.FillColor(this.bar,3585535);
         }
         else
         {
            DisplayUtil.FillColor(this.bar,16719647);
         }
      }
      
      public function setHp(hp:uint, maxHp:uint, damage:uint = 0) : void
      {
         var p:Number;
         var txt:TextField = null;
         this._hp = hp;
         this._maxHp = maxHp;
         p = hp / maxHp;
         this.bar.width = 50 * p;
         this.show();
         if(damage > 0)
         {
            txt = new TextField();
            txt.autoSize = TextFieldAutoSize.LEFT;
            txt.textColor = 16711680;
            txt.filters = [new GlowFilter(16777215,1,2,2,5)];
            txt.text = "-" + damage;
            txt.setTextFormat(this.tf);
            txt.x = -txt.width / 2;
            txt.y = -this._model.height;
            TweenLite.to(txt,0.5,{"y":txt.y - 20});
            this._model.addChild(txt);
            setTimeout(function():void
            {
               DisplayUtil.removeForParent(txt);
            },2000);
         }
      }
      
      public function show() : void
      {
         this.barBg.x = this.bar.x = -this.barBg.width / 2;
         addChild(this.barBg);
         addChild(this.bar);
      }
      
      public function hide() : void
      {
         DisplayUtil.removeForParent(this.barBg);
         DisplayUtil.removeForParent(this.bar);
      }
   }
}

