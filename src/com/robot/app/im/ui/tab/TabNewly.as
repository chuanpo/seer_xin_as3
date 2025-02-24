package com.robot.app.im.ui.tab
{
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TabNewly implements IIMTab
   {
      private var _index:int;
      
      private var _fun:Function;
      
      private var _ui:MovieClip;
      
      private var _con:Sprite;
      
      private var _isInfo:Boolean = true;
      
      public function TabNewly(i:int, ui:MovieClip, con:Sprite, fun:Function)
      {
         super();
         this._index = i;
         this._ui = ui;
         this._ui.gotoAndStop(1);
         this._con = con;
         this._fun = fun;
      }
      
      public function show() : void
      {
         this._ui.mouseEnabled = false;
         if(Boolean(this._ui.parent))
         {
            this._ui.parent.addChild(this._ui);
            this._ui.gotoAndStop(2);
         }
      }
      
      public function hide() : void
      {
         this._ui.mouseEnabled = true;
         if(Boolean(this._ui.parent))
         {
            this._ui.parent.addChildAt(this._ui,0);
            this._ui.gotoAndStop(1);
         }
      }
      
      public function get index() : int
      {
         return this._index;
      }
      
      public function set index(i:int) : void
      {
         this._index = i;
      }
   }
}

