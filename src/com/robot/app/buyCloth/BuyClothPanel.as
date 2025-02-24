package com.robot.app.buyCloth
{
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.newloader.MCLoader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.system.ApplicationDomain;
   import org.taomee.utils.DisplayUtil;
   
   public class BuyClothPanel extends Sprite
   {
      private var PATH:String = "resource/module/clothBook/clothBook.swf";
      
      private var app:ApplicationDomain;
      
      private var _mainUI:MovieClip;
      
      private var _closeBtn:SimpleButton;
      
      public function BuyClothPanel()
      {
         super();
         var loader:MCLoader = new MCLoader(this.PATH,LevelManager.topLevel,1,"正在打开装备列表");
         loader.addEventListener(MCLoadEvent.SUCCESS,this.onLoad);
         loader.doLoad();
      }
      
      public function show() : void
      {
         var buyMC:MovieClip = null;
         if(Boolean(this._mainUI))
         {
            DisplayUtil.removeForParent(this._mainUI);
            this._mainUI = new (this.app.getDefinition("BookPanel") as Class)() as MovieClip;
            addChild(this._mainUI);
            (this._mainUI["buyPanel"] as MovieClip).gotoAndStop(1);
            buyMC = this._mainUI["buyPanel"] as MovieClip;
            buyMC.gotoAndStop(1);
            LevelManager.appLevel.addChild(this);
            this._closeBtn = this._mainUI["closeBtn"];
            this._closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
         }
      }
      
      public function destroy() : void
      {
         this.app = null;
         if(Boolean(this._mainUI))
         {
            this._closeBtn.removeEventListener(MouseEvent.CLICK,this.closeHandler);
            this._closeBtn = null;
            this._mainUI = null;
         }
      }
      
      private function onLoad(event:MCLoadEvent) : void
      {
         if(Boolean(this._mainUI))
         {
            DisplayUtil.removeForParent(this._mainUI);
         }
         this.app = event.getApplicationDomain();
         this._mainUI = new (this.app.getDefinition("BookPanel") as Class)() as MovieClip;
         var buyMC:MovieClip = this._mainUI["buyPanel"] as MovieClip;
         buyMC.gotoAndStop(1);
         (buyMC["coverMC"] as MovieClip).stop();
         addChild(this._mainUI);
         this.x = 94;
         this.y = 34;
         LevelManager.appLevel.addChild(this);
         LevelManager.closeMouseEvent();
         this._closeBtn = this._mainUI["closeBtn"];
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.closeHandler);
      }
      
      private function closeHandler(event:MouseEvent) : void
      {
         DisplayUtil.removeForParent(this);
         LevelManager.openMouseEvent();
      }
   }
}

