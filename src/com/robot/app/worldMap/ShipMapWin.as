package com.robot.app.worldMap
{
   import com.robot.core.event.MCLoadEvent;
   import com.robot.core.manager.LevelManager;
   import com.robot.core.manager.MapManager;
   import com.robot.core.newloader.MCLoader;
   import flash.display.MovieClip;
   import flash.display.SimpleButton;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.utils.setTimeout;
   
   public class ShipMapWin extends Sprite
   {
      private var mapMC:MovieClip;
      
      private var idArray:Array = [4,5,9,7,6,1,8];
      
      public function ShipMapWin()
      {
         super();
      }
      
      public function show() : void
      {
         var loader:MCLoader = null;
         LevelManager.appLevel.addChild(this);
         if(!this.mapMC)
         {
            loader = new MCLoader("resource/shipMap.swf",LevelManager.appLevel,1,"正在打开飞船地图");
            loader.addEventListener(MCLoadEvent.SUCCESS,this.onLoad);
            loader.doLoad();
         }
         else
         {
            setTimeout(this.initMap,200);
         }
      }
      
      private function onLoad(event:MCLoadEvent) : void
      {
         this.mapMC = event.getContent() as MovieClip;
         setTimeout(this.initMap,200);
      }
      
      private function initMap() : void
      {
         var btn:SimpleButton = null;
         addChild(this.mapMC);
         var clostBtn:SimpleButton = this.mapMC["closeBtn"];
         clostBtn.addEventListener(MouseEvent.CLICK,this.close);
         for(var i:int = 0; i < 7; i++)
         {
            btn = this.mapMC.getChildByName("btn_" + i) as SimpleButton;
            btn.addEventListener(MouseEvent.CLICK,this.changeMap);
         }
      }
      
      private function changeMap(event:MouseEvent) : void
      {
         var name:String = SimpleButton(event.currentTarget).name;
         var id:uint = uint(name.substr(-1,1));
         MapManager.changeMap(this.idArray[id]);
         this.close(null);
      }
      
      private function close(event:MouseEvent) : void
      {
         this.parent.removeChild(this);
      }
   }
}

