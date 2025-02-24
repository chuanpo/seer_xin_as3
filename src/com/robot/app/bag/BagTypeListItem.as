package com.robot.app.bag
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   import flash.system.ApplicationDomain;
   import flash.text.TextField;
   import org.taomee.utils.DisplayUtil;
   
   public class BagTypeListItem extends Sprite
   {
      private var _width:Number;
      
      private var _id:int = 0;
      
      private var _txt:TextField;
      
      private var _bgMC:MovieClip;
      
      public function BagTypeListItem(app:ApplicationDomain)
      {
         super();
         mouseChildren = false;
         buttonMode = true;
         this._bgMC = new (app.getDefinition("ListItemMc") as Class)() as MovieClip;
         this._bgMC.gotoAndStop(1);
         addChild(this._bgMC);
         this._txt = this._bgMC["txt"];
         visible = true;
         this.width = 80;
      }
      
      override public function set width(v:Number) : void
      {
         this._width = v;
         this._bgMC.width = v;
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      public function setInfo(id:int, txt:String) : void
      {
         this._id = id;
         this._txt.text = txt;
         visible = true;
      }
      
      public function get id() : int
      {
         return this._id;
      }
      
      public function set select(b:Boolean) : void
      {
         if(b)
         {
            this._bgMC.gotoAndStop(2);
         }
         else
         {
            this._bgMC.gotoAndStop(1);
         }
      }
      
      public function clear() : void
      {
         this._txt.text = "";
         visible = false;
      }
      
      public function destroy() : void
      {
         DisplayUtil.removeAllChild(this);
         this._txt = null;
      }
   }
}

