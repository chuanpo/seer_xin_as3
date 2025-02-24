package com.robot.app.im.ui.tab
{
   import com.robot.core.manager.UserManager;
   import com.robot.core.mode.BasePeoleModel;
   import flash.display.MovieClip;
   import flash.display.Sprite;
   
   public class TabOnline implements IIMTab
   {
      private var _index:int;
      
      private var _fun:Function;
      
      private var _ui:MovieClip;
      
      private var _con:Sprite;
      
      public function TabOnline(i:int, ui:MovieClip, con:Sprite, fun:Function)
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
         var obj:BasePeoleModel = null;
         this._ui.mouseEnabled = false;
         if(Boolean(this._ui.parent))
         {
            this._ui.parent.addChild(this._ui);
            this._ui.gotoAndStop(2);
         }
         var arr:Array = [];
         var list:Array = UserManager.getUserModelList();
         for each(obj in list)
         {
            arr.push(obj.info);
         }
         arr.sortOn("vip",Array.DESCENDING | Array.NUMERIC);
         this._fun(arr,300);
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

